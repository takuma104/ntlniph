#import <UIKit/UIKit.h>

#import "NTLNTimelineViewController.h"

@class NTLNTweetViewController;
@class NTLNMentionsViewController;

@interface NTLNFriendsViewController : NTLNTimelineViewController <UIActionSheetDelegate>
{		
	UITextField *tweetTextField;
	NTLNMentionsViewController *mentionsViewController;
}

@property (readwrite, assign) NTLNMentionsViewController *mentionsViewController;

//- (NSMutableArray*)unreadStatuses;
//- (void)allRead;

@end
