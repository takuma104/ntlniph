#import "NTLNBrowserViewController.h"
#import "NTLNAlert.h"
#import "NTLNAccelerometerSensor.h"
#import "NTLNWebView.h"
#import "NTLNTwitterPost.h"
#import "NTLNTweetPostViewController.h"

@implementation NTLNBrowserViewController

@synthesize url;

- (void)dealloc {
	LOG(@"NTLNBrowserViewController#dealloc");

	[url release];
	[toobarTop release];
	[toobarBottom release];
	[self.view release];
	[super dealloc];
}

- (void)reloadButtonPushed:(id)sender {
	[webView reload];
}

- (void)doneButtonPushed:(id)sender {
	[webView stopLoading];
	[webView loadHTMLString:@"" baseURL:nil];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)prevButtonPushed:(id)sender {
	[webView goBack];
}

- (void)nextButtonPushed:(id)sender {
	[webView goForward];
}

- (void)safariButtonPushed:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)tweetURLButtonPushed:(id)sender {
	[[NTLNTwitterPost shardInstance] updateText:[[[webView request] URL] absoluteString]];
	[NTLNTweetPostViewController present:self];
}

- (void)setupToolbarTop {
	UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"done" 
																   style:UIBarButtonItemStyleBordered 
																  target:self		
																   action:@selector(doneButtonPushed:)] autorelease];
	
	UIBarButtonItem *reloadButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																				  target:self 
																				   action:@selector(reloadButtonPushed:)] autorelease];
	[toobarTop setItems:[NSArray arrayWithObjects:doneButton, reloadButton, nil]];
}

- (void)setupToolbarBottom {
	UIBarButtonItem *prevButton = [[[UIBarButtonItem alloc] initWithTitle:@"prev" 
																	style:UIBarButtonItemStyleBordered 
																   target:self		
																   action:@selector(prevButtonPushed:)] autorelease];

	UIBarButtonItem *nextButton = [[[UIBarButtonItem alloc] initWithTitle:@"next" 
																	style:UIBarButtonItemStyleBordered 
																   target:self		
																   action:@selector(nextButtonPushed:)] autorelease];

	UIBarButtonItem *safariButton = [[[UIBarButtonItem alloc] initWithTitle:@"safari" 
																	style:UIBarButtonItemStyleBordered 
																   target:self		
																   action:@selector(safariButtonPushed:)] autorelease];

	UIBarButtonItem *tweetURLButton = [[[UIBarButtonItem alloc] initWithTitle:@"TwURL" 
																	  style:UIBarButtonItemStyleBordered 
																	 target:self		
																	 action:@selector(tweetURLButtonPushed:)] autorelease];

	[toobarBottom setItems:[NSArray arrayWithObjects:prevButton, nextButton, tweetURLButton, safariButton, nil]];
}

- (void)loadView {  
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	toobarTop = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//	toobarTop.barStyle = UIBarStyleBlack;
	[self setupToolbarTop];
	[self.view addSubview:toobarTop];
	

	webView = [NTLNWebView sharedInstance];
	webView.frame = CGRectMake(0, 44, 320, 480-44-44);
	[self.view addSubview:webView];

	toobarBottom = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480-44-20, 320, 44)];
//	toobarBottom.barStyle = UIBarStyleBlack;
	[self setupToolbarBottom];
	[self.view addSubview:toobarBottom];
	
}

- (void)viewDidDisappear:(BOOL)animated {
///	self.view = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
	webView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
//	[self.navigationItem setTitle:@"Copyright Notice"];
	
	webView.delegate = self;
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//	if (shown && error.code != -999) {
//		[[NTLNAlert instance] alert:@"Browser error" withMessage:error.localizedDescription];
//	}
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *scheme = request.URL.scheme;
	if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
		return YES;
	} else {
		[[UIApplication sharedApplication] openURL:request.URL];
	}
	return NO;
}

@end
