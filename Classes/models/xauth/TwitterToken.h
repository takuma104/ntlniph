#import "OAToken.h"

@interface TwitterToken : NSObject {
	NSString *_screenName;
	OAToken *_token;
}

@property (readwrite, retain) NSString *screenName;
@property (readwrite, retain) OAToken *token;

+ (TwitterToken*)tokenWithName:(NSString*)name;
- (void)saveWithName:(NSString*)name;
- (BOOL)isValid;

@end
