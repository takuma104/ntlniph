#import <UIKit/UIKit.h>
#import "NTLNTimelineViewController.h"

@interface NTLNUserTimelineViewController : NTLNTimelineViewController {
	NSString *screenName;
	NSArray *screenNames;
}

@property (readwrite, retain) NSString *screenName;
@property (readwrite, retain) NSArray *screenNames;

@end
