#import <UIKit/UIKit.h>
#import "UICPrototypeTableCell.h"
#import "UICPrototypeTableGroup.h"

@interface UICTableViewController : UITableViewController {
	NSArray *groups;
}

@property (readwrite, retain) NSArray *groups;

@end
