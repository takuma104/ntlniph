#import "UICTableViewController.h"
#import "UICTableViewCellSwitch.h"
#import "UICTableViewCellTextInput.h"
#import "UICPrototypeTableCellSelect.h"
#import "UICPrototypeTableGroup.h"
#import "UICTableViewControllerSelect.h"

@implementation UICTableViewController

@synthesize groups;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		LOG(@"UICTableViewController initWithStyle");
	}
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [groups count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	UICPrototypeTableGroup *g = (UICPrototypeTableGroup *)[groups objectAtIndex:section];
	return g.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	UICPrototypeTableGroup *g = (UICPrototypeTableGroup *)[groups objectAtIndex:section];
	return [g.cells count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UICPrototypeTableGroup *g = (UICPrototypeTableGroup *)[groups objectAtIndex:[indexPath section]];
	id prototype = (UICPrototypeTableCell*)[g.cells objectAtIndex:[indexPath row]];

	NSString *cellId = [prototype cellIdentifier];
    id cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
		cell = [prototype tableCellViewWithReuseId:cellId];
	}

	if (! [[cell class] isEqual:[UITableViewCell class]]) {
		[cell updateWithPrototype:prototype];
	}
	
	[cell setText:[prototype title]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UICPrototypeTableGroup *g = (UICPrototypeTableGroup *)[groups objectAtIndex:[indexPath section]];
	id prototype = (UICPrototypeTableCell*)[g.cells objectAtIndex:[indexPath row]];

	if ([[prototype class] isEqual:[UICPrototypeTableCellSelect class]]) {
		UICPrototypeTableCellSelect *p = prototype;
		NSArray *g = [NSArray arrayWithObject:[UICPrototypeTableGroup groupWithCells:
											   [UICPrototypeTableCell cellsForTitles:p.titles] withTitle:nil]];
		UICTableViewControllerSelect *tc = [[[UICTableViewControllerSelect alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
		tc.groups = g;
		tc.prototype = prototype;
		[self.navigationController pushViewController:tc animated:YES];
	}
	
	// disselect
	NSIndexPath *tableSelection = [tableView indexPathForSelectedRow];
	[tableView deselectRowAtIndexPath:tableSelection animated:YES];
}


- (void)dealloc {
	LOG(@"UICTableViewController dealloc");
	[groups release];
    [super dealloc];
}

@end

