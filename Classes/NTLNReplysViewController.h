#import <UIKit/UIKit.h>
#import "NTLNStatusViewController.h"

@interface NTLNReplysViewController : NTLNStatusViewController {

}

- (NSMutableArray*)unreadStatuses;
- (void)allRead;

@end
