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

- (void)requestGET:(NSString*)url {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)requestPOST:(NSString*)url body:(NSString*)body {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url];
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
