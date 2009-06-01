#import "NTLNDirectMessageViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "NTLNCache.h"
#import "NTLNTwitterClient.h"
#import "NTLNHttpClientPool.h"


@implementation NTLNDirectMessageViewController

- (id)init {
	if (self = [super init]) {
		timeline = [[NTLNTimeline alloc] initWithDelegate:self 
									  withArchiveFilename:@"direct_message.plist"];
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
	[self.navigationItem setTitle:@"Direct Messages"];
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
	[tc getDirectMessagesWithPage:page since_id:since_id];
}

@end
