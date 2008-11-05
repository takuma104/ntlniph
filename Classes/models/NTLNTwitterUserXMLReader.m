#import "NTLNTwitterUserXMLReader.h"

@implementation NTLNTwitterUserXMLReader

@synthesize user;

- (void)parseXMLData:(NSData *)data {
	user = [[NTLNUser alloc] init];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
	[parser parse];
	[parser release];
}

- (void)dealloc {
	[currentStringValue release];
	[user release];
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
		userTagChild = YES;
	} else if ([elementName isEqualToString:@"status"]) {
		userTagChild = NO;
	} else if ([elementName isEqualToString:@"id"] ||
				[elementName isEqualToString:@"screen_name"] ||
				[elementName isEqualToString:@"profile_image_url"]) {
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
			} else if ([elementName isEqualToString:@"screen_name"]) {
				user.screen_name = currentStringValue;
			} else if ([elementName isEqualToString:@"profile_image_url"]) {
				user.profile_image_url = currentStringValue;
			}
		} else if ([elementName isEqualToString:@"user"]) {
			userTagChild = NO;
		}
	}
    
	[currentStringValue release];
    currentStringValue = nil;
}

@end
