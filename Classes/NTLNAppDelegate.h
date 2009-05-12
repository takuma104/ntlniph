#import <UIKit/UIKit.h>

#import "NTLNCacheCleaner.h"

@class NTLNBrowserViewController;
@class NTLNFriendsViewController;
@class NTLNReplysViewController;
@class NTLNSentsViewController;
@class NTLNUnreadsViewController;
@class NTLNSettingViewController;
@class NTLNFavoriteViewController;
@class NTLNDirectMessageViewController;

@interface NTLNAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, NTLNCacheCleanerDelegate> {
	UIWindow *window;
	UITabBarController *tabBarController;
	
	NTLNFriendsViewController *friendsViewController;
	NTLNReplysViewController *replysViewController;
	NTLNSentsViewController *sentsViewController;
	NTLNUnreadsViewController *unreadsViewController;
	NTLNSettingViewController *settingViewController;
	
	NTLNFavoriteViewController *favoriteViewController;
	
	NTLNDirectMessageViewController *directMessageViewController;

	BOOL applicationActive;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (readonly) BOOL applicationActive;

- (NTLNBrowserViewController*)browserViewController;
- (void)presentTwitterAccountSettingView;
- (BOOL)isInMoreTab:(UIViewController*)vc;

@end

