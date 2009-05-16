#import "NTLNAccount.h"
#import "NTLNConfigurationKeys.h"
#import "GTMObjectSingleton.h"

@implementation NTLNAccount

GTMOBJECT_SINGLETON_BOILERPLATE(NTLNAccount, sharedInstance)

- (id)init {
	if (self = [super init]) {
		userToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:NTLN_OAUTH_PROVIDER 
																		   prefix:NTLN_OAUTH_PREFIX];
		screenName = [[[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_USERID] retain];
	}
	return self;
}

- (void) dealloc {
	[userToken release];
	[screenName release];
    [super dealloc];
}

- (void)setScreenName:(NSString*)sn {
	[screenName release];
	screenName = [sn retain];
    [[NSUserDefaults standardUserDefaults] setObject:screenName forKey:NTLN_PREFERENCE_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)screenName {
	return screenName;
}

- (NSString*)footer {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_FOOTER];
}

- (BOOL)valid {
	return screenName.length > 0 &&
	userToken && 
	userToken.key.length > 0 &&
	userToken.secret.length > 0;
}

- (OAToken*)userToken {
	return userToken;
}

- (void)setUserToken:(OAToken*)token {
	[userToken release];
	userToken = [token retain];
	[userToken storeInUserDefaultsWithServiceProviderName:NTLN_OAUTH_PROVIDER 
												   prefix:NTLN_OAUTH_PREFIX];
}

@end
