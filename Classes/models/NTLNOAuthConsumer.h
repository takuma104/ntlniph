#import <Foundation/Foundation.h>

@interface NTLNOAuthConsumer : NSObject {
	UIViewController *rootViewController;
}

+ (NTLNOAuthConsumer*)sharedInstance;
- (void)requestToken:(UIViewController*)viewController;

- (BOOL)isCallbackURL:(NSURL*)url;
- (void)accessToken:(NSURL*)callbackUrl;

@end
