#import "NTLNTweetPostViewController.h"
#import "NTLNAppDelegate.h"
#import "NTLNAccount.h"
#import "NTLNCache.h"
#import "NTLNConfiguration.h"
#import "NTLNTwitterPost.h"

@interface NTLNTweetPostViewController(Private)
- (IBAction)closeButtonPushed:(id)sender;
- (IBAction)sendButtonPushed:(id)sender;
- (IBAction)clearButtonPushed:(id)sender;

@end

static NTLNTweetPostViewController *_tweetViewController;

@implementation NTLNTweetPostViewController

+ (BOOL)active {
	return _tweetViewController ? YES : NO;
}

+ (void)dismiss {
	[_tweetViewController dismissModalViewControllerAnimated:NO];
	[_tweetViewController release];
	_tweetViewController = nil;
}

+ (void)present:(UIViewController*)parentViewController {
	[NTLNTweetPostViewController dismiss];
	NTLNTweetPostViewController *vc = [[[NTLNTweetPostViewController alloc] init] autorelease];
	[parentViewController presentModalViewController:vc animated:NO];
	_tweetViewController = [vc retain];
}

- (void)updateViewColors {
	UIColor *textColor, *backgroundColor, *backgroundColorBottom;
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		textColor = [UIColor whiteColor];
		if ([[NTLNTwitterPost shardInstance] isDirectMessage]) {
			backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.5f alpha:1.f];
		} else {
			backgroundColor = [UIColor colorWithWhite:61.f/255.f alpha:1.0f];
		}
		backgroundColorBottom = [UIColor colorWithWhite:24.f/255.f alpha:1.0f];
	} else {
		textColor = [UIColor blackColor];
		if ([[NTLNTwitterPost shardInstance] isDirectMessage]) {
			backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:1.f alpha:1.f];
		} else {
			backgroundColor = [UIColor colorWithWhite:252.f/255.f alpha:1.0f];
		}
		backgroundColorBottom = [UIColor colorWithWhite:200.f/255.f alpha:1.0f];
	}
	
	self.view.backgroundColor = backgroundColorBottom;//[UIColor blackColor];
	
	tweetPostView.textView.textColor = textColor;
	tweetPostView.textView.backgroundColor = backgroundColor;
	
	if ([[NTLNTwitterPost shardInstance] replyMessage]) {
		tweetPostView.backgroundColor = backgroundColorBottom;
	} else {
		tweetPostView.backgroundColor = backgroundColor;
	}
	
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		// to use black keyboard appearance
		tweetPostView.textView.keyboardAppearance = UIKeyboardAppearanceAlert;
	} else {
		// to use default keyboard appearance
		tweetPostView.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
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
	
	
	tweetPostView = [[NTLNTweetPostView alloc] initWithFrame:CGRectMake(0, 44, 320, 200)];
	tweetPostView.textViewDelegate = self;
		
	[self.view addSubview:toolbar];
	[self.view addSubview:tweetPostView];
	[self updateViewColors];
}

- (void)setMaxTextLength {
	maxTextLength = 140;
	NSString *footer = [[NTLNAccount sharedInstance] footer];
	if (footer && [footer length] > 0 && 
		! [[NTLNTwitterPost shardInstance] isDirectMessage]) {
		maxTextLength -= [footer length] + 1;
	}
}

- (void)updateTextLengthView {
	[self setMaxTextLength];
	int len = [tweetPostView.textView.text length];
	[textLengthView setText:[NSString stringWithFormat:@"%d", (maxTextLength-len)]];
	if (len >= maxTextLength) {
		textLengthView.textColor = [UIColor redColor];
	} else {
		textLengthView.textColor = [UIColor whiteColor];
	}	
}

- (void)viewDidLoad {
	[self setMaxTextLength];
	[self setupViews];
	[self updateTextLengthView];
	[super viewDidLoad];
}

- (void)dealloc {
	LOG(@"NTLNTweetPostViewController dealloc");
	[tweetPostView release];
	[textLengthView release];
	[super dealloc];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	return YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[self updateViewColors];
	tweetPostView.textView.text = [[NTLNTwitterPost shardInstance] text];
	[tweetPostView.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[tweetPostView.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
	[[NTLNTwitterPost shardInstance] updateText:tweetPostView.textView.text];
	[self updateTextLengthView];
	[self updateViewColors];
	[tweetPostView updateQuoteView];
}

- (IBAction)closeButtonPushed:(id)sender {
	[tweetPostView.textView resignFirstResponder];
	[NTLNTweetPostViewController dismiss];
}

- (IBAction)clearButtonPushed:(id)sender {
	tweetPostView.textView.text = @""; // this will invoke textViewDidChange
}

- (IBAction)sendButtonPushed:(id)sender {
	[[NTLNTwitterPost shardInstance] updateText:tweetPostView.textView.text];
	[[NTLNTwitterPost shardInstance] post];
	
	[tweetPostView.textView resignFirstResponder];
	[NTLNTweetPostViewController dismiss];
}

@end
