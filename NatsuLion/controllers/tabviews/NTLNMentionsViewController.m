#import "NTLNMentionsViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "NTLNCache.h"
#import "NTLNTwitterClient.h"
#import "NTLNFriendsViewController.h"
#import "NTLNHttpClientPool.h"

@implementation NTLNMentionsViewController

@synthesize friendsViewController;

- (id)init {
	if (self = [super init]) {
		timeline = [[NTLNTimeline alloc] initWithDelegate:self 
									  withArchiveFilename:@"replies.plist"];
		timeline.readTracker = YES;
		timeline.getLatest20TweetOnHumanOperation = YES;
		badge_enable = YES;
		disableColorize = YES;
	}
	return self;
}

- (void)setupNavigationBar {
	[super setupNavigationBar];
	[super setupPostButton];
	[super setupClearButton];
	[self.navigationItem setTitle:@"Mentions"];
}

- (void)dealloc {
	[super dealloc];
}

- (void)allRead {
	[timeline markAllAsRead];
	[self.tableView reloadData];
	[self updateBadge];
}

- (void)timeline:(NTLNTimeline*)tl requestForPage:(int)page since_id:(NSString*)since_id {
	NTLNTwitterClient *tc = [[NTLNHttpClientPool sharedInstance] 
								idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
	tc.delegate = tl;
	[tc getRepliesTimelineWithPage:page since_id:since_id];
}

- (void)timeline:(NTLNTimeline*)tl clientSucceeded:(NTLNTwitterClient*)client insertedStatuses:(NSArray*)statuses {
	[super timeline:tl clientSucceeded:client insertedStatuses:statuses];
//	[friendsViewController.timeline appendStatuses:statuses];
}

@end
