#import <UIKit/UIKit.h>

@interface NTLNHttpClient : NSObject {
    NSURLConnection *connection;
    NSMutableData *recievedData;
	int statusCode;	
}

- (void)requestGET:(NSString*)url;
- (void)requestPOST:(NSString*)url body:(NSString*)body;
- (void)cancel;

- (void)requestSucceeded;
- (void)requestFailed:(NSError*)error;

@property (readonly) NSMutableData *recievedData;
@property (readonly) int statusCode;

@end
