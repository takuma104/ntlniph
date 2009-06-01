#import <UIKit/UIKit.h>
#import "UICPrototypeTableCell.h"

@interface UICPrototypeTableCellTextInput : UICPrototypeTableCell {
	NSString *value;
	NSString *placeholder;
	BOOL secure;
}

- (id)initWithTitle:(NSString*)title withUserDefaultsKey:(NSString*)key;

- (id)tableCellViewWithReuseId:(NSString*)reuseId;
- (NSString*)cellIdentifier;


- (void)setValue:(NSString*)aValue;
- (NSString*)value;

//@property (readwrite, retain) NSString *value;	
@property (readwrite, retain) NSString *placeholder;	
@property (readwrite) BOOL secure;

@end
