#import <UIKit/UIKit.h>
#import "NTLNTimelineViewController.h"

@class NTLNFriendsViewController;
@class NTLNReplysViewController;
@class NTLNDirectMessageViewController;

@interface NTLNUnreadsViewController : NTLNTimelineViewController {
	NTLNFriendsViewController *friendsViewController;
	NTLNReplysViewController *replysViewController;
	NTLNDirectMessageViewController *directMessageViewController;
}

@property (readwrite, assign) NTLNFriendsViewController *friendsViewController;
@property (readwrite, assign) NTLNReplysViewController *replysViewController;
@property (readwrite, assign) NTLNDirectMessageViewController *directMessageViewController;

- (void)clearButton:(id)sender;

@end
