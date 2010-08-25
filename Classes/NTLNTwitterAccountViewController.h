#import <Foundation/Foundation.h>
#import "UICTableViewController.h"
#import "XAuthAccessTokenClient.h"

@interface NTLNTwitterAccountViewController : UICTableViewController <XAuthAccessTokenClientDelegate>{
	NSString *usernameOriginal;
	XAuthAccessTokenClient *_client;
}

@end
