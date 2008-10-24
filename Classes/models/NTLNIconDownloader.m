#import "NTLNIconDownloader.h"

@implementation NTLNIconDownloader

- (void) dealloc {
#ifdef DEBUG
	NSLog(@"NTLNIconDownloader#dealloc");
#endif
	[delegate release];
	[super dealloc];
}

- (id)initWithDelegate:(NSObject<NTLNIconDownloaderDelegate>*)aDelegate {
	self = [super init];
	delegate = aDelegate;
	[delegate retain];
	return self;
}

- (void)download:(NSString*)url {
	[self requestGET:url];
}

- (void)requestSucceeded {
	[delegate iconDownloaderSucceeded:self];
	[self autorelease];
}

- (void)requestFailed:(NSError*)error {
	[delegate iconDownloaderFailed:self];
	[self autorelease];
}

@end
