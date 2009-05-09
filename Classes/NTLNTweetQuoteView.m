#import "NTLNTweetQuoteView.h"
#import "NTLNColors.h"

@implementation NTLNTweetQuoteView

@synthesize messageHeight;

+ (UIFont*)textFont {
	return [UIFont systemFontOfSize:14];
}

+ (UIFont*)textAnnotateFont {
	return [UIFont boldSystemFontOfSize:12];
}

+ (CGFloat)getTextboxHeight:(NSString *)str {
    UILabel *textLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    textLabel.font = [NTLNTweetQuoteView textFont];
    textLabel.numberOfLines = 10;
    textLabel.text = str;
    CGRect bounds = CGRectMake(0.f, 0.f, 256.f, 300.f);
    CGRect result = [textLabel textRectForBounds:bounds limitedToNumberOfLines:10];
	CGFloat h = result.size.height;
	[textLabel release];
	return h;
}

- (id)initWithFrame:(CGRect)frame withMessage:(NTLNMessage*)theMessage {
    if (self = [super initWithFrame:frame]) {
		message = [theMessage retain];
		messageHeight = [NTLNTweetQuoteView getTextboxHeight:message.text];
		self.frame = CGRectMake(frame.origin.x, frame.origin.y, 320, messageHeight+40);
		[self setNeedsDisplay];
		[self setNeedsLayout];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [[NTLNColors instance] quoteBackgroundColor]);
	CGContextFillRect(context, rect);
	
	[[NTLNColors instance] textShadowBegin:context];

	CGContextSetFillColorWithColor(context, [[NTLNColors instance] quoteTextColor]);
	CGRect r = rect;
	r.size.height = 1;
	CGContextFillRect(context, r);
	
	CGContextSetTextDrawingMode(context, kCGTextFill);
	
	r = CGRectMake(10, 10, 300, 16);
	NSString *text;
	if (message.replyType == NTLN_MESSAGE_REPLY_TYPE_DIRECT) {
		text = [NSString stringWithFormat:@"Direct message from @%@:", message.screenName];
	} else {
		text = [NSString stringWithFormat:@"In reply to @%@:", message.screenName];
	}
	[text drawInRect:r 
			withFont:[NTLNTweetQuoteView textAnnotateFont]
	   lineBreakMode:UILineBreakModeTailTruncation];

	r = CGRectMake(10, 28, 300, messageHeight);
	[message.text drawInRect:r 
					withFont:[NTLNTweetQuoteView textFont]
			   lineBreakMode:UILineBreakModeTailTruncation];
	
	[[NTLNColors instance] textShadowEnd:context];
}

- (void)dealloc {
	[message release];
    [super dealloc];
}


@end
