#import "NTLNIconTextCell.h"
#import "NTLNColors.h"

@implementation NTLNIconTextCell


+ (void)drawImage:(UIImage*)image atPoint:(CGPoint)pos withOverlayColor:(UIColor*)color {

	CGContextRef context = UIGraphicsGetCurrentContext();

	CGRect r = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, pos.x, -r.size.height-pos.y);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, r, image.CGImage);
    
    [color set];
	[[NTLNColors instance] textShadowBegin:context];
    CGContextFillRect(context, r);
	[[NTLNColors instance] textShadowEnd:context];
	
    CGContextRestoreGState(context);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
	CGContextDrawImage(context, r, image.CGImage); // dont shadow with me!
}

+ (void)drawText:(NSString*)text icon:(UIImage*)icon selected:(BOOL)selected{
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetTextDrawingMode(context, kCGTextFill);
	if (selected) {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textSelected].CGColor);
	} else {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textForground].CGColor);
		[[NTLNColors instance] textShadowBegin:context];
	}
	
	[text drawInRect:CGRectMake(13+30, 10, 280-30, 24)
			withFont:[UIFont boldSystemFontOfSize:18]
	   lineBreakMode:UILineBreakModeTailTruncation];
	
	[[NTLNColors instance] textShadowEnd:context];

	if (selected) {
		[NTLNIconTextCell drawImage:icon 
							atPoint:CGPointMake(13,10) 
				   withOverlayColor:[[NTLNColors instance] selectedIconOverlayColor]];
	} else {
		[NTLNIconTextCell drawImage:icon 
							atPoint:CGPointMake(13,10) 
				   withOverlayColor:[[NTLNColors instance] iconOverlayColor]];
	}
	
}	

- (void)createCellWithText:(NSString*)aText icon:(UIImage*)anIcon isEven:(BOOL)even{
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.cellType = NTLNCellTypeNoRound;
	
	[text release];
	text = [aText retain];
	
	[icon release];
	icon = [anIcon retain];
	
	isEven = even;
}

- (void)dealloc {
	[text release];
	[icon release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	if (isEven) {
		bgcolor = [[NTLNColors instance] evenBackground];
	} else {
		bgcolor = [[NTLNColors instance] oddBackground];
	}
	
	[super drawRect:rect];
	[NTLNIconTextCell drawText:text icon:icon selected:NO];
}

- (void)drawBackgroundRect:(CGRect)rect {
	[super drawBackgroundRect:rect];
	[NTLNIconTextCell drawText:text icon:icon selected:YES];
}

@end
