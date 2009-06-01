#import <UIKit/UIKit.h>
#import "NTLNTimelineViewController.h"

@class NTLNFriendsViewController;

@interface NTLNMentionsViewController : NTLNTimelineViewController {
	NTLNFriendsViewController *friendsViewController;
}

@property (readwrite, assign) NTLNFriendsViewController *friendsViewController;

@end
