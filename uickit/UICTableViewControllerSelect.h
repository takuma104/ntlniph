#import <UIKit/UIKit.h>
#import "UICTableViewController.h"
#import "UICPrototypeTableCellSelect.h"

@interface UICTableViewControllerSelect : UICTableViewController {
	UICPrototypeTableCellSelect *prototype;
}

@property (readwrite, retain) UICPrototypeTableCellSelect *prototype; 

@end
