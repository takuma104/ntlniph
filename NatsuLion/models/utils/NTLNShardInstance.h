#define SHARD_INSTANCE_IMPL \
	+ (id)shardInstance { \
		@synchronized(self) { \
			if (shardInstance == nil) { \
				[[self alloc] init]; \
			} \
		} \
		return shardInstance; \
	} \
 \
	+ (id)allocWithZone:(NSZone *)zone { \
		@synchronized(self) { \
			if (shardInstance == nil) { \
				shardInstance = [super allocWithZone:zone]; \
				return shardInstance; \
			} \
		} \
		return nil; \
	} \
 \
	- (id)copyWithZone:(NSZone *)zone { \
		return self; \
	} \
 \
	- (id)retain { \
		return self; \
	} \
 \
	- (unsigned)retainCount { \
		return UINT_MAX; \
	} \
 \
	- (void)release { \
	} \
 \
	- (id)autorelease { \
		return self; \
	}
