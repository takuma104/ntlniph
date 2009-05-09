#import "NTLNTweetTextView.h"
#import "NTLNColors.h"

@implementation NTLNTweetTextView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextDrawLinearGradient(context, [[NTLNColors instance] linkBackgroundGradient], 
								CGPointMake(0,0), CGPointMake(0,rect.size.height), 
								kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
	
	CGContextRestoreGState(context);
}

- (void)dealloc {
    [super dealloc];
}

@end
