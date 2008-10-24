#import <UIKit/UIKit.h>

@class NTLNTweetPostViewController;
@class NTLNBrowserViewController;
@class NTLNFriendsViewController;
@class NTLNReplysViewController;

@interface NTLNAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UITabBarController *tabBarController;
	IBOutlet NTLNTweetPostViewController *tweetPostViewController;
	IBOutlet NTLNBrowserViewController *browserViewController;
	IBOutlet NTLNFriendsViewController *friendsViewController;
	IBOutlet NTLNReplysViewController *replysViewController;
	BOOL applicationActive;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (readonly) BOOL applicationActive;
@property (readonly) NTLNBrowserViewController *browserViewController;
@property (readonly) NTLNTweetPostViewController *tweetPostViewController;

@end

