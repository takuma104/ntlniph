#import "NTLNRateLimitView.h"
#import "NTLNShardInstance.h"
#import "NTLNRateLimit.h"

@implementation NTLNRateLimitView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	int now = [NTLNRateLimit shardInstance].rate_limit_remaining;
	int all = [NTLNRateLimit shardInstance].rate_limit;

	if (now && all) {
		CGFloat h = rect.size.height * (CGFloat)now / (CGFloat)all;

		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSetRGBStrokeColor(context, 1.f, 1.f, 1.f, 1.f);
		CGContextSetRGBFillColor(context, 1.f, 1.f, 1.f, 1.f);
		CGContextStrokeRectWithWidth(context, rect, 4);
		CGContextFillRect(context,CGRectMake(0, rect.size.height-h, rect.size.width, h));
	}
}

- (void)dealloc {
    [super dealloc];
}

@end
