#import <UIKit/UIKit.h>

#import "NTLNTwitterClient.h"
#import "NTLNIconRepository.h"
#import "NTLNStatus.h"
#import "NTLNStatusCell.h"
#import "NTLNAccelerometerSensor.h"
#import "NTLNTimeline.h"

@class NTLNAppDelegate;
@class NTLNTweetViewController;
@class NTLNStatus;
@class NTLNRoundedIconView;
@class NTLNTweetPostViewController;

@interface NTLNTimelineViewController : UITableViewController {
	NTLNTimeline *timeline;
	
	// Read
	BOOL badge_enable;
	
	// View
	BOOL enable_read;
	UIView *nowloadingView;
	NSDate *lastReloadTime;
	UIActivityIndicatorView *footerActivityIndicatorView;
	BOOL evenInv;
	
	UIButton *headReloadButton;
	
	UIButton *moreButton;
				
	// Accerlerometer
	UIView *tableViewSuperView;
	CGRect tableViewOriginalFrame;		
	
	BOOL disableColorize;

	// ReadTrack
	int readTrackContinueCounter;
	NSTimer *readTrackTimer;
	
	NSString *lastTopStatusId;
	
}

@property (readonly) NTLNTimeline *timeline;

@end

@interface NTLNTimelineViewController(Accerlerometer) <NTLNAccelerometerSensorDelegate>
- (void)normalScreenTimeline;

@end

@interface NTLNTimelineViewController(View)
- (void)insertNowloadingViewIfNeeds;
- (void)removeNowloadingView;
- (void)setupTableView;
- (void)setupNavigationBar;
- (UIBarButtonItem*)clearButtonItem;
- (void)setReloadButtonNormal:(BOOL)normal;
- (void)setupClearButton;

@end


@interface NTLNTimelineViewController(Scroll) <UIScrollViewDelegate>

@end

@interface NTLNTimelineViewController(Read)
- (void)startReadTrackTimer;
- (void)stopReadTrackTimer;
- (BOOL)readTrackTimerActivated;
- (void)updateBadge;
- (BOOL)doReadTrack;

@end

@interface NTLNTimelineViewController(Post)
- (void)setupPostButton;
- (void)postButton:(id)sender;

@end

@interface NTLNTimelineViewController(TableView) <UITableViewDataSource, UITableViewDelegate>
- (CGFloat)cellHeightForIndex:(int)index;

@end

@interface NTLNTimelineViewController(Paging)
- (void)autopagerize;
- (void)updateFooterView;
- (void)footerActivityIndicator:(BOOL)active;

@end

@interface NTLNTimelineViewController(Timeline) <NTLNTimelineDelegate>
@end



