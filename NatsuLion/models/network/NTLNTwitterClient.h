#import <UIKit/UIKit.h>
#import "NTLNOAuthHttpClient.h"
#import "NTLNTwitterXMLParser.h"

@class NTLNTwitterClient;

@protocol NTLNTwitterClientDelegate
- (void)twitterClientBegin:(NTLNTwitterClient*)sender;
- (void)twitterClientEnd:(NTLNTwitterClient*)sender;
- (void)twitterClientSucceeded:(NTLNTwitterClient*)sender messages:(NSArray*)messages;
- (void)twitterClientFailed:(NTLNTwitterClient*)sender;
@end

#ifdef ENABLE_OAUTH
@interface NTLNTwitterClient : NTLNOAuthHttpClient {
#else
@interface NTLNTwitterClient : NTLNHttpClient {
#endif
	int requestPage;
	NSString *screenNameForUserTimeline;
	BOOL parseResultXML;
	NSObject<NTLNTwitterClientDelegate> *delegate;
	BOOL requestForTimeline;
	BOOL requestForDirectMessage;
	NTLNTwitterXMLParser *xmlParser;
}

- (void)getFriendsTimelineWithPage:(int)page since_id:(NSString*)since_id;
- (void)getRepliesTimelineWithPage:(int)page since_id:(NSString*)since_id;
- (void)getSentsTimelineWithPage:(int)page since_id:(NSString*)since_id;
- (void)getUserTimelineWithScreenName:(NSString*)screenName page:(int)page since_id:(NSString*)since_id;
- (void)getDirectMessagesWithPage:(int)page since_id:(NSString*)since_id;
- (void)getSentDirectMessagesWithPage:(int)page;
- (void)getFavoriteWithScreenName:(NSString*)screenName page:(int)page since_id:(NSString*)since_id;
- (void)getStatusWithStatusId:(NSString*)statusId;
- (void)createFavoriteWithID:(NSString*)messageId;
- (void)destroyFavoriteWithID:(NSString*)messageId;
- (void)post:(NSString*)tweet reply_id:(NSString*)reply_id;

@property (readonly) int requestPage;
@property (readonly) BOOL requestForDirectMessage;
@property (readwrite, retain) NSObject<NTLNTwitterClientDelegate> *delegate;

@end
