#import "NTLNTimelineViewController.h"

@interface NTLNFavoriteViewController : NTLNTimelineViewController {
	NSString *screenName;
	NSString *screenNameInternal;
}

- (id)initWithScreenName:(NSString*)screenName;

@end
