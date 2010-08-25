#import "NTLNTwitterAccountViewController.h"
#import "NTLNConfigurationKeys.h"
#import "NTLNAccount.h"
#import "UICTableViewCellTextInput.h"
#import "XAuthAccessTokenClient.h"
#import "NTLNAlert.h"

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
															 withUserDefaultsKey:nil];
	c2.secure = YES;
	
	NSArray *g1 = [NSArray arrayWithObjects:c1, c2, nil];	
	
	groups = [[NSArray arrayWithObjects:
			   [UICPrototypeTableGroup groupWithCells:g1 withTitle:nil], 
			   nil] retain];
}

- (void)setupNavButtons {
	UIBarButtonItem *doneButton;
	doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																target:self
																action:@selector(doneButtonPushed:)] autorelease];
	[[self navigationItem] setRightBarButtonItem:doneButton];

	UIBarButtonItem *cancelButton;
	cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																  target:self
																  action:@selector(cancelButtonPushed:)] autorelease];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
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
	usernameOriginal = [[[NTLNAccount instance] username] retain];
	[self.tableView reloadData];
	[self becomeFirstResponderForCell:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self resignFirstResponderForCell:[NSIndexPath indexPathForRow:0 inSection:0]];
	[self resignFirstResponderForCell:[NSIndexPath indexPathForRow:1 inSection:0]];
	
	if (! [[[NTLNAccount instance] username] isEqualToString:usernameOriginal]) {
		[[NTLNAccount instance] getUserId];
	}
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

- (NSString*)textForCell:(NSIndexPath*)indexPath {
	UICTableViewCellTextInput *cell = (UICTableViewCellTextInput*)[self.tableView cellForRowAtIndexPath:indexPath];
	return cell.textField.text;
}

- (void)doneButtonPushed:(UIBarButtonItem*)sender {
	if (_client == nil) {
		sender.enabled = NO;
	//	[self dismissModalViewControllerAnimated:YES];
	//	self.tabBarController.selectedIndex = 0; //hmmm...
		
		NSString *screenName = [self textForCell:[NSIndexPath indexPathForRow:0 inSection:0]];
		NSString *password = [self textForCell:[NSIndexPath indexPathForRow:1 inSection:0]];

		_client = [[XAuthAccessTokenClient alloc] init];
		_client.delegate = self;
		[_client requestTokenWithScreenName:screenName
								   password:password];
		
	}
}

- (void)cancelButtonPushed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[usernameOriginal release];
	[super dealloc];
}

- (void)XAuthAccessTokenClient:(XAuthAccessTokenClient*)client 
		   didSuccessWithToken:(TwitterToken*)token {
	[token saveWithName:@"NatsuLion"];
	[[NTLNAccount instance] setUsername:token.screenName];
	[self dismissModalViewControllerAnimated:YES];
	
	[_client autorelease];
	_client = nil;
}

- (void)XAuthAccessTokenClient:(XAuthAccessTokenClient*)client 
			  didFailWithError:(NSError*)error {
	[[NTLNAlert instance] alert:@"Authorization Failed" 
					withMessage:@"Wrong Username/Email and password combination."];
	[_client autorelease];
	_client = nil;
}

@end
