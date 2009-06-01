#import "NTLNIconRepository.h"
#import "NTLNCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "NTLNHttpClientPool.h"

static UIImage *default_icon = nil;
static NTLNIconRepository *_instance = nil;

#define ICON_FETCH_NOTIFICATION	@"ICON_FETCH_NOTIFICATION"

@implementation NTLNIconContainer

@synthesize iconImage;
@synthesize url;

+ (NSString*)md5:(NSString*) str {
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat: 
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1],
			result[2], result[3],
			result[4], result[5],
			result[6], result[7],
			result[8], result[9],
			result[10], result[11],
			result[12], result[13],
			result[14], result[15]];
}

- (id)initWithIconURL:(NSString*)theUrl {
	if (self = [super init]) {
		url = [theUrl retain];
	}
	return self;
}

+ (NSString*)cacheFilenameForURL:(NSString*)url {
	return [[NTLNIconRepository instance].iconCacheRootPath stringByAppendingString:[NTLNIconContainer md5:url]];
}

+ (void)writeAsCacheFileForURL:(NSString*)url data:(NSData*)data {
	[NTLNCache saveWithFilename:[NTLNIconContainer cacheFilenameForURL:url] data:data];
}

+ (NSData*)readFromCacheFileForURL:(NSString*)url {
	return [NTLNCache loadWithFilename:[NTLNIconContainer cacheFilenameForURL:url]];
}

- (void)dealloc {
	[iconImage release];
	[url release];
	[super dealloc];
}

- (BOOL)loadCache {
	NSData *cached = [NTLNIconContainer readFromCacheFileForURL:url];
	if (cached) {
		[iconImage release];
		iconImage = [[UIImage alloc] initWithData:cached];
		LOG(@"Cached: %@", url);
		return YES;
	}
	return NO;
}

- (void)requestDownload {
	if (!downloading) {
		downloading = YES;
		NTLNIconDownloader *downloader = [[NTLNHttpClientPool sharedInstance] idleClientWithType:NTLNHttpClientPoolClientType_IconDownloader];
		downloader.delegate = self;
		[downloader download:url];
		LOG(@"Icon fetch: %@", url);
	}
}

- (void)iconDownloaderSucceeded:(NTLNIconDownloader*)sender {
	[iconImage release];
	iconImage = [[UIImage alloc] initWithData:sender.recievedData];
	[NTLNIconContainer writeAsCacheFileForURL:url data:sender.recievedData];
	downloading = NO;

	NSNotification *notification = [NSNotification notificationWithName:ICON_FETCH_NOTIFICATION
																 object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)iconDownloaderFailed:(NTLNIconDownloader*)sender {
	downloading = NO;
}

@end


@implementation NTLNIconRepository

@synthesize iconCacheRootPath;

+ (NTLNIconRepository*) instance {
    @synchronized (self) {
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

+ (UIImage*)defaultIcon {
	if (default_icon == nil) {
		default_icon = [UIImage imageNamed:@"default_icon.png"];
	}
	return default_icon;
}

- (id)init {
	if (self = [super init]) {
		urlToContainer = [[NSMutableDictionary alloc] initWithCapacity:100];
		iconCacheRootPath = [NTLNCache createIconCacheDirectory];
		[iconCacheRootPath retain];
		downloadQueue = [[NSMutableArray alloc] init];
		[[NTLNHttpClientPool sharedInstance] addIdleClientObserver:self selector:@selector(processDownloadQueue)];
	}
    return self;
}

- (void)dealloc {
	[urlToContainer release];
	[iconCacheRootPath release];
	[downloadQueue release];
	[[NTLNHttpClientPool sharedInstance] removeIdleClientObserver:self];
	[super dealloc];
}

- (NTLNIconContainer*)iconContainerForURL:(NSString*)url {
	NTLNIconContainer *container = [urlToContainer objectForKey:url];
	if (!container) {
		container = [[NTLNIconContainer alloc] initWithIconURL:url];
		[urlToContainer setObject:container forKey:url];
		[container release];
	}
	if (container.iconImage) {
		return container;
	}
	if ([container loadCache]) {
		return container;
	}

	@synchronized (self){
		[downloadQueue addObject:container];
	}
	[self performSelectorOnMainThread:@selector(processDownloadQueue) 
						   withObject:nil 
						waitUntilDone:NO];
	return container;
}

+ (void)addObserver:(id)observer selectorSuccess:(SEL)success {
	[[NSNotificationCenter defaultCenter] addObserver:observer 
											 selector:success 
												 name:ICON_FETCH_NOTIFICATION 
											   object:nil];
}

+ (void)removeObserver:(id)observer {
	[[NSNotificationCenter defaultCenter] removeObserver:observer];
}

- (void)processDownloadQueue {
	@synchronized (self) {
		if (downloadQueue.count > 0) {
			int cnt = [[NTLNHttpClientPool sharedInstance] activeClientCountWithType:
					   NTLNHttpClientPoolClientType_IconDownloader];
			if (cnt < 5) {
				NTLNIconContainer* container = [downloadQueue objectAtIndex:0];
				[container requestDownload];
				[downloadQueue removeObjectAtIndex:0];
			}
		}
	}
}

@end
