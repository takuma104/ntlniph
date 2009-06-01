#import "NTLNSettingViewController.h"
#import "NTLNConfigurationKeys.h"
#import "UICPrototypeTableCellTextInput.h"
#import "NTLNAboutViewController.h"
#import "NTLNConfiguration.h"
#import "NTLNColors.h"
#import "NTLNAccelerometerSensor.h"
#import "NTLNAppDelegate.h"
#import "NTLNFooterSettingViewController.h"
#import "NTLNOAuthConsumer.h"

@interface NTLNSettingViewController(Private)
- (void)setupPrototypes;
	
@end

@implementation NTLNSettingViewController

- (void)setupPrototypes {
	if (groups != nil) return;
	
	NSArray *g1 = [NSArray arrayWithObjects:[UICPrototypeTableCell cellForTitle:@"Twitter Account"], nil];	
	NSArray *g2 = [NSArray arrayWithObjects:
				   [UICPrototypeTableCell cellForSelect:@"Auto refresh" 
									   withSelectTitles:[NSArray arrayWithObjects:
														 @"disabled", 
														 @"1 Minute", 
														 @"1.5 Minute", 
														 @"2 Minutes", 
														 @"3 Minutes", 
														 @"5 Minutes",
														 @"10 Minutes", nil]
									withUserDefaultsKey:NTLN_PREFERENCE_REFRESH_INTERVAL],
					
				   [UICPrototypeTableCell cellForSwitch:@"UseSafari" 
									withUserDefaultsKey:NTLN_PREFERENCE_USE_SAFARI],

				   [UICPrototypeTableCell cellForSwitch:@"Dark color theme" 
									withUserDefaultsKey:NTLN_PREFERENCE_DARK_COLOR_THEME],
				   
				   [UICPrototypeTableCell cellForSwitch:@"Shake to fullscreen" 
									withUserDefaultsKey:NTLN_PREFERENCE_SHAKE_TO_FULLSCREEN],
				   nil];
	
	NSArray *g3 = [NSArray arrayWithObjects:
				   [UICPrototypeTableCell cellForSwitch:@"AutoPagerize" 
									withUserDefaultsKey:NTLN_PREFERENCE_SHOW_MORE_TWEETS_MODE],

				   [UICPrototypeTableCell cellForSelect:@"Initial load" 
									   withSelectTitles:[NSArray arrayWithObjects:
														 @"20 posts", 
														 @"50 Posts", 
														 @"100 Posts", 
														 @"200 Posts", nil]
									withUserDefaultsKey:NTLN_PREFERENCE_FETCH_COUNT],

				   [UICPrototypeTableCell cellForSwitch:@"AutoScroll" 
									withUserDefaultsKey:NTLN_PREFERENCE_AUTO_SCROLL],
				   
				   [UICPrototypeTableCell cellForSwitch:@"Left-Handed controls" 
									withUserDefaultsKey:NTLN_PREFERENCE_LEFTHAND],
				   
				   nil];
	
	NSArray *g4 = [NSArray arrayWithObjects:
				   [UICPrototypeTableCell cellForTitle:@"Footer"],
				   nil];

	NSArray *g5 = [NSArray arrayWithObjects:
				   [UICPrototypeTableCell cellForTitle:@"About NatsuLion for iPhone"],
				   nil];
	
	groups = [[NSArray arrayWithObjects:
			   [UICPrototypeTableGroup groupWithCells:g1 withTitle:nil], 
			   [UICPrototypeTableGroup groupWithCells:g2 withTitle:nil], 
			   [UICPrototypeTableGroup groupWithCells:g3 withTitle:nil], 
			   [UICPrototypeTableGroup groupWithCells:g4 withTitle:nil], 
			   [UICPrototypeTableGroup groupWithCells:g5 withTitle:nil], 
			   nil] retain];
}

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		[self.navigationItem setTitle:@"Settings"];
	}
	return self;
}

- (void)loadView {
	[self setupPrototypes];
	[super loadView];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NTLNConfiguration instance] reload];

	[[NTLNColors instance] setupColors];
	[[NTLNAccelerometerSensor sharedInstance] updateByConfiguration];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

	// for "Twitter account" or "Footer" cell
	if (([indexPath section] == 0 || [indexPath section] == 3) && [indexPath row] == 0) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// for "About NatsuLion for iPhone" cell
	if ([indexPath section] == 4 && [indexPath row] == 0) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// for "Twitter account" cell
	if ([indexPath section] == 0 && [indexPath row] == 0) {
#ifdef ENABLE_OAUTH
		[[NTLNOAuthConsumer sharedInstance] requestToken:self.tabBarController];
#else
		[(NTLNAppDelegate*)[UIApplication sharedApplication].delegate presentTwitterAccountSettingView];
#endif
	}
	
	// for "Footer" cell
	if ([indexPath section] == 3 && [indexPath row] == 0) {
		UITableViewController *vc = [[[NTLNFooterSettingViewController alloc] 
									  initWithStyle:UITableViewStyleGrouped] autorelease];
		UINavigationController *nc = [[[UINavigationController alloc] 
									   initWithRootViewController:vc] autorelease];
		[nc.navigationBar setBarStyle:UIBarStyleBlackOpaque];
		[self.tabBarController presentModalViewController:nc animated:YES];
	}

	// for "About NatsuLion for iPhone" cell
	if ([indexPath section] == 4 && [indexPath row] == 0) {
		UIViewController *vc = [[[NTLNAboutViewController alloc] init] autorelease];
		[self.navigationController pushViewController:vc animated:YES];
	}
	
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


@end
