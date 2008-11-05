#import "NTLNTimelineViewController.h"
#import "NTLNCache.h"
#import "NTLNTwitterXMLReader.h"

@implementation NTLNTimelineViewController(Cache)

#pragma mark Private

- (void)loadCacheWithFilename:(NSString*)fn{
	NSData *data = [NTLNCache loadWithFilename:fn];
	if (data) {
		NTLNTwitterXMLReader *xr = [[NTLNTwitterXMLReader alloc] init];
		[xr parseXMLData:data];
		[self twitterClientSucceeded:nil messages:xr.messages];
		[xr release];
	}
}

- (void)loadCache {
	[self loadCacheWithFilename:xmlCachePath];
}

- (void)saveCache:(NTLNTwitterClient*)sender filename:(NSString*)filename {
	[NTLNCache saveWithFilename:filename data:sender.recievedData];
}

- (void)saveCache:(NTLNTwitterClient*)sender {
	[self saveCache:sender filename:xmlCachePath];
}

- (void)initialCacheLoading:(NSString*)name {
	xmlCachePath = [[NTLNCache createXMLCacheDirectory] stringByAppendingString:name];
	[xmlCachePath retain];
	[self loadCache];
}

- (void)initialCacheLoading {
}


@end