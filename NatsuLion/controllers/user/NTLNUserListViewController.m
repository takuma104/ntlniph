#import "NTLNUserListViewController.h"
#import "NTLNLinkTweetCell.h"
#import "NTLNRoundedIconView.h"
#import "NTLNColors.h"
#import "NTLNConfiguration.h"
#import "NTLNIconTextCell.h"
#import "NTLNUserTimelineViewController.h"
#import "NTLNFavoriteViewController.h"
#import "NTLNUserCell.h"
#import "NTLNUserViewController.h"
#import "NTLNUser.h"
#import "NTLNHttpClientPool.h"

@interface NTLNUserListViewController (Private)
- (void)getUserInfo;


@end


@implementation NTLNUserListViewController

@synthesize screenName;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)setupTableView {
	UITableView *tv = [[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
													style:UITableViewStylePlain] autorelease];	
	tv.delegate = self;
	tv.dataSource = self;
	tv.autoresizesSubviews = YES;
	tv.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.view = tv;
}

- (void)viewDidLoad {
	[self setupTableView];
	((UITableView*)self.view).autoresizesSubviews = YES;
	[self.navigationItem setTitle:@"User List"];
}

- (void)viewWillAppear:(BOOL)animated {
	[self getUserInfo];
	
	NSIndexPath *tableSelection = [(UITableView*)self.view indexPathForSelectedRow];
	[(UITableView*)self.view deselectRowAtIndexPath:tableSelection animated:NO];
	
	//	[(UITableView*)self.view reloadData];
	
	((UITableView*)self.view).backgroundColor = [[NTLNColors instance] scrollViewBackground];
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		((UITableView*)self.view).indicatorStyle = UIScrollViewIndicatorStyleWhite;
	} else {
		((UITableView*)self.view).indicatorStyle = UIScrollViewIndicatorStyleBlack;
	}
	
	[NTLNIconRepository addObserver:self selectorSuccess:@selector(iconUpdate:)];
}

- (void)viewWillDisappear:(BOOL)animated {
	[NTLNIconRepository removeObserver:self];
}

- (void)dealloc {
	[users release];
    [super dealloc];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return users.count;
}


#define CELL_RESUSE_ID2	@"fuga"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NTLNUserCell *cell = (NTLNUserCell*)[tableView dequeueReusableCellWithIdentifier:CELL_RESUSE_ID2];
	if (cell == nil) {
		cell = [[[NTLNUserCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_RESUSE_ID2] autorelease];
	}
	[cell updateByUser:[users objectAtIndex:indexPath.row] isEven:(indexPath.row%2==0)];
	return cell;
}

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *tableSelection = [(UITableView*)self.view indexPathForSelectedRow];
	[(UITableView*)self.view deselectRowAtIndexPath:tableSelection animated:NO];
	
	NTLNUser *user = [users objectAtIndex:indexPath.row];
	
	NTLNUserViewController *vc = [[[NTLNUserViewController alloc] init] autorelease];
	vc.message = [[[NTLNMessage alloc] init] autorelease];
	vc.message.screenName = user.screen_name;
	vc.message.name = user.name;
	[[self navigationController] pushViewController:vc animated:YES];
	
}

- (void)getUserInfo {
	NTLNTwitterUserClient *c = [[NTLNHttpClientPool sharedInstance] 
								idleClientWithType:NTLNHttpClientPoolClientType_TwitterUserClient];
	c.delegate = self;
//	[c getFollowersWithScreenName:screenName page:1];
	[c getFollowingsWithScreenName:screenName page:1];
}

- (void)twitterUserClientSucceeded:(NTLNTwitterUserClient*)sender {
/*	LOG(@"%d users fetched.", sender.users.count);

	for (NTLNUser *u in sender.users) {
		LOG(@"%@(%@) :%@", u.screen_name, u.name, u.description);
	}
*/	
	[users release];
	users = [sender.users retain];
	[self.tableView reloadData];
}

- (void)twitterUserClientFailed:(NTLNTwitterUserClient*)sender {
}

- (void)iconUpdate:(NSNotification*)sender {
	NTLNIconContainer *container = (NTLNIconContainer*)sender.object;
	NSArray *vc = [self.tableView visibleCells];
	for (NTLNUserCell *cell in vc) {
		if (container == cell.user.iconContainer){
			[cell updateIcon];
		}
	}
}


@end
