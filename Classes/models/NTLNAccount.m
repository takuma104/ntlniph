#import "NTLNAccount.h"

#define NTLN_PREFERENCE_USERID		@"userId"
#define NTLN_PREFERENCE_PASSWORD	@"password"

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
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString*)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:NTLN_PREFERENCE_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) username {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_USERID];
}

- (NSString*) password {
	return [[NSUserDefaults standardUserDefaults] stringForKey:NTLN_PREFERENCE_PASSWORD];
}

- (BOOL) valid {
	NSString *pwd = self.password;
	NSString *usn = self.username;
	return usn != nil && usn.length > 0 &&
			pwd != nil && pwd.length > 0;
}

@end
