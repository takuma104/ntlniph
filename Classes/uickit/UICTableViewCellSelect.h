#import <UIKit/UIKit.h>
#import "UICPrototypeTableCellSelect.h"

@interface UICTableViewCellSelect : UITableViewCell {
	UICPrototypeTableCellSelect *prototype;
	UILabel *label;
}

- (void)updateWithPrototype:(UICPrototypeTableCellSelect*)prototype;

@end
