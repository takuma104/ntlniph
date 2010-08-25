#import <Foundation/Foundation.h>

@interface NetworkActivityIndicator : NSObject {
	int counter;
}

+ (NetworkActivityIndicator*)sharedNetworkActivityIndicator;

- (void)beginAnimation;
- (void)stopAnimation;

@end
