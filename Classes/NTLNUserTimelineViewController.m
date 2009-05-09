#import "NTLNUserTimelineViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "NTLNHttpClientPool.h"
#import "NTLNTwitterPost.h"

@implementation NTLNUserTimelineViewController

@synthesize screenName, screenNames;

- (id)init {
	if (self = [super init]) {
		timeline = [[NTLNTimeline alloc] initWithDelegate:self 
									  withArchiveFilename:nil];
	}
	return self;
}

- (void)dealloc {
	LOG(@"NTLNUserTimelineViewController#dealloc");
	[screenName release];
	[screenNames release];
	[super dealloc];
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
	
	if (![[NTLNConfiguration instance] lefthand]) {
		[super setupPostButton];
	}
}

- (void)timeline:(NTLNTimeline*)tl requestForPage:(int)page since_id:(NSString*)since_id {
	if (screenNames) {
		for (NSString *n in screenNames) {
			NTLNTwitterClient *tc = [[NTLNHttpClientPool sharedInstance] 
									 idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
			tc.delegate = tl;
			[tc getUserTimelineWithScreenName:n page:page since_id:since_id];
		}
	} else {
		NTLNTwitterClient *tc = [[NTLNHttpClientPool sharedInstance] 
								 idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
		tc.delegate = tl;
		[tc getUserTimelineWithScreenName:screenName page:page since_id:since_id];
	}
}

- (void)timeline:(NTLNTimeline*)tl clientSucceeded:(NTLNTwitterClient*)client insertedStatuses:(NSArray*)statuses {
	[super timeline:tl clientSucceeded:client insertedStatuses:statuses];

	if (screenNames) {
		for (NSString *n in screenNames) { 
			[timeline hilightByScreenName:n];
		}
	}
}

- (void)postButton:(id)sender {
	NSString *txt = nil;
	if (screenName) {
		txt = [@"@" stringByAppendingString:screenName];
	} else if (screenNames.count == 2){
		txt = [NSString stringWithFormat:@"@%@ @%@", 
			 [screenNames objectAtIndex:0],
			 [screenNames objectAtIndex:1]];
	}

	[[NTLNTwitterPost shardInstance] createReplyPost:txt withReplyMessage:nil];
	[super postButton:sender];
}

@end

