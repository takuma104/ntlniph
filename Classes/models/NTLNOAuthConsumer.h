#ifdef ENABLE_OAUTH
#import <Foundation/Foundation.h>
#import "OAConsumer.h"

@interface NTLNOAuthConsumer : NSObject {
	UIViewController *rootViewController;
}

+ (NTLNOAuthConsumer*)sharedInstance;

- (OAConsumer*)consumer;

- (void)requestToken:(UIViewController*)viewController;

- (BOOL)isCallbackURL:(NSURL*)url;
- (void)accessToken:(NSURL*)callbackUrl;

@end

#endif
