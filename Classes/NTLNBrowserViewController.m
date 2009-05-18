#import "NTLNBrowserViewController.h"
#import "NTLNAlert.h"
#import "NTLNAccelerometerSensor.h"
#import "NTLNWebView.h"
#import "NTLNTwitterPost.h"
#import "NTLNTweetPostViewController.h"

@interface NTLNBrowserViewController(Private)
- (void)setupToolbarTop;
- (void)setupToolbarBottom;
- (void)updatePrevNextButton;
- (void)updateReloadButton;

- (void)reloadButtonPushed:(id)sender;
- (void)doneButtonPushed:(id)sender;
- (void)prevButtonPushed:(id)sender;
- (void)nextButtonPushed:(id)sender;
- (void)safariButtonPushed:(id)sender;
- (void)tweetURLButtonPushed:(id)sender;
										
@end

@implementation NTLNBrowserViewController

@synthesize url;

- (void)loadView {  
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	toobarTop = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	toobarTop.barStyle = UIBarStyleBlackOpaque;
	[self setupToolbarTop];
	[self.view addSubview:toobarTop];
	
	
	webView = [NTLNWebView sharedInstance];
	webView.frame = CGRectMake(0, 44, 320, 480-44-44);
	[self.view addSubview:webView];
	
	toobarBottom = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480-44-20, 320, 44)];
	toobarBottom.barStyle = UIBarStyleBlackOpaque;
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
	webView.delegate = self;
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)dealloc {
	LOG(@"NTLNBrowserViewController#dealloc");
	
	[url release];
	[toobarTop release];
	[toobarBottom release];
	
	[reloadButton release];
	[title release];
	[prevButton release];
	[nextButton release];
	
	[toobarTopItems release];
	
	[self.view release];
	[super dealloc];
}

#pragma mark UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
	loading = YES;
	[self updateReloadButton];
	[self updatePrevNextButton];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	loading = NO;
	title.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	[self updateReloadButton];
	[self updatePrevNextButton];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	if (error.code != -999) {
		[[NTLNAlert instance] alert:@"Browser error" withMessage:error.localizedDescription];
	}
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType {
	NSString *scheme = request.mainDocumentURL.scheme;
	if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
		title.title = request.mainDocumentURL.description;
		return YES;
	} else {
		[[UIApplication sharedApplication] openURL:request.URL];
	}
	return NO;
}

#pragma mark Private

- (void)setupToolbarTop {
	UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"close" 
																	style:UIBarButtonItemStyleBordered 
																   target:self		
																   action:@selector(doneButtonPushed:)] autorelease];
	
	[self updateReloadButton];
	
	title =	[[UIBarButtonItem alloc] initWithTitle:@"" 
											 style:UIBarButtonItemStylePlain
											target:nil 
											action:nil];
	title.width = 220;
	
	UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																			 target:nil action:nil] autorelease];
	
	toobarTopItems = [[NSMutableArray arrayWithObjects:doneButton, spacer, title, spacer, reloadButton, nil] retain];
	[toobarTop setItems:toobarTopItems];
}

- (void)setupToolbarBottom {

	
	prevButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser_icons_01.png"]
												  style:UIBarButtonItemStylePlain 
												 target:self		
												 action:@selector(prevButtonPushed:)];
	prevButton.enabled = NO;
	
	nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser_icons_03.png"] 
												  style:UIBarButtonItemStylePlain 
												 target:self		
												 action:@selector(nextButtonPushed:)];
	nextButton.enabled = NO;
	
	UIBarButtonItem *safariButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser_icons_05.png"]
																	  style:UIBarButtonItemStylePlain 
																	 target:self		
																	 action:@selector(safariButtonPushed:)] autorelease];
	
	UIBarButtonItem *tweetURLButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																					 target:self 
																					 action:@selector(tweetURLButtonPushed:)] autorelease];
	
	UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																			 target:nil action:nil] autorelease];
	
	[toobarBottom setItems:[NSArray arrayWithObjects:prevButton, spacer, nextButton, spacer, tweetURLButton, spacer, safariButton, nil]];
}

- (void)reloadButtonPushed:(id)sender {
	if (loading) {
		[webView stopLoading];
	} else {
		[webView reload];
	}
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
	[[UIApplication sharedApplication] openURL:[[webView request] mainDocumentURL]];
}

- (void)tweetURLButtonPushed:(id)sender {
	[[NTLNTwitterPost shardInstance] updateText:[[[webView request] mainDocumentURL] absoluteString]];
	[NTLNTweetPostViewController present:self];
}

- (void)updatePrevNextButton {
	prevButton.enabled = [webView canGoBack];
	nextButton.enabled = [webView canGoForward];
}

- (void)updateReloadButton {
	UIBarButtonSystemItem item;
	if (loading) {
		item = UIBarButtonSystemItemStop;
	} else {
		item = UIBarButtonSystemItemRefresh;
	}
	
	[reloadButton release];
	reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item
																 target:self 
																 action:@selector(reloadButtonPushed:)];
	
	if (toobarTop.items.count > 0) {
		[toobarTopItems replaceObjectAtIndex:4 withObject:reloadButton];
		[toobarTop setItems:toobarTopItems];
	}
}

@end
