#import <UIKit/UIKit.h>
#import "NTLNUser.h"
#import "NTLNHttpClient.h"

@class NTLNTwitterUserClient;

@protocol NTLNTwitterUserClientDelegate
- (void)twitterUserClientSucceeded:(NTLNTwitterUserClient*)sender;
- (void)twitterUserClientFailed:(NTLNTwitterUserClient*)sender;
@end

@interface NTLNTwitterUserClient : NTLNHttpClient {
	@private
	NSObject<NTLNTwitterUserClientDelegate> *delegate;
	NTLNUser *user;
}

- (id)initWithDelegate:(NSObject<NTLNTwitterUserClientDelegate>*)delegate;
- (void)getUserInfoForScreenName:(NSString*)screen_name;
- (void)getUserInfoForUserId:(NSString*)user_id;

@property (readonly) NTLNUser *user;

@end
