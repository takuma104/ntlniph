#import "NTLNStatusViewController.h"
#import "NTLNLinkViewController.h"
#import "NTLNConfiguration.h"
#import "NTLNRoundedIconView.h"
#import "NTLNColors.h"
#import "NTLNCache.h"
#import "NTLNTweetPostViewController.h"
#import "Reachability.h"
#import "NTLNTwitterXMLReader.h"
#import "NTLNAccount.h"

@implementation NTLNStatusViewController

@synthesize appDelegate, tweetPostViewController;

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
	}
	return self;
}

- (void)showMoreButton:(id)sender {
	if ([[NTLNConfiguration instance] showMoreTweetMode]) {
		currentPage++;
		if (currentPage < 2) currentPage = 2;
		if (currentPage <= 10) {
			[self stopTimer];
			[self getTimelineWithPage:currentPage autoload:NO];
			[self startTimer];
		}
	}
}

- (UIView*)showMoreTweetView {
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	v.backgroundColor = [UIColor blackColor];
	
		
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	label.text = @"Autopagerizing...";
	label.font = [UIFont boldSystemFontOfSize:16];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	label.backgroundColor =  [UIColor blackColor];
	[v addSubview:label];

	UIActivityIndicatorView *ai = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(60, 8, 24, 24)] autorelease];
	ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	ai.hidesWhenStopped = YES;
	autoloadActivityView = ai;
//	[ai startAnimating];
	[v addSubview:ai];

	return v;
}

- (UIView*)nowloadingView {
	UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 160, 320, 40)] autorelease];
	v.backgroundColor = [[NTLNColors instance] scrollViewBackground];

	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	label.text = @"Loading...";
	label.font = [UIFont boldSystemFontOfSize:14];
	label.textColor = [[NTLNColors instance] textForground];
	label.textAlignment = UITextAlignmentCenter;
	label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	label.backgroundColor = [[NTLNColors instance] scrollViewBackground];
	label.shadowColor = [[NTLNColors instance] textShadow];
	label.shadowOffset = CGSizeMake(0, 1);	
	[v addSubview:label];
	
	UIActivityIndicatorView *ai = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 8, 24, 24)] autorelease];
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	} else {
		ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	}
	[ai startAnimating];
	[v addSubview:ai];
	
	return v;
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

- (void)setupTableView {
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	footerShowMoreTweetView = [self showMoreTweetView];
}

- (void)setupNavigationBar {

	reloadButton = [[UIBarButtonItem alloc] 
							initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
						   target:self action:@selector(reloadButton:)];
	
	[[self navigationItem] setRightBarButtonItem:reloadButton];
}

- (void)loadCache {
	NSData *data = [NTLNCache loadWithFilename:xmlCachePath];
	if (data) {
		NTLNTwitterXMLReader *xr = [[NTLNTwitterXMLReader alloc] init];
		[xr parseXMLData:data];
		[self twitterClientSucceeded:nil messages:xr.messages];
		[xr release];
	}
}

- (void)saveCache:(NSData*)data {
	[NTLNCache saveWithFilename:xmlCachePath data:data];
}

- (void)initialCacheLoading:(NSString*)name {
	xmlCachePath = [[NTLNCache createXMLCacheDirectory] stringByAppendingString:name];
	[xmlCachePath retain];
	[self loadCache];
}

- (void)initialCacheLoading {
}

- (void)attachOrDetachAutopagerizeView {
	if ([[NTLNConfiguration instance] showMoreTweetMode]) {
		if (timeline.count >= 20 && self.tableView.tableFooterView == nil) {
			self.tableView.tableFooterView = footerShowMoreTweetView;
		}
		if (self.tableView.tableFooterView && currentPage >= 10) {
			self.tableView.tableFooterView = nil;
		}
	} else if (self.tableView.tableFooterView) {
		self.tableView.tableFooterView = nil;
	}
}

- (void)viewDidLoad {	
	always_read_tweets = YES;
	
	[self setupTableView];
	[self setupNavigationBar];
	
	timeline = [[NSMutableArray alloc] init];

	[self initialCacheLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
	[self.tableView reloadData];
	[self attachOrDetachAutopagerizeView];
	
	self.tableView.backgroundColor = [[NTLNColors instance] scrollViewBackground];
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	} else {
		self.tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	}
}

- (void)viewDidAppear:(BOOL)animated {
	enable_read = TRUE;
	[self getTimelineWithPage:0 autoload:YES];
	[self checkCellRead];
	[self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated {
	enable_read = FALSE;
	[self stopTimer];
}

- (void) dealloc {
	[timeline release];
	[reloadButton release];
	[xmlCachePath release];
	[footerShowMoreTweetView release];
	[lastReloadTime release];
	[nowloadingView release];
    [super dealloc];
}

- (NTLNStatus*)timelineStatusAtIndex:(int)index {
	int cnt = [timeline count];
	if (index >= 0 && cnt > index) {
		return [timeline objectAtIndex:index];
	}
	return nil;
}

static int compareStatus(NTLNStatus *a, NTLNStatus *b, void *ptr)
{
	NTLNMessage *msg_a = a.message;
	NTLNMessage *msg_b = b.message;
	int sid_cmp = [msg_a.statusId compare:msg_b.statusId];
	if (sid_cmp == 0) return 0;
	int c = [msg_a.timestamp compare:msg_b.timestamp];
	if (c == 0) {
		c = sid_cmp;
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

- (CGFloat)cellHeightForIndex:(int)index {
	NTLNStatus *s = [self timelineStatusAtIndex:index];	
	return s.cellHeight;
}

- (void)twitterClientSucceeded:(NTLNTwitterClient*)sender messages:(NSArray*)statuses {

	if (sender && sender.requestPage == 0) {
		[self saveCache:sender.recievedData];
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
			[msg release];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
	NSLog(@"NTLNStatusViewController#didReceiveMemoryWarning");
}

/////////////////// table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 0.0;
	@synchronized(timeline) {
		height = [self cellHeightForIndex:[indexPath row]];
	}
	return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger n = 0;
	@synchronized(timeline) {
		n = [timeline count];
	}
	return n;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NTLNStatus *s = nil;
	int n = 0;
	@synchronized(timeline) {
		s = [self timelineStatusAtIndex:[indexPath row]];
		n = [timeline count];
	}

	BOOL isEven = ([indexPath row] % 2 == 0);
	if (n % 2 == 1) isEven = !isEven;
	
	NTLNStatusCell *cell = (NTLNStatusCell*)[tv dequeueReusableCellWithIdentifier:CELL_RESUSE_ID];
//	NTLNTweetCell *cell = (NTLNTweetCell*)[tv dequeueReusableCellWithIdentifier:CELL_RESUSE_ID];
	if (cell == nil) {
		cell = [[[NTLNStatusCell alloc] initWithIsEven:isEven] autorelease];
//		cell = [[[NTLNTweetCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_RESUSE_ID] autorelease];
	}
	
	[s.message setIconUpdateDelegate:self];
	[cell updateCell:s isEven:isEven];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NTLNStatus *s = nil;
	@synchronized(timeline) {
		s = [self timelineStatusAtIndex:[indexPath row]];
	}

	NTLNLinkViewController *lvc = [[[NTLNLinkViewController alloc] 
									init] autorelease];
	lvc.appDelegate = appDelegate;
	lvc.tweetPostViewController = tweetPostViewController;
	lvc.message = s.message;
	[[self navigationController] pushViewController:lvc animated:YES];
}

/////////////////// timer

- (void) resetTimer {
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        [_refreshTimer release];
		_refreshTimer = nil;
    }
}

- (void) stopTimer {
    [self resetTimer];
}

- (void) startTimer {
    [self resetTimer];
    
	int refreshInterval = [[NTLNConfiguration instance] refreshIntervalSeconds];

    if (refreshInterval < 30) {
        return;
    }
    
	_refreshTimer = [[NSTimer scheduledTimerWithTimeInterval:refreshInterval
                                                      target:self
                                                    selector:@selector(timerExpired)
                                                    userInfo:nil
                                                     repeats:YES] retain];
}

- (void)getTimelineWithPage:(int)page autoload:(BOOL)autoload {
	if (activeTwitterClient == nil && [[NTLNAccount instance] valid]) {
		[self stopTimer];
		NSDate *now = [NSDate date];
		BOOL got = NO;
		if (autoload) { 
			if (lastReloadTime == nil || [now timeIntervalSinceDate:lastReloadTime] > 60) {
				if ([[Reachability sharedReachability] internetConnectionStatus] != NotReachable) {
					[self getTimelineImplWithPage:page];
					[self insertNowloadingViewIfNeeds];
					got = YES;
				}
			}
		} else {
			[self getTimelineImplWithPage:page];
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

- (void)removeLastReloadTime {
	[lastReloadTime release];
	lastReloadTime = nil;
}


- (void)timerExpired {
	// override by subclass
}

- (void)getTimelineImplWithPage:(int)page {
	// override by subclass
}

-(IBAction)reloadButton:(id)sender {
	if (activeTwitterClient == nil) {
		[self getTimelineWithPage:0 autoload:NO];
	} else {
		[activeTwitterClient cancel];
	}
}

- (void)checkCellRead {
	if (!enable_read) return;
	
	CGFloat h = 0.0;
	CGFloat viewTop = self.tableView.contentOffset.y;
	CGFloat viewBottom = viewTop + self.tableView.frame.size.height;
	@synchronized(timeline) {
		for (NTLNStatus *s in timeline) {
			if (s.message.status == NTLN_MESSAGE_STATUS_NORMAL) {
				CGFloat top = h + 3.0;
				CGFloat bottom = h + s.cellHeight - 3.0;
				
				if (viewTop <= top && bottom <= viewBottom) {
					[s didAppearWithScrollPos];
				} else {
					[s didDisapper];
				}
			}
			h += s.cellHeight;// + 1.0;
		}
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	NSLog(@"scroll: %3.2f:%3.2f %3.2f:%3.2f", scrollView.contentOffset.x, scrollView.contentOffset.y, 
//		  scrollView.frame.size.width, scrollView.frame.size.height);
	[self checkCellRead];
	scrollMoved = YES;

	// autopagerize
	if (activeTwitterClient == nil && self.tableView.tableFooterView != nil) {
		const int offset = 0;
		if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + offset) {
			[self showMoreButton:self];
		}
	}
}

static BOOL is_badge_unread_message(NTLNMessage *message) {
	return message.replyType == NTLN_MESSAGE_REPLY_TYPE_REPLY ||
	message.replyType == NTLN_MESSAGE_REPLY_TYPE_REPLY_PROBABLE;
}

#pragma mark NTLNStatusReadProtocol
- (void)incrementReadStatus:(NTLNStatus*)status {
	
	if (badge_enable && is_badge_unread_message(status.message)) {
		unread_count++;
		if (unread_count > 0) {
			super.tabBarItem.badgeValue = [[[NSString alloc] initWithFormat:@"%d", unread_count] autorelease];
		} else {
			super.tabBarItem.badgeValue = nil;
		}
	}
}

- (void)decrementReadStatus:(NTLNStatus*)status {

	if (badge_enable && is_badge_unread_message(status.message)) {
		unread_count--;
		if (unread_count > 0) {
			super.tabBarItem.badgeValue = [[[NSString alloc] initWithFormat:@"%d", unread_count] autorelease];
		} else {
			super.tabBarItem.badgeValue = nil;
		}
	}
	
	NSArray *vc = [self.tableView visibleCells];
	for (NTLNStatusCell *cell in vc) {
		if (cell.status == status) {
			[cell updateBackgroundColor];
		}
	}
}

- (void)iconUpdate:(NTLNMessage*)sender {
	NSArray *vc = [self.tableView visibleCells];
	for (NTLNStatusCell *cell in vc) {
		if (sender == cell.status.message){
			[cell updateIcon];
		}
	}
}

- (BOOL)scrollMoved {
	return scrollMoved;
}


/////////////////// post

- (void)setupPostButton {
	UIBarButtonItem *postButton = [[[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
								   target:self 
								   action:@selector(postButton:)] autorelease];
	
	[[self navigationItem] setLeftBarButtonItem:postButton];
}

- (void)postButton:(id)sender {
	[[self navigationController].view addSubview:tweetPostViewController.view];
	[tweetPostViewController forcus];
}


@end
