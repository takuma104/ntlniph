#import <UIKit/UIKit.h>

#import "NTLNTimelineViewController.h"

@class NTLNLinkViewController;

@interface NTLNFriendsViewController : NTLNTimelineViewController <UIActionSheetDelegate>
{		
	UITextField *tweetTextField;
}

- (NSMutableArray*)unreadStatuses;
- (void)allRead;

@end
