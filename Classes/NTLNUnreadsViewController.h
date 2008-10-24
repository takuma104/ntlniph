#import <UIKit/UIKit.h>
#import "NTLNStatusViewController.h"

@class NTLNFriendsViewController;
@class NTLNReplysViewController;

@interface NTLNUnreadsViewController : NTLNStatusViewController {
	IBOutlet NTLNFriendsViewController *friendsViewController;
	IBOutlet NTLNReplysViewController *replysViewController;
}

- (void)clearButton:(id)sender;

@end
