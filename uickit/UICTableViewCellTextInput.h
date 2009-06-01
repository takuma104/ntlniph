#import <UIKit/UIKit.h>
#import "UICPrototypeTableCellTextInput.h"

@interface UICTableViewCellTextInput : UITableViewCell<UITextFieldDelegate> {
	UICPrototypeTableCellTextInput *prototype;
	UITextField *textField;
}

- (void)updateWithPrototype:(UICPrototypeTableCellTextInput*)prototype;

@property (readonly) UITextField *textField;

@end
