#import <UIKit/UIKit.h>
#import "NTLNAppDelegate.h"
#import "NTLNTwitterClient.h"

@class NTLNMessage;
@class NTLNFriendsViewController;
@class NTLNBrowserViewController;
@class NTLNTweetPostViewController;
@class NTLNUserTimelineViewController;

@interface NTLNURLPair : NSObject
{
	NSString *text;
	NSString *url;
	NSString *screenName;
	BOOL conversation;
}

@property(readwrite, retain) NSString *url, *text, *screenName;
@property(readwrite) BOOL conversation;

@end


@interface NTLNTweetViewController : UITableViewController 
										<UITableViewDelegate, 
										UITableViewDataSource, 
										NTLNTwitterClientDelegate> {											
	NTLNMessage *message;
	NSMutableArray *links;	
	UIButton *favButton;
	UIActivityIndicatorView *favAI;
}

@property(readwrite, retain) NTLNMessage *message;

@end

