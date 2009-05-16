#import "NTLNMessage.h"
#import "NTLNAccount.h"
#import "NTLNIconRepository.h"

@implementation NTLNMessage

@synthesize statusId, name, screenName, text, timestamp, replyType, status, user, source, 
	in_reply_to_status_id, favorited, iconContainer;
@synthesize in_reply_to_screen_name;


- (void)encodeWithCoder:(NSCoder*)coder {
	[coder encodeObject:statusId forKey:@"statusId"];
	[coder encodeObject:name forKey:@"name"];
	[coder encodeObject:screenName forKey:@"screenName"];
	[coder encodeObject:text forKey:@"text"];
	[coder encodeObject:timestamp forKey:@"timestamp"];
	[coder encodeObject:source forKey:@"source"];
	[coder encodeObject:in_reply_to_status_id forKey:@"in_reply_to_status_id"];
	[coder encodeObject:in_reply_to_screen_name forKey:@"in_reply_to_screen_name"];

	[coder encodeInt:replyType forKey:@"replyType"];
	[coder encodeInt:status forKey:@"status"];
	
	[coder encodeBool:favorited forKey:@"favorited"];

	//	[coder encodeObject:user forKey:@"user"];
	//	[coder encodeObject:iconContainer forKey:@"iconContainer"];

	[coder encodeObject:iconContainer.url forKey:@"iconURL"];
	
	
	LOG(@"*** NTLNMessage save status:%d", status);

}

- (id)initWithCoder:(NSCoder*)decoder {
	if (self = [super init]) {
		statusId				= [[decoder decodeObjectForKey:@"statusId"] retain];
		name					= [[decoder decodeObjectForKey:@"name"] retain];
		screenName				= [[decoder decodeObjectForKey:@"screenName"] retain];
		text					= [[decoder decodeObjectForKey:@"text"] retain];
		timestamp				= [[decoder decodeObjectForKey:@"timestamp"] retain];
		source					= [[decoder decodeObjectForKey:@"source"] retain];
		in_reply_to_status_id	= [[decoder decodeObjectForKey:@"in_reply_to_status_id"] retain];
		in_reply_to_screen_name	= [[decoder decodeObjectForKey:@"in_reply_to_screen_name"] retain];

		replyType				= [decoder decodeIntForKey:@"replyType"];
		status					= [decoder decodeIntForKey:@"status"];
		
		LOG(@"*** NTLNMessage load status:%d", status);
		
		favorited				= [decoder decodeBoolForKey:@"favorited"];
		
		NSString *iconURL		= [decoder decodeObjectForKey:@"iconURL"];
		if (iconURL) {
			iconContainer		= [[[NTLNIconRepository instance] iconContainerForURL:iconURL] retain];
		}
	}
	return self;
}

- (void) dealloc {
    [statusId release];
    [name release];
    [screenName release];
    [text release];
    [timestamp release];
    [source release];
	[in_reply_to_status_id release];
	[in_reply_to_screen_name release];
	[iconContainer release];
    [super dealloc];
}

- (BOOL) isEqual:(id)anObject {
    if ([[self statusId] isEqual:[anObject statusId]]) {
        return TRUE;
    }
    return FALSE;
}

- (void) setStatus:(enum NTLNMessageStatus)value {
    status = value;
}

- (BOOL) isReplyToMe {
    if ([text hasPrefix:[@"@" stringByAppendingString:[[NTLNAccount sharedInstance] screenName]]]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL) isProbablyReplyToMe {
    NSString *query = [@"@" stringByAppendingString:[[NTLNAccount sharedInstance] screenName]];
    NSRange range = [text rangeOfString:query];
    
    if (range.location != NSNotFound) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL) isMyUpdate {
    return [screenName isEqualToString:[[NTLNAccount sharedInstance] screenName]];
}

- (void) finishedToSetProperties:(BOOL)forDirectMessage {
	if (forDirectMessage) {
		replyType = NTLN_MESSAGE_REPLY_TYPE_DIRECT;
	} else {
		/*if ([self isMyUpdate]) {
			replyType = NTLN_MESSAGE_REPLY_TYPE_MYUPDATE;
		} else*/ if ([self isReplyToMe]) {
			replyType = NTLN_MESSAGE_REPLY_TYPE_REPLY;
		} else if ([self isProbablyReplyToMe]) {
			replyType = NTLN_MESSAGE_REPLY_TYPE_REPLY_PROBABLE;
		} else {
			replyType = NTLN_MESSAGE_REPLY_TYPE_NORMAL;
		}
	}
}

- (void) hilightUserReplyWithScreenName:(NSString*)aScreenName {
	NSString *query = [@"@" stringByAppendingString:aScreenName];
	NSRange range = [text rangeOfString:query];
	
	if (range.location != NSNotFound) {
		replyType = NTLN_MESSAGE_REPLY_TYPE_REPLY_PROBABLE;
	}
}

- (void) setIconForURL:(NSString*)url {
	[iconContainer release];
	NTLNIconContainer *container = [[NTLNIconRepository instance] iconContainerForURL:url];
	iconContainer = [container retain];
}


@end
