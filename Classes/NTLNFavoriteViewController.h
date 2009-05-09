#import "NTLNTimelineViewController.h"

@interface NTLNFavoriteViewController : NTLNTimelineViewController {
	NSString *screenName;
	NSString *screenNameInternal;
}

@property (readwrite, retain) NSString *screenName;

@end
