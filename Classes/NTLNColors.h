#import <UIKit/UIKit.h>

@interface NTLNColors : NSObject {
    UIColor *textForground;
    UIColor *textAnnotateForground;
	
	UIColor *textSelected;
	
    UIColor *oddBackground;
    UIColor *evenBackground;

    UIColor *replyBackground;
	UIColor *probableReplyBackground;
	UIColor *directMessageBackground;
	
	UIColor *scrollViewBackground;
	
	UIColor *selectedBackground;

	UIColor *iconOverlayColor;
	UIColor *selectedIconOverlayColor;

	CGGradientRef	linkBackgroundGradient;
	CGGradientRef	linkSelectedBackgroundGradient;
	
	CGGradientRef	timelineSelectedBackgroundGradient;
	
	CGColorRef		separator;
	
	CGColorRef		textShadowColor;
	CGSize			textShadowSize;	
	
	CGColorRef		quoteTextColor;
	CGColorRef		quoteBackgroundColor;
}

+ (id) instance;

- (void) setupColors;

@property (readonly) UIColor *textForground, *textAnnotateForground, *textSelected;
@property (readonly) UIColor *oddBackground, *evenBackground, *replyBackground, *directMessageBackground;
@property (readonly) UIColor *probableReplyBackground;
@property (readonly) UIColor *scrollViewBackground, *selectedBackground;
@property (readonly) UIColor *iconOverlayColor;
@property (readonly) UIColor *selectedIconOverlayColor;

@property (readonly) CGGradientRef	linkBackgroundGradient;
@property (readonly) CGGradientRef	linkSelectedBackgroundGradient;

@property (readonly) CGGradientRef timelineSelectedBackgroundGradient;

@property (readonly) CGColorRef separator;

@property (readonly) CGColorRef quoteTextColor;
@property (readonly) CGColorRef quoteBackgroundColor;

- (void)textShadowBegin:(CGContextRef)context;
- (void)textShadowEnd:(CGContextRef)context;

@end
