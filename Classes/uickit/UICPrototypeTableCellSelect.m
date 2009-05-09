#import "UICPrototypeTableCellSelect.h"
#import "UICTableViewCellSelect.h"

@implementation UICPrototypeTableCellSelect

@synthesize titles;

- (id)initWithTitle:(NSString*)aTitle withSelectTitles:(NSArray*)Titles {
	if (self = [super initWithTitle:aTitle]) {
		titles = [Titles retain];
		selectedIndex = 0;
	}
	return self;
}

- (id)initWithTitle:(NSString*)aTitle withSelectTitles:(NSArray*)Titles withUserDefaultsKey:(NSString*)key {
	if (self = [self initWithTitle:aTitle withSelectTitles:Titles]) {
		userDefaultsKey = [key retain];
		selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:userDefaultsKey];
		if (selectedIndex > titles.count) {
			selectedIndex = 0;
			[[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:userDefaultsKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
	return self;
}

- (id)tableCellViewWithReuseId:(NSString*)reuseId {
	return [[[UICTableViewCellSelect alloc] initWithFrame:CGRectZero reuseIdentifier:reuseId] autorelease];
}

- (NSString*)cellIdentifier {
	static NSString *s = @"TBCSL";
	return s;
}

- (void)setSelectedIndex:(int)index {
	selectedIndex = index;
	if (userDefaultsKey) {
		[[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:userDefaultsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (int)selectedIndex {
	return selectedIndex;
}

- (void)dealloc {
	[titles release];
	[super dealloc];
}

@end
