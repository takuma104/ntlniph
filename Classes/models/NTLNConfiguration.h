#import <UIKit/UIKit.h>

@interface NTLNConfiguration : NSObject {
    BOOL usePost;
	BOOL useSafari;
	BOOL darkColorTheme;
	BOOL scrollLock;
    int refreshIntervalSeconds;
	BOOL showMoreTweetMode;
//    NSString *version;
}

@property (readonly) BOOL usePost;
@property (readonly) BOOL useSafari;
@property (readonly) BOOL darkColorTheme;
@property (readonly) BOOL scrollLock;
@property (readonly) BOOL showMoreTweetMode;
@property (readonly) int refreshIntervalSeconds;

+ (id) instance;

- (void) setRefleshIntervalSeconds:(int)second;
- (void) setUsePost:(BOOL)use;
- (void) setUseSafari:(BOOL)use;
- (void) setDarkColorTheme:(BOOL)use;
- (void) setScrollLock:(BOOL)use;
- (void) setShowMoreTweetMode:(BOOL)use;

@end
