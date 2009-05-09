#import <Foundation/Foundation.h>

@interface NSDate(NTLNExtended)
- (NSString*)descriptionWithTwitterStyle;
- (NSString*)descriptionWithNTLNStyle;
- (NSString*)descriptionWithRateLimitRemaining;

@end

