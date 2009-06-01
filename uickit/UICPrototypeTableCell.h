#import <UIKit/UIKit.h>

@interface UICPrototypeTableCell : NSObject {
	NSString *title;
	NSString *userDefaultsKey;
}

+ (id)cellForTitle:(NSString*)title;
+ (id)cellForSwitch:(NSString*)title withSwitch:(BOOL)val;
+ (id)cellForSwitch:(NSString*)title withUserDefaultsKey:(NSString*)key;
+ (id)cellForTextInput:(NSString*)title withPlaceholder:(NSString*)placeholder;
+ (id)cellForTextInput:(NSString*)title withPlaceholder:(NSString*)placeholder withUserDefaultsKey:(NSString*)key;
+ (id)cellForSelect:(NSString*)title withSelectTitles:(NSArray*)titles;
+ (id)cellForSelect:(NSString*)title withSelectTitles:(NSArray*)titles withUserDefaultsKey:(NSString*)key;
+ (id)cellsForTitles:(NSArray*)titles;

- (id)initWithTitle:(NSString*)aText;

- (id)tableCellViewWithReuseId:(NSString*)reuseId;
- (NSString*)cellIdentifier;

@property (readonly) NSString *title;
//@property (readwrite, retain) NSString *userDefaultsKey;

@end
