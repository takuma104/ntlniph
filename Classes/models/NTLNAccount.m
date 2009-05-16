#import "NTLNAccount.h"
#import "NTLNConfigurationKeys.h"
#import "NTLNHttpClientPool.h"
#import "GTMObjectSingleton.h"

@implementation NTLNAccount

GTMOBJECT_SINGLETON_BOILERPLATE(NTLNAccount, sharedInstance)

- (id)init {
	if (self = [super init]) {
		userToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:NTLN_OAUTH_PROVIDER 
																		   prefix:NTLN_OAUTH_PREFIX];
		screenName = [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_USERID];
	}
	return self;
}

- (void) dealloc {
	[userToken release];
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


#pragma mark ----

- (NSString*)userId {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_TWITTER_USERID];
}

- (void)setUserId:(NSString*)user_id {
    [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:NTLN_PREFERENCE_TWITTER_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getUserId {
	NTLNTwitterUserClient *c = [[NTLNHttpClientPool sharedInstance] idleClientWithType:NTLNHttpClientPoolClientType_TwitterUserClient];
	c.delegate = self;
	[c getUserInfoForScreenName:screenName];
}

- (void)twitterUserClientSucceeded:(NTLNTwitterUserClient*)sender {
	if ([sender.users count] > 0) {
		NTLNUser *user = [sender.users objectAtIndex:0];
		[self setUserId:user.user_id];
	}	
}

- (void)twitterUserClientFailed:(NTLNTwitterUserClient*)sender {
}

@end
