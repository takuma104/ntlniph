#import "OAToken.h"
#import "OAConsumer.h"
#import "TwitterToken.h"

@class XAuthAccessTokenClient;

@protocol XAuthAccessTokenClientDelegate
- (void)XAuthAccessTokenClient:(XAuthAccessTokenClient*)client 
		   didSuccessWithToken:(TwitterToken*)token;
- (void)XAuthAccessTokenClient:(XAuthAccessTokenClient*)client 
			  didFailWithError:(NSError*)error;

@end


@interface XAuthAccessTokenClient : NSObject {
	id<XAuthAccessTokenClientDelegate> _delegate;
}

@property (readwrite, assign) id<XAuthAccessTokenClientDelegate> delegate;

+ (OAConsumer *)consumer;
- (void)requestTokenWithScreenName:(NSString*)screenName
						  password:(NSString*)password;


@end
