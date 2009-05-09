#import "NTLNIconDownloader.h"
#import "NTLNHttpClientPool.h"

@implementation NTLNIconDownloader

@synthesize delegate;

- (void) dealloc {
	LOG(@"NTLNIconDownloader#dealloc");
	[delegate release];
	[super dealloc];
}

- (void)download:(NSString*)url {
	[self requestGET:url];
}

- (void)requestSucceeded {
	[delegate iconDownloaderSucceeded:self];
	[[NTLNHttpClientPool sharedInstance] releaseClient:self];
}

- (void)requestFailed:(NSError*)error {
	[delegate iconDownloaderFailed:self];
	[[NTLNHttpClientPool sharedInstance] releaseClient:self];
}

@end
