#import "NTLNTimelineViewController.h"
#import "NTLNConfiguration.h"
#import "NTLNColors.h"
#import "NTLNAppDelegate.h"

@interface NTLNTimelineViewController(Private)
- (UIView*)moreTweetView;
- (UIView*)autopagerizeTweetView;
- (UIView*)nowloadingView;

@end


@implementation NTLNTimelineViewController(View)

#pragma mark Private

- (UIView*)nowloadingView {
	
	UIActivityIndicatorView *ai = [[[UIActivityIndicatorView alloc] 
									initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] 
									autorelease];
	[ai startAnimating];

	CGSize s = ai.frame.size;
	ai.frame = CGRectMake((320-s.width)/2, (368-s.height)/2, s.width, s.height); // !!
	return ai;
}

- (void)setReloadButtonNormal:(BOOL)normal {
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		if (normal) {
			[headReloadButton setBackgroundImage:[UIImage imageNamed:@"reload_button_normal_b.png"] forState:UIControlStateNormal];
			[headReloadButton setBackgroundImage:[UIImage imageNamed:@"reload_button_normal_b.png"] forState:UIControlStateHighlighted];
		} else {
			[headReloadButton setBackgroundImage:[UIImage imageNamed:@"reload_button_loading_b.png"] forState:UIControlStateNormal];
			[headReloadButton setBackgroundImage:[UIImage imageNamed:@"reload_button_loading_b.png"] forState:UIControlStateHighlighted];
		}
	} else {
		if (normal) {
			[headReloadButton setBackgroundImage:[UIImage imageNamed:@"reload_button_normal.png"] forState:UIControlStateNormal];
			[headReloadButton setBackgroundImage:[UIImage imageNamed:@"reload_button_pushed.png"] forState:UIControlStateHighlighted];
		} else {
			[headReloadButton setBackgroundImage:[UIImage imageNamed:@"reload_button_loading.png"] forState:UIControlStateNormal];
			[headReloadButton setBackgroundImage:[UIImage imageNamed:@"reload_button_loading_pushed.png"] forState:UIControlStateHighlighted];
		}
	}
}

- (UIView*)reloadView {
	UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
	b.frame = CGRectMake(0, 0, 320, 55);
	[b addTarget:self action:@selector(reloadButton:) forControlEvents:UIControlEventTouchUpInside];
	headReloadButton = [b retain];
	[self setReloadButtonNormal:YES];
	return b;
}

- (void)setupTableView {
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.tableHeaderView = [self reloadView];
}

- (void)setupNavigationBar {
/*	reloadButton = [[UIBarButtonItem alloc] 
					initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
					target:self action:@selector(reloadButton:)];
	
	[[self navigationItem] setRightBarButtonItem:reloadButton];
*/
}

- (void)insertNowloadingViewIfNeeds {
	if (timeline.count == 0 && nowloadingView == nil) {
		nowloadingView = [[self nowloadingView] retain];
		[self.tableView addSubview:nowloadingView];
	}
}

- (void)removeNowloadingView {
	if (nowloadingView) {
		[nowloadingView removeFromSuperview];
		[nowloadingView release];
		nowloadingView = nil;
	}
}

-(IBAction)reloadButton:(id)sender {
	if (![timeline isClientActive]) {
		[timeline getTimelineWithPage:0 autoload:NO];
	} else {
		[timeline clientCancel];
	}
}

- (void)iconUpdate:(NSNotification*)sender {
	NTLNIconContainer *container = (NTLNIconContainer*)sender.object;
	NSArray *vc = [self.tableView visibleCells];
	for (NTLNStatusCell *cell in vc) {
		if (container == cell.status.message.iconContainer){
			[cell updateIcon];
		}
	}
}

- (void)clearButton:(id)sender {
	[timeline markAllAsRead];
	[super.tableView reloadData];
	[self updateBadge];
}

- (UIBarButtonItem*)clearButtonItem {
	UIBarButtonItem *b = [[UIBarButtonItem alloc] 
						  initWithImage:[UIImage imageNamed:@"checkmark.png"]
//						  initWithImage:[UIImage imageNamed:@"unread_clear.png"]
						  style:UIBarButtonItemStyleBordered 
						  target:self action:@selector(clearButton:)];
	[b autorelease];
	return b;
}

- (void)setupClearButton {
	if ([[NTLNConfiguration instance] lefthand]) {
		[[self navigationItem] setRightBarButtonItem:[self clearButtonItem]];
	} else {
		if (! [(NTLNAppDelegate*)[[UIApplication sharedApplication] delegate] 
				isInMoreTab:self]){
			[[self navigationItem] setLeftBarButtonItem:[self clearButtonItem]];
		}
	}
}

@end