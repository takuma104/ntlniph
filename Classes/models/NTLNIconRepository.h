#import <UIKit/UIKit.h>
#import "NTLNIconDownloader.h"

@class NTLNIconContainer;

@protocol NTLNIconDownloadDelegate
- (void) finishedToGetIcon:(NTLNIconContainer*)sender;
- (void) failedToGetIcon:(NTLNIconContainer*)sender;
@end

@interface NTLNIconContainer : NSObject <NTLNIconDownloaderDelegate>
{
	UIImage *iconImage;
	NSMutableArray *delegates;
	NSString *url;
	BOOL downloading;
}

@property (readonly) UIImage *iconImage;

- (BOOL)requestForURL:(NSString*)url delegate:(NSObject<NTLNIconDownloadDelegate>*)delegate;

@end

@interface NTLNIconRepository : NSObject  {
    NSMutableDictionary *urlToContainer;
	NSString *iconCacheRootPath;
}

@property (readonly) NSString *iconCacheRootPath;

+ (NTLNIconRepository*) instance;
+ (UIImage*) defaultIcon;

- (UIImage*)imageForURL:(NSString*)url delegate:(NSObject<NTLNIconDownloadDelegate>*)delegate;

@end