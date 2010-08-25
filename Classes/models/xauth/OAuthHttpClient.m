#import "OAuthHttpClient.h"
#import "OAToken.h"
#import "OAMutableURLRequest.h"
#import "XAuthAccessTokenClient.h"

#define TIMEOUT_SEC		20.0

@implementation OAuthHttpClient

@synthesize recievedData, statusCode;
@synthesize token = _token;

- (id)init {
	if (self = [super init]) {
		[self reset];
	}
	return self;
}

- (void)dealloc {
//	LOG(@"NTLNHttpClient#dealloc");
	[connection release];
	[recievedData release];
	[signatureProvider release];
	[consumer release];
	[_token release];
	[super dealloc];
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

- (NSMutableURLRequest*)makeRequest:(NSString*)url {
	if (signatureProvider == nil) {
		signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	}
	
	if (consumer == nil) {
		consumer = [[XAuthAccessTokenClient consumer] retain];
	}
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                   consumer:consumer
                                                                      token:_token
                                                                      realm:nil
                                                          signatureProvider:signatureProvider];
	[request setTimeoutInterval:TIMEOUT_SEC];
	[request autorelease];
	return request;
}

- (NSMutableURLRequest*)makeRequestWithoutAuth:(NSString*)url {
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

- (void)requestGETWithoutAuth:(NSString*)url {
	NSMutableURLRequest *request = [self makeRequestWithoutAuth:url];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)requestGET:(NSString*)url {
	NSMutableURLRequest *request = [self makeRequest:url];
	[(OAMutableURLRequest*)request prepare];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)requestPOST:(NSString*)url body:(NSString*)body {
	NSMutableURLRequest *request = [self makeRequest:url];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	[(OAMutableURLRequest*)request prepare];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)cancel {
	[connection cancel];
	[self requestFailed:nil];
	[self reset];
}

- (void)requestSucceeded {
	// implement by subclass
}

- (void)requestFailed:(NSError*)error {
	// implement by subclass
}

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
    [recievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self requestSucceeded];
	[self reset];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
	[self requestFailed:error];
	[self reset];
}

@end
