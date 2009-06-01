#import "NTLNTwitterAccountViewController.h"
#import "NTLNConfigurationKeys.h"
#import "NTLNAccount.h"
#import "UICTableViewCellTextInput.h"

@interface NTLNTwitterAccountViewController(Private)
- (void)setupPrototypes;
- (void)setupNavButtons;
- (void)resignFirstResponderForCell:(NSIndexPath*)indexPath;
- (void)becomeFirstResponderForCell:(NSIndexPath*)indexPath;
- (void)doneButtonPushed:(id)sender;
- (void)cancelButtonPushed:(id)sender;

@end

@implementation NTLNTwitterAccountViewController

- (void)setupPrototypes {
	if (groups != nil) return;
	
	UICPrototypeTableCellTextInput *c1 = [UICPrototypeTableCell cellForTextInput:@"Username" 
																 withPlaceholder:@"required" 
															 withUserDefaultsKey:NTLN_PREFERENCE_USERID];
	
	UICPrototypeTableCellTextInput *c2 = [UICPrototypeTableCell cellForTextInput:@"Passowrd" 
																 withPlaceholder:@"required" 
															 withUserDefaultsKey:NTLN_PREFERENCE_PASSWORD];
	c2.secure = YES;
	
	NSArray *g1 = [NSArray arrayWithObjects:c1, c2, nil];	
	
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
/*
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithTitle:@"Cancel" 
									  style:UIBarButtonItemStylePlain 
									  target:self 
									  action:@selector(cancelButtonPushed:)] autorelease];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
*/	
}

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		[self.navigationItem setTitle:@"Twitter Account"];
	}
	return self;
}


- (void)loadView {
	[self setupPrototypes];
	[self setupNavButtons];

	[super loadView];
}

- (void)viewWillAppear:(BOOL)animated {
	usernameOriginal = [[[NTLNAccount sharedInstance] screenName] retain];
	[self.tableView reloadData];
	[self becomeFirstResponderForCell:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self resignFirstResponderForCell:[NSIndexPath indexPathForRow:0 inSection:0]];
	[self resignFirstResponderForCell:[NSIndexPath indexPathForRow:1 inSection:0]];
	
	[[NTLNAccount sharedInstance] update];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
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
//	self.tabBarController.selectedIndex = 0; //hmmm...
}

- (void)cancelButtonPushed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[usernameOriginal release];
	[super dealloc];
}

@end
