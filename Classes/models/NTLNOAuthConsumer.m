#import "NTLNOAuthConsumer.h"
#import "GTMObjectSingleton.h"

#import "twitter_apikeys.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OAServiceTicket.h"

#import "NTLNOAuthBrowserViewController.h"
#import "GTMRegex.h"

@implementation NTLNOAuthConsumer

GTMOBJECT_SINGLETON_BOILERPLATE(NTLNOAuthConsumer, sharedInstance)

#pragma mark Public

- (void)requestToken:(UIViewController*)viewController {
	[rootViewController release];
	rootViewController = [viewController retain];
	
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:TWITTER_OAUTH_CONSUMER_KEY
                                                    secret:TWITTER_OAUTH_CONSUMER_SECRET];
	
    NSURL *url = [NSURL URLWithString:@"http://twitter.com/oauth/request_token"];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
	
    [request setHTTPMethod:@"POST"];
	
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
	
}

#pragma mark Private

- (void)dealloc {
	[rootViewController release];
	[super dealloc];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		///		requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		//		NSLog(@"responseBody: %@", responseBody);
		NSString *url = [NSString stringWithFormat:@"https://twitter.com/oauth/authorize?%@", responseBody];

		NTLNOAuthBrowserViewController *bvc = [[[NTLNOAuthBrowserViewController alloc] init] autorelease];
		bvc.url = url;
		[rootViewController presentModalViewController:bvc animated:YES];
		[rootViewController release];
		rootViewController = nil;
		
		//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	NSLog(@"Error: %@", error);
	[rootViewController release];
	rootViewController = nil;
}


- (BOOL)isCallbackURL:(NSURL*)url {
	NSString *u = [url description];
	return [u gtm_matchesPattern:
			@"^http:\\/\\/iphone.natsulion.org\\/oauth_callback\\?oauth_token=.*$"];
}

- (void)accessToken:(NSURL*)callbackUrl {
	NSString *u = [callbackUrl description];
	NSArray *a = [u gtm_subPatternsOfPattern: 
				  @"^http:\\/\\/iphone.natsulion.org\\/oauth_callback\\?(oauth_token=.*)$"];
	if (a && a.count == 2) {
		NSString *param = [a objectAtIndex:1];
		NSLog(@"param: %@", param);
	}
	
}


@end
