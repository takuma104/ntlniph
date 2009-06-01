#import "UICTableViewCellSelect.h"

@implementation UICTableViewCellSelect


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {

//		self.selectionStyle = UITableViewCellSelectionStyleNone;

		label = [[[[UILabel alloc] initWithFrame:CGRectMake(160, 12, 120, 24)] autorelease] retain];
//		label.text = @"test";
		label.font = [UIFont systemFontOfSize:18];
		label.textAlignment = UITextAlignmentRight;
//		label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		label.textColor = [UIColor colorWithRed:(0x32/255.0) green:(0x4f/255.0) blue:(0x85/255.0) alpha:1.0];
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
		[self addSubview:label];
    }
	return self;
}

- (void)dealloc {
	[prototype release];
	[label removeFromSuperview];
	[label release];
	[super dealloc];
}

- (void)updateWithPrototype:(UICPrototypeTableCellSelect*)aPrototype {
	[prototype release];
	prototype = [aPrototype retain];
	
	NSString *selectedTitle = [prototype.titles objectAtIndex:prototype.selectedIndex];
	label.text = selectedTitle;
}


@end
