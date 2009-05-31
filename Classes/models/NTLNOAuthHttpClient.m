#ifdef ENABLE_OAUTH
#import "NTLNOAuthHttpClient.h"
#import "OAMutableURLRequest.h"
#import "NTLNConfigurationKeys.h"
#import "NTLNOAuthConsumer.h"
#import "NTLNAccount.h"

@implementation NTLNOAuthHttpClient

- (void)deallc {
	[signatureProvider release];
	[consumer release];
	[super dealloc];
}

- (NSMutableURLRequest*)makeRequest:(NSString*)url {

	if (signatureProvider == nil) {
		signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	}
	
	if (consumer == nil) {
		consumer = [[[NTLNOAuthConsumer sharedInstance] consumer] retain];
	}
	
	OAToken *token = [[NTLNAccount sharedInstance] userToken];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:nil
                                                          signatureProvider:signatureProvider];
	[request setTimeoutInterval:TIMEOUT_SEC];
	[request autorelease];
	return request;
}

- (void)prepareWithRequest:(NSMutableURLRequest*)request {
	[(OAMutableURLRequest*)request prepare]; // this is important for OAMutableURLRequest
}

@end

#endif
