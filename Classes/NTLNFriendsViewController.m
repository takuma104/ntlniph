#import "NTLNFriendsViewController.h"
#import "NTLNLinkViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "ntlniphAppDelegate.h"
#import "NTLNTweetPostViewController.h"

#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kBottomMargin			20.0
#define kTweenMargin			10.0
#define kTextFieldHeight		30.0

#define TITLE_NAME @"NatsuLion for iPhone"

@implementation NTLNFriendsViewController

- (void)setupNavigationBar {
	[super setupNavigationBar];
	[super setupPostButton];
	[self.navigationItem setTitle:TITLE_NAME];
}

- (void)initialCacheLoading {
	[super initialCacheLoading:@"friends_timeline.xml"];
	always_read_tweets = NO;
	badge_enable = YES;
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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)loadCache {
	if ( ! [[NTLNConfiguration instance] showMoreTweetMode]) {
		[super loadCache];
	}
}

/////////////////// timer

- (void) timerExpired {
	[self getTimelineWithPage:0 autoload:YES];
}

- (void)getTimelineImplWithPage:(int)page since_id:(NSString*)since_id {
    if (!tweetPostViewController.active && appDelegate.applicationActive) {
		NTLNTwitterClient *tc = [[NTLNTwitterClient alloc] initWithDelegate:self];
		[tc getFriendsTimelineWithPage:page since_id:since_id];
	}
}

// !! duplicated to replys view
- (NSMutableArray*)unreadStatuses {
	NSMutableArray *ret = [[NSMutableArray alloc] init];
	@synchronized(timeline) {
		for (NTLNStatus *s in timeline) {
			if (s.message.status == NTLN_MESSAGE_STATUS_NORMAL) {
				[ret addObject:[s retain]];
			}
		}
	}
	return ret;
}

// !! duplicated to replys view
- (void)allRead {
	@synchronized(timeline) {
		for (NTLNStatus *s in timeline) {
			s.message.status = NTLN_MESSAGE_STATUS_READ;
		}
	}
	unread_count = 0;
	super.tabBarItem.badgeValue = nil;
}

@end
