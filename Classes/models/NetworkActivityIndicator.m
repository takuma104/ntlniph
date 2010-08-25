#import "NetworkActivityIndicator.h"
#import "ObjectSingleton.h"

@implementation NetworkActivityIndicator

OBJECT_SINGLETON_TEMPLATE(NetworkActivityIndicator, sharedNetworkActivityIndicator)

- (void)beginAnimation {
	@synchronized (self) {
		if (counter == 0) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		}
		counter++;
	}
}

- (void)stopAnimation {
	@synchronized (self) {
		if (counter == 1) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
		counter--;
		if (counter < 0) {
			counter = 0;
		}
	}
}

@end
