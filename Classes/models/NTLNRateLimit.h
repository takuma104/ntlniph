#import <UIKit/UIKit.h>

@interface NTLNRateLimit : NSObject {
	int rate_limit;
	int rate_limit_remaining;
	NSDate *rate_limit_reset;
}

+ (NTLNRateLimit*)shardInstance;
- (void)updateNavigationBarColor:(UINavigationBar*)navBar;

@property (readwrite) int rate_limit;
@property (readwrite) int rate_limit_remaining;
@property (readwrite, retain) NSDate *rate_limit_reset;

@end
