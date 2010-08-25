#import <UIKit/UIKit.h>
#import "OAHMAC_SHA1SignatureProvider.h"
#import "OAConsumer.h"
#import "OAToken.h"

@interface OAuthHttpClient : NSObject {
	OAHMAC_SHA1SignatureProvider *signatureProvider;
	OAConsumer *consumer;
    NSURLConnection *connection;
    NSMutableData *recievedData;
	int statusCode;	
	BOOL contentTypeIsXml;
	OAToken *_token;
	
	int rate_limit;
	int rate_limit_remaining;
	NSDate *rate_limit_reset;
}

- (void)requestGET:(NSString*)url;
- (void)requestGETWithoutAuth:(NSString*)url;
- (void)requestPOST:(NSString*)url body:(NSString*)body;
- (void)cancel;

- (NSMutableURLRequest*)makeRequest:(NSString*)url;
- (void)requestSucceeded;
- (void)requestFailed:(NSError*)error;

@property (readonly) NSMutableData *recievedData;
@property (readonly) int statusCode;
@property (readwrite, retain) OAToken *token;

@end
