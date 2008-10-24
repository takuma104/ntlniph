#import <UIKit/UIKit.h>


@interface NTLNBrowserViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate> {
	UIWebView	*myWebView;
	UIBarButtonItem	*reloadButton;
	UILabel *urlLabel;

	NSString *url;
	
	BOOL shown;
	BOOL loading;
}

@property (readwrite, retain) NSString *url;

@end
