#import "NTLNFetchCountConfigViewController.h"
#import "NTLNConfiguration.h"

static int count_from_index(int index)
{
	const int m[] = {20,50,100,200};
	return m[index];
}

static int index_from_count(int count)
{
	const int m[] = {20,50,100,200};
	for (int i = 0; i < 4; i++)
	{
		if (m[i] == count) return i;
	}
	return 0;
}

@implementation NTLNFetchCountConfigViewController

- (void)viewDidLoad {
	selectedIndex = index_from_count([[NTLNConfiguration instance] fetchCount]);
}

- (void)dealloc {
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Choose fetching count";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	switch (indexPath.row)
	{
		case 0:
			cell.text = @"20 posts";
			break;
		case 1:
			cell.text = @"50 posts";
			break;
		case 2:
			cell.text = @"100 posts";
			break;
		case 3:
			cell.text = @"200 posts";
			break;
	}
	
	if (indexPath.row == selectedIndex) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSIndexPath *tableSelection = [tableView indexPathForSelectedRow];
	[tableView deselectRowAtIndexPath:tableSelection animated:YES];
	
	selectedIndex = [indexPath row];
	[tableView reloadData];
	[[NTLNConfiguration instance] setFetchCount:count_from_index(selectedIndex)];
}

@end

