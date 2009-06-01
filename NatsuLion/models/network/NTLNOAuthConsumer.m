#ifdef ENABLE_OAUTH
#import "NTLNOAuthConsumer.h"
#import "GTMObjectSingleton.h"

#import "twitter_apikeys.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OAServiceTicket.h"

#import "GTMRegex.h"
#import "NTLNConfigurationKeys.h"
#import "NTLNAccount.h"

#import "NTLNAppDelegate.h"

@implementation NTLNOAuthConsumer

GTMOBJECT_SINGLETON_BOILERPLATE(NTLNOAuthConsumer, sharedInstance)

#pragma mark Public

- (OAConsumer *)consumer {
	return [[[OAConsumer alloc] initWithKey:TWITTER_OAUTH_CONSUMER_KEY
									 secret:TWITTER_OAUTH_CONSUMER_SECRET] autorelease];
}

- (void)requestToken:(UIViewController*)viewController {
	[rootViewController release];
	rootViewController = [viewController retain];
	
    NSURL *url = [NSURL URLWithString:@"http://twitter.com/oauth/request_token"];
	
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
																	consumer:[self consumer]
																	   token:nil   // we don't have a Token yet
																	   realm:nil   // our service provider doesn't specify a realm
														   signatureProvider:nil]  // use the default method, HMAC-SHA1
																		autorelease]; 
	
    [request setHTTPMethod:@"POST"];
	
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
	
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
	
}

- (BOOL)isCallbackURL:(NSURL*)url {
	NSString *u = [url description];
	return [u gtm_matchesPattern:
			@"^.*oauth_callback\\?oauth_token=.*$"];
}

- (void)accessToken:(NSURL*)callbackUrl {
	NSString *u = [callbackUrl description];
	NSArray *a = [u gtm_subPatternsOfPattern: 
				  @"^.*oauth_callback\\?(oauth_token=.*)$"];
	if (a && a.count != 2) {
		//error?
		return;
	}
	
	NSString *response = [a objectAtIndex:1];
	LOG(@"response: %@", response);
	
	OAToken *token = [[[OAToken alloc] initWithHTTPResponseBody:response] autorelease];
		
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/oauth/access_token"];
	
	OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
																   consumer:[self consumer]
																	  token:token
																	  realm:nil   // our service provider doesn't specify a realm
														  signatureProvider:nil] autorelease]; // use the default method, HMAC-SHA1
	
	[request setHTTPMethod:@"POST"];
	
	OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
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
		NSString *url = [NSString stringWithFormat:@"https://twitter.com/oauth/authorize?%@", responseBody];
		[responseBody release];

		[[NTLNAccount sharedInstance] setWaitForOAuthCallback:YES];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	LOG(@"Error: %@", error);
	[rootViewController release];
	rootViewController = nil;
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

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[[NTLNAccount sharedInstance] setUserToken:token];
		[token release];

		NSString *screenName = [self screenNameFromHTTPResponseBody:responseBody];
		[[NTLNAccount sharedInstance] setScreenName:screenName];
		[responseBody release];
		
		[(NTLNAppDelegate*)[UIApplication sharedApplication].delegate resetAllTimelinesAndCache];
	}
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	LOG(@"Error: %@", error);
}

@end

#endif
