#import "NTLNTwitterXMLParser.h"
#import "NTLNXMLHTTPEncoder.h"
#import "NTLNIconRepository.h"
#import "NTLNAccount.h"
#import "GTMNSString+HTML.h"

//#define TAGMATCH(v,tag)		(strncmp((const char *)v, tag, sizeof(tag)-1) == 0)
#define TAGMATCH(v,tag)		(strcmp((const char *)v, tag) == 0)

@interface NTLNTwitterXMLParser(Private)
+ (NSString*) decodeHeart:(NSString*)aString;
+ (NSString*)decodeSource:(NSString*)str;

@end
	

static void InitParserContext(ParserContext *p) {
	memset(p, 0, sizeof(*p));
	p->messages = [[NSMutableArray alloc] init];
	p->currentString = [[NSMutableData alloc] init];
}

static void DestroyParserContext(ParserContext *p) {
	[p->currentString release];
	[p->currentMessage release];
	[p->currentIconURL release];
	[p->currentInReplyToUserId release];
	[p->messages release];
	memset(p, 0, sizeof(*p));
}
	
static void startElementSAX(void *ctx, 
							const xmlChar *localname, 
							const xmlChar *prefix, 
							const xmlChar *URI, 
                            int nb_namespaces, 
							const xmlChar **namespaces, 
							int nb_attributes, 
							int nb_defaulted, 
							const xmlChar **attributes) {
	
	ParserContext *p = (ParserContext*)ctx;
	p->readText = NO;
	[p->currentString setLength:0];
	
	BOOL d = TAGMATCH(localname, "direct_message");
	if (TAGMATCH(localname, "status") || d) {
		[p->currentMessage release];
		p->currentMessage = [[NTLNMessage alloc] init];
		[p->currentIconURL release];
		p->currentIconURL = nil;
		[p->currentInReplyToUserId release];
		p->currentInReplyToUserId = nil;
		p->statusTagChild = YES;
		p->userTagChild = NO;
		p->currentMsgDirectMessage = d;
	} else if (p->currentMessage && (TAGMATCH(localname, "user") || TAGMATCH(localname, "sender"))) {
		p->statusTagChild = NO;
		p->userTagChild = YES;
	} else if (TAGMATCH(localname, "id") || 
			   TAGMATCH(localname, "text") || 
			   TAGMATCH(localname, "created_at") || 
			   TAGMATCH(localname, "favorited") || 
			   TAGMATCH(localname, "name") || 
			   TAGMATCH(localname, "source") || 
			   TAGMATCH(localname, "screen_name") || 
			   TAGMATCH(localname, "in_reply_to_user_id") || 
			   TAGMATCH(localname, "in_reply_to_status_id") || 
			   TAGMATCH(localname, "in_reply_to_screen_name") || 
			   TAGMATCH(localname, "profile_image_url")) {
		p->readText = YES;
	}	
}

static void didParseMessage(ParserContext *p) {
	[p->currentMessage setIconForURL:p->currentIconURL];
	[p->currentMessage finishedToSetProperties:p->currentMsgDirectMessage];

	[p->messages addObject:p->currentMessage];

	[p->currentMessage release];
	p->currentMessage = nil;
	
	[p->currentIconURL release];
	p->currentIconURL = nil;

	[p->currentInReplyToUserId release];
	p->currentInReplyToUserId = nil;
	
	p->currentMsgDirectMessage = NO;	
}

static void	endElementSAX(void *ctx, 
						  const xmlChar *localname, 
						  const xmlChar *prefix, 
						  const xmlChar *URI) {    	
	ParserContext *p = (ParserContext*)ctx;
	
	NSString *currentStringValue = nil;
	if (p->readText) {
		currentStringValue = [[NSString alloc] initWithData:p->currentString 
												   encoding:NSUTF8StringEncoding];
		[p->currentString setLength:0];
	}
	
	if (p->currentMessage) {
		if (TAGMATCH(localname, "status") || TAGMATCH(localname, "direct_message")) {
			didParseMessage(p);
		} else if (p->currentMessage && (TAGMATCH(localname, "user") || TAGMATCH(localname, "sender"))) {
			p->userTagChild = NO;
		}
		
		if (p->statusTagChild) {
			if (TAGMATCH(localname, "id")) {
				p->currentMessage.statusId = currentStringValue;
			} else if (TAGMATCH(localname, "text")) {
				NSString *s = [NTLNXMLHTTPEncoder decodeXML:currentStringValue];
				s = [s gtm_stringByUnescapingFromHTML];
				s = [NTLNTwitterXMLParser decodeHeart:s];
				p->currentMessage.text = s;
			} else if (TAGMATCH(localname, "source")) {
				p->currentMessage.source = [NTLNTwitterXMLParser decodeSource:currentStringValue];
			} else if (TAGMATCH(localname, "created_at")) {
				struct tm time;
				strptime([currentStringValue UTF8String], "%a %b %d %H:%M:%S %z %Y", &time);
				p->currentMessage.timestamp = [NSDate dateWithTimeIntervalSince1970:mktime(&time)];
			} else if (TAGMATCH(localname, "favorited")) {
				if ([currentStringValue isEqualToString:@"true"]) {
					p->currentMessage.favorited = TRUE;
				}
			} else if (TAGMATCH(localname, "in_reply_to_status_id")) {
				p->currentMessage.in_reply_to_status_id = currentStringValue;
			} else if (TAGMATCH(localname, "in_reply_to_user_id")) {
				p->currentInReplyToUserId = [currentStringValue retain];
			} else if (TAGMATCH(localname, "in_reply_to_screen_name")) {
				p->currentMessage.in_reply_to_screen_name = currentStringValue;
			}
		}
		
		if (p->userTagChild) {
			if (TAGMATCH(localname, "name")) {
				p->currentMessage.name = currentStringValue;
			} else if (TAGMATCH(localname, "screen_name")) {
				p->currentMessage.screenName = currentStringValue;
			} else if (TAGMATCH(localname, "profile_image_url")) {
				p->currentIconURL = [currentStringValue retain];
			}
		}
	}
    
	[currentStringValue release];
}

static void	charactersFoundSAX(void *ctx, const xmlChar *ch, int len) {
	ParserContext *p = (ParserContext*)ctx;
    [p->currentString appendBytes:(const char *)ch length:len];
}

static void errorEncounteredSAX(void *ctx, const char *msg, ...) {
//	ParserContext *parser = (ParserContext*)ctx;
	NSLog(@"errorEncounteredSAX: %s", msg);
}

static xmlSAXHandler simpleSAXHandlerStruct = {
	NULL,                       /* internalSubset */
	NULL,                       /* isStandalone   */
	NULL,                       /* hasInternalSubset */
	NULL,                       /* hasExternalSubset */
	NULL,                       /* resolveEntity */
	NULL,                       /* getEntity */
	NULL,                       /* entityDecl */
	NULL,                       /* notationDecl */
	NULL,                       /* attributeDecl */
	NULL,                       /* elementDecl */
	NULL,                       /* unparsedEntityDecl */
	NULL,                       /* setDocumentLocator */
	NULL,                       /* startDocument */
	NULL,                       /* endDocument */
	NULL,                       /* startElement*/
	NULL,                       /* endElement */
	NULL,                       /* reference */
	charactersFoundSAX,         /* characters */
	NULL,                       /* ignorableWhitespace */
	NULL,                       /* processingInstruction */
	NULL,                       /* comment */
	NULL,                       /* warning */
	errorEncounteredSAX,        /* error */
	NULL,                       /* fatalError //: unused error() get all the errors */
	NULL,                       /* getParameterEntity */
	NULL,                       /* cdataBlock */
	NULL,                       /* externalSubset */
	XML_SAX2_MAGIC,             //
	NULL,
	startElementSAX,            /* startElementNs */
	endElementSAX,              /* endElementNs */
	NULL,                       /* serror */
};


@implementation NTLNTwitterXMLParser

@synthesize messages;

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

- (id)init {
	if (self = [super init]) {
		InitParserContext(&ctx);
		context = xmlCreatePushParserCtxt(&simpleSAXHandlerStruct, &ctx, NULL, 0, NULL);
	}
	return self;
}

- (void)parseXMLData:(NSData *)data {
	[self parseXMLDataPartial:data];
	[self parseXMLDataPartial:nil];
}

- (void)parseXMLDataPartial:(NSData *)data {
	if (data) {
		xmlParseChunk(context, (const char *)[data bytes], [data length], 0);
	} else {
		xmlParseChunk(context, NULL, 0, 1);
		xmlFreeParserCtxt(context);
		messages = [ctx.messages retain];
	}
}

- (void)dealloc {
	[messages release];
	DestroyParserContext(&ctx);
	[super dealloc];
}

@end
