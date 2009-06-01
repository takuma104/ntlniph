#import <UIKit/UIKit.h>

#define TIMEOUT_SEC		20.0

@interface NTLNHttpClient : NSObject {
    NSURLConnection *connection;
    NSMutableData *recievedData;
	int statusCode;	
	BOOL contentTypeIsXml;
	
	int rate_limit;
	int rate_limit_remaining;
	NSDate *rate_limit_reset;
}

- (void)requestGET:(NSString*)url;
- (void)requestPOST:(NSString*)url body:(NSString*)body;
- (void)requestGET:(NSString*)url username:(NSString*)username password:(NSString*)password;
- (void)requestPOST:(NSString*)url body:(NSString*)body username:(NSString*)username password:(NSString*)password;

- (void)cancel;

- (void)requestSucceeded;
- (void)requestFailed:(NSError*)error;

- (void)reset;

@property (readonly) NSMutableData *recievedData;
@property (readonly) int statusCode;

@end
