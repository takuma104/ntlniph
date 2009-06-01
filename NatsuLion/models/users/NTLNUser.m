#import "NTLNUser.h"

@implementation NTLNUser

@synthesize user_id;
@synthesize name;
@synthesize screen_name;
@synthesize location;
@synthesize description;
@synthesize url;
@synthesize protected_;
@synthesize following;
@synthesize followers_count;
@synthesize favourites_count;
@synthesize friends_count;
@synthesize statuses_count;
@synthesize iconContainer;


- (void) dealloc {
	[user_id release];
	[screen_name release];
	[name release];
	[location release];
	[description release];
	[url release];
	[iconContainer release];
    [super dealloc];
}

- (void) setIconForURL:(NSString*)anUrl {
	[iconContainer release];
	NTLNIconContainer *container = [[NTLNIconRepository instance] iconContainerForURL:anUrl];
	iconContainer = [container retain];
}


@end
