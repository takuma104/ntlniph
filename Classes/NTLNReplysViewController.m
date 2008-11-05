#import "NTLNReplysViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "NTLNCache.h"
#import "NTLNTwitterXMLReader.h"
#import "NTLNTwitterClient.h"

@implementation NTLNReplysViewController

- (void)setupNavigationBar {
	[super setupNavigationBar];
	[super setupPostButton];
	[self.navigationItem setTitle:@"Replies"];
}

- (void)dealloc {
	[repliesXMLPath release];
	[directMessageXMLPath release];
	[super dealloc];
}

- (void)viewDidLoad {	
	[super viewDidLoad];
	always_read_tweets = NO;
	badge_enable = YES;
}

- (void)saveCache:(NTLNTwitterClient*)sender {
	if (sender.requestForDirectMessage) {
		[super saveCache:sender filename:directMessageXMLPath];
	} else {
		[super saveCache:sender filename:repliesXMLPath];
	}
}

- (void)initialCacheLoading {
	repliesXMLPath = [[[NTLNCache createXMLCacheDirectory] stringByAppendingString:@"replies.xml"] retain];
	directMessageXMLPath = [[[NTLNCache createXMLCacheDirectory] stringByAppendingString:@"dm.xml"] retain];
	[super loadCacheWithFilename:repliesXMLPath];
	[super loadCacheWithFilename:directMessageXMLPath];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)getTimelineImplWithPage:(int)page since_id:(NSString*)since_id {
	NTLNTwitterClient *tc = [[NTLNTwitterClient alloc] initWithDelegate:self];
	[tc getRepliesTimelineWithPage:page];

	NTLNTwitterClient *tcd = [[NTLNTwitterClient alloc] initWithDelegate:self];
	[tcd getDirectMessagesWithPage:page];
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
