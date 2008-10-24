#import <UIKit/UIKit.h>
#import "ntlniphAppDelegate.h"
#import "NTLNTwitterClient.h"

@class NTLNMessage;
@class NTLNFriendsViewController;
@class NTLNBrowserViewController;
@class NTLNTweetPostViewController;
@class NTLNUserTimelineViewController;

@interface NTLNURLPair : NSObject
{
	NSString *url;
	NSString *text;
	NSString *screenName;
}

@property(readwrite, retain) NSString *url, *text, *screenName;

@end



@interface NTLNLinkViewController : UITableViewController 
										<UITableViewDelegate, 
										UITableViewDataSource, 
										NTLNTwitterClientDelegate> {

	NTLNAppDelegate *appDelegate;
	NTLNTweetPostViewController *tweetPostViewController;
											
	NTLNMessage *message;
	NSMutableArray *urls;
	NTLNURLPair *messageOwnerUrl;
	
	UIButton *favButton;
}

- (CGFloat)getTextboxHeight:(NSString *)str;
- (UITableViewCell *)screenNameCell;
- (UITableViewCell *)urlCell:(NTLNURLPair*)pair isEven:(BOOL)isEven;
- (void)parseToken;

@property(readwrite, assign) NTLNAppDelegate *appDelegate;
@property(readwrite, assign) NTLNTweetPostViewController *tweetPostViewController;

@property(readwrite, retain) NTLNMessage *message;

@end

@interface NTLNLinkCell : UITableViewCell
{
	UILabel *label;
}

- (void)createCell:(NTLNURLPair*)pair isEven:(BOOL)isEven;

@end

