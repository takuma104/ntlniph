#import "NTLNRoundedIconView.h"

@implementation NTLNRoundedIconView

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image round:(CGFloat)round {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor whiteColor];
		[self setImage:image];
		roundSize = round;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	// flip the coordinate system to avoid upside-down image drawing
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGFloat w = rect.size.width;
	CGFloat h = rect.size.height;

	// setup rounded-rect clip
	CGContextBeginPath (context);
	CGContextMoveToPoint(context,w/2, 0);
	CGContextAddArcToPoint(context, w, 0, w, h/2, roundSize);
	CGContextAddArcToPoint(context, w, h, w/2, h, roundSize);
	CGContextAddArcToPoint(context, 0, h, 0, h/2, roundSize);
	CGContextAddArcToPoint(context, 0, 0, w/2, 0, roundSize);
	CGContextClosePath (context);
	CGContextClip (context);
	
	// draw image with rounded-rect clip
	CGContextDrawImage (context, rect, imageRef);

	// outline 
	CGContextSetLineWidth(context, 2.f);
	CGContextSetRGBStrokeColor(context, 0.5f, 0.5f, 0.5f, 0.2f);
	CGContextBeginPath (context);
	CGContextMoveToPoint(context,w/2, 0);
	CGContextAddArcToPoint(context, w, 0, w, h/2, roundSize);
	CGContextAddArcToPoint(context, w, h, w/2, h, roundSize);
	CGContextAddArcToPoint(context, 0, h, 0, h/2, roundSize);
	CGContextAddArcToPoint(context, 0, 0, w/2, 0, roundSize);
	CGContextClosePath(context);
	CGContextStrokePath(context);
}

- (void)dealloc {
	CGImageRelease(imageRef);
	[super dealloc];
}

- (void)setImage:(UIImage*)image {
	if (imageRef) {
		CGImageRelease(imageRef);
	}

	imageRef = NULL;

	@try {
		if ([image isKindOfClass:[UIImage class]]) {
			imageRef = CGImageRetain([image CGImage]);
		}
	}
	@catch (NSException *exception) {
		imageRef = NULL;
	}
	
	[self setNeedsDisplay];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView *v = [super hitTest:point withEvent:event];
	if (v == self) {
		self.showsTouchWhenHighlighted = YES;
	} else {
		self.showsTouchWhenHighlighted = NO;
	}
	return v;
}

@end
