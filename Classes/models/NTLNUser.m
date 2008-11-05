#import "NTLNUser.h"

@implementation NTLNUser

@synthesize user_id, screen_name, profile_image_url;

- (void) dealloc {
	[user_id release];
	[screen_name release];
	[profile_image_url release];
    [super dealloc];
}

@end
