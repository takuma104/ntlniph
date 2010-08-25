#import "XAuthAccessTokenClient.h"
#import "APIKeys.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OAAsynchronousDataFetcher.h"
#import "OAServiceTicket.h"
#import "NetworkActivityIndicator.h"

@implementation XAuthAccessTokenClient

@synthesize delegate = _delegate;

+ (OAConsumer *)consumer {
	return [[[OAConsumer alloc] initWithKey:TWITTER_OAUTH_CONSUMER_KEY
									 secret:TWITTER_OAUTH_CONSUMER_SECRET] autorelease];
}

- (void)requestTokenWithScreenName:(NSString*)screenName
						  password:(NSString*)password {
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
																	consumer:[[self class] consumer]
																	   token:nil   // we don't have a Token yet
																	   realm:nil   // our service provider doesn't specify a realm
														   signatureProvider:nil]  // use the default method, HMAC-SHA1
									autorelease]; 
    [request setHTTPMethod:@"POST"];
	[request setParameters:[NSArray arrayWithObjects:
							[OARequestParameter requestParameterWithName:@"x_auth_mode" 
																   value:@"client_auth"],
							[OARequestParameter requestParameterWithName:@"x_auth_username" 
																   value:screenName],
							[OARequestParameter requestParameterWithName:@"x_auth_password" 
																   value:password],
							nil]];
	[request setTimeoutInterval:20.0];

    OAAsynchronousDataFetcher *fetcher;
	fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:request
															   delegate:self
													  didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
														didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
	[fetcher start];
	[[NetworkActivityIndicator sharedNetworkActivityIndicator] beginAnimation];
}

- (NSString*)screenNameFromHTTPResponseBody:(NSString*)body {
	NSArray *pairs = [body componentsSeparatedByString:@"&"];
	for (NSString *pair in pairs) {
		NSArray *elements = [pair componentsSeparatedByString:@"="];
		if ([[elements objectAtIndex:0] isEqualToString:@"screen_name"]) {
			return [elements objectAtIndex:1];
		}
	}
	return nil;
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket 
		didFinishWithData:(NSData *)data {
	[[NetworkActivityIndicator sharedNetworkActivityIndicator] stopAnimation];
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		TwitterToken *tt = [[[TwitterToken alloc] init] autorelease];
		tt.token = [[[OAToken alloc] initWithHTTPResponseBody:responseBody] autorelease];
		tt.screenName = [self screenNameFromHTTPResponseBody:responseBody];
		[self.delegate XAuthAccessTokenClient:self
						  didSuccessWithToken:tt];
		[responseBody release];
	} else {
		[self.delegate XAuthAccessTokenClient:self
							 didFailWithError:nil];
	}
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket 
		 didFailWithError:(NSError *)error {
	[[NetworkActivityIndicator sharedNetworkActivityIndicator] stopAnimation];
	[self.delegate XAuthAccessTokenClient:self
						 didFailWithError:error];
}

@end
