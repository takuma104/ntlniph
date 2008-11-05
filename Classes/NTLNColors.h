#import <UIKit/UIKit.h>

@interface NTLNColors : NSObject {
    UIColor *textForground;
    UIColor *textAnnotateForground;
	UIColor *textShadow;
	
	UIColor *textSelected;
	
    UIColor *oddBackground;
    UIColor *evenBackground;

    UIColor *replyBackground;
	UIColor *probableReplyBackground;
	UIColor *directMessageBackground;
	
	UIColor *scrollViewBackground;
	
	UIColor *selectedBackground;
}

+ (id) instance;

- (void) setupColors;

@property (readonly) UIColor *textForground, *textAnnotateForground, *textShadow, *textSelected;
@property (readonly) UIColor *oddBackground, *evenBackground, *replyBackground, *directMessageBackground;
@property (readonly) UIColor *probableReplyBackground;
@property (readonly) UIColor *scrollViewBackground, *selectedBackground;

@end
