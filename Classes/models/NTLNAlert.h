#import <UIKit/UIKit.h>

@interface NTLNAlert : NSObject <UIAlertViewDelegate> {

}

+ (id)instance;
- (void)alert:(NSString*)title withMessage:(NSString*)message;

@end
