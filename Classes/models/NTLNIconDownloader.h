#import <UIKit/UIKit.h>
#import "NTLNHttpClient.h"

@class NTLNIconDownloader;

@protocol NTLNIconDownloaderDelegate
- (void)iconDownloaderSucceeded:(NTLNIconDownloader*)sender;
- (void)iconDownloaderFailed:(NTLNIconDownloader*)sender;
@end

@interface NTLNIconDownloader : NTLNHttpClient {
	NSObject<NTLNIconDownloaderDelegate> *delegate;
}

@property (readwrite, retain) NSObject<NTLNIconDownloaderDelegate> *delegate;

- (void)download:(NSString*)url;

@end
