#import <UIKit/UIKit.h>

@protocol NTLNCacheCleanerDelegate
- (void)cacheCleanerAlertClosed;
@end


@interface NTLNCacheCleaner : NSObject<UIAlertViewDelegate> {
	NSObject<NTLNCacheCleanerDelegate> *delegate;
}

@property (readwrite, retain) NSObject<NTLNCacheCleanerDelegate> *delegate;

+ (NTLNCacheCleaner*)sharedCacheCleaner;

- (BOOL)bootup;
- (void)shutdown;

@end
