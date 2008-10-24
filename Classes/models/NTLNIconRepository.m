#import "NTLNIconRepository.h"
#import "NTLNCache.h"
#import <CommonCrypto/CommonDigest.h>

static UIImage *default_icon = nil;
static NTLNIconRepository *_instance = nil;

@implementation NTLNIconContainer

@synthesize iconImage;

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


- (id)init {
	self = [super init];
	delegates = [[NSMutableArray alloc] init];
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
	[delegates release];
	[url release];
	[super dealloc];
}

- (BOOL)requestForURL:(NSString*)aUrl delegate:(NSObject<NTLNIconDownloadDelegate>*)delegate {
	NSData *cached = [NTLNIconContainer readFromCacheFileForURL:aUrl];
	if (cached) {
		[iconImage release];
		iconImage = [[UIImage alloc] initWithData:cached];
#ifdef DEBUG
		NSLog(@"Cached: %@", aUrl);
#endif
		return YES;
	} else {
		if (!downloading) {
			downloading = YES;
			[url release];
			url = aUrl;
			[url retain];
			NTLNIconDownloader *downloader = [[NTLNIconDownloader alloc] initWithDelegate:self];
			[downloader download:aUrl];
#ifdef DEBUG
			NSLog(@"Icon fetch: %@", aUrl);
#endif
		}
		[delegates addObject:delegate];
	}
	return FALSE;
}

- (void)iconDownloaderSucceeded:(NTLNIconDownloader*)sender {
	[iconImage release];
	iconImage = [[UIImage alloc] initWithData:sender.recievedData];
	[NTLNIconContainer writeAsCacheFileForURL:url data:sender.recievedData];
	[url release];
	url = nil;
	downloading = NO;
	for (NSObject<NTLNIconDownloadDelegate>* d in delegates) {
		[d finishedToGetIcon:self];
	}
	[delegates removeAllObjects];
}

- (void)iconDownloaderFailed:(NTLNIconDownloader*)sender {
	[url release];
	url = nil;
	downloading = NO;
	for (NSObject<NTLNIconDownloadDelegate>* d in delegates) {
		[d failedToGetIcon:self];
	}
	[delegates removeAllObjects];
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

- (id) init {
	self = [super init];
    urlToContainer = [[NSMutableDictionary alloc] initWithCapacity:100];
	iconCacheRootPath = [NTLNCache createIconCacheDirectory];
	[iconCacheRootPath retain];
    return self;
}

- (void) dealloc {
	[urlToContainer release];
	[iconCacheRootPath release];
	[super dealloc];
}

- (UIImage*)imageForURL:(NSString*)url delegate:(NSObject<NTLNIconDownloadDelegate>*)delegate {
	NTLNIconContainer *container = [urlToContainer objectForKey:url];
	if (!container) {
		container = [[NTLNIconContainer alloc] init];
		[urlToContainer setObject:container forKey:url];
		[container release];
	}
	if (container.iconImage || [container requestForURL:url delegate:delegate]) {
		return container.iconImage;
	}
	return nil;
}

@end
