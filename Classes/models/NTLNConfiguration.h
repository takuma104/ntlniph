#import <UIKit/UIKit.h>

@interface NTLNConfiguration : NSObject {
    BOOL usePost;
	BOOL useSafari;
	BOOL darkColorTheme;
	BOOL scrollLock;
    int refreshIntervalSeconds;
	BOOL showMoreTweetMode;
	int fetchCount;
	BOOL shakeToFullscreen;
}

@property (readonly) BOOL usePost;
@property (readonly) BOOL useSafari;
@property (readonly) BOOL darkColorTheme;
@property (readonly) BOOL scrollLock;
@property (readonly) BOOL showMoreTweetMode;
@property (readonly) int refreshIntervalSeconds;
@property (readonly) int fetchCount;
@property (readonly) BOOL shakeToFullscreen;

+ (id) instance;

- (void) setRefleshIntervalSeconds:(int)second;
- (void) setUsePost:(BOOL)use;
- (void) setUseSafari:(BOOL)use;
- (void) setDarkColorTheme:(BOOL)use;
- (void) setScrollLock:(BOOL)use;
- (void) setShowMoreTweetMode:(BOOL)use;
- (void) setFetchCount:(int)count;
- (void) setShakeToFullscreen:(BOOL)use;

@end
