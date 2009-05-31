#import "NTLNHttpClientPool.h"
#import "GTMObjectSingleton.h"
#import "NTLNTwitterClient.h"
#import "NTLNIconDownloader.h"
#import "NTLNTwitterUserClient.h"

#define IDLE_CLIENT_NOTIFICATION		@"IDLE_CLIENT_NOTIFICATION"

@implementation NTLNHttpClientPool

GTMOBJECT_SINGLETON_BOILERPLATE(NTLNHttpClientPool, sharedInstance)

- (id)init {
	if (self = [super init]) {
		clientsActive = [[NSMutableArray alloc] init];
		clientsIdle = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	[clientsActive release];
	[clientsIdle release];
	[super dealloc];
}

- (Class)classFromType:(NTLNHttpClientPoolClientType)type {
	switch (type) {
		case NTLNHttpClientPoolClientType_TwitterClient:
			return [NTLNTwitterClient class];
		case NTLNHttpClientPoolClientType_IconDownloader:
			return [NTLNIconDownloader class];
		case NTLNHttpClientPoolClientType_TwitterUserClient:
			return [NTLNTwitterUserClient class];
	}
	return [NSNull class];
}

- (id)idleClientWithType:(NTLNHttpClientPoolClientType)type {
	id ret = nil;
	@synchronized (self) {
		Class klass = [self classFromType:type];
		for (id a in clientsIdle) {
			if ([a isKindOfClass:klass]) {
				[clientsActive addObject:a];
				[clientsIdle removeObject:a];
				ret = a;
				LOG(@"@@ reuse:%p (%@) idle:%d active:%d", ret, [[ret class] description], 
					  clientsIdle.count, clientsActive.count);
				break;
			}
		}
		
		if (ret == nil) {
			ret = [[klass alloc] init];
			[clientsActive addObject:ret];
			LOG(@"@@ alloc:%p (%@) idle:%d active:%d", ret, [[ret class] description], 
				  clientsIdle.count, clientsActive.count);
		}
	}
	
	if (clientsActive.count == 1) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	return ret;
}

- (void)hideNetworkActivityIndicator {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)releaseClient:(id)client {
	@synchronized (self) {
		[clientsIdle addObject:client];
		[clientsActive removeObject:client];
		LOG(@"@@ release:%p (%@) idle:%d active:%d", client, 
			  [[client class] description], clientsIdle.count, clientsActive.count);

		if (clientsActive.count == 0) {
			[NSObject cancelPreviousPerformRequestsWithTarget:self 
													 selector:@selector(hideNetworkActivityIndicator) 
													   object:nil];
			[self performSelector:@selector(hideNetworkActivityIndicator) 
					   withObject:nil 
					   afterDelay:0.3];
		}
		
		NSNotification *notification = [NSNotification notificationWithName:IDLE_CLIENT_NOTIFICATION
																	 object:self];
		[[NSNotificationCenter defaultCenter] postNotification:notification];
	}
}

- (void)removeAllIdleObjects {
	[clientsIdle removeAllObjects];
}

- (int)activeClientCountWithType:(NTLNHttpClientPoolClientType)type {
	int cnt = 0;
	@synchronized (self) {
		Class klass = [self classFromType:type];
		for (id a in clientsActive) {
			if ([a isKindOfClass:klass]) {
				cnt++;
			}
		}
	}
	return cnt;
}

- (void)addIdleClientObserver:(id)observer selector:(SEL)selector {
	[[NSNotificationCenter defaultCenter] addObserver:observer 
											 selector:selector 
												 name:IDLE_CLIENT_NOTIFICATION 
											   object:nil];
}

- (void)removeIdleClientObserver:(id)observer {
	[[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
