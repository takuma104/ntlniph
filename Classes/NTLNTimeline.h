#import "NTLNStatus.h"
#import "NTLNTwitterClient.h"

@class NTLNTimeline;

@protocol NTLNTimelineDelegate
- (void)timeline:(NTLNTimeline*)timeline requestForPage:(int)page since_id:(NSString*)since_id;
- (void)timeline:(NTLNTimeline*)timeline clientBegin:(NTLNTwitterClient*)client;
- (void)timeline:(NTLNTimeline*)timeline clientEnd:(NTLNTwitterClient*)client;
- (void)timeline:(NTLNTimeline*)timeline clientSucceeded:(NTLNTwitterClient*)client insertedStatuses:(NSArray*)statuses;
- (void)timeline:(NTLNTimeline*)timeline clientFailed:(NTLNTwitterClient*)client;

@end

@interface NTLNTimeline : NSObject<NTLNTwitterClientDelegate> {
	NSObject<NTLNTimelineDelegate>* delegate;
	NSMutableArray *timeline;
	NSString *archiverCachePath;
	NTLNTwitterClient *activeTwitterClient;
	NSDate *lastReloadTime;
	NSTimer *refreshTimer;
	BOOL readTracker;
	BOOL autoRefresh;
	BOOL evenInv;
	BOOL updated;
	BOOL getLatest20TweetOnHumanOperation;
	BOOL loadArchive;
}

@property (readwrite) BOOL readTracker;
@property (readwrite) BOOL autoRefresh;
@property (readwrite) BOOL getLatest20TweetOnHumanOperation;

- (id)initWithDelegate:(NSObject<NTLNTimelineDelegate>*)delegate
   withArchiveFilename:(NSString*)filename;

- (id)initWithDelegate:(NSObject<NTLNTimelineDelegate>*)delegate
   withArchiveFilename:(NSString*)filename withLoadArchive:(BOOL)loadArchive;

- (void)activate;
- (void)suspend;
- (void)disactivate;
- (void)clear;
- (void)prefetch;
- (void)clearAndRemoveCache;

- (void)getTimelineWithPage:(int)page autoload:(BOOL)autoload;

- (void)removeLastReloadTime; // !!

- (BOOL)isClientActive;
- (void)clientCancel;

// call from delegate (for syncronization)
- (int)count;
- (NTLNStatus*)statusAtIndex:(int)index;
- (BOOL)isEven:(int)index;
- (int)indexFromStatusId:(NSString*)statusId;
- (NSString*)latestStatusId;

- (void)appendStatuses:(NSArray*)statuses;

- (int)badgeCount;

- (NSMutableArray*)unreadStatuses;
- (void)markAllAsRead;

- (void)hilightByScreenName:(NSString*)screenName;

@end
