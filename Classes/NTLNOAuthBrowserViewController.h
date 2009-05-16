#import <UIKit/UIKit.h>
#import "NTLNAccelerometerSensor.h"
#import "NTLNWebView.h"

@interface NTLNOAuthBrowserViewController : UIViewController<UIWebViewDelegate> {
	NSString *url;
	NTLNWebView *webView;
	UIToolbar *toobarTop;
}

@property (readwrite, retain) NSString *url;

@end
