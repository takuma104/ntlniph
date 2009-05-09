#import "NTLNConfiguration.h"
#import "NTLNColors.h"
#import "NTLNNotification.h"
#import "NTLNConfigurationKeys.h"

@implementation NTLNConfiguration

@synthesize useSafari, darkColorTheme, autoScroll, showMoreTweetMode, shakeToFullscreen;
@synthesize lefthand;

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
	if (self = [super init]) {
		[self reload];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void)reload {
	refreshIntervalSeconds = [[NSUserDefaults standardUserDefaults] integerForKey:NTLN_PREFERENCE_REFRESH_INTERVAL];
	useSafari = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_USE_SAFARI];
	darkColorTheme = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_DARK_COLOR_THEME];
	autoScroll = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_AUTO_SCROLL];
	showMoreTweetMode = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_SHOW_MORE_TWEETS_MODE];
	fetchCount = [[NSUserDefaults standardUserDefaults] integerForKey:NTLN_PREFERENCE_FETCH_COUNT];
	shakeToFullscreen = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_SHAKE_TO_FULLSCREEN];
	lefthand = [[NSUserDefaults standardUserDefaults] boolForKey:NTLN_PREFERENCE_LEFTHAND];
}

static int seconds_from_index(int index)
{
	if (index == 0) return 0;
	if (index > 6) return 0;
	
	const int m[] = {1*60,2*60,2*60+30,3*60,5*60,10*60};
	return m[index-1];
}

static int count_from_index(int index)
{
	if (index > 3) return 0;

	const int m[] = {20,50,100,200};
	return m[index];
}

- (int)refreshIntervalSeconds {
	return seconds_from_index(refreshIntervalSeconds);
}

- (int)fetchCount {
	return count_from_index(fetchCount);
}


@end
