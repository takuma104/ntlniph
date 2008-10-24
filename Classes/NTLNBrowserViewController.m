#import "NTLNBrowserViewController.h"
#import "NTLNAlert.h"

@implementation NTLNBrowserViewController

@synthesize url;

- (void)dealloc
{
	NSLog(@"NTLNBrowserViewController#dealloc");
	[myWebView release];
	[reloadButton release];
	[urlLabel release];
	[super dealloc];
}

- (void)setReloadButton:(BOOL)reloadBtn {
	
	UIBarButtonSystemItem item = reloadBtn ? 
				UIBarButtonSystemItemRefresh : UIBarButtonSystemItemStop;
	
	[reloadButton release];
	reloadButton = [[UIBarButtonItem alloc] 
					initWithBarButtonSystemItem:item 
					target:self action:@selector(reloadButton:)];
	
	[[self navigationItem] setRightBarButtonItem:reloadButton];
}

- (void)loadView
{	
	myWebView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	myWebView.backgroundColor = [UIColor whiteColor];
	myWebView.scalesPageToFit = YES;
	myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	myWebView.delegate = self;
	myWebView.autoresizesSubviews = YES;
	self.view = myWebView;
	
	CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width - 40, 50);
	urlLabel = [[UILabel alloc] initWithFrame:frame];
	urlLabel.font = [UIFont systemFontOfSize:14.f];
	urlLabel.text = url;
	urlLabel.textColor = [UIColor whiteColor];
	urlLabel.backgroundColor = [UIColor clearColor];
	urlLabel.lineBreakMode = UILineBreakModeTailTruncation;
	urlLabel.numberOfLines = 1;
	
	[[self navigationItem] setTitleView:urlLabel];
	
	[self setReloadButton:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// we support rotation in this view controller
	return YES;
}

// this helps dismiss the keyboard when the "Done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[textField text]]]];
	
	return YES;
}


#pragma mark UIWebView delegate methods

- (void)stopProgressIndicator
{
    loading = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self setReloadButton:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	loading = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self setReloadButton:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self stopProgressIndicator];
	urlLabel.text = [[webView.request URL] absoluteString];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self stopProgressIndicator];
	
	if (shown && error.code != -999) {
		[[NTLNAlert instance] alert:@"Browser error" withMessage:error.localizedDescription];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	shown = NO;
	[myWebView loadHTMLString:nil baseURL:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	shown = YES;
	urlLabel.text = url;
	[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)reloadButton:(id)sender {
	if (loading) {
		[myWebView stopLoading];
	} else {
		[myWebView reload];
	}
}

@end
