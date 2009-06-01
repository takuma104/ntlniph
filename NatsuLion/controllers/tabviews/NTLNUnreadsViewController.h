#import <UIKit/UIKit.h>
#import "NTLNTimelineViewController.h"

@class NTLNFriendsViewController;
@class NTLNMentionsViewController;
@class NTLNDirectMessageViewController;

@interface NTLNUnreadsViewController : NTLNTimelineViewController {
	NTLNFriendsViewController *friendsViewController;
	NTLNMentionsViewController *replysViewController;
	NTLNDirectMessageViewController *directMessageViewController;
}

@property (readwrite, assign) NTLNFriendsViewController *friendsViewController;
@property (readwrite, assign) NTLNMentionsViewController *replysViewController;
@property (readwrite, assign) NTLNDirectMessageViewController *directMessageViewController;

- (void)clearButton:(id)sender;

@end
