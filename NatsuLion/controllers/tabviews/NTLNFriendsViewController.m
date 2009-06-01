#import "NTLNFriendsViewController.h"
#import "NTLNTweetViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "NTLNAppDelegate.h"
#import "NTLNTweetPostViewController.h"
#import "NTLNMentionsViewController.h"
#import "NTLNHttpClientPool.h"

#define TITLE_NAME @"NatsuLion for iPhone"

@implementation NTLNFriendsViewController

@synthesize mentionsViewController;

- (id)init {
	if (self = [super init]) {
		BOOL loadArchive = ! [[NTLNConfiguration instance] showMoreTweetMode];
		timeline = [[NTLNTimeline alloc] initWithDelegate:self 
									  withArchiveFilename:@"friends_timeline.plist"
										  withLoadArchive:loadArchive];
		timeline.readTracker = YES;
		timeline.autoRefresh = YES;
	}
	return self;
}

- (void)setupNavigationBar {
	[super setupNavigationBar];
	[super setupPostButton];
	[super setupClearButton];
	[self.navigationItem setTitle:TITLE_NAME];
}

- (void) dealloc {
    [super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (! tweetTextField.editing) {
		[self.navigationItem setTitle:@"Timeline"];
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationItem setTitle:TITLE_NAME];
	[super viewWillAppear:animated];
}

- (void)timeline:(NTLNTimeline*)tl requestForPage:(int)page since_id:(NSString*)since_id {
	NTLNTwitterClient *tc = [[NTLNHttpClientPool sharedInstance] 
								idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
	tc.delegate = tl;
	[tc getFriendsTimelineWithPage:page since_id:since_id];
}

- (void)timeline:(NTLNTimeline*)tl clientSucceeded:(NTLNTwitterClient*)client insertedStatuses:(NSArray*)statuses {
	[super timeline:tl clientSucceeded:client insertedStatuses:statuses];

	NSMutableArray *replies = [[NSMutableArray alloc] init];
	for (NTLNStatus *s in statuses) {
		if (s.message.replyType == NTLN_MESSAGE_REPLY_TYPE_REPLY || 
			s.message.replyType == NTLN_MESSAGE_REPLY_TYPE_REPLY_PROBABLE) {
			[replies addObject:s];
		}
	}
	if (replies.count > 0) {
		[mentionsViewController.timeline appendStatuses:replies];
		[mentionsViewController updateBadge];
	}
	[replies release];
}

- (BOOL)doReadTrack {
	BOOL updated = [super doReadTrack];
	if (updated) {
		[mentionsViewController updateBadge];
	}
	return updated;
}

@end
