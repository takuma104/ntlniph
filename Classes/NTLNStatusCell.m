#import "NTLNStatusCell.h"
#import "NTLNColors.h"
#import "NTLNIconRepository.h"
#import "ntlniphAppDelegate.h"
#import "NTLNTweetPostViewController.h"
#import "NTLNConfiguration.h"
#import "NTLNCellBackgroundView.h"
#import "NTLNImages.h"

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
    CGRect bounds = CGRectMake(0, 0, 250.0, 300.0);
    CGRect result = [textLabel textRectForBounds:bounds limitedToNumberOfLines:10];
	CGFloat h = result.size.height;
	[textLabel release];
	return h;
}

- (UIColor*)colorForBackground {
	UIColor *color = nil;
	if (status) {
		switch (status.message.replyType) {
			case NTLN_MESSAGE_REPLY_TYPE_REPLY:
				color = [[NTLNColors instance] replyBackground];
				break;
			case NTLN_MESSAGE_REPLY_TYPE_REPLY_PROBABLE:
				color =  [[NTLNColors instance] probableReplyBackground];
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
	UIColor *bgcolor = [self colorForBackground];

	value = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	value.font = [NTLNStatusCell textFont];
	value.textColor = [[NTLNColors instance] textForground];
	value.lineBreakMode = UILineBreakModeWordWrap;
	value.numberOfLines = 0;
	value.backgroundColor = bgcolor;
	[self.contentView addSubview:value];	

	name = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	name.font = [NTLNStatusCell metaFont];
	name.textColor = [[NTLNColors instance] textAnnotateForground];
	name.lineBreakMode = UILineBreakModeTailTruncation;
	name.numberOfLines = 1;
	name.backgroundColor = bgcolor;
//	name.shadowColor = [[NTLNColors instance] textShadow];
//	name.shadowOffset = CGSizeMake(0, 1);
	[self.contentView addSubview:name];	

	timestamp = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	timestamp.font = [NTLNStatusCell metaFont];
	timestamp.textColor = [[NTLNColors instance] textAnnotateForground];
	timestamp.lineBreakMode = UILineBreakModeClip;
	timestamp.numberOfLines = 1;
	timestamp.backgroundColor = bgcolor;
//	timestamp.shadowColor = [[NTLNColors instance] textShadow];
//	timestamp.shadowOffset = CGSizeMake(0, 1);
	[self.contentView addSubview:timestamp];	

	iconView = [[[NTLNRoundedIconView alloc] 
				 initWithFrame:CGRectMake(4.0, 6.0, 40.0, 40.0) 
				 image:[NTLNIconRepository defaultIcon]
				 round:5.0] autorelease];
	[self.contentView addSubview:iconView];	

	
	unreadView = [[[UIImageView alloc] initWithFrame:CGRectMake(300, 0, 16, 16)] autorelease];
	unreadView.hidden = YES;
	[self.contentView addSubview:unreadView];

	
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.selectionStyle = UITableViewCellSelectionStyleGray;
	NTLNCellBackgroundView *v = [[[NTLNCellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
	v.backgroundColor = bgcolor;
	self.backgroundView = v;
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
	value.backgroundColor = color;
	name.backgroundColor = color;
	timestamp.backgroundColor = color;
	iconView.backgroundColor = color;
	
	if (status.message.status == NTLN_MESSAGE_STATUS_NORMAL) {
		unreadView.hidden = NO;
	} else {
		unreadView.hidden = YES;
	}
}

- (void)iconButtonPushed:(id)sender {
	NSLog(@"reply to @%@", status.message.screenName);

	NTLNAppDelegate* appDelegate = (NTLNAppDelegate*)[UIApplication sharedApplication].delegate;
	[appDelegate.tweetPostViewController createReplyPost:[@"@" stringByAppendingString:status.message.screenName]];
}

- (void)updateCell:(NTLNStatus*)aStatus isEven:(BOOL)iseven {
	
	[status release];
	status = aStatus;
	[status retain];
	
	isEven = iseven;
	
	CGFloat metaTextY = status.cellHeight - 16;
	
	if (status.message.favorited) {
		CGRect r = CGRectMake(300, metaTextY-2, 16, 16);
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
	
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		unreadView.image = [[NTLNImages sharedInstance] unreadDark];
	} else {
		unreadView.image = [[NTLNImages sharedInstance] unreadLight];
	}
	
	value.frame = CGRectMake(48.0, 4.0, 250.0, status.textHeight);
	value.text = status.message.text;
	
	name.frame = CGRectMake(48.0, metaTextY, 200.0, 12.0);
	if ([status.message.screenName isEqualToString:status.message.name]) {
		name.text = status.message.screenName;
	} else {
		name.text = [status.message.screenName stringByAppendingString:@" / "];
		name.text = [name.text stringByAppendingString:status.message.name];
	}

	char tmp[80];
	time_t tt = [status.message.timestamp timeIntervalSince1970];
	struct tm *t = localtime(&tt);
	strftime(tmp, sizeof(tmp), "%H:%M:%S", t);
	
	timestamp.frame = CGRectMake(250.0, metaTextY, 100.0, 12.0);
	timestamp.text = [NSString stringWithUTF8String:tmp];
	
	UIImage *icon = status.message.icon;
	if (icon == nil) {
		icon = [NTLNIconRepository defaultIcon];
	}
	[iconView setImage:icon];
	
	[iconView addTarget:self 
				 action:@selector(iconButtonPushed:)
	   forControlEvents:UIControlEventTouchUpInside];
	

	[self updateBackgroundColor];
}

- (void)updateIcon {
	[iconView setImage:status.message.icon];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	if (selected) {
		value.textColor		= [UIColor blackColor];
		name.textColor		= [UIColor blackColor];
		timestamp.textColor = [UIColor blackColor];
	} else {
		value.textColor		= [[NTLNColors instance] textForground];
		name.textColor		= [[NTLNColors instance] textAnnotateForground];
		timestamp.textColor = [[NTLNColors instance] textAnnotateForground];
	}
}

@end