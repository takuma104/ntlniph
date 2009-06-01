#import "NTLNWebView.h"
#import "GTMObjectSingleton.h"
#import "NTLNColors.h"

@implementation NTLNWebView

GTMOBJECT_SINGLETON_BOILERPLATE(NTLNWebView, sharedInstance)

- (id)init {
	if (self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]]) {
		self.backgroundColor = [[NTLNColors instance] scrollViewBackground];
		self.scalesPageToFit = YES;
		self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		self.autoresizesSubviews = YES;
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
