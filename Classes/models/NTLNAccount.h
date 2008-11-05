#import <UIKit/UIKit.h>
#import "NTLNTwitterUserClient.h"

@interface NTLNAccount : NSObject<NTLNTwitterUserClientDelegate> {
}

+ (id) instance;
+ (id) newInstance;

- (NSString*) username;
- (NSString*) password;
- (NSString*) userId;

- (void)setUsername:(NSString*)username;
- (void)setPassword:(NSString*)password;
	
- (BOOL) valid;

- (void)getUserId;

@end


