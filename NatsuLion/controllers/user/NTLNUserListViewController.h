#import <UIKit/UIKit.h>
#import "NTLNTwitterUserClient.h"
#import "NTLNMessage.h"

@interface NTLNUserListViewController : UITableViewController
	<UITableViewDelegate, UITableViewDataSource, NTLNTwitterUserClientDelegate> {
		
	NSArray *users;
	NSString *screenName;
}

@property (readwrite, retain) NSString *screenName;

- (void)iconUpdate:(NSNotification*)sender;

@end
