#import "OAuthHttpClient.h"
#import "OAToken.h"
#import "OAMutableURLRequest.h"
#import "XAuthAccessTokenClient.h"
#import "NetworkActivityIndicator.h"

#define TIMEOUT_SEC		20.0

@implementation OAuthHttpClient

@synthesize recievedData, statusCode;
@synthesize token = _token;

- (id)init {
	if (self = [super init]) {
		recievedData = [[NSMutableData alloc] init];
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


- (void)requestGET:(NSString*)url {
	NSMutableURLRequest *request = [self makeRequest:url];
	[(OAMutableURLRequest*)request prepare];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	[[NetworkActivityIndicator sharedNetworkActivityIndicator] beginAnimation];
}

- (void)requestPOST:(NSString*)url body:(NSString*)body {
	NSMutableURLRequest *request = [self makeRequest:url];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	[(OAMutableURLRequest*)request prepare];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	[[NetworkActivityIndicator sharedNetworkActivityIndicator] beginAnimation];
}

- (void)cancel {
	[connection cancel];
	[self requestFailed:nil];
	[[NetworkActivityIndicator sharedNetworkActivityIndicator] stopAnimation];
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
	[[NetworkActivityIndicator sharedNetworkActivityIndicator] stopAnimation];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
	[self requestFailed:error];
	[[NetworkActivityIndicator sharedNetworkActivityIndicator] stopAnimation];
}

@end
