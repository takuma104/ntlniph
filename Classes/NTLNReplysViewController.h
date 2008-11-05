#import <UIKit/UIKit.h>
#import "NTLNTimelineViewController.h"

@interface NTLNReplysViewController : NTLNTimelineViewController {
	NSString *repliesXMLPath;
	NSString *directMessageXMLPath;
}

- (NSMutableArray*)unreadStatuses;
- (void)allRead;

@end
