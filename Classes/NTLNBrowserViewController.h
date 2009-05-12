#import <UIKit/UIKit.h>
#import "NTLNAccelerometerSensor.h"
#import "NTLNWebView.h"

@interface NTLNBrowserViewController : UIViewController<UIWebViewDelegate> {
	NSString *url;
	NTLNWebView *webView;
	UIToolbar *toobarTop;
	UIToolbar *toobarBottom;
}

@property (readwrite, retain) NSString *url;

@end
