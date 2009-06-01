#import <UIKit/UIKit.h>

@interface NTLNRoundedIconView : UIButton {
	CGImageRef imageRef;
	CGFloat roundSize;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image round:(CGFloat)round;
- (void)setImage:(UIImage*)image;

@end
