#import "NTLNHttpClient.h"
#import "OAHMAC_SHA1SignatureProvider.h"
#import "OAToken.h"
#import "OAConsumer.h"

@interface NTLNOAuthHttpClient : NTLNHttpClient {
	OAHMAC_SHA1SignatureProvider *signatureProvider;
	OAToken *token;
	OAConsumer *consumer;
}

@end
