#import "NTLNTwitterXMLReader.h"
#import "NTLNXMLHTTPEncoder.h"
#import "NTLNIconRepository.h"
#import "NTLNAccount.h"

#import "GTMNSString+HTML.h"

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

+ (NSString*)decodeSource:(NSString*)str {
	NSRange rgt = [str rangeOfString:@"\">"];
	NSRange rlt = [str rangeOfString:@"</" options:NSBackwardsSearch];
	if (rgt.location != NSNotFound && rlt.location != NSNotFound) {
		int pos = rgt.location + rgt.length;
		NSRange r = NSMakeRange(pos, rlt.location - pos);
		str = [str substringWithRange:r];
	}
	//LOG(@"source: %@", str);
	return str;
}

- (void)parseXMLData:(NSData *)data {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
	[parser parse];
	[parser release];
}

- (void)didParseMessage:(NTLNMessage*)message iconURL:(NSString*)iconURL {
	[message setIconForURL:iconURL];
	if ([currentInReplyToUserId isEqualToString:[[NTLNAccount sharedInstance] userId]]) {
		message.replyType = NTLN_MESSAGE_REPLY_TYPE_REPLY;
	} else {
		[message finishedToSetProperties:currentMsgDirectMessage];
	}
	[messages addObject:message];
}

- (void)dealloc {
	[currentMessage release];
	[currentIconURL release];
	[currentStringValue release];
	[messages release];	
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

	readText = NO;
	
	[currentStringValue release];
	currentStringValue = nil;
	
	BOOL d = [elementName isEqualToString:@"direct_message"];
	
	if ([elementName isEqualToString:@"status"] || d) {
		[currentMessage release];
		currentMessage = [[[NTLNMessage alloc] init] autorelease];
		[currentIconURL release];
		currentIconURL = nil;
		[currentInReplyToUserId release];
		currentInReplyToUserId = nil;
		statusTagChild = YES;
		userTagChild = NO;
		currentMsgDirectMessage = d;
	} else if (currentMessage && ([elementName isEqualToString:@"user"] || [elementName isEqualToString:@"sender"])) {
		statusTagChild = NO;
		userTagChild = YES;
	} else if ([elementName isEqualToString:@"id"] ||
				[elementName isEqualToString:@"text"] ||
				[elementName isEqualToString:@"created_at"] ||
				[elementName isEqualToString:@"favorited"] ||
				[elementName isEqualToString:@"name"] ||
				[elementName isEqualToString:@"source"] ||
				[elementName isEqualToString:@"screen_name"] ||
				[elementName isEqualToString:@"in_reply_to_user_id"] ||
				[elementName isEqualToString:@"in_reply_to_status_id"] ||
			    [elementName isEqualToString:@"in_reply_to_screen_name"] ||
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

//- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString {
//}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (currentMessage) {
		if ([elementName isEqualToString:@"status"] || [elementName isEqualToString:@"direct_message"]) {
			[self didParseMessage:currentMessage iconURL:currentIconURL];
			currentMessage = nil;
			[currentIconURL release];
			currentIconURL = nil;
			[currentInReplyToUserId release];
			currentInReplyToUserId = nil;
			currentMsgDirectMessage = NO;
		} else if (currentMessage && ([elementName isEqualToString:@"user"] || [elementName isEqualToString:@"sender"])) {
			userTagChild = NO;
		}
		
		if (statusTagChild) {
			if ([elementName isEqualToString:@"id"]) {
				[currentMessage setStatusId:currentStringValue];
			} else if ([elementName isEqualToString:@"text"]) {
				NSString *s = [NTLNXMLHTTPEncoder decodeXML:currentStringValue];
				s = [s gtm_stringByUnescapingFromHTML];
				s = [NTLNTwitterXMLReader decodeHeart:s];
				[currentMessage setText:s];
			} else if ([elementName isEqualToString:@"source"]) {
				[currentMessage setSource:[NTLNTwitterXMLReader decodeSource:currentStringValue]];
			} else if ([elementName isEqualToString:@"created_at"]) {
				struct tm time;
				strptime([currentStringValue UTF8String], "%a %b %d %H:%M:%S %z %Y", &time);
				[currentMessage setTimestamp:[NSDate dateWithTimeIntervalSince1970:mktime(&time)]];
			} else if ([elementName isEqualToString:@"favorited"]) {
				if ([currentStringValue isEqualToString:@"true"]) {
					currentMessage.favorited = TRUE;
				}
			} else if ([elementName isEqualToString:@"in_reply_to_status_id"]) {
				currentMessage.in_reply_to_status_id = currentStringValue;
			} else if ([elementName isEqualToString:@"in_reply_to_user_id"]) {
				currentInReplyToUserId = [currentStringValue copy];
			} else if ([elementName isEqualToString:@"in_reply_to_screen_name"]) {
				currentMessage.in_reply_to_screen_name = currentStringValue;
			}
		}

		if (userTagChild) {
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
    
	[currentStringValue release];
    currentStringValue = nil;
}

@end
