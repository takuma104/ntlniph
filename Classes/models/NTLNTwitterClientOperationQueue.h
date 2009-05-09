#import <Foundation/Foundation.h>

@interface NTLNTwitterClientOperationQueue : NSObject {
	NSOperationQueue *queue;
}

+ (NTLNTwitterClientOperationQueue*)shardInstance;
@property (readonly) NSOperationQueue *queue;

@end
