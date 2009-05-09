#import <UIKit/UIKit.h>

@interface NTLNTweetPostView : UIScrollView<UITextViewDelegate> {
	UITextView *textView;
	UIView *quoteView;
	NSObject<UITextViewDelegate> *textViewDelegate;
}

@property (readonly) UITextView	*textView;
@property (readwrite, retain) 	NSObject<UITextViewDelegate> *textViewDelegate;

- (void)updateQuoteView;

@end
