#import "NTLNTwitterXMLReader.h"
#import "NTLNXMLHTTPEncoder.h"
#import "NTLNIconRepository.h"

@implementation NTLNTwitterXMLReader

@synthesize messages;

- (id)init {
	self = [super init];
	messages = [[NSMutableArray alloc] init];
	return self;
}

+ (NSString*) decodeHeart:(NSString*)aString {
    NSMutableString *s = [aString mutableCopy];
    [s replaceOccurrencesOfString:@"<3" withString:@"♥" options:0 range:NSMakeRange(0, [s length])];
	[s autorelease];
    return s;
}

- (void)parseXMLData:(NSData *)data {
	[parser release];
	parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
	[parser parse];
}

- (void)didParseMessage:(NTLNMessage*)message iconURL:(NSString*)iconURL {
	[message setIconForURL:iconURL];
	[message finishedToSetProperties];
	[messages addObject:message];
}

- (void)dealloc {
	[parser release];
	[currentMessage release];
	[currentIconURL release];
	[currentStringValue release];
	[messages release];	
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ( [elementName isEqualToString:@"status"]) {
		[currentMessage release];
		currentMessage = [[NTLNMessage alloc] init];
		[currentIconURL release];
		currentIconURL = nil;
		userTag = false;
	} else if ( currentMessage && [elementName isEqualToString:@"user"]) {
		userTag = true;
	}

	[currentStringValue release];
	currentStringValue = [[NSMutableString alloc] initWithCapacity:50];

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[currentStringValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString {
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (currentMessage) {
		if ( [elementName isEqualToString:@"status"]) {
			[self didParseMessage:currentMessage iconURL:currentIconURL];
			currentMessage = nil;
			[currentIconURL release];
			currentIconURL = nil;
		} else if ( currentMessage && [elementName isEqualToString:@"user"]) {
			userTag = false;
		}
		
		if (!userTag) {
			if ([elementName isEqualToString:@"id"]) {
				[currentMessage setStatusId:currentStringValue];
			} else if ([elementName isEqualToString:@"text"]) {
				[currentMessage setText:[NTLNTwitterXMLReader decodeHeart:
										 [NTLNXMLHTTPEncoder decodeXML:currentStringValue]]];
//			} else if ([elementName isEqualToString:@"source"]) {
//				[currentMessage setSource:currentStringValue];
			} else if ([elementName isEqualToString:@"created_at"]) {
				struct tm time;
				strptime([currentStringValue UTF8String], "%a %b %d %H:%M:%S %z %Y", &time);
				[currentMessage setTimestamp:[NSDate dateWithTimeIntervalSince1970:mktime(&time)]];
			} else if ([elementName isEqualToString:@"favorited"]) {
				if ([currentStringValue isEqualToString:@"true"]) {
					currentMessage.favorited = TRUE;
				}
			}
		} else {
			if ([elementName isEqualToString:@"name"]) {
				[currentMessage setName:currentStringValue];
			} else if ([elementName isEqualToString:@"screen_name"]) {
				[currentMessage setScreenName:currentStringValue];
			} else if ([elementName isEqualToString:@"profile_image_url"]) {
				//[currentMessage setName:currentStringValue];
				currentIconURL = currentStringValue;
				[currentIconURL retain];
			}
		}
	}

//	NSLog(@"<%@> : %@", elementName, currentStringValue);
    
	[currentStringValue release];
    currentStringValue = nil;
}

@end
