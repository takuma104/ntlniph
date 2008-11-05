#import "NTLNConfigViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "NTLNFriendsViewController.h"
#import "NTLNColors.h"
#import "NTLNAccelerometerSensor.h"

@implementation NTLNConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		[self.navigationItem setTitle:@"Settings"];
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
	NSLog(@"NTLNConfigViewController#didReceiveMemoryWarning");
}

- (void)dealloc {
	[usernameField release];
	[passwordField release];
	[usePostSwitch release];
	[useSafariSwitch release];
	[darkColorThemeSwitch release];
	[scrollLockSwitch release];
	[showMoreTweetsModeSwitch release];
	[shakeToFullscreenSwitch release];
	[super dealloc];
}

- (void)loadView {
	[super loadView];

	UIBarButtonItem *item = [[[UIBarButtonItem alloc] 
							 initWithTitle:@"Done" 
							 style:UIBarButtonItemStylePlain 
							 target:self 
							 action:@selector(doneButton:)] autorelease];
	
	[[self navigationItem] setRightBarButtonItem:item];

	usernameField = [[NTLNConfigViewController textInputFieldForCellWithValue:
						[[NTLNAccount instance] username]  secure:NO] retain];
	usernameField.delegate = self;
	passwordField = [[NTLNConfigViewController textInputFieldForCellWithValue:
					 [[NTLNAccount instance] password]  secure:YES] retain];
	passwordField.delegate = self;
	
	usePostSwitch = [[NTLNConfigViewController switchForCell] retain];
	useSafariSwitch = [[NTLNConfigViewController switchForCell] retain];
	darkColorThemeSwitch = [[NTLNConfigViewController switchForCell] retain];
	scrollLockSwitch = [[NTLNConfigViewController switchForCell] retain];
	showMoreTweetsModeSwitch = [[NTLNConfigViewController switchForCell] retain];
	shakeToFullscreenSwitch = [[NTLNConfigViewController switchForCell] retain];
	
	if (usernameField.text.length == 0 && passwordField.text.length == 0) {
		[usernameField becomeFirstResponder];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	UITableView *tableView = (UITableView*)self.view;
	NSIndexPath *tableSelection = [tableView indexPathForSelectedRow];
	[tableView deselectRowAtIndexPath:tableSelection animated:NO];
	
	usePostSwitch.on = [[NTLNConfiguration instance] usePost];
	useSafariSwitch.on = [[NTLNConfiguration instance] useSafari];
	darkColorThemeSwitch.on = [[NTLNConfiguration instance] darkColorTheme];
	scrollLockSwitch.on = [[NTLNConfiguration instance] scrollLock];
	showMoreTweetsModeSwitch.on = [[NTLNConfiguration instance] showMoreTweetMode];
	shakeToFullscreenSwitch.on = [[NTLNConfiguration instance] shakeToFullscreen];
	[tableView reloadData];
}

#pragma mark - UITableView delegates

// if you want the entire table to just be re-orderable then just return UITableViewCellEditingStyleNone
//
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:
			return @"Twitter Account";
		case 1:
			return @"Settings";
		case 2:
			return @"Advanced Settings";
		case 3:
			return @"About";
	}
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:
			return 2;
		case 1:
			return 4;
		case 2:
			return 4;
		case 3:
			return 1;
	}
	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section)
	{
		case 0:
			switch (indexPath.row)
			{
				case 0:
					return [self containerCellWithTitle:@"Username" view:usernameField];
				case 1:
					return [self containerCellWithTitle:@"Password" view:passwordField];
			}
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					{
						NSString *title = nil; 
						int intervalSec = [[NTLNConfiguration instance] refreshIntervalSeconds];
						if (intervalSec == 0) {
							title = @"Auto refresh disabled";
						} else {
							title = [NSString stringWithFormat:@"Refresh Interval: %dmin", intervalSec / 60];
						}
						return [self textCellWithTitle:title];
					}
				case 1:
					return [self containerCellWithTitle:@"Use Safari" view:useSafariSwitch];
				case 2:
					return [self containerCellWithTitle:@"Dark color theme" view:darkColorThemeSwitch];
				case 3:
					return [self containerCellWithTitle:@"Shake to fullsceen" view:shakeToFullscreenSwitch];
			}
			break;
		case 2:
			switch (indexPath.row) {
				case 0:
					{
						int fetchCount = [[NTLNConfiguration instance] fetchCount];
						return [self textCellWithTitle:
									[NSString stringWithFormat:@"Fetching count: %d posts", fetchCount]];
					}
				case 1:
					return [self containerCellWithTitle:@"Autopagerize" view:showMoreTweetsModeSwitch];
				case 2:
					return [self containerCellWithTitle:@"No auto scroll" view:scrollLockSwitch];
				case 3:
					return [self containerCellWithTitle:@"Use POST Method" view:usePostSwitch];
			}
			break;
		case 3:
			return [self textCellWithTitle:@"About NatsuLion for iPhone"];
	}

	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 && indexPath.row == 0) {
		[[self navigationController] pushViewController:refleshIntervalConfigViewController animated:YES];
	} else if  (indexPath.section == 2 && indexPath.row == 0) {
		[[self navigationController] pushViewController:fetchCountConfigViewController animated:YES];
	} else if  (indexPath.section == 3 && indexPath.row == 0) {
		[[self navigationController] pushViewController:aboutViewController animated:YES];
	}
}

- (void)doneButton:(id)sender {
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	self.tabBarController.selectedIndex = 0;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSString *t = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if (textField == usernameField) {
		[[NTLNAccount instance] setUsername:t];
		usernameEdited = YES;
	} else if (textField == passwordField) {
		[[NTLNAccount instance] setPassword:t];
	}
	
	[friendsViewController removeLastReloadTime];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	
	if (usernameField) {
		[[NTLNAccount instance] getUserId];
	}
	
	[[NTLNConfiguration instance] setUsePost:usePostSwitch.on];
	[[NTLNConfiguration instance] setUseSafari:useSafariSwitch.on];
	[[NTLNConfiguration	instance] setDarkColorTheme:darkColorThemeSwitch.on];
	[[NTLNConfiguration instance] setScrollLock:scrollLockSwitch.on];
	[[NTLNConfiguration	instance] setShowMoreTweetMode:showMoreTweetsModeSwitch.on];
	[[NTLNConfiguration	instance] setShakeToFullscreen:shakeToFullscreenSwitch.on];

	[[NTLNColors instance] setupColors];
	[[NTLNAccelerometerSensor sharedInstance] updateByConfiguration];
}

+ (UITextField*)textInputFieldForCellWithValue:(NSString*)value secure:(BOOL)secure {
	UITextField *textField = [[[UITextField alloc] 
									initWithFrame:CGRectMake(110, 12, 160, 24)] autorelease];
	
	textField.text = value;
	textField.placeholder = @"Required";
	textField.secureTextEntry = secure;
	textField.keyboardType = UIKeyboardTypeASCIICapable;
	textField.returnKeyType = UIReturnKeyDone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	return textField;
}

- (UITableViewCell*)containerCellWithTitle:(NSString*)title view:(UIView*)view {
	NSString *MyIdentifier = title;
	NTLNContainerCell *cell = (NTLNContainerCell*)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[NTLNContainerCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.text = title;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell attachContainer:view];
	return cell;
}

- (UITableViewCell*)textCellWithTitle:(NSString*)title {
	NSString *MyIdentifier = title;
	NTLNContainerCell *cell = (NTLNContainerCell*)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[NTLNContainerCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.text = title;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

+ (UISwitch*)switchForCell {
	return [[[UISwitch alloc] initWithFrame:CGRectMake(190, 9, 0, 0)] autorelease];
}

@end

@implementation NTLNContainerCell

- (void)attachContainer:(UIView*)view {
	[container removeFromSuperview];
	[container release];
	container = [view retain];
	[self addSubview:view];
}

@end

