#import "NTLNAboutViewController.h"
#import	"version.h"

#define CREDIT_TEXT @"© 2008, 2009 natsulion.org all rights reserved.\n\nProgramming by @takuma104\nBased on NatsuLion for Mac OSX by @akr\nIcon design by YUKI, @epytwen\nMany thanks to beta tester users and the twitter community."

@implementation NTLNAboutViewController


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
	}
	return self;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:
			return @"About";
		case 1:
			return @"Credits";
	}
	
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					return 70;
			}
			break;
		case 1:
			return 140;
	}
	
	return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:	return 3;
		case 1: return 1;
	}
	return 0;
}

+ (UIView*)creditTextView {
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 260, 120)] autorelease];
	label.font = [UIFont boldSystemFontOfSize:12];
	label.textColor = [UIColor blackColor];
	label.lineBreakMode = UILineBreakModeWordWrap;
	label.numberOfLines = 0;
	label.backgroundColor = [UIColor whiteColor];
	label.text = CREDIT_TEXT;
//	label.shadowColor = [[NTLNColors instance] textShadow];
//	label.shadowOffset = CGSizeMake(0, 1);
	return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					cell.image = [UIImage imageNamed:@"icon.png"];
					cell.text = @"NatsuLion for iPhone";
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
				case 1:
					cell.text = [NSString stringWithFormat:@"Version 1.07 (%@)", ntlniph_version];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					break;
				case 2:
					cell.text = @"http://iphone.natsulion.org/";
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
			}
			break;
		case 1:
			[cell addSubview:[NTLNAboutViewController creditTextView]];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
	}
	
	// Configure the cell
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 2) {
		NSURL *myURL = [NSURL URLWithString:@"http://iphone.natsulion.org/"];
		[[UIApplication sharedApplication] openURL:myURL];
	}
}

- (void)dealloc {
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

