#import "UICPrototypeTableCellTextInput.h"
#import "UICTableViewCellTextInput.h"

@implementation UICPrototypeTableCellTextInput

@synthesize placeholder, secure;

- (id)initWithTitle:(NSString*)aTitle withUserDefaultsKey:(NSString*)key {
	if (self = [super initWithTitle:aTitle]) {
		userDefaultsKey = [key retain];
		value = [[[NSUserDefaults standardUserDefaults] stringForKey:userDefaultsKey] retain];
	}
	return self;
}

- (id)tableCellViewWithReuseId:(NSString*)reuseId {
	return [[[UICTableViewCellTextInput alloc] initWithFrame:CGRectZero reuseIdentifier:reuseId] autorelease];
}

- (NSString*)cellIdentifier {
	static NSString *s = @"TBCTI";
	return s;
}

- (void)setValue:(NSString*)aValue {
	[value release];
	value = [aValue retain];
	if (userDefaultsKey) {
		[[NSUserDefaults standardUserDefaults] setObject:value forKey:userDefaultsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (NSString*)value {
	return value;
}

- (void)dealloc {
	[value release];
	[placeholder release];
	[super dealloc];
}

@end
