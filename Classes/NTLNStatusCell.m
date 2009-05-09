#import "NTLNStatusCell.h"
#import "NTLNColors.h"
#import "NTLNIconRepository.h"
#import "NTLNAppDelegate.h"
#import "NTLNTweetPostViewController.h"
#import "NTLNConfiguration.h"
#import "NTLNCellBackgroundView.h"
#import "NTLNImages.h"
#import "NTLNSelectedCellBackgroundView.h"
#import "NTLNTwitterPost.h"
#import "NSDateExtended.h"

@implementation NTLNStatusCell

@synthesize status;

+ (UIFont*)textFont {
	return [UIFont systemFontOfSize:14.0];
}

+ (UIFont*)metaFont {
	return [UIFont boldSystemFontOfSize:11.0];
}

+ (CGFloat)getTextboxHeight:(NSString *)str {
    UILabel *textLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    textLabel.font = [NTLNStatusCell textFont];
    textLabel.numberOfLines = 10;
    textLabel.text = str;
    CGRect bounds = CGRectMake(0, 0, 256, 300.0);
    CGRect result = [textLabel textRectForBounds:bounds limitedToNumberOfLines:10];
	CGFloat h = result.size.height;
	[textLabel release];
	return h;
}

+ (void)drawTexts:(NTLNStatus*)status selected:(BOOL)selected{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat metaTextY = status.cellHeight - 17;
	
	CGContextSetTextDrawingMode(context, kCGTextFill);
	if (selected) {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textSelected].CGColor);
	} else {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textForground].CGColor);
	}
	
	[status.message.text drawInRect:CGRectMake(48.0, 4.0, 256, status.textHeight) 
	 withFont:[NTLNStatusCell textFont]
	 lineBreakMode:UILineBreakModeWordWrap];
	
	if (selected) {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textSelected].CGColor);
	} else {
		CGContextSetFillColorWithColor(context, [[NTLNColors instance] textAnnotateForground].CGColor);
		[[NTLNColors instance] textShadowBegin:context];
	}
	
	NSString *name;
	if ([status.message.screenName isEqualToString:status.message.name]) {
		name = status.message.screenName;
	} else {
		name = [status.message.screenName stringByAppendingString:@" / "];
		name = [name stringByAppendingString:status.message.name];
	}
	
	[name drawInRect:CGRectMake(48.0, metaTextY, 200.0, 12.0) 
			withFont:[NTLNStatusCell metaFont]
	   lineBreakMode:UILineBreakModeTailTruncation];
		
	[[status.message.timestamp descriptionWithNTLNStyle] 
				   drawInRect:CGRectMake(264.0, metaTextY, 100.0, 12.0) 
					 withFont:[NTLNStatusCell metaFont]
				lineBreakMode:UILineBreakModeTailTruncation];

	if (!selected) {
		[[NTLNColors instance] textShadowEnd:context];
	}
}

- (UIColor*)colorForBackground {
	UIColor *color = nil;
	if (status && !disableColorize) {
		switch (status.message.replyType) {
			case NTLN_MESSAGE_REPLY_TYPE_REPLY:
				color = [[NTLNColors instance] replyBackground];
				break;
			case NTLN_MESSAGE_REPLY_TYPE_REPLY_PROBABLE:
				color =  [[NTLNColors instance] probableReplyBackground];
				break;
			case NTLN_MESSAGE_REPLY_TYPE_DIRECT:
				color =  [[NTLNColors instance] directMessageBackground];
				break;
		}	
	}
	
	if (!color) {
		if (isEven) {
			color = [[NTLNColors instance] evenBackground];
		} else {
			color = [[NTLNColors instance] oddBackground];
		}
	}
	return color;
}

- (void)createCell {
	iconView = [[[NTLNRoundedIconView alloc] 
				 initWithFrame:CGRectMake(4.0, 6.0, 40.0, 40.0) 
				 image:[NTLNIconRepository defaultIcon]
				 round:5.0] autorelease];
	[self.contentView addSubview:iconView];	

	unreadView = [[[UIImageView alloc] initWithFrame:CGRectMake(300, 0, 16, 16)] autorelease];
	unreadView.hidden = YES;
	[self.contentView addSubview:unreadView];

	self.accessoryType = UITableViewCellAccessoryNone;
	
	NTLNSelectedCellBackgroundView *v = [[[NTLNSelectedCellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
	v.status = status;
	self.selectedBackgroundView = v;
}

- (id)initWithIsEven:(BOOL)iseven {
	self = [super initWithFrame:CGRectZero reuseIdentifier:CELL_RESUSE_ID];
	isEven = iseven;
	[self createCell];
	return self;
}

- (void)dealloc {
	[status release];
	[super dealloc];
}

- (void)updateBackgroundColor {
	UIColor *color = [self colorForBackground];
	((NTLNCellBackgroundView*)self.backgroundView).backgroundColor = color;
	iconView.backgroundColor = color;
	
	if (status.message.status == NTLN_MESSAGE_STATUS_NORMAL) {
		unreadView.hidden = NO;
	} else {
		unreadView.hidden = YES;
	}
}

- (void)iconButtonPushed:(id)sender {
	LOG(@"reply to @%@", status.message.screenName);
	
	if (status.message.replyType == NTLN_MESSAGE_REPLY_TYPE_DIRECT) {
		[[NTLNTwitterPost shardInstance] createDMPost:status.message.screenName withReplyMessage:status.message];
	} else {
		[[NTLNTwitterPost shardInstance] createReplyPost:[@"@" stringByAppendingString:status.message.screenName]
										withReplyMessage:status.message];
	}
}

- (void)updateCell:(NTLNStatus*)aStatus isEven:(BOOL)iseven {
	
	[status release];
	status = aStatus;
	[status retain];
	
	isEven = iseven;
	
	if (status.message.favorited) {
		CGRect r = CGRectMake(300, (status.cellHeight-16)/2, 16, 16);
		if (starView == nil) {
			starView = [[UIImageView alloc] initWithFrame:r];
			starView.image = [[NTLNImages sharedInstance] starHilighted];
			[self.contentView addSubview:starView];
		} else {
			[starView setFrame:r];
		}
	} else if (starView) {
		[starView removeFromSuperview];
		[starView release];
		starView = nil;
	}
	
	unreadView.frame = CGRectMake(302, 2, 16, 16);
	
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		unreadView.image = [[NTLNImages sharedInstance] unreadDark];
	} else {
		unreadView.image = [[NTLNImages sharedInstance] unreadLight];
	}

	UIImage *icon = status.message.iconContainer.iconImage;
	if (icon == nil) {
		icon = [NTLNIconRepository defaultIcon];
	}
	[iconView setImage:icon];
	
	[iconView addTarget:self 
				 action:@selector(iconButtonPushed:)
	   forControlEvents:UIControlEventTouchUpInside];
	
	[self updateBackgroundColor];
	[self setNeedsDisplay];
	
	((NTLNSelectedCellBackgroundView*)self.selectedBackgroundView).status = status;
	[(NTLNSelectedCellBackgroundView*)self.selectedBackgroundView setNeedsDisplay];
}

- (void)updateIcon {
	[iconView setImage:status.message.iconContainer.iconImage];
}

- (void)drawRect:(CGRect)rect {
//	[NTLNCellBackgroundView drawBackground:rect gradient:[[NTLNColors instance] timelineBackgroundGradient]];
	[NTLNCellBackgroundView drawBackground:rect backgroundColor:[self colorForBackground]];
	[NTLNStatusCell drawTexts:status selected:NO];
}

- (void)setDisableColorize {
	disableColorize = YES;
}


@end