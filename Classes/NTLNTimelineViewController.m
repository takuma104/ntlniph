#import "NTLNTimelineViewController.h"
#import "NTLNColors.h"
#import	"NTLNConfiguration.h"
#import "NTLNAccelerometerSensor.h"

@implementation NTLNTimelineViewController

@synthesize appDelegate, tweetPostViewController;

- (id)init {
	if (self = [super init]) {
		always_read_tweets = YES;
		timeline = [[NSMutableArray alloc] init];
	}
	return self;
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

- (void)viewDidLoad {	
	[self setupTableView];
	[self setupNavigationBar];
	
	
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
	[NTLNAccelerometerSensor sharedInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
	[NTLNAccelerometerSensor sharedInstance].delegate = nil;
	
	enable_read = FALSE;
	[self stopTimer];
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

@end

