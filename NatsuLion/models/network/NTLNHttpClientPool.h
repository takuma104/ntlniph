#import <Foundation/Foundation.h>

typedef enum NTLNHttpClientPoolClientType {
	NTLNHttpClientPoolClientType_TwitterClient,
	NTLNHttpClientPoolClientType_IconDownloader,
	NTLNHttpClientPoolClientType_TwitterUserClient,
} NTLNHttpClientPoolClientType;
		
@interface NTLNHttpClientPool : NSObject {
	NSMutableArray *clientsActive;
	NSMutableArray *clientsIdle;
}

+ (NTLNHttpClientPool*)sharedInstance;

- (id)idleClientWithType:(NTLNHttpClientPoolClientType)type;
- (void)releaseClient:(id)client;
- (void)removeAllIdleObjects;
- (int)activeClientCountWithType:(NTLNHttpClientPoolClientType)type;

- (void)addIdleClientObserver:(id)observer selector:(SEL)selector;
- (void)removeIdleClientObserver:(id)observer;

@end
