#import "NTLNFavoriteViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"
#import "NTLNHttpClientPool.h"

@implementation NTLNFavoriteViewController

- (id)initWithScreenName:(NSString*)aScreenName {
	if (self = [self init]) {
		if (aScreenName) {
			screenName = [aScreenName retain];
			timeline = [[NTLNTimeline alloc] initWithDelegate:self 
										  withArchiveFilename:nil];
		} else {
			timeline = [[NTLNTimeline alloc] initWithDelegate:self 
										  withArchiveFilename:@"favorites.plist"];
		}
	}
	return self;
}

- (void)dealloc {
	LOG(@"NTLNFavoriteViewController#dealloc");
	[screenName release];
	[screenNameInternal release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated]; //with reload

	[screenNameInternal release];
	if (screenName == nil) {
		screenNameInternal = [[[NTLNAccount sharedInstance] screenName] retain];
		[self.navigationItem setTitle:@"Favorites"];
	} else {
		screenNameInternal = [screenName retain];
		[self.navigationItem setTitle:[NSString stringWithFormat:@"%@'s fav", screenNameInternal]];
	}
}

- (void)setupNavigationBar {
	[super setupNavigationBar];
	[super setupPostButton];
}

- (void)timeline:(NTLNTimeline*)tl requestForPage:(int)page since_id:(NSString*)since_id {
	NTLNTwitterClient *tc = [[NTLNHttpClientPool sharedInstance] 
							 idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
	tc.delegate = tl;
	[tc getFavoriteWithScreenName:screenNameInternal page:page since_id:since_id];
}

@end

