#ifdef ENABLE_OAUTH
#import "NTLNHttpClient.h"
#import "OAHMAC_SHA1SignatureProvider.h"
#import "OAConsumer.h"

@interface NTLNOAuthHttpClient : NTLNHttpClient {
	OAHMAC_SHA1SignatureProvider *signatureProvider;
	OAConsumer *consumer;
}

@end

#endif