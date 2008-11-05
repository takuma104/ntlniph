#import <UIKit/UIKit.h>

@interface NTLNUser : NSObject {
	@private
	NSString *user_id;
	NSString *screen_name;
	NSString *profile_image_url;
}

@property (readwrite, copy) NSString *user_id;
@property (readwrite, copy) NSString *screen_name;
@property (readwrite, copy) NSString *profile_image_url;

@end
