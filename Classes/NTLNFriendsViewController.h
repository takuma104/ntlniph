#import <UIKit/UIKit.h>

#import "NTLNStatusViewController.h"

@class NTLNLinkViewController;

@interface NTLNFriendsViewController : NTLNStatusViewController <UIActionSheetDelegate>
{		
	UITextField *tweetTextField;
}

- (NSMutableArray*)unreadStatuses;
- (void)allRead;

@end
