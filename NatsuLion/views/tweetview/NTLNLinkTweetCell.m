#import "NTLNLinkTweetCell.h"
#import "NTLNColors.h"
#import "NTLNCellBackgroundView.h"

@implementation NTLNLinkTweetCell

+ (void)drawText:(NSString*)text footer:(NSString*)footer textHeight:(CGFloat)textHeight selected:(BOOL)selected{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetTextDrawingMode(context, kCGTextFill);
	if (selected) {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textSelected].CGColor);
	} else {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textForground].CGColor);
		[[NTLNColors instance] textShadowBegin:context];
	}

	[text drawInRect:CGRectMake(13, 13, 300, textHeight)
			withFont:[UIFont systemFontOfSize:16]
	   lineBreakMode:UILineBreakModeTailTruncation];

	[footer drawInRect:CGRectMake(13, 17 + textHeight, 300, 12)
			withFont:[UIFont boldSystemFontOfSize:11]
	   lineBreakMode:UILineBreakModeTailTruncation];

	[[NTLNColors instance] textShadowEnd:context];
}

- (void)dealloc {
	[text release];
	[footer release];
    [super dealloc];
}

- (void)createCellWithText:(NSString*)aText footer:(NSString*)aFooter textHeight:(CGFloat)aTextHeight {
	self.cellType = NTLNCellTypeRoundSpeech;
	text = [aText retain];
	footer = [aFooter retain];
	textHeight = aTextHeight;
	bgcolor = [[NTLNColors instance] oddBackground];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[NTLNLinkTweetCell drawText:text footer:footer textHeight:textHeight selected:NO];
}

- (void)drawSelectedBackgroundRect:(CGRect)rect {
	[super drawSelectedBackgroundRect:rect];
	[NTLNLinkTweetCell drawText:text footer:footer textHeight:textHeight selected:YES];
}

@end

@implementation NTLNLinkNameCell

+ (void)drawName:(NSString*)name screenName:(NSString*)screenName selected:(BOOL)selected {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetTextDrawingMode(context, kCGTextFill);
	if (selected) {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textSelected].CGColor);
	} else {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textForground].CGColor);
		[[NTLNColors instance] textShadowBegin:context];
	}

	[name drawInRect:CGRectMake(70.0, 10.0, 230.0, 30.0)
			withFont:[UIFont boldSystemFontOfSize:20.0]
	   lineBreakMode:UILineBreakModeTailTruncation];

	[screenName drawInRect:CGRectMake(70.0, 30+6.0, 230.0, 30.0)
			withFont:[UIFont boldSystemFontOfSize:14.0]
	   lineBreakMode:UILineBreakModeTailTruncation];

	[[NTLNColors instance] textShadowEnd:context];
}

- (void)dealloc {
	[name release];
	[screenName release];
    [super dealloc];
}

- (void)createCellWithName:(NSString*)aName screenName:(NSString*)aScreenName {
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.cellType = NTLNCellTypeRound;
	name = [aName retain];
	screenName = [aScreenName retain];
	bgcolor = [[NTLNColors instance] oddBackground];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[NTLNLinkNameCell drawName:name screenName:screenName selected:NO];
}

- (void)drawBackgroundRect:(CGRect)rect {
	[super drawBackgroundRect:rect];
	[NTLNLinkNameCell drawName:name screenName:screenName selected:YES];
}

@end



