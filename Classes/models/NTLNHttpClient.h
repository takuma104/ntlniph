#import <UIKit/UIKit.h>

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
- (void)cancel;

- (void)requestSucceeded;
- (void)requestFailed:(NSError*)error;

- (void)reset;

@property (readonly) NSMutableData *recievedData;
@property (readonly) int statusCode;

@end
