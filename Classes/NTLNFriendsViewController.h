#import <UIKit/UIKit.h>

#import "NTLNTimelineViewController.h"

@class NTLNLinkViewController;
@class NTLNReplysViewController;

@interface NTLNFriendsViewController : NTLNTimelineViewController <UIActionSheetDelegate>
{		
	UITextField *tweetTextField;
	NTLNReplysViewController *replysViewController;
}

@property (readwrite, assign) NTLNReplysViewController *replysViewController;

//- (NSMutableArray*)unreadStatuses;
//- (void)allRead;

@end
