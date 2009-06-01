#import "NTLNTwitterUserXMLReader.h"

@implementation NTLNTwitterUserXMLReader

@synthesize users;

- (void)parseXMLData:(NSData *)data {
	users = [[NSMutableArray alloc] init];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
	[parser parse];
	[parser release];
}

- (void)dealloc {
	[currentStringValue release];
	[user release];
	[users release];
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser 
			didStartElement:(NSString *)elementName 
				namespaceURI:(NSString *)namespaceURI 
				qualifiedName:(NSString *)qName 
				attributes:(NSDictionary *)attributeDict {
	
	readText = NO;
	
	[currentStringValue release];
	currentStringValue = nil;
	readText = NO;

	if ([elementName isEqualToString:@"user"]) {
		[user release];
		user = [[NTLNUser alloc] init];
		userTagChild = YES;
	} else if ([elementName isEqualToString:@"status"]) {
		userTagChild = NO;
	} else if ([elementName isEqualToString:@"id"] ||
				[elementName isEqualToString:@"name"] ||
				[elementName isEqualToString:@"screen_name"] ||
				[elementName isEqualToString:@"profile_image_url"] ||
				[elementName isEqualToString:@"location"] ||
				[elementName isEqualToString:@"description"] ||
				[elementName isEqualToString:@"url"] ||
				[elementName isEqualToString:@"protected"] ||
				[elementName isEqualToString:@"following"] ||
				[elementName isEqualToString:@"followers_count"] ||
				[elementName isEqualToString:@"favourites_count"] ||
				[elementName isEqualToString:@"friends_count"] ||
				[elementName isEqualToString:@"statuses_count"] ) {
		readText = YES;
		currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
	} 
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (readText) {
		[currentStringValue appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser 
			didEndElement:(NSString *)elementName 
			namespaceURI:(NSString *)namespaceURI 
			qualifiedName:(NSString *)qName {
	
	if (userTagChild) {
		if (readText) {
			if ([elementName isEqualToString:@"id"]) {
				user.user_id = currentStringValue;
			} else if ([elementName isEqualToString:@"name"]) {
				user.name = currentStringValue;
			} else if ([elementName isEqualToString:@"screen_name"]) {
				user.screen_name = currentStringValue;
			} else if ([elementName isEqualToString:@"profile_image_url"]) {
				[user setIconForURL:currentStringValue];
			} else if ([elementName isEqualToString:@"location"]) {
				user.location = currentStringValue;
			} else if ([elementName isEqualToString:@"description"]){
				user.description = currentStringValue;
			} else if ([elementName isEqualToString:@"url"]) {
				user.url = currentStringValue;
			} else if ([elementName isEqualToString:@"protected"]) {
				if ([currentStringValue isEqualToString:@"true"]) {
					user.protected_ = YES;
				} else {
					user.protected_ = NO;
				}
			} else if ([elementName isEqualToString:@"following"]) {
				if ([currentStringValue isEqualToString:@"true"]) {
					user.following = YES;
				} else {
					user.following = NO;
				}
			} else if ([elementName isEqualToString:@"followers_count"]) {
				user.followers_count = [currentStringValue intValue];
			} else if ([elementName isEqualToString:@"favourites_count"]) {
				user.favourites_count = [currentStringValue intValue];
			} else if ([elementName isEqualToString:@"friends_count"]) {
				user.friends_count = [currentStringValue intValue];
			} else if ([elementName isEqualToString:@"statuses_count"]) {
				user.statuses_count	= [currentStringValue intValue];
			}
		}
	}
	
	if ([elementName isEqualToString:@"user"]) {
		userTagChild = NO;
		[users addObject:user];
	}
    
	[currentStringValue release];
    currentStringValue = nil;
}

@end
