#import <UIKit/UIKit.h>
#import "UICPrototypeTableCellSwitch.h"

@interface UICTableViewCellSwitch : UITableViewCell {
	UICPrototypeTableCellSwitch *prototype;
	UISwitch *sw;
}

- (void)updateWithPrototype:(UICPrototypeTableCellSwitch*)prototype;

@end
