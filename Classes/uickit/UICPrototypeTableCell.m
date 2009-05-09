#import "UICPrototypeTableCell.h"
#import "UICPrototypeTableCellSwitch.h"
#import "UICPrototypeTableCellTextInput.h"
#import "UICPrototypeTableCellSelect.h"

@implementation UICPrototypeTableCell

@synthesize title;

- (id)initWithTitle:(NSString*)aTitle {
	if (self = [super init]) {
		title = [aTitle retain];
		LOG(@"UICPrototypeCell initWithTitle");
	}
	return self;
}

+ (id)cellForTitle:(NSString*)aTitle {
	return [[[UICPrototypeTableCell alloc] initWithTitle:aTitle] autorelease];
}

+ (id)cellForSwitch:(NSString*)aTitle withSwitch:(BOOL)val {
	return [[[UICPrototypeTableCellSwitch alloc] 
					initWithTitle:aTitle withSwitch:val] autorelease];
}

+ (id)cellForSwitch:(NSString*)aTitle withUserDefaultsKey:(NSString*)key{
	return [[[UICPrototypeTableCellSwitch alloc] 
			 initWithTitle:aTitle withUserDefaultsKey:key] autorelease];
}

+ (id)cellForTextInput:(NSString*)aTitle withPlaceholder:(NSString*)placeholder {
	UICPrototypeTableCellTextInput *p = [[[UICPrototypeTableCellTextInput alloc] initWithTitle:aTitle] 
											autorelease];
	p.placeholder = placeholder;
	return p;
}

+ (id)cellForTextInput:(NSString*)aTitle 
	   withPlaceholder:(NSString*)placeholder 
   withUserDefaultsKey:(NSString*)key {
	UICPrototypeTableCellTextInput *p = [[[UICPrototypeTableCellTextInput alloc] 
												initWithTitle:aTitle 
										  withUserDefaultsKey:key] autorelease];
	p.placeholder = placeholder;
	return p;
}

+ (id)cellForSelect:(NSString*)aTitle withSelectTitles:(NSArray*)titles {
	return [[[UICPrototypeTableCellSelect alloc] initWithTitle:aTitle 
											  withSelectTitles:titles] autorelease];
}

+ (id)cellForSelect:(NSString*)aTitle withSelectTitles:(NSArray*)titles 
									withUserDefaultsKey:(NSString*)key {
	return [[[UICPrototypeTableCellSelect alloc] initWithTitle:aTitle 
											  withSelectTitles:titles
										   withUserDefaultsKey:key] autorelease];
}

+ (id)cellsForTitles:(NSArray*)titles {
	NSMutableArray *a = [NSMutableArray arrayWithCapacity:10];
	for (NSString *t in titles) {
		[a addObject:[UICPrototypeTableCell cellForTitle:t]];
	}
	return a;
}

- (id)tableCellViewWithReuseId:(NSString*)reuseId {
	return [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseId] autorelease];
}

- (NSString*)cellIdentifier {
	static NSString *s = @"TBC";
	return s;
}

- (void)dealloc {
	LOG(@"UICPrototypeCell dealloc");
	[title release];
	[userDefaultsKey release];
	[super dealloc];
}

@end
