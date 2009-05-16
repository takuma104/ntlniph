#import "NTLNOAuthBrowserViewController.h"
#import "NTLNAlert.h"
#import "NTLNAccelerometerSensor.h"
#import "NTLNWebView.h"
#import "NTLNTwitterPost.h"
#import "NTLNTweetPostViewController.h"
#import "NTLNOAuthConsumer.h"

@implementation NTLNOAuthBrowserViewController

@synthesize url;

- (void)dealloc {
	LOG(@"NTLNOAuthBrowserViewController#dealloc");
	
	[url release];
	[toobarTop release];
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

- (void)setupToolbarTop {
	UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"done" 
																	style:UIBarButtonItemStyleBordered 
																   target:self		
																   action:@selector(doneButtonPushed:)] autorelease];
	
	[toobarTop setItems:[NSArray arrayWithObjects:doneButton, nil]];
}


- (void)loadView {  
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	toobarTop = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	toobarTop.barStyle = UIBarStyleBlack;
	[self setupToolbarTop];
	[self.view addSubview:toobarTop];
	
	
	webView = [NTLNWebView sharedInstance];
	webView.frame = CGRectMake(0, 44, 320, 480-44);
	[self.view addSubview:webView];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	///	self.view = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
	webView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {	
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
	NSURL *u = request.URL;
	
	LOG(@"shouldStartLoadWithRequest: %@", u);
	
	NSString *scheme = u.scheme;
	if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
		if ([[NTLNOAuthConsumer sharedInstance] isCallbackURL:u]) {
			[webView stopLoading];
			[webView loadHTMLString:@"" baseURL:nil];
			[[NTLNOAuthConsumer sharedInstance] accessToken:u];
			[self dismissModalViewControllerAnimated:YES];
			return NO;
		}
		return YES;
	} else {
		[[UIApplication sharedApplication] openURL:request.URL];
	}
	return NO;
}

@end
