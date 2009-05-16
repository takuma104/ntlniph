#import <UIKit/UIKit.h>
#import "NTLNTwitterUserClient.h"

@interface NTLNAccount : NSObject<NTLNTwitterUserClientDelegate> {
}

+ (id) instance;
+ (id) newInstance;

- (NSString*)username;
- (NSString*)userId;
- (NSString*)footer;

- (void)setUsername:(NSString*)username;
	
- (BOOL)valid;

- (void)getUserId;

@end


