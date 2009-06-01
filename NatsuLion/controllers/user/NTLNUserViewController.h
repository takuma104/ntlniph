#import <UIKit/UIKit.h>
#import "NTLNTwitterUserClient.h"
#import "NTLNMessage.h"

@interface NTLNUserViewController : UITableViewController 
	<UITableViewDelegate, UITableViewDataSource, NTLNTwitterUserClientDelegate> {
	NTLNMessage *message;
	NTLNUser *userInfo;
}

@property(readwrite, retain) NTLNMessage *message;

@end
