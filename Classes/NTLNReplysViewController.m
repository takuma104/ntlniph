#import "NTLNReplysViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"

@implementation NTLNReplysViewController

- (void)setupNavigationBar {
	[super setupNavigationBar];
	[super setupPostButton];
}

- (void)dealloc {
	[super dealloc];
}

- (void)viewDidLoad {	
	[super viewDidLoad];
	always_read_tweets = NO;
	badge_enable = YES;
}

- (void)initialCacheLoading {
	[super initialCacheLoading:@"replies.xml"];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)getTimelineImplWithPage:(int)page {
	NTLNTwitterClient *tc = [[NTLNTwitterClient alloc] initWithDelegate:self];
	[tc getRepliesTimelineWithPage:page];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.navigationItem setTitle:@"Replies"];
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

// !! duplicated from friends view
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

// !! duplicated from friends view
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
