#import <UIKit/UIKit.h>

@interface NTLNAlert : NSObject <UIAlertViewDelegate> {
	BOOL shown;
}

+ (id)instance;
- (void)alert:(NSString*)title withMessage:(NSString*)message;

@end
