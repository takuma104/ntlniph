#import <UIKit/UIKit.h>
#import "NTLNStatus.h"

@interface NTLNSelectedCellBackgroundView : UIView {
	NTLNStatus *status;
}

@property (readwrite, retain) NTLNStatus *status;

@end
