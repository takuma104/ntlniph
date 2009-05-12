#import "NTLNAboutViewController.h"
#import "NTLNWebView.h"

@implementation NTLNAboutViewController

- (void)dealloc {
	LOG(@"NTLNAboutViewController#dealloc");
	[super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated {
	self.view = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
	[(NTLNWebView*)self.view setDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationItem setTitle:@"Copyright Notice"];

	self.view = [NTLNWebView sharedInstance];
	[(NTLNWebView*)self.view setDelegate:self];

	NSString *path = [[NSBundle mainBundle] pathForResource:@"readme" ofType:@"html"];
	NSURL *url = [[NSURL alloc] initFileURLWithPath:path isDirectory:NO];
	[(NTLNWebView*)self.view loadRequest:[NSURLRequest requestWithURL:url]];
	[url release];
}

#pragma mark UIWebView delegate methods

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([request.URL.scheme isEqualToString:@"http"]) {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	return YES;
}

@end

