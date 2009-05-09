#import "NTLNCell.h"
#import "NTLNColors.h"

@implementation NTLNCellBackground

- (id)initWithDelegate:(NSObject<NTLNCellBackgroundDelegate>*)aDelegate {
	if (self = [super init]) {
		delegate = [aDelegate retain];
	}
	return self;
}

- (void)dealloc {
	[delegate release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	[delegate drawBackgroundRect:rect];
}

@end


static void drawRoundedRectPath(CGRect rect, BOOL topRound, BOOL bottomRound, BOOL topTriangle)
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	const CGFloat roundSize = 8.0;
	
	CGFloat x = rect.origin.x - 0.5;
	CGFloat y = rect.origin.y - 0.5;
	CGFloat w = rect.size.width;
	CGFloat h = rect.size.height;
	
	CGContextBeginPath (context);
	
	CGContextMoveToPoint(context,   x + w/2, y + 0);
	if (topRound) {
		CGContextAddArcToPoint(context, x + w, y + 0, x + w,   y + h/2, roundSize);
	} else {
		CGContextAddLineToPoint(context, x + w, y + 0);
	}
	if (bottomRound) {
		CGContextAddArcToPoint(context, x + w, y + h, x + w/2, y + h, roundSize);
		CGContextAddArcToPoint(context, x + 0, y + h, x + 0,   y + h/2, roundSize);
	} else {
		CGContextAddLineToPoint(context, x + w, y + h);
		CGContextAddLineToPoint(context, x + 0, y + h);
	}
	if (topRound) {
		CGContextAddArcToPoint(context, x + 0, y + 0, x + w/2, y + 0, roundSize);
	} else {
		CGContextAddLineToPoint(context, x + 0, y + 0);
	}
	
	if (topTriangle) {
		CGContextAddLineToPoint(context, x + 27, y);
		CGContextAddLineToPoint(context, x + 32, y - 4);
		CGContextAddLineToPoint(context, x + 37, y);
	}
	
	CGContextClosePath(context);
}

static void drawRoundedRectBackground(CGRect rect, UIColor *bgColor, BOOL topRound, BOOL bottomRound, BOOL topTriangle) 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetStrokeColorWithColor(context, [[NTLNColors instance] separator]);
	CGContextSetLineWidth(context, 1.f);
	CGContextSetFillColorWithColor(context, bgColor.CGColor);
	
	drawRoundedRectPath(rect, topRound, bottomRound, topTriangle);
	CGContextFillPath(context);
	
	drawRoundedRectPath(rect, topRound, bottomRound, topTriangle);
	CGContextStrokePath(context);
}

static void drawRoundedRectBackgroundGradient(CGRect rect, CGGradientRef gradient, BOOL topRound, BOOL bottomRound, BOOL topTriangle) 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	

	CGContextSaveGState(context);
	drawRoundedRectPath(rect, topRound, bottomRound, topTriangle);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,rect.size.height), 
								kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);

	CGContextRestoreGState(context);
	
	CGContextSetStrokeColorWithColor(context, [[NTLNColors instance] separator]);
	CGContextSetLineWidth(context, 1.f);

	drawRoundedRectPath(rect, topRound, bottomRound, topTriangle);
	CGContextStrokePath(context);
}

static void drawRectBackground(CGRect rect, UIColor *bgColor) 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, bgColor.CGColor);
	CGContextFillRect(context,CGRectMake(0, 1, rect.size.width, rect.size.height-2));
	
	const CGFloat *f = CGColorGetComponents(bgColor.CGColor);
	
	CGContextSetRGBFillColor(context, f[0]*1.5, f[1]*1.5, f[2]*1.5, 1.f);
	CGContextFillRect(context,CGRectMake(0, 0, rect.size.width,1));
	
	CGContextSetRGBFillColor(context, f[0]*0.9, f[1]*0.9, f[2]*0.9, 1.f);
	CGContextFillRect(context,CGRectMake(0, rect.size.height-1, rect.size.width,1));
}

@implementation NTLNCell

@synthesize cellType, bgcolor;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		self.selectedBackgroundView = [[[NTLNCellBackground alloc] 
									initWithDelegate:self] autorelease];
		self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
		self.cellType = NTLNCellTypeNormal;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawBackgroundImpl:(CGRect)rect color:(UIColor*)color {	
	switch (cellType){
		case NTLNCellTypeNormal:
			drawRectBackground(rect, color);
			break;
		case NTLNCellTypeNoRound:
			rect.size.width -= 6;
			rect.origin.x += 3;
			drawRoundedRectBackground(rect, color, NO, NO, NO);
			break;
		case NTLNCellTypeRound:
			rect.size.width -= 6;
			rect.size.height -= 6;
			rect.origin.x += 3;
			rect.origin.y += 3;
			drawRoundedRectBackground(rect, color, YES, YES, NO);
			break;
		case NTLNCellTypeRoundTop:
			rect.size.width -= 6;
			rect.size.height -= 3;
			rect.origin.x += 3;
			rect.origin.y += 3;
			drawRoundedRectBackground(rect, color, YES, NO, NO);
			break;
		case NTLNCellTypeRoundBottom:
			rect.size.width -= 6;
//			rect.size.height -= 3;
			rect.origin.x += 3;
			drawRoundedRectBackground(rect, color, NO, YES, NO);
			break;
		case NTLNCellTypeRoundSpeech:
			rect.size.width -= 6;
			rect.size.height -= 4;
			rect.origin.x += 3;
			rect.origin.y += 5;
			drawRoundedRectBackground(rect, color, YES, NO, YES);
			break;
	}
}

- (void)drawBackgroundGradientImpl:(CGRect)rect gradient:(CGGradientRef)gradient {	
	switch (cellType){
		case NTLNCellTypeNormal:
//			drawRectBackground(rect, color);
			break;
		case NTLNCellTypeNoRound:
			rect.size.width -= 6;
			rect.origin.x += 3;
			drawRoundedRectBackgroundGradient(rect, gradient, NO, NO, NO);
			break;
		case NTLNCellTypeRound:
			rect.size.width -= 6;
			rect.size.height -= 6;
			rect.origin.x += 3;
			rect.origin.y += 3;
			drawRoundedRectBackgroundGradient(rect, gradient, YES, YES, NO);
			break;
		case NTLNCellTypeRoundTop:
			rect.size.width -= 6;
			rect.size.height -= 3;
			rect.origin.x += 3;
			rect.origin.y += 3;
			drawRoundedRectBackgroundGradient(rect, gradient, YES, NO, NO);
			break;
		case NTLNCellTypeRoundBottom:
			rect.size.width -= 6;
			//			rect.size.height -= 3;
			rect.origin.x += 3;
			drawRoundedRectBackgroundGradient(rect, gradient, NO, YES, NO);
			break;
		case NTLNCellTypeRoundSpeech:
			rect.size.width -= 6;
			rect.size.height -= 4;
			rect.origin.x += 3;
			rect.origin.y += 5;
			drawRoundedRectBackgroundGradient(rect, gradient, YES, NO, YES);
			break;
	}
}

- (void)drawRect:(CGRect)rect {
//	UIColor *color = [[NTLNColors instance] oddBackground];
//	[self drawBackgroundImpl:rect color:bgcolor];
//	[self drawBackgroundGradientImpl:rect  gradient:[[NTLNColors instance] linkBackgroundGradient]];

	if (cellType == NTLNCellTypeNoRound || cellType == NTLNCellTypeRoundBottom) {
		//			UIColor *color = [[NTLNColors instance] selectedBackground];
		[self drawBackgroundImpl:rect color:bgcolor];
	} else {
		[self drawBackgroundGradientImpl:rect  gradient:[[NTLNColors instance] linkBackgroundGradient]];
	}
	
}

- (void)drawBackgroundRect:(CGRect)rect {
	[self drawSelectedBackgroundRect:rect];
}

- (void)drawSelectedBackgroundRect:(CGRect)rect {
	[self drawBackgroundGradientImpl:rect  gradient:[[NTLNColors instance] linkSelectedBackgroundGradient]];
}


@end
