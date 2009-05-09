#import <UIKit/UIKit.h>
#import "NTLNTweetPostView.h"

@class NTLNAppDelegate;

@interface NTLNTweetPostViewController : UIViewController <UITextViewDelegate> {
	NTLNTweetPostView *tweetPostView;
	UILabel *textLengthView;
	int maxTextLength;
}

+ (void)present:(UIViewController*)parentViewController;
+ (void)dismiss;
+ (BOOL)active;

@end
