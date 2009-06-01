#import <UIKit/UIKit.h>
#import "NTLNUser.h"
#import "NTLNHttpClient.h"
#import "NTLNOAuthHttpClient.h"

@class NTLNTwitterUserClient;

@protocol NTLNTwitterUserClientDelegate
- (void)twitterUserClientSucceeded:(NTLNTwitterUserClient*)sender;
- (void)twitterUserClientFailed:(NTLNTwitterUserClient*)sender;
@end

#ifdef ENABLE_OAUTH
@interface NTLNTwitterUserClient : NTLNOAuthHttpClient {
#else
@interface NTLNTwitterUserClient : NTLNHttpClient {
#endif
@private
	NSObject<NTLNTwitterUserClientDelegate> *delegate;
	NSMutableArray *users;
}

@property (readwrite, retain) NSObject<NTLNTwitterUserClientDelegate> *delegate;

- (void)getUserInfoForScreenName:(NSString*)screen_name;
- (void)getUserInfoForUserId:(NSString*)user_id;
- (void)getFollowingsWithScreenName:(NSString*)screen_name page:(int)page;
- (void)getFollowersWithScreenName:(NSString*)screen_name page:(int)page;

@property (readonly) NSMutableArray *users;

@end
