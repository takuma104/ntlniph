#import <UIKit/UIKit.h>
#import "NTLNTimelineViewController.h"

@class NTLNFriendsViewController;

@interface NTLNReplysViewController : NTLNTimelineViewController {
	NTLNFriendsViewController *friendsViewController;
}

@property (readwrite, assign) NTLNFriendsViewController *friendsViewController;

@end
