#import <UIKit/UIKit.h>
#import "NTLNIconDownloader.h"

@class NTLNIconContainer;

/*
@protocol NTLNIconDownloadDelegate
- (void) finishedToGetIcon:(NTLNIconContainer*)sender;
- (void) failedToGetIcon:(NTLNIconContainer*)sender;
@end
*/

@interface NTLNIconContainer : NSObject <NTLNIconDownloaderDelegate>
{
	UIImage *iconImage;
	NSString *url;
	BOOL downloading;
}

@property (readonly) UIImage *iconImage;
@property (readonly) NSString *url;


- (id)initWithIconURL:(NSString*)url;
- (BOOL)loadCache;
- (void)requestDownload;

@end

@interface NTLNIconRepository : NSObject  {
    NSMutableDictionary *urlToContainer;
	NSMutableArray *downloadQueue;
	NSString *iconCacheRootPath;
}

@property (readonly) NSString *iconCacheRootPath;

+ (NTLNIconRepository*) instance;
+ (UIImage*) defaultIcon;

- (NTLNIconContainer*)iconContainerForURL:(NSString*)url;

+ (void)addObserver:(id)observer selectorSuccess:(SEL)success;
+ (void)removeObserver:(id)observer;

@end