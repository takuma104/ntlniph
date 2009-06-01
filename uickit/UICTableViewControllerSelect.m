#import "UICTableViewControllerSelect.h"

@implementation UICTableViewControllerSelect

@synthesize prototype;

- (void)dealloc {
	[prototype release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationItem setTitle:prototype.title];
	[self.tableView reloadData];
}

- (void)setCellCheckmarkAndColor:(UITableViewCell*)cell {
	if (prototype.selectedIndex == cell.tag) {
		cell.textColor = [UIColor colorWithRed:(0x32/255.0) green:(0x4f/255.0) blue:(0x85/255.0) alpha:1.0];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.textColor = [UIColor blackColor];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	cell.tag = [indexPath row];
	[self setCellCheckmarkAndColor:cell];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	NSIndexPath *tableSelection = [tableView indexPathForSelectedRow];
	[tableView deselectRowAtIndexPath:tableSelection animated:YES];
	
	prototype.selectedIndex = [indexPath row];
	
	// reflesh checkmark
	for (UITableViewCell *cell in tableView.visibleCells) {
		[self setCellCheckmarkAndColor:cell];
	}	
}


@end
