#import "UICPrototypeTableCellSwitch.h"
#import "UICTableViewCellSwitch.h"

@implementation UICPrototypeTableCellSwitch

- (id)initWithTitle:(NSString*)aTitle withSwitch:(BOOL)val {
	if (self = [super initWithTitle:aTitle]) {
		value = val;
	}
	return self;
}

- (id)initWithTitle:(NSString*)aTitle withUserDefaultsKey:(NSString*)key {
	if (self = [super initWithTitle:aTitle]) {
		userDefaultsKey = [key retain];
		value = [[NSUserDefaults standardUserDefaults] boolForKey:userDefaultsKey];
	}
	return self;
}

- (id)tableCellViewWithReuseId:(NSString*)reuseId {
	return [[[UICTableViewCellSwitch alloc] initWithFrame:CGRectZero reuseIdentifier:reuseId] autorelease];
}

- (NSString*)cellIdentifier {
	static NSString *s = @"TBCSW";
	return s;
}

- (void)setValue:(BOOL)aValue {
	value = aValue;
	if (userDefaultsKey) {
		[[NSUserDefaults standardUserDefaults] setBool:value forKey:userDefaultsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (BOOL)value {
	return value;
}

@end
