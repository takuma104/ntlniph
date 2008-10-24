#import "NTLNRefleshIntervalConfigViewController.h"
#import "NTLNConfiguration.h"

static int seconds_from_index(int index)
{
	if (index == 0) return 0;

	const int m[] = {1,2,3,5,10};
	if (index > 5) return 60;
	return m[index-1] * 60;
}

static int index_from_second(int second)
{
	if (second == 0) return 0;
	
	const int m[] = {1,2,3,5,10};
	for (int i = 0; i < 5; i++)
	{
		if (m[i] * 60 >= second) return i + 1;
	}
	return 0;
}

@implementation NTLNRefleshIntervalConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

- (void)viewDidLoad {
	selectedIndex = index_from_second([[NTLNConfiguration instance] refreshIntervalSeconds]);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
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
	return @"Choose Refresh Interval";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 6;
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
			cell.text = @"Auto refresh disabled";
			break;
		case 1:
			cell.text = @"1 Minute";
			break;
		case 2:
			cell.text = @"2 Minutes";
			break;
		case 3:
			cell.text = @"3 Minutes";
			break;
		case 4:
			cell.text = @"5 Minutes";
			break;
		case 5:
			cell.text = @"10 Minutes";
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
	[[NTLNConfiguration instance] setRefleshIntervalSeconds:seconds_from_index(selectedIndex)];
}

@end
