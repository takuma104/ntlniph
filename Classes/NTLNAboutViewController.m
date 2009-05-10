#import "NTLNAboutViewController.h"
#import	"version.h"

@implementation NTLNAboutViewController

- (void)dealloc {
	LOG(@"NTLNBrowserViewController#dealloc");
	[webView release];
	[super dealloc];
}

- (void)createWebView {
	if (webView == nil) {
		webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		webView.backgroundColor = [UIColor whiteColor];
		webView.scalesPageToFit = YES;
		webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		webView.autoresizesSubviews = YES;
		self.view = webView;
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	webView.delegate = nil;
	self.view = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationItem setTitle:@"Copyright Notice"];

	[self createWebView];
	webView.delegate = self;

	NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
	NSURL *url = [[NSURL alloc] initFileURLWithPath:path isDirectory:NO];
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	[url release];
}

#pragma mark UIWebView delegate methods

- (void)webViewDidFinishLoad:(UIWebView *)wv {
	NSString *js = [NSString stringWithFormat:@"document.getElementById(\"version\").innerHTML="
					"'Version %@<br/><small>%@</small>';",
					[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
					ntlniph_version];
	[wv stringByEvaluatingJavaScriptFromString:js];
	
	js = [NSString stringWithFormat:@"document.getElementById(\"source_code\").href="
		  "'http://github.com/takuma104/ntlniph/commit/%@';",
		  ntlniph_version];
	[wv stringByEvaluatingJavaScriptFromString:js];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([request.URL.scheme isEqualToString:@"http"]) {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	return YES;
}

@end

