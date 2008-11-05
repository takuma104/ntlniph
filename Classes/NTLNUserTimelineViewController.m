#import "NTLNUserTimelineViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"

@implementation NTLNUserTimelineViewController

@synthesize screenName, screenNames;

- (void)dealloc {
	NSLog(@"NTLNUserTimelineViewController#dealloc");
	[super dealloc];
}

- (void)viewDidLoad {	
	always_read_tweets = TRUE;
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated]; //with reload
	
	NSString *title = screenName;
	if (title == nil) {
		for (NSString *n in screenNames) { 
			if (title == nil) {
				title = n;
			} else {
				title = [NSString stringWithFormat:@"%@ + %@", title, n];
			}
		}
	}
	
	[self.navigationItem setTitle:title];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)getTimelineImplWithPage:(int)page since_id:(NSString*)since_id {
	if (screenNames) {
		for (NSString *n in screenNames) {
			NTLNTwitterClient *tc = [[NTLNTwitterClient alloc] initWithDelegate:self];
			[tc getUserTimelineWithScreenName:n page:page since_id:since_id];
		}
	} else {
		NTLNTwitterClient *tc = [[NTLNTwitterClient alloc] initWithDelegate:self];
		[tc getUserTimelineWithScreenName:screenName page:page since_id:since_id];
	}
}

- (void)twitterClientSucceeded:(NTLNTwitterClient*)sender messages:(NSArray*)statuses {
	if (screenNames) {
		NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
		for (NTLNMessage *m in statuses) {
			for (NSString *n in screenNames) {
				[m hilightUserReplyWithScreenName:n];
			}
			[array addObject:m];
		}
		statuses = array;
	}
	
	[super twitterClientSucceeded:sender messages:statuses];
}
@end

