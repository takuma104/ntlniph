#import "NTLNRateLimit.h"
#import "NTLNShardInstance.h"

static NTLNRateLimit *shardInstance = NULL;

@implementation NTLNRateLimit
@synthesize rate_limit, rate_limit_remaining;
@synthesize rate_limit_reset;

SHARD_INSTANCE_IMPL

- (void)dealloc {
	[rate_limit_reset release];
	[super dealloc];
}

- (void)updateNavigationBarColor:(UINavigationBar*)navBar {
	CGFloat v = 0.f;
	if (rate_limit && 10 > rate_limit_remaining) {
		v = 0.5f;
	}
	CGFloat r = v * (80.f/255.f) + 30.f/255.f;
	CGFloat g = 30.f/255.f;
	CGFloat b = 30.f/255.f;
	navBar.tintColor = [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

@end