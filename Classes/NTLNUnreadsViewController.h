#import <UIKit/UIKit.h>
#import "NTLNTimelineViewController.h"

@class NTLNFriendsViewController;
@class NTLNReplysViewController;

@interface NTLNUnreadsViewController : NTLNTimelineViewController {
	NTLNFriendsViewController *friendsViewController;
	NTLNReplysViewController *replysViewController;
}

@property (readwrite, assign) NTLNFriendsViewController *friendsViewController;
@property (readwrite, assign) NTLNReplysViewController *replysViewController;

- (void)clearButton:(id)sender;

@end
