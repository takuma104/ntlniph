#import <UIKit/UIKit.h>
#import "UICPrototypeTableCell.h"

@interface UICPrototypeTableCellSwitch : UICPrototypeTableCell {
	BOOL value;
}

- (id)initWithTitle:(NSString*)title withSwitch:(BOOL)val;
- (id)initWithTitle:(NSString*)title withUserDefaultsKey:(NSString*)key;

- (id)tableCellViewWithReuseId:(NSString*)reuseId;
- (NSString*)cellIdentifier;

- (void)setValue:(BOOL)value;
- (BOOL)value;

@end
