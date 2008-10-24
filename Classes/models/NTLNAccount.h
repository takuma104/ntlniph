#import <UIKit/UIKit.h>


@interface NTLNAccount : NSObject {
    NSString *_username;
}

+ (id) instance;
+ (id) newInstance;

- (NSString*) username;
- (NSString*) password;

- (void)setUsername:(NSString*)username;
- (void)setPassword:(NSString*)password;
	
- (BOOL) valid;

@end


