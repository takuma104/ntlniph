#import "NTLNTimelineViewController.h"
#import "NTLNConfiguration.h"

@implementation NTLNTimelineViewController(Scroll)

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
		if (![timeline isClientActive] && self.tableView.tableFooterView != nil) {
			if ([[NTLNConfiguration instance] showMoreTweetMode]) {
				[self autopagerize];
			}
		}
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//	LOG(@"scrollViewWillBeginDragging");
	if (! [self readTrackTimerActivated]) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self 
												 selector:@selector(stopReadTrackTimer) 
												   object:nil];
		[self startReadTrackTimer];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (! decelerate) {
//		LOG(@"scrollViewDidEndDragging");
		[NSObject cancelPreviousPerformRequestsWithTarget:self 
												 selector:@selector(stopReadTrackTimer) 
												   object:nil];
		[self performSelector:@selector(stopReadTrackTimer) withObject:nil afterDelay:2.0];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//	LOG(@"scrollViewDidEndDecelerating");
	[NSObject cancelPreviousPerformRequestsWithTarget:self 
											 selector:@selector(stopReadTrackTimer) 
											   object:nil];
	[self performSelector:@selector(stopReadTrackTimer) withObject:nil afterDelay:2.0];
}


@end