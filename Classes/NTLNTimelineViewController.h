#import <UIKit/UIKit.h>

#import "NTLNTwitterClient.h"
#import "NTLNIconRepository.h"
#import "NTLNStatus.h"
#import "NTLNStatusCell.h"
#import "NTLNAccelerometerSensor.h"

@class NTLNAppDelegate;
@class NTLNLinkViewController;
@class NTLNStatus;
@class NTLNRoundedIconView;
@class NTLNTweetPostViewController;

@interface NTLNTimelineViewController : UITableViewController {

	// Main
	IBOutlet NTLNAppDelegate *appDelegate;
	IBOutlet NTLNTweetPostViewController *tweetPostViewController;

	// Timeline
	NSMutableArray *timeline;

	// Timer
	NSTimer *_refreshTimer;
	
	// Read
	int unread_count;
	BOOL badge_enable;
			
	// Client
	NTLNTwitterClient *activeTwitterClient;
	BOOL always_read_tweets;
	
	// Cache
	NSString *xmlCachePath;
	
	// View
	BOOL enable_read;
	UIBarButtonItem *reloadButton;
	int currentPage;
	UIView *footerShowMoreTweetView;
	UIActivityIndicatorView *autoloadActivityView;
	UIView *nowloadingView;
	NSDate *lastReloadTime;
	
	// Scroll
	BOOL scrollMoved;	
			
	// Accerlerometer
	UIView *tableViewSuperView;
	CGRect tableViewOriginalFrame;			
}

@property(readwrite, assign) NTLNAppDelegate *appDelegate;
@property(readwrite, assign) NTLNTweetPostViewController *tweetPostViewController;

@end


@interface NTLNTimelineViewController(Accerlerometer) <NTLNAccelerometerSensorDelegate>
- (void)normalScreenTimeline;

@end

@interface NTLNTimelineViewController(View)
- (void)insertNowloadingViewIfNeeds;
- (void)removeNowloadingView;
- (void)setupTableView;
- (void)setupNavigationBar;
- (void)attachOrDetachAutopagerizeView;

@end

@interface NTLNTimelineViewController(Cache)
- (void)initialCacheLoading;
- (void)initialCacheLoading:(NSString*)name;
- (void)saveCache:(NTLNTwitterClient*)sender filename:(NSString*)filename;
- (void)saveCache:(NTLNTwitterClient*)sender;
- (void)loadCacheWithFilename:(NSString*)fn;
- (void)loadCache;

@end

@interface NTLNTimelineViewController(Timer)
- (void)resetTimer;
- (void)stopTimer;
- (void)startTimer;
- (void)timerExpired;

@end

@interface NTLNTimelineViewController(Scroll) <UIScrollViewDelegate>

@end

@interface NTLNTimelineViewController(Read) <NTLNStatusReadProtocol>
- (void)checkCellRead;

@end

@interface NTLNTimelineViewController(Post)
- (void)setupPostButton;

@end

@interface NTLNTimelineViewController(Client) <NTLNTwitterClientDelegate, NTLNMessageIconUpdate>
- (void)getTimelineWithPage:(int)page autoload:(BOOL)autoload;
- (void)removeLastReloadTime; // !!

@end

@interface NTLNTimelineViewController(tableView) <UITableViewDataSource, UITableViewDelegate>
- (CGFloat)cellHeightForIndex:(int)index;

@end




