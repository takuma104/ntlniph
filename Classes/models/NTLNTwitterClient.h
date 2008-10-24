#import <UIKit/UIKit.h>
#import "NTLNHttpClient.h"

@class NTLNTwitterClient;

@protocol NTLNTwitterClientDelegate
- (void)twitterClientBegin:(NTLNTwitterClient*)sender;
- (void)twitterClientEnd:(NTLNTwitterClient*)sender;
- (void)twitterClientSucceeded:(NTLNTwitterClient*)sender messages:(NSArray*)messages;
- (void)twitterClientFailed:(NTLNTwitterClient*)sender;
@end

@interface NTLNTwitterClient : NTLNHttpClient {
	int requestPage;
	NSString *screenNameForUserTimeline;
	BOOL parseResultXML;
	NSObject<NTLNTwitterClientDelegate> *delegate;
	BOOL requestForTimeline;
}

- (id)initWithDelegate:(NSObject<NTLNTwitterClientDelegate>*)delegate;

- (void)getFriendsTimelineWithPage:(int)page;
- (void)getRepliesTimelineWithPage:(int)page;
- (void)getSentsTimelineWithPage:(int)page;
- (void)getUserTimelineWithScreenName:(NSString*)screenName page:(int)page;
- (void)createFavoriteWithID:(NSString*)messageId;
- (void)destroyFavoriteWithID:(NSString*)messageId;
- (void)post:(NSString*)tweet;

@property (readonly) int requestPage;

@end
