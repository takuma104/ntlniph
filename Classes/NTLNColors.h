#import <UIKit/UIKit.h>

@interface NTLNColors : NSObject {
    UIColor *textForground;
    UIColor *textAnnotateForground;
	UIColor *textShadow;
	
    UIColor *oddBackground;
    UIColor *evenBackground;

    UIColor *replyBackground;
	UIColor *probableReplyBackground;
	
	UIColor *scrollViewBackground;
}

+ (id) instance;

- (void) setupColors;

@property (readonly) UIColor *textForground, *textAnnotateForground, *textShadow;
@property (readonly) UIColor *oddBackground, *evenBackground, *replyBackground;
@property (readonly) UIColor *probableReplyBackground;
@property (readonly) UIColor *scrollViewBackground;

@end
