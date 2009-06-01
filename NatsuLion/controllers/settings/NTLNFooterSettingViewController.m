#import "NTLNFooterSettingViewController.h"
#import "NTLNConfigurationKeys.h"
#import "NTLNAccount.h"
#import "UICPrototypeTableCellTextInput.h"
#import "UICTableViewCellTextInput.h"

@interface NTLNFooterSettingViewController(Private)
- (void)resignFirstResponderForCell:(NSIndexPath*)indexPath;
- (void)becomeFirstResponderForCell:(NSIndexPath*)indexPath;
- (void)doneButtonPushed:(id)sender;

@end

@implementation NTLNFooterSettingViewController

- (void)setupPrototypes {
	if (groups != nil) return;
	
	UICPrototypeTableCellTextInput *c1 = [UICPrototypeTableCell cellForTextInput:@"Footer" 
																 withPlaceholder:@"optional" 
															 withUserDefaultsKey:NTLN_PREFERENCE_FOOTER];
	
	NSArray *g1 = [NSArray arrayWithObjects:c1, nil];	
	
	groups = [[NSArray arrayWithObjects:
			   [UICPrototypeTableGroup groupWithCells:g1 withTitle:nil], 
			   nil] retain];
}

- (void)setupNavButtons {
	
	UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] 
									initWithTitle:@"Done" 
									style:UIBarButtonItemStylePlain 
									target:self 
									action:@selector(doneButtonPushed:)] autorelease];
	[[self navigationItem] setRightBarButtonItem:doneButton];
}

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		[self.navigationItem setTitle:@"Footer"];
	}
	return self;
}

- (void)loadView {
	[self setupPrototypes];
	[self setupNavButtons];
	
	[super loadView];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
	[self becomeFirstResponderForCell:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self resignFirstResponderForCell:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)resignFirstResponderForCell:(NSIndexPath*)indexPath {
	UICTableViewCellTextInput *cell = (UICTableViewCellTextInput*)[self.tableView cellForRowAtIndexPath:indexPath];
	[cell.textField resignFirstResponder];
}

- (void)becomeFirstResponderForCell:(NSIndexPath*)indexPath {
	UICTableViewCellTextInput *cell = (UICTableViewCellTextInput*)[self.tableView cellForRowAtIndexPath:indexPath];
	[cell.textField becomeFirstResponder];
}

- (void)doneButtonPushed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[super dealloc];
}


@end
