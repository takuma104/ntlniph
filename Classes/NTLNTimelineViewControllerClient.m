#import "NTLNTimelineViewController.h"
#import "NTLNConfiguration.h"
#import "NTLNAccount.h"
#import "Reachability.h"

@implementation NTLNTimelineViewController(Client)

#pragma mark Private

static int compareStatus(NTLNStatus *a, NTLNStatus *b, void *ptr)
{
	NTLNMessage *msg_a = a.message;
	NTLNMessage *msg_b = b.message;
	enum NTLNReplyType ra = msg_a.replyType;
	enum NTLNReplyType rb = msg_b.replyType;
	
	int c = [msg_a.statusId compare:msg_b.statusId options:NSNumericSearch];
	if (c == 0) return 0;
	
	if ((ra == NTLN_MESSAGE_REPLY_TYPE_DIRECT && rb != NTLN_MESSAGE_REPLY_TYPE_DIRECT) ||
		(ra != NTLN_MESSAGE_REPLY_TYPE_DIRECT && rb == NTLN_MESSAGE_REPLY_TYPE_DIRECT)) {
		
		int c_ = [msg_a.timestamp compare:msg_b.timestamp];
		if (c_ != 0) {
			c = c_;
		}
	}
	return (-1) * c;	
}

- (BOOL)insertStatusToSortedTimeline:(NTLNStatus*)status {
	int i = 0;
	for (NTLNStatus *s in timeline) {
		int n = compareStatus(s, status, nil);
		if (n == 0) return NO;
		if (n > 0) {
			[timeline insertObject:status atIndex:i];
			return YES;
		}
		i++;
	}
	
	[timeline addObject:status];
	return YES;
}

- (NSString*)latestStatusId {
	NSString *statusId = nil;
	@synchronized(timeline) {
		if ([timeline count] > 0) {
			NTLNStatus *s = [timeline objectAtIndex:0];
			statusId = [[s.message.statusId copy] autorelease];
		}
	}
	return statusId;
}

#pragma mark NTLNTwitterClientDelegate

- (void)twitterClientSucceeded:(NTLNTwitterClient*)sender messages:(NSArray*)statuses {
	
	if (sender && sender.requestPage == 0) {
		[self saveCache:sender];
	}
	
	int cnt = 0;
	int initial_timeline_count = 0;
	@synchronized(timeline) {
		initial_timeline_count = timeline.count;
		for (NTLNMessage *msg in statuses) {
			NTLNStatus *status = [[NTLNStatus alloc] initWithMessage:msg];
			status.statusRead = self;
			
			BOOL inserted = [self insertStatusToSortedTimeline:status];
			if (inserted) {
				if (! always_read_tweets) {
					[self incrementReadStatus:status];
				} else {
					status.message.status = NTLN_MESSAGE_STATUS_READ;
				}
				cnt++;
			}
			[status release];
		}
	}
	
	[self removeNowloadingView];
	
	if ([[NTLNConfiguration instance] scrollLock] && 
		activeTwitterClient.requestPage == 0 && 
		initial_timeline_count > 0) {
		if (cnt > 0) {
			CGFloat y = self.tableView.contentOffset.y;
			CGFloat offset = 0.f;
			for (int i = 0; i < cnt; i++) {
				offset += [self cellHeightForIndex:i];
			}
			
			[self.tableView reloadData];
			
			self.tableView.contentOffset = CGPointMake(0, y + offset);
			
			[self checkCellRead];
			[self.tableView flashScrollIndicators];
		}
	} else {
		if (cnt > 0 && cnt < 8 && timeline.count >= 20) {
			NSMutableArray *indexPath = [[[NSMutableArray alloc] init] autorelease];
			for (int i = 0; i < cnt; ++i) {
				[indexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
			}        
			[self.tableView beginUpdates];
			[self.tableView insertRowsAtIndexPaths:indexPath 
			 withRowAnimation:UITableViewRowAnimationTop];
			[self.tableView endUpdates];
			
			[self checkCellRead];
		}
		else if (cnt > 0){
			[self.tableView reloadData];
			[self checkCellRead];
			[self.tableView flashScrollIndicators];
		}
	}
	
	[self attachOrDetachAutopagerizeView];
	if ([statuses count] == 0) {
		if (self.tableView.tableFooterView && currentPage >= 10) {
			self.tableView.tableFooterView = nil;
		}
	}
	
	scrollMoved = NO;
}

- (void)twitterClientFailed:(NTLNTwitterClient*)sender {
	[self removeNowloadingView];
}

- (void)twitterClientBegin:(NTLNTwitterClient*)sender {
	NSLog(@"StatusView#twitterClientBegin");
	
	[reloadButton release];
	reloadButton = [[UIBarButtonItem alloc] 
					initWithBarButtonSystemItem:UIBarButtonSystemItemStop 
					target:self action:@selector(reloadButton:)];
	
	[[self navigationItem] setRightBarButtonItem:reloadButton];
	
	
	[activeTwitterClient release];
	activeTwitterClient = sender;
	[activeTwitterClient retain];
	
	if (self.tableView.tableFooterView) {
		[autoloadActivityView startAnimating];
	}
}

- (void)twitterClientEnd:(NTLNTwitterClient*)sender {
	NSLog(@"StatusView#twitterClientEnd");
	
	[reloadButton release];
	reloadButton = [[UIBarButtonItem alloc] 
					initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
					target:self action:@selector(reloadButton:)];
	
	[[self navigationItem] setRightBarButtonItem:reloadButton];
	
	[activeTwitterClient release];
	activeTwitterClient = nil;
	
	if (self.tableView.tableFooterView) {
		[autoloadActivityView stopAnimating];
	}
	
	[self removeNowloadingView];
}

#pragma mark Protected

- (void)getTimelineImplWithPage:(int)page since_id:(NSString*)since_id {
	// override by subclass
}

- (void)getTimelineWithPage:(int)page autoload:(BOOL)autoload {
	if (activeTwitterClient == nil && [[NTLNAccount instance] valid]) {
		[self stopTimer];
		NSDate *now = [NSDate date];
		BOOL got = NO;
		
		NSString *since_id = nil;
		if (page == 0) {
			since_id = [self latestStatusId];
		}
		
		if (autoload) { 
			if (lastReloadTime == nil || [now timeIntervalSinceDate:lastReloadTime] > 60) {
//				if ([[Reachability sharedReachability] internetConnectionStatus] != NotReachable) {
					[self getTimelineImplWithPage:page since_id:since_id];
					[self insertNowloadingViewIfNeeds];
					got = YES;
//				}
			}
		} else {
			[self getTimelineImplWithPage:page since_id:since_id];
			[self insertNowloadingViewIfNeeds];
			got = YES;
		}
		
		if (got) {
			[lastReloadTime release];
			lastReloadTime = now;
			[lastReloadTime retain];
		}
		[self startTimer];
	}	
}

#pragma mark NTLNStatusReadProtocol

- (void)iconUpdate:(NTLNMessage*)sender {
	NSArray *vc = [self.tableView visibleCells];
	for (NTLNStatusCell *cell in vc) {
		if (sender == cell.status.message){
			[cell updateIcon];
		}
	}
}

#pragma mark Public

- (void)removeLastReloadTime {
	[lastReloadTime release];
	lastReloadTime = nil;
}

@end