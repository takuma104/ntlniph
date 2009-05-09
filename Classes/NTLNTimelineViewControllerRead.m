#import "NTLNTimelineViewController.h"

@implementation NTLNTimelineViewController(Read)

#pragma mark Private

- (BOOL)doReadTrack {
	if (!enable_read) return NO;
	CGFloat viewTop = self.tableView.contentOffset.y;
	CGFloat viewBottom = viewTop + self.tableView.frame.size.height;
	
	BOOL updated = NO;
	NSArray *a = [self.tableView visibleCells];
	for (NTLNStatusCell *cell in a) {
		CGFloat t = cell.frame.origin.y + 3.0;
		CGFloat b = cell.frame.origin.y + cell.frame.size.height - 3.0;
		if (viewTop <= t && b <= viewBottom) {
			int c = [cell.status updateReadTrackCounter:readTrackContinueCounter];
			if (c > 5) {
				if ([cell.status markAsRead]) {
					[cell updateBackgroundColor];
					updated = YES;
				}
			}
		}
	}
	
	if (updated) {
		[self updateBadge];
	}
	
	readTrackContinueCounter++;
	return updated;
}

- (void)updateBadge {
	if (badge_enable) {
		int cnt = [timeline badgeCount];
		if (cnt > 0) {
			super.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", cnt];
		} else {
			super.tabBarItem.badgeValue = nil;
		}
	}
}

- (void)stopReadTrackTimer {
//	LOG(@"stopReadTrackTimer");
	[readTrackTimer invalidate];
	[readTrackTimer release];
	readTrackTimer = nil;
}

- (void)startReadTrackTimer {
//	LOG(@"startReadTrackTimer");
	[self stopReadTrackTimer];
	
	readTrackTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0/5.0
													   target:self
													 selector:@selector(doReadTrack)
													 userInfo:nil
													  repeats:YES] retain];
}

- (BOOL)readTrackTimerActivated {
	return readTrackTimer != nil;
}


@end