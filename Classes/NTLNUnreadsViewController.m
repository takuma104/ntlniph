#import "NTLNUnreadsViewController.h"
#import "NTLNFriendsViewController.h"
#import "NTLNReplysViewController.h"

@implementation NTLNUnreadsViewController

@synthesize friendsViewController, replysViewController;

- (void)dealloc {
	[super dealloc];
}

- (void)setupNavigationBar {
	
	UIBarButtonItem *b = [[UIBarButtonItem alloc] 
					initWithImage:[UIImage imageNamed:@"unread_clear.png"]
					style:UIBarButtonItemStyleBordered 
					target:self action:@selector(clearButton:)];
	[b autorelease];
	[[self navigationItem] setRightBarButtonItem:b];
	[self.navigationItem setTitle:@"Unreads"];
	[super setupPostButton];
}

- (void)viewDidLoad {	
	always_read_tweets = TRUE;
	[super viewDidLoad];
}

- (void) getTimeline {
}

- (void)viewWillAppear:(BOOL)animated {
	[timeline release];
	timeline = [[friendsViewController unreadStatuses] retain];
	
	[timeline addObjectsFromArray:[replysViewController unreadStatuses]];
	
	[super viewWillAppear:animated]; //with reload
}

- (void)viewWillDisappear:(BOOL)animated {
	[timeline release];
	timeline = nil;
}

- (void)checkCellRead {
	// ignore
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.navigationItem setTitle:@"Unreads"];
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)clearButton:(id)sender {
	[friendsViewController allRead];
	[replysViewController allRead];
	[timeline release];
	timeline = nil;
	[super.tableView reloadData];
}

- (void)attachOrDetachAutopagerizeView {
	// do nothing
}

- (void)showMoreButton:(id)sender {
	// do nothing
}

- (void)getTimelineWithPage:(int)page autoload:(BOOL)autoload {
	// do nothing
}

@end
