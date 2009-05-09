#import "NTLNTweetPostViewController.h"
#import "ntlniphAppDelegate.h"
#import "NTLNAccount.h"
#import "NTLNCache.h"
#import "NTLNConfiguration.h"

@implementation NTLNTweetPostViewController

@synthesize active;

- (void)setViewColors {
	UIColor *textColor, *backgroundColor;
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		textColor = [UIColor whiteColor];
		backgroundColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
	} else {
		textColor = [UIColor blackColor];
		backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
	}
	
	self.view.backgroundColor = backgroundColor;
	tweetTextView.textColor = textColor;
	tweetTextView.backgroundColor = backgroundColor;
	
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		// to use black keyboard appearance
		tweetTextView.keyboardAppearance = UIKeyboardAppearanceAlert;
	} else {
		// to use default keyboard appearance
		tweetTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
	}
}

- (void)setupViews {

	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	
	UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
	toolbar.barStyle = UIBarStyleBlackOpaque;

	UIBarButtonItem *closeButton = [[[UIBarButtonItem alloc] 
									initWithTitle:@"close" 
									style:UIBarButtonItemStyleBordered 
									target:self action:@selector(closeButtonPushed:)] autorelease];
	
	UIBarButtonItem *clearButton = [[[UIBarButtonItem alloc] 
									initWithTitle:@"clear" 
									style:UIBarButtonItemStyleBordered 
									target:self action:@selector(clearButtonPushed:)] autorelease];
	
	UIView *expandView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 133, 44)] autorelease];

	textLengthView = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 133-80, 34)];
	textLengthView.font = [UIFont boldSystemFontOfSize:20];
	textLengthView.textAlignment = UITextAlignmentRight;
	textLengthView.textColor = [UIColor whiteColor];
	textLengthView.backgroundColor = [UIColor clearColor];
	textLengthView.text = @"140";
	
	[expandView addSubview:textLengthView];
	
	UIBarButtonItem	*expand = [[[UIBarButtonItem alloc] initWithCustomView:expandView] autorelease];
	
	UIBarButtonItem *sendButton = [[[UIBarButtonItem alloc] 
									initWithTitle:@"post" 
									style:UIBarButtonItemStyleBordered 
									target:self action:@selector(sendButtonPushed:)] autorelease];
	
	[toolbar setItems:[NSArray arrayWithObjects:closeButton, clearButton, expand, sendButton, nil]];
	
	tweetTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, 320, 200)];
	tweetTextView.font = [UIFont systemFontOfSize:16];
	tweetTextView.delegate = self;
		
	[self.view addSubview:toolbar];
	[self.view addSubview:tweetTextView];
	[self setViewColors];
}

- (void)viewDidLoad {
	[self setupViews];
	
	backupFilename = [[[NTLNCache createTextCacheDirectory] 
						stringByAppendingString:@"postbackup.txt"] retain];
	
	NSData *d = [NTLNCache loadWithFilename:backupFilename];
	if (d) {
		tweetTextView.text = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)setSuperView:(UIView*)view {
	superView = view;
}

- (void)dealloc {
	[tweetTextView release];
	[textLengthView release];
	[reply_id release];
	
	[backupFilename release];
	[tmpTextForInitial release];
	[super dealloc];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	return YES;
}

- (void)savePost {
	[NTLNCache saveWithFilename:backupFilename 
						   data:[tweetTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)twitterClientSucceeded:(NTLNTwitterClient*)sender messages:(NSArray*)statuses {	
	[tweetTextView setText:@""];
	[self savePost];
}

- (void)twitterClientFailed:(NTLNTwitterClient*)sender {
}

- (void)twitterClientBegin:(NTLNTwitterClient*)sender {
	NSLog(@"TweetPostView#twitterClientBegin");
}

- (void)twitterClientEnd:(NTLNTwitterClient*)sender {
	NSLog(@"TweetPostView#twitterClientEnd");
}

- (void)createReplyPost:(NSString*)text reply_id:(NSString*)aReply_id {
	NSString *tt = [text stringByAppendingString:@" "];
	NSString *t = [tweetTextView text];
	if (t == nil) {
		t = tmpTextForInitial;
	}
	if (t && [t length] > 0) {
		t = [t stringByAppendingString:tt];
	} else {
		t = tt;
	}

	if (tweetTextView == nil) {
		tmpTextForInitial = [t retain];
	} else {
		[tweetTextView setText:t];
	}
	
	[reply_id release];
	reply_id = [aReply_id retain];
}

- (void)createDMPost:(NSString*)reply_to {
	NSString *t = [NSString stringWithFormat:@"d %@ ", reply_to];
	if (tweetTextView == nil) {
		tmpTextForInitial = [t retain];
	} else {
		[tweetTextView setText:t];
	}
}

- (void)showWindow {
	active = YES;
	[superView addSubview:self.view];
	[self setViewColors];
	if (tmpTextForInitial) {
		[tweetTextView setText:tmpTextForInitial];
		[tmpTextForInitial release];
		tmpTextForInitial = nil;
	}
	[tweetTextView becomeFirstResponder];
}

- (void)closeWindow {
	[self closeButtonPushed:self];
}

- (void)textViewDidChange:(UITextView *)textView {
	int len = [textView.text length];
	[textLengthView setText:[NSString stringWithFormat:@"%d", (140-len)]];
	if (len >= 140) {
		textLengthView.textColor = [UIColor redColor];
	} else {
		textLengthView.textColor = [UIColor whiteColor];
	}
	
	[self savePost];
}

- (IBAction)closeButtonPushed:(id)sender {
	[tweetTextView resignFirstResponder];
	[self.view removeFromSuperview];
	active = NO;
}

- (IBAction)clearButtonPushed:(id)sender {
	[tweetTextView setText:@""];
	[reply_id release];
	reply_id = nil;
	[self savePost];
}

- (IBAction)sendButtonPushed:(id)sender {
	NTLNTwitterClient *tc = [[NTLNTwitterClient alloc] initWithDelegate:self];
	[tc post:tweetTextView.text reply_id:reply_id];
	
	[tweetTextView resignFirstResponder];
	[self.view removeFromSuperview];
	active = NO;
}

@end
