#import "NTLNHttpClient.h"


#define TIMEOUT_SEC		20.0

@implementation NTLNHttpClient

@synthesize recievedData, statusCode;

- (id)init {
	self = [super init];
	recievedData = [[NSMutableData alloc] init];
	return self;
}

- (void)dealloc {
#ifdef DEBUG
	NSLog(@"NTLNHttpClient#dealloc");
#endif
	[connection release];
	[recievedData release];
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
    NSString *s = @"Basic ";
    [s autorelease];
    return [s stringByAppendingString:[NTLNHttpClient stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];
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

- (void)requestGET:(NSString*)url {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)requestGET:(NSString*)url username:(NSString*)username password:(NSString*)password {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url username:username password:password];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}
/*
- (void)requestPOST:(NSString*)url body:(NSString*)body {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url];
    [request setHTTPMethod:@"POST"];
	if (body) {
		[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	}
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
*/

- (void)requestPOST:(NSString*)url body:(NSString*)body username:(NSString*)username password:(NSString*)password {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url username:username password:password];
    [request setHTTPMethod:@"POST"];
	if (body) {
		[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	}
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancel {
	[connection cancel];
	[self requestFailed:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
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
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [recievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self requestSucceeded];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
	[self requestFailed:error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
