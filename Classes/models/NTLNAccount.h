#import <UIKit/UIKit.h>
#import "NTLNTwitterUserClient.h"
#import "OAToken.h"

@interface NTLNAccount : NSObject<NTLNTwitterUserClientDelegate> {
	OAToken *userToken;
	NSString *screenName;
}

+ (NTLNAccount*)sharedInstance;

- (BOOL)valid;

- (void)setScreenName:(NSString*)screenName;
- (NSString*)screenName;

- (OAToken*)userToken;
- (void)setUserToken:(OAToken*)token;

- (NSString*)footer;

- (void)getUserId;
- (NSString*)userId;

@end


