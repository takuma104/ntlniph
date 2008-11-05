#import <UIKit/UIKit.h>

#import "NTLNCacheCleaner.h"

@class NTLNTweetPostViewController;
@class NTLNBrowserViewController;
@class NTLNFriendsViewController;
@class NTLNReplysViewController;
@class NTLNSentsViewController;
@class NTLNUnreadsViewController;
@class NTLNConfigViewController;

@interface NTLNAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, NTLNCacheCleanerDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UITabBarController *tabBarController;
	
	NTLNFriendsViewController *friendsViewController;
	NTLNReplysViewController *replysViewController;
	NTLNSentsViewController *sentsViewController;
	NTLNUnreadsViewController *unreadsViewController;

	NTLNTweetPostViewController *tweetPostViewController;
	NTLNBrowserViewController *browserViewController;
	
	NTLNConfigViewController *configViewController;
	
	BOOL applicationActive;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (readonly) BOOL applicationActive;
@property (readonly) NTLNBrowserViewController *browserViewController;
@property (readonly) NTLNTweetPostViewController *tweetPostViewController;

@end

