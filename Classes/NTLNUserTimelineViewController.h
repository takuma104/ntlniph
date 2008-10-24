#import <UIKit/UIKit.h>
#import "NTLNStatusViewController.h"

@interface NTLNUserTimelineViewController : NTLNStatusViewController {
	NSString *screenName;
	NSArray *screenNames;
}

@property (readwrite, retain) NSString *screenName;
@property (readwrite, retain) NSArray *screenNames;

@end
