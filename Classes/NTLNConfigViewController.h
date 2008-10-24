#import <UIKit/UIKit.h>

@class NTLNFriendsViewController;

@interface NTLNConfigViewController : UITableViewController 
			<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 
{
	IBOutlet UITableViewController *refleshIntervalConfigViewController;
	IBOutlet UITableViewController *aboutViewController;
	IBOutlet NTLNFriendsViewController *friendsViewController;
	
	UITextField *usernameField;
	UITextField *passwordField;
	UISwitch *usePostSwitch;
	UISwitch *useSafariSwitch;
	UISwitch *darkColorThemeSwitch;
	UISwitch *scrollLockSwitch;
	UISwitch *showMoreTweetsModeSwitch;
}

+ (UITextField*)textInputFieldForCellWithValue:(NSString*)value secure:(BOOL)secure;
+ (UISwitch*)switchForCell;

- (UITableViewCell*)containerCellWithTitle:(NSString*)title view:(UIView*)view;
- (UITableViewCell*)textCellWithTitle:(NSString*)title;
	
- (void)doneButton:(id)sender;

@end


@interface NTLNContainerCell : UITableViewCell
{
	UIView *container;
}

- (void)attachContainer:(UIView*)view;

@end
