#import "NTLNSentsViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "NTLNHttpClientPool.h"

@implementation NTLNSentsViewController

- (id)init {
	if (self = [super init]) {
		timeline = [[NTLNTimeline alloc] initWithDelegate:self 
									  withArchiveFilename:@"sents.plist"];
	}
	return self;
}

- (void)setupNavigationBar {
	[super setupNavigationBar];
	[super setupPostButton];
	[self.navigationItem setTitle:@"Sents"];
}

- (void)timeline:(NTLNTimeline*)tl requestForPage:(int)page since_id:(NSString*)since_id {

	

	
	
	NTLNTwitterClient *tc = [[NTLNHttpClientPool sharedInstance] 
								idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
	tc.delegate = tl;
	[tc getSentsTimelineWithPage:page since_id:since_id];
}

@end
