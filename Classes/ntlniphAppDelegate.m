#import "ntlniphAppDelegate.h"
#import "NTLNAccount.h"
#import "NTLNTweetPostViewController.h"
#import "NTLNFriendsViewController.h"
#import "NTLNReplysViewController.h"

@implementation NTLNAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize applicationActive;
@synthesize browserViewController;
@synthesize tweetPostViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	if (![[NTLNAccount instance] valid]) {		
		tabBarController.selectedIndex = 4; // config view
	}
	
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
	
	tweetPostViewController.view.hidden = YES;
	applicationActive = TRUE;
}

- (void)dealloc {
	[tabBarController release];
	[window release];
	[super dealloc];
}

- (void)tabBarController:(UITabBarController *)tabBarController 
			didSelectViewController:(UIViewController *)viewController {
	NSLog(@"view selected: %@", [[viewController tabBarItem] title]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"applicationWillResignActive");
	applicationActive = FALSE;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"applicationDidBecomeActive");
	applicationActive = TRUE;
	[friendsViewController getTimelineWithPage:0 autoload:YES];
	[replysViewController getTimelineWithPage:0 autoload:YES];
}

@end
