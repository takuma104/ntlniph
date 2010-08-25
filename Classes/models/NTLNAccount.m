#import "NTLNAccount.h"
#import "NTLNConfigurationKeys.h"
#import "NTLNHttpClientPool.h"
#import "TwitterToken.h"

static NTLNAccount *_instance;

@implementation NTLNAccount

+ (id) instance {
    if (!_instance) {
        return [NTLNAccount newInstance];
    }
    return _instance;
}

+ (id) newInstance {
    if (_instance) {
        [_instance release];
        _instance = nil;
    }
    
    _instance = [[NTLNAccount alloc] init];
    return _instance;
}

- (void) dealloc {
    [super dealloc];
}

- (void)setUsername:(NSString*)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:NTLN_PREFERENCE_USERID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserId:(NSString*)user_id {
    [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:NTLN_PREFERENCE_TWITTER_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)username {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_USERID];
}

- (NSString*) userId {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_TWITTER_USERID];
}

- (NSString*)footer {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_FOOTER];
}

- (BOOL)valid {
	return [[TwitterToken tokenWithName:@"NatsuLion"] isValid];
}

- (void)getUserId {
	
	NTLNTwitterUserClient *c = [[NTLNHttpClientPool sharedInstance] idleClientWithType:NTLNHttpClientPoolClientType_TwitterUserClient];
	c.delegate = self;
	[c getUserInfoForScreenName:[self username]];
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
