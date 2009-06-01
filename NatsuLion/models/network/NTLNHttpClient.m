#import "NTLNHttpClient.h"

@implementation NTLNHttpClient

@synthesize recievedData, statusCode;

- (id)init {
	if (self = [super init]) {
		[self reset];
	}
	return self;
}

- (void)dealloc {
	LOG(@"NTLNHttpClient#dealloc");
	[connection release];
	[recievedData release];
	[rate_limit_reset release];
	[super dealloc];
}

+ (NSString*)stringEncodedWithBase64:(NSString*)str
{
	static const char *tbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

	const char *s = [str UTF8String];
	int length = [str length];
	char *tmp = malloc(length * 4 / 3 + 4);

	int i = 0;
	int n = 0;
	char *p = tmp;
	
	while (i < length) {
		n = s[i++];
		n *= 256;
		if (i < length) n += s[i];
		i++;
		n *= 256;
		if (i < length) n += s[i];
		i++;
		
		p[0] = tbl[((n & 0x00fc0000) >> 18)];
		p[1] = tbl[((n & 0x0003f000) >> 12)];
		p[2] = tbl[((n & 0x00000fc0) >>  6)];
		p[3] = tbl[((n & 0x0000003f) >>  0)];
		
		if (i > length) p[3] = '=';
		if (i > length + 1) p[2] = '=';

		p += 4;
	}
	
	*p = '\0';
	
	NSString *ret = [NSString stringWithCString:tmp];
	free(tmp);

	return ret;
}

+ (NSString*) stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password {
    return [@"Basic " stringByAppendingString:[NTLNHttpClient stringEncodedWithBase64:
											   [NSString stringWithFormat:@"%@:%@", username, password]]];
}

- (NSMutableURLRequest*)makeRequest:(NSString*)url {
	NSString *encodedUrl = (NSString*)CFURLCreateStringByAddingPercentEscapes(
										NULL, (CFStringRef)url, NULL, NULL, kCFStringEncodingUTF8);
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:encodedUrl]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setTimeoutInterval:TIMEOUT_SEC];
	[request setHTTPShouldHandleCookies:FALSE];
	[encodedUrl release];
	return request;
}

- (NSMutableURLRequest*)makeRequest:(NSString*)url username:(NSString*)username password:(NSString*)password {
	NSMutableURLRequest *request = [self makeRequest:url];
	[request setValue:[NTLNHttpClient stringOfAuthorizationHeaderWithUsername:username password:password]
   forHTTPHeaderField:@"Authorization"];
	return request;
}

- (void)reset {
	[recievedData release];
	recievedData = [[NSMutableData alloc] init];
	[connection release];
	connection = nil;
	[rate_limit_reset release];
	rate_limit_reset = nil;
	
	statusCode = 0;	
	contentTypeIsXml = NO;
	
	rate_limit = 0;
	rate_limit_remaining = 0;
}

- (void)prepareWithRequest:(NSMutableURLRequest*)request {
	// do nothing (for OAuthHttpClient)
}

- (void)requestGET:(NSString*)url {
	[self reset];
	NSMutableURLRequest *request = [self makeRequest:url];
	[self prepareWithRequest:request];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)requestPOST:(NSString*)url body:(NSString*)body {
	[self reset];
	NSMutableURLRequest *request = [self makeRequest:url];
    [request setHTTPMethod:@"POST"];
	if (body) {
		[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[self prepareWithRequest:request];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)requestGET:(NSString*)url username:(NSString*)username password:(NSString*)password {
	[self reset];
	NSMutableURLRequest *request = [self makeRequest:url username:username password:password];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)requestPOST:(NSString*)url body:(NSString*)body username:(NSString*)username password:(NSString*)password {
	[self reset];
	NSMutableURLRequest *request = [self makeRequest:url username:username password:password];
    [request setHTTPMethod:@"POST"];
	if (body) {
		[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	}
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancel {
	[connection cancel];
	[self reset];
	[self requestFailed:nil];
}

- (void)requestSucceeded {
	// implement by subclass
}

- (void)requestFailed:(NSError*)error {
	// implement by subclass
}
/*
-(void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge { 
	[[challenge sender] cancelAuthenticationChallenge:challenge]; 
}    
*/

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    NSLog(@"didReceiveResponse");
	
	statusCode = [(NSHTTPURLResponse*)response statusCode];
	NSDictionary *header = [(NSHTTPURLResponse*)response allHeaderFields];

	contentTypeIsXml = NO;
	NSString *content_type = [header objectForKey:@"Content-Type"];
	if (content_type) {
		NSRange r = [content_type rangeOfString:@"xml"];
		if (r.location != NSNotFound) {
			contentTypeIsXml = YES;
		}
	}

/*	for (NSString *s in [header allKeys]) {
		LOG(@"header: %@", s);
	}
*/	
	NSString *rateLimit = [header objectForKey:@"X-Ratelimit-Limit"];
	NSString *rateLimitRemaining = [header objectForKey:@"X-Ratelimit-Remaining"];
	NSString *rateLimitReset = [header objectForKey:@"X-Ratelimit-Reset"];
	if (rateLimit && rateLimitRemaining) {
		rate_limit = [rateLimit intValue];
		rate_limit_remaining = [rateLimitRemaining intValue];
		rate_limit_reset = [[NSDate dateWithTimeIntervalSince1970:[rateLimitReset intValue]] retain];
		LOG(@"rate_limit: %d rate_limit_remaining:%d",rate_limit, rate_limit_remaining);
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"didReceiveData");
    [recievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"connectionDidFinishLoading");
	[self requestSucceeded];
	[self reset];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
//    NSLog(@"didFailWithError");
	[self requestFailed:error];
	[self reset];
}

@end
