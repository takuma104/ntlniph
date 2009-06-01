#import "NTLNTimelineViewController.h"
#import "NTLNColors.h"
#import	"NTLNConfiguration.h"
#import "NTLNAccelerometerSensor.h"
#import "NTLNIconRepository.h"
#import "NTLNRateLimit.h"

@implementation NTLNTimelineViewController

@synthesize timeline;

- (void) dealloc {
	[self stopReadTrackTimer];
	[timeline release];
	[lastReloadTime release];
	[nowloadingView release];
	[footerActivityIndicatorView release];
	[lastTopStatusId release];
	[headReloadButton release];
	[moreButton release];
    [super dealloc];
}

- (void)viewDidLoad {	
	[self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
	[self.tableView reloadData];
	[self updateFooterView];
	
	self.tableView.backgroundColor = [[NTLNColors instance] scrollViewBackground];
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	} else {
		self.tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	}
	
	[[NTLNRateLimit shardInstance] updateNavigationBarColor:self.navigationController.navigationBar];
	[NTLNIconRepository addObserver:self selectorSuccess:@selector(iconUpdate:)];

	[self setupNavigationBar];
	[self setReloadButtonNormal:![timeline isClientActive]];
}

- (void)viewDidAppear:(BOOL)animated {
	enable_read = TRUE;
	[timeline activate];
	[timeline getTimelineWithPage:0 autoload:YES];
	[self.tableView flashScrollIndicators];
	[NTLNAccelerometerSensor sharedInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
	[NTLNIconRepository removeObserver:self];
	[NTLNAccelerometerSensor sharedInstance].delegate = nil;
	
	enable_read = FALSE;
	[timeline suspend];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
	LOG(@"NTLNStatusViewController#didReceiveMemoryWarning");
//	[timeline suspend];
}

@end

