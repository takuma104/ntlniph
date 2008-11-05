#import "NTLNTwitterUserClient.h"
#import "NTLNTwitterUserXMLReader.h"

@implementation NTLNTwitterUserClient

@synthesize user;

- (id)init {
	return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(NSObject<NTLNTwitterUserClientDelegate>*)aDelegate {
	if ((self = [super init])) {
		delegate = aDelegate;
		[delegate retain];
	}
	return self;
}

- (void)getUserInfo:(NSString*)q {
	NSString *url = [NSString stringWithFormat:@"http://twitter.com/users/show/%@.xml", q];
	[super requestGET:url];
}

- (void)getUserInfoForScreenName:(NSString*)screen_name {
	[self getUserInfo:screen_name];
}

- (void)getUserInfoForUserId:(NSString*)user_id {
	[self getUserInfo:user_id];
}

- (void)requestSucceeded {
	if (statusCode == 200) {
		if (contentTypeIsXml) {
			NTLNTwitterUserXMLReader *xr = [[NTLNTwitterUserXMLReader alloc] init];
			[xr parseXMLData:recievedData];
			user = [xr.user retain];
			[xr release];
		}
	}
	
	[delegate twitterUserClientSucceeded:self];
	[self autorelease];
}

- (void)requestFailed:(NSError*)error {
	[delegate twitterUserClientFailed:self];
	[self autorelease];
}

@end
