#import <UIKit/UIKit.h>
#import "NTLNAccelerometerSensor.h"

@interface NTLNBrowserViewController : UIViewController 
			<UITextFieldDelegate, UIWebViewDelegate, NTLNAccelerometerSensorDelegate> {

	UIWebView	*myWebView;
	UIBarButtonItem	*reloadButton;
	UILabel *urlLabel;

	NSString *url;
	
	BOOL shown;
	BOOL loading;
	
	UIView *browserViewSuperView;
	CGRect browserViewOriginalFrame;
}

@property (readwrite, retain) NSString *url;

@end
