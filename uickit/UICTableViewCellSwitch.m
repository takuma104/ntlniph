#import "UICTableViewCellSwitch.h"

@interface UICTableViewCellSwitch(Private)
- (void)switchPushed:(id)sender;

@end

@implementation UICTableViewCellSwitch

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		sw = [[[[UISwitch alloc] initWithFrame:CGRectMake(206, 9, 0, 0)] autorelease] retain];		
		[sw addTarget:self 
			   action:@selector(switchPushed:)
	 forControlEvents:UIControlEventValueChanged];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		[self addSubview:sw];
    }
	LOG(@"UICTableViewCellSwitch created:%x", self);
    return self;
}

- (void)switchPushed:(id)sender {
	prototype.value = sw.on;
	LOG(@"switch val changed:%d", prototype.value);
}

- (void)updateWithPrototype:(UICPrototypeTableCellSwitch*)aPrototype {
	[prototype release];
	prototype = [aPrototype retain];
	sw.on = prototype.value;
}

- (void)dealloc {
	LOG(@"UICTableViewCellSwitch dealloc:%x", self);
	[prototype release];
	[sw removeFromSuperview];
	[sw release];
    [super dealloc];
}

@end
