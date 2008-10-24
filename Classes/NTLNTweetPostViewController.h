#import <UIKit/UIKit.h>
#import "NTLNTwitterClient.h"

@class NTLNAppDelegate;

@interface NTLNTweetPostViewController : UIViewController <UITextViewDelegate, NTLNTwitterClientDelegate> {
	IBOutlet UITextView *tweetTextView;
	IBOutlet NTLNAppDelegate *appDelegate;
	IBOutlet UILabel *textLengthView;
	NSString *backupFilename;
}

- (IBAction)cancelButtonPushed:(id)sender;
- (IBAction)sendButtonPushed:(id)sender;
- (IBAction)clearButtonPushed:(id)sender;

- (void) createReplyPost:(NSString*)text;

- (void) forcus;

@end
