#import <UIKit/UIKit.h>
#import "NTLNMessage.h"

@interface NTLNTweetQuoteView : UIView {
	NTLNMessage *message;
	CGFloat messageHeight;
}

@property (readonly) CGFloat messageHeight;

- (id)initWithFrame:(CGRect)frame withMessage:(NTLNMessage*)message;

@end
