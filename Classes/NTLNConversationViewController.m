#import "NTLNConversationViewController.h"
#import "NTLNHttpClientPool.h"
#import "NTLNTwitterPost.h"
#import "NTLNConfiguration.h"

@implementation NTLNConversationViewController

@synthesize rootMessage;

- (id)init {
	if (self = [super init]) {
		timeline = [[NTLNTimeline alloc] initWithDelegate:self 
									  withArchiveFilename:nil];
	}
	return self;
}

- (void)dealloc {
	LOG(@"NTLNConversationViewController#dealloc");
	[rootMessage release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated]; //with reload
	[self.navigationItem setTitle:[NSString stringWithFormat:@"%@ & %@", 
								   rootMessage.screenName,
								   rootMessage.in_reply_to_screen_name]];
	
	NTLNStatus *rs = [[[NTLNStatus alloc] initWithMessage:rootMessage] autorelease];
	NSArray *statuses = [NSArray arrayWithObjects:rs, nil];
	[timeline appendStatuses:statuses];

	// for reload view
	[super timeline:timeline clientSucceeded:nil insertedStatuses:statuses];

	NSString *sid = rs.message.in_reply_to_status_id;
	if (sid.length > 0) {
		NTLNTwitterClient *tc = [[NTLNHttpClientPool sharedInstance] 
									idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
		tc.delegate = timeline;
		[tc getStatusWithStatusId:sid];
	}

	if (![[NTLNConfiguration instance] lefthand]) {
		[super setupPostButton];
	}
}

- (void)timeline:(NTLNTimeline*)tl clientSucceeded:(NTLNTwitterClient*)client insertedStatuses:(NSArray*)statuses {
	[super timeline:tl clientSucceeded:client insertedStatuses:statuses];
	if (statuses.count == 1) {
		NTLNStatus *lastStatus = [statuses lastObject];
		NSString *sid = lastStatus.message.in_reply_to_status_id;
		if (sid.length > 0) {
			NTLNTwitterClient *tc = [[NTLNHttpClientPool sharedInstance] 
										idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
			tc.delegate = tl;
			[tc getStatusWithStatusId:sid];
		}
	}
}

- (void)setupTableView {
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)postButton:(id)sender {
	[[NTLNTwitterPost shardInstance] createReplyPost:[@"@" stringByAppendingString:rootMessage.screenName]
									withReplyMessage:rootMessage];
	[super postButton:sender];
}

@end
