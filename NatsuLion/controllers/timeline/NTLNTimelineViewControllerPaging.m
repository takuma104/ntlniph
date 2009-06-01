#import "NTLNTimelineViewController.h"
#import "NTLNColors.h"
#import "NTLNConfiguration.h"

@interface NTLNTimelineViewController(Private)
- (void)setupFooterActivityIndicatorView;
- (UIView*)moreTweetView;
- (UIView*)autopagerizeView;
- (void)moreTweet:(id)sender;
- (void)loadNextPage;

@end


@implementation NTLNTimelineViewController(Paging)

#pragma mark Private

- (void)setupFooterActivityIndicatorView {
	if (footerActivityIndicatorView == nil) {
		UIActivityIndicatorView *ai = [[[UIActivityIndicatorView alloc] 
										initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] 
									   autorelease];
		CGSize s = CGSizeMake(25,25);//= ai.frame.size;
		ai.frame = CGRectMake((320-s.width)/2, (55-s.height)/2, s.width, s.height);// !!
		ai.hidesWhenStopped = YES;
		footerActivityIndicatorView = [ai retain];
	}
}

- (void)setMoreButtonNormal:(BOOL)normal {
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		if (normal) {
			[moreButton setBackgroundImage:[UIImage imageNamed:@"more_button_normal_b.png"] forState:UIControlStateNormal];
		} else {
			[moreButton setBackgroundImage:nil forState:UIControlStateNormal];
		}
		[moreButton setBackgroundImage:nil forState:UIControlStateHighlighted];
	} else {
		if (normal) {
			[moreButton setBackgroundImage:[UIImage imageNamed:@"more_button_normal.png"] forState:UIControlStateNormal];
		} else {
			[moreButton setBackgroundImage:[UIImage imageNamed:@"more_button_pushed.png"] forState:UIControlStateNormal];
		}
		[moreButton setBackgroundImage:[UIImage imageNamed:@"more_button_pushed.png"] forState:UIControlStateHighlighted];
	}
}

- (UIView*)moreTweetView {
	[self setupFooterActivityIndicatorView];
	if (moreButton == nil) {
		UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
		[b setFrame:CGRectMake(0, 0, 320, 55)];
		[b addTarget:self action:@selector(moreTweet:) forControlEvents:UIControlEventTouchUpInside];
		moreButton = [b retain];
	}
	[self setMoreButtonNormal:YES];
	return moreButton;
}

- (UIView*)autopagerizeView {
	[self setupFooterActivityIndicatorView];

	UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)] autorelease];
	v.backgroundColor = [[NTLNColors instance] scrollViewBackground];
	[v addSubview:footerActivityIndicatorView];
	return v;
}

- (void)loadNextPage {
	int nextPage = timeline.count / 20 + 1;
	LOG(@"count:%d nextPage:%d", timeline.count, nextPage);
	[timeline getTimelineWithPage:nextPage autoload:NO];
}

- (void)moreTweet:(id)sender {	
	[self setMoreButtonNormal:NO];
	[self loadNextPage];
}

#pragma mark Paging

- (void)autopagerize {
	[self loadNextPage];
}

- (void)updateFooterView {
	if (timeline.count >= 20) {
		self.tableView.tableFooterView = nil;
		if ([[NTLNConfiguration instance] showMoreTweetMode]) {
			self.tableView.tableFooterView = [self autopagerizeView];
		} else {
			self.tableView.tableFooterView = [self moreTweetView];
		}
	}
}

- (void)footerActivityIndicator:(BOOL)active {
	if (active) {
		[self.tableView.tableFooterView addSubview:footerActivityIndicatorView];
		[footerActivityIndicatorView startAnimating];
	} else {
		[footerActivityIndicatorView stopAnimating];
		[footerActivityIndicatorView removeFromSuperview];
	}
}

@end
