#import <UIKit/UIKit.h>
#import "NTLNTwitterUserClient.h"

@interface NTLNAccount : NSObject<NTLNTwitterUserClientDelegate> {
}

+ (id) instance;
+ (id) newInstance;

- (NSString*)username;
- (NSString*)password;
- (NSString*)userId;
- (NSString*)footer;

- (void)setUsername:(NSString*)username;
- (void)setPassword:(NSString*)password;
	
- (BOOL) valid;

- (void)getUserId;

@end


