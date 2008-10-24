#import "NTLNTweetPostViewController.h"
#import "ntlniphAppDelegate.h"
#import "NTLNAccount.h"
#import "NTLNCache.h"

@implementation NTLNTweetPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
 */
- (void)viewDidLoad {
	
	self.view.frame = CGRectMake(0, 0, 320, 480);
	
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

- (void)dealloc {
	[backupFilename release];
	[super dealloc];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	return YES;
}

- (void)savePost {
	[NTLNCache saveWithFilename:backupFilename 
						   data:[tweetTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
}

- (IBAction)cancelButtonPushed:(id)sender {
	[tweetTextView resignFirstResponder];
	self.view.hidden = YES;
	[self.view removeFromSuperview];
//	[appDelegate switchToTimelineView];
}

- (IBAction)sendButtonPushed:(id)sender {
	NTLNTwitterClient *tc = [[NTLNTwitterClient alloc] initWithDelegate:self];
	[tc post:tweetTextView.text];
	[tweetTextView resignFirstResponder];
	self.view.hidden = YES;
	[self.view removeFromSuperview];
//	[appDelegate switchToTimelineView];
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

- (void) createReplyPost:(NSString*)text {
	NSString *tt = [text stringByAppendingString:@" "];
	NSString *t = [tweetTextView text];
	if (t && [t length] > 0) {
		t = [t stringByAppendingString:tt];
	} else {
		t = tt;
	}

	[tweetTextView setText:t];
}

- (void) forcus {
	self.view.hidden = NO;
	[tweetTextView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
	int len = [textView.text length];
	[textLengthView setText:[NSString stringWithFormat:@"%d", (140-len)]];

	[self savePost];
}

- (IBAction)clearButtonPushed:(id)sender {
	[tweetTextView setText:@""];
	[self savePost];
}

@end
