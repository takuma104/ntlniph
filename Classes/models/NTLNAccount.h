#import <Foundation/Foundation.h>
#import "OAToken.h"

@interface NTLNAccount : NSObject {
	OAToken *userToken;
	NSString *screenName;
}

+ (NTLNAccount*)sharedInstance;

- (BOOL)valid;

- (void)setScreenName:(NSString*)screenName;
- (NSString*)screenName;

- (OAToken*)userToken;
- (void)setUserToken:(OAToken*)token;

- (BOOL)waitForOAuthCallback;
- (void)setWaitForOAuthCallback:(BOOL)wait;

- (NSString*)footer;

@end


