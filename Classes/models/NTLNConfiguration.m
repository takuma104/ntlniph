#import "NTLNConfiguration.h"
#import "NTLNColors.h"
#import "NTLNNotification.h"

#define NTLN_CONFIGURATION_TIMELINE_SORT_ORDER_ASCENDING 0
#define NTLN_CONFIGURATION_TIMELINE_SORT_ORDER_DESCENDING 1

#define NTLN_PREFERENCE_REFRESH_INTERVAL @"refreshInterval"
#define NTLN_PREFERENCE_USE_POST @"usePost"
#define NTLN_PREFERENCE_USE_SAFARI @"useSafari"
#define NTLN_PREFERENCE_DARK_COLOR_THEME @"darkColorTheme"
#define NTLN_PREFERENCE_SCROLL_LOCK @"scrollLock"
#define NTLN_PREFERENCE_SHOW_MORE_TWEETS_MODE	@"showMoreTweetMode"
#define NTLN_PREFERENCE_FETCH_COUNT	@"fetchCount"
#define NTLN_PREFERENCE_SHAKE_TO_FULLSCREEN	@"shakeToFullscreen"

@implementation NTLNConfiguration

@synthesize refreshIntervalSeconds, usePost, useSafari, darkColorTheme, 
			scrollLock, showMoreTweetMode, fetchCount, shakeToFullscreen;

static id _instance = nil;

+ (id) instance {
    @synchronized (self) {
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (id) init {
	refreshIntervalSeconds = [[NSUserDefaults standardUserDefaults] integerForKey:NTLN_PREFERENCE_REFRESH_INTERVAL];
	usePost = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_USE_POST];
	useSafari = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_USE_SAFARI];
	darkColorTheme = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_DARK_COLOR_THEME];
	scrollLock = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_SCROLL_LOCK];
	showMoreTweetMode = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_SHOW_MORE_TWEETS_MODE];
	fetchCount = [[NSUserDefaults standardUserDefaults] integerForKey:NTLN_PREFERENCE_FETCH_COUNT];
	shakeToFullscreen = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_SHAKE_TO_FULLSCREEN];
	
	if (fetchCount < 20) {
		fetchCount = 20;
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void) setRefleshIntervalSeconds:(int)second {
	refreshIntervalSeconds = second;
	[[NSUserDefaults standardUserDefaults] setInteger:second forKey:NTLN_PREFERENCE_REFRESH_INTERVAL];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setUsePost:(BOOL)use {
	usePost = use;
	[[NSUserDefaults standardUserDefaults] setBool:use forKey:NTLN_PREFERENCE_USE_POST];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setUseSafari:(BOOL)use {
	useSafari = use;
	[[NSUserDefaults standardUserDefaults] setBool:use forKey:NTLN_PREFERENCE_USE_SAFARI];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setDarkColorTheme:(BOOL)use {
	darkColorTheme = use;
	[[NSUserDefaults standardUserDefaults] setBool:use forKey:NTLN_PREFERENCE_DARK_COLOR_THEME];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setScrollLock:(BOOL)use {
	scrollLock = use;
	[[NSUserDefaults standardUserDefaults] setBool:use forKey:NTLN_PREFERENCE_SCROLL_LOCK];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setShowMoreTweetMode:(BOOL)use {
	showMoreTweetMode = use;
	[[NSUserDefaults standardUserDefaults] setBool:use forKey:NTLN_PREFERENCE_SHOW_MORE_TWEETS_MODE];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setFetchCount:(int)count {
	fetchCount = count;
	[[NSUserDefaults standardUserDefaults] setInteger:count forKey:NTLN_PREFERENCE_FETCH_COUNT];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setShakeToFullscreen:(BOOL)use {
	shakeToFullscreen = use;
	[[NSUserDefaults standardUserDefaults] setBool:use forKey:NTLN_PREFERENCE_SHAKE_TO_FULLSCREEN];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
