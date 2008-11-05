#import "NTLNTimelineViewController.h"
#import "NTLNConfiguration.h"

@implementation NTLNTimelineViewController(Scroll)

#pragma mark Private

- (void)Autopagerize {
	if ([[NTLNConfiguration instance] showMoreTweetMode]) {
		currentPage++;
		if (currentPage < 2) currentPage = 2;
		
		[self stopTimer];
		[self getTimelineWithPage:currentPage autoload:NO];
		[self startTimer];
	}
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	//	NSLog(@"scroll: %3.2f:%3.2f %3.2f:%3.2f", scrollView.contentOffset.x, scrollView.contentOffset.y, 
	//		  scrollView.frame.size.width, scrollView.frame.size.height);
	[self checkCellRead];
	scrollMoved = YES;
	
	// autopagerize
	if (activeTwitterClient == nil && self.tableView.tableFooterView != nil) {
		const int offset = 0;
		if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + offset) {
			[self Autopagerize];
		}
	}
}


@end