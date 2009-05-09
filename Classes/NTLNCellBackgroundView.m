#import "NTLNCellBackgroundView.h"
#import "NTLNStatusCell.h"
#import "NTLNColors.h"

@implementation NTLNCellBackgroundView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}

+ (void)drawBackground:(CGRect)rect backgroundColor:(UIColor*)backgroundColor {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
	CGContextFillRect(context,CGRectMake(0, 0, rect.size.width, rect.size.height-1));
	CGContextSetFillColorWithColor(context, [[NTLNColors instance] separator]);
	CGContextFillRect(context,CGRectMake(0, rect.size.height-1, rect.size.width,1));
}

- (void)drawRect:(CGRect)rect {
	[NTLNCellBackgroundView drawBackground:rect backgroundColor:self.backgroundColor];
}

- (void)dealloc {
	[super dealloc];
}

@end


