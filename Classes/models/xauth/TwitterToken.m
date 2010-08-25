#import "TwitterToken.h"

@implementation TwitterToken

@synthesize screenName = _screenName;
@synthesize token = _token;

- (void)dealloc {
	[_screenName release];
	[_token release];
	[super dealloc];
}

+ (NSString*)nameForScreenName:(NSString*)name {
	return [NSString stringWithFormat:@"%@_screenName", name];
}

+ (NSString*)nameForTokenKey:(NSString*)name {
	return [NSString stringWithFormat:@"%@_tokenKey", name];
}

+ (NSString*)nameForTokenSecret:(NSString*)name {
	return [NSString stringWithFormat:@"%@_tokenSecret", name];
}

+ (TwitterToken*)tokenWithName:(NSString*)name {
	NSString *screenName = [[NSUserDefaults standardUserDefaults] 
							objectForKey:[[self class] nameForScreenName:name]];
	NSString *key = [[NSUserDefaults standardUserDefaults] 
					 objectForKey:[[self class] nameForTokenKey:name]];
	NSString *secret = [[NSUserDefaults standardUserDefaults] 
						objectForKey:[[self class] nameForTokenSecret:name]];

	TwitterToken *t = [[[TwitterToken alloc] init] autorelease];
	t.token = [[[OAToken alloc] init] autorelease];
	t.token.key = key;
	t.token.secret = secret;
	t.screenName = screenName;
	return t;
}

- (void)saveWithName:(NSString*)name {
	[[NSUserDefaults standardUserDefaults] setObject:_screenName
											  forKey:[[self class] nameForScreenName:name]];
	[[NSUserDefaults standardUserDefaults] setObject:_token.key
											  forKey:[[self class] nameForTokenKey:name]];
	[[NSUserDefaults standardUserDefaults] setObject:_token.secret
											  forKey:[[self class] nameForTokenSecret:name]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isValid {
	return _screenName.length > 0 &&
		_token.key.length > 0 &&
		_token.secret.length > 0;
}

@end
