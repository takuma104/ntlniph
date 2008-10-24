#import <UIKit/UIKit.h>
#import "NTLNTwitterClient.h"
#import "NTLNIconRepository.h"

#import "NTLNStatus.h"
#import "NTLNStatusCell.h"

@class NTLNLinkViewController;
@class NTLNStatus;
@class NTLNRoundedIconView;
@class NTLNTweetPostViewController;

@class NTLNAppDelegate;

@interface NTLNStatusViewController : UITableViewController
	<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, 
		NTLNStatusReadProtocol, NTLNTwitterClientDelegate, NTLNMessageIconUpdate> 
{		
	IBOutlet NTLNAppDelegate *appDelegate;
	IBOutlet NTLNTweetPostViewController *tweetPostViewController;
	
	UIBarButtonItem *reloadButton;
	
	NSMutableArray *timeline;
	
	UIFont *textFont;
	UIFont *metadataFont;
	
	NSTimer *_refreshTimer;
	
	int unread_count;
	
	BOOL always_read_tweets;
	BOOL badge_enable;
	BOOL enable_read;
	
	BOOL isViewAppear;
	
	NTLNTwitterClient *activeTwitterClient;
	
	NSString *xmlCachePath;

	int currentPage;
	
	UIView *footerShowMoreTweetView;
	UIActivityIndicatorView *autoloadActivityView;
	
	UIView *nowloadingView;
	
	NSDate *lastReloadTime;
	
	BOOL scrollMoved;
}

@property(readwrite, assign) NTLNAppDelegate *appDelegate;
@property(readwrite, assign) NTLNTweetPostViewController *tweetPostViewController;

- (void)setupTableView;
- (void)setupNavigationBar;
- (void)resetTimer;
- (void)stopTimer;
- (void)startTimer;
- (void)timerExpired;

- (void)getTimelineWithPage:(int)page autoload:(BOOL)autoload;
- (void)getTimelineImplWithPage:(int)page;

- (IBAction)reloadButton:(id)sender;

- (void)checkCellRead;

- (void)incrementReadStatus:(NTLNStatus*)status;
- (void)decrementReadStatus:(NTLNStatus*)status;

- (void)initialCacheLoading;
- (void)initialCacheLoading:(NSString*)name;

- (void)postButton:(id)sender;
- (void)setupPostButton;

- (void)removeLastReloadTime;

- (void)loadCache;

- (void)attachOrDetachAutopagerizeView;

- (void)showMoreButton:(id)sender;

@end
