#import "NTLNTimelineViewController.h"
#import "NTLNConfiguration.h"
#import "NTLNRateLimit.h"

@implementation NTLNTimelineViewController(Timeline)

- (void)timeline:(NTLNTimeline*)timeline requestForPage:(int)page since_id:(NSString*)since_id {
	// implements by subclass
}

- (void)timeline:(NTLNTimeline*)timeline clientBegin:(NTLNTwitterClient*)client {
	[self setReloadButtonNormal:NO];
	[self footerActivityIndicator:TRUE];
	[self insertNowloadingViewIfNeeds];
}

- (void)timeline:(NTLNTimeline*)timeline clientEnd:(NTLNTwitterClient*)client {
	[self setReloadButtonNormal:YES];
	[self footerActivityIndicator:FALSE];
	[self removeNowloadingView];
}

- (void)timeline:(NTLNTimeline*)tl clientSucceeded:(NTLNTwitterClient*)client insertedStatuses:(NSArray*)statuses {
	[self removeNowloadingView];
	
	int count = statuses.count;
	int idx = NSNotFound;
	
	if (count > 0) {
		if ((![[NTLNConfiguration instance] autoScroll]) && 
			(idx = [timeline indexFromStatusId:lastTopStatusId]) != NSNotFound) {
			CGFloat y = self.tableView.contentOffset.y;
			CGFloat offset = 0.f;
			for (int i = 0; i < idx; i++) {
				offset += [self cellHeightForIndex:i];
			}
			
			[self.tableView reloadData];
			
			self.tableView.contentOffset = CGPointMake(0, y + offset);
			
			[self.tableView flashScrollIndicators];
		} else {
			if (count < 8 && [timeline count] >= 20) {
				NSMutableArray *indexPath = [[[NSMutableArray alloc] init] autorelease];
				for (int i = 0; i < count; ++i) {
					[indexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
				}        
				[self.tableView beginUpdates];
				[self.tableView insertRowsAtIndexPaths:indexPath 
				 withRowAnimation:UITableViewRowAnimationTop];
				[self.tableView endUpdates];
			}
			else {
				[self.tableView reloadData];
				[self.tableView flashScrollIndicators];
			}
		}
	}
	
	[self updateFooterView];
	[self updateBadge];
	[[NTLNRateLimit shardInstance] updateNavigationBarColor:self.navigationController.navigationBar];
	
	[lastTopStatusId release];
	lastTopStatusId = [[[tl latestStatusId] copy] retain];
}

- (void)timeline:(NTLNTimeline*)timeline clientFailed:(NTLNTwitterClient*)client {
	[self removeNowloadingView];
	[[NTLNRateLimit shardInstance] updateNavigationBarColor:self.navigationController.navigationBar];
}

- (void)timeline:(NTLNTimeline*)timeline unreadCountChanged:(int)count {
}


@end
