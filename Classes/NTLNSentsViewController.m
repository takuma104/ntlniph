#import "NTLNSentsViewController.h"
#import "NTLNAccount.h"
#import "NTLNConfiguration.h"

@implementation NTLNSentsViewController

- (void)setupNavigationBar {
	[super setupNavigationBar];
	[super setupPostButton];
	[self.navigationItem setTitle:@"Sents"];
}

- (void)dealloc {
	[super dealloc];
}

- (void)viewDidLoad {	
	always_read_tweets = TRUE;
	[super viewDidLoad];
}

- (void)initialCacheLoading {
	[super initialCacheLoading:@"sents.xml"];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)getTimelineImplWithPage:(int)page since_id:(NSString*)since_id {
	NTLNTwitterClient *tc = [[NTLNTwitterClient alloc] initWithDelegate:self];
	[tc getSentsTimelineWithPage:page since_id:since_id];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.navigationItem setTitle:@"Sents"];
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)loadCache {
	if ( ! [[NTLNConfiguration instance] showMoreTweetMode]) {
		[super loadCache];
	}
}

@end
