#import "NTLNUserCell.h"
#import "NTLNColors.h"

@interface NTLNUserCell(Private)
- (void)createCell;

@end


@implementation NTLNUserCell

@synthesize user;

- (id)initWithFrame:(CGRect)rect reuseIdentifier:(NSString*)anId {
	if (self = [super initWithFrame:rect reuseIdentifier:anId]) {
		[self createCell];
	}
	return self;
}

- (void)dealloc {
	[user release];
	[iconView release];
	[super dealloc];
}

- (void)createCell {
	iconView = [[NTLNRoundedIconView alloc] 
				 initWithFrame:CGRectMake(7.0, 7.0, 30.0, 30.0) 
				 image:[NTLNIconRepository defaultIcon]
				 round:5.0];
	[self.contentView addSubview:iconView];	
}

- (void)updateByUser:(NTLNUser*)anUser isEven:(BOOL)even{
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.cellType = NTLNCellTypeNoRound;
	
	isEven = even;
	
	[user release];
	user = [anUser retain];
	[self updateIcon];
	[self setNeedsDisplay];
}


+ (void)drawText:(NSString*)text selected:(BOOL)selected {
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
}	

- (void)drawRect:(CGRect)rect {
	
	if (isEven) {
		bgcolor = [[NTLNColors instance] evenBackground];
	} else {
		bgcolor = [[NTLNColors instance] oddBackground];
	}
	
	[super drawRect:rect];
	[NTLNUserCell drawText:[NSString stringWithFormat:@"%@ / %@",user.screen_name,user.name] 
				  selected:NO];
}

- (void)drawBackgroundRect:(CGRect)rect {
	[super drawBackgroundRect:rect];
	[NTLNUserCell drawText:[NSString stringWithFormat:@"%@ / %@",user.screen_name,user.name] 
				  selected:YES];
}

- (void)updateIcon {
	UIImage *icon = user.iconContainer.iconImage;
	if (icon == nil) {
		icon = [NTLNIconRepository defaultIcon];
	}
	[iconView setImage:icon];
}

@end
