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
	BOOL requestForDirectMessage;
}

- (id)initWithDelegate:(NSObject<NTLNTwitterClientDelegate>*)delegate;

- (void)getFriendsTimelineWithPage:(int)page since_id:(NSString*)since_id;
- (void)getRepliesTimelineWithPage:(int)page;
- (void)getSentsTimelineWithPage:(int)page since_id:(NSString*)since_id;
- (void)getUserTimelineWithScreenName:(NSString*)screenName page:(int)page since_id:(NSString*)since_id;
- (void)getDirectMessagesWithPage:(int)page;
- (void)getSentDirectMessagesWithPage:(int)page;
- (void)createFavoriteWithID:(NSString*)messageId;
- (void)destroyFavoriteWithID:(NSString*)messageId;
- (void)post:(NSString*)tweet;

@property (readonly) int requestPage;
@property (readonly) BOOL requestForDirectMessage;

@end
