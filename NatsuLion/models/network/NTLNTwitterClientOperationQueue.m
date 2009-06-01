#import "NTLNTwitterClientOperationQueue.h"
#import "NTLNShardInstance.h"

static NTLNTwitterClientOperationQueue *shardInstance;

@implementation NTLNTwitterClientOperationQueue

@synthesize queue;

SHARD_INSTANCE_IMPL

- (id)init {
	if (self = [super init]) {
		queue = [[NSOperationQueue alloc] init];
	}
	return self;
}

- (void)dealloc {
	[queue release];
	[super dealloc];
}

@end
