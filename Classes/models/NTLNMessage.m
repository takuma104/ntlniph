#import "NTLNMessage.h"
#import "NTLNAccount.h"
#import "NTLNIconRepository.h"

@implementation NTLNMessage

@synthesize statusId, name, screenName, text, icon, timestamp, replyType, status, user, source, favorited;

- (void) dealloc {
    [statusId release];
    [name release];
    [screenName release];
    [text release];
    [icon release];
    [timestamp release];
    [source release];
	[iconUpdateDelegate release];
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
    if ([text hasPrefix:[@"@" stringByAppendingString:[[NTLNAccount instance] username]]]) {
        //        NSLog(@"reply");
        return TRUE;
    }
    //    NSLog(@"not reply");
    return FALSE;
}

- (BOOL) isProbablyReplyToMe {
    NSString *query = [@"@" stringByAppendingString:[[NTLNAccount instance] username]];
    NSRange range = [text rangeOfString:query];
    
    if (range.location != NSNotFound) {
        //        NSLog(@"probable reply");
        return TRUE;
    }
    //    NSLog(@"not reply");
    return FALSE;
}

- (BOOL) isMyUpdate {
    return [screenName isEqualToString:[[NTLNAccount instance] username]];
}

- (void) finishedToSetProperties {
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

- (void) hilightUserReplyWithScreenName:(NSString*)aScreenName {
	NSString *query = [@"@" stringByAppendingString:aScreenName];
	NSRange range = [text rangeOfString:query];
	
	if (range.location != NSNotFound) {
		replyType = NTLN_MESSAGE_REPLY_TYPE_REPLY_PROBABLE;
	}
}

- (void) setIconForURL:(NSString*)url {
	UIImage *img = [[NTLNIconRepository instance] imageForURL:url delegate:self];
	if (img) {
		[icon release];
		icon = img;
		[icon retain];
	}
}

- (void) finishedToGetIcon:(NTLNIconContainer*)sender {
	[icon release];
	icon = sender.iconImage;
	[icon retain];
	if (iconUpdateDelegate) {
		[iconUpdateDelegate iconUpdate:self];
		[iconUpdateDelegate release];
		iconUpdateDelegate = nil;
	}
}

- (void) failedToGetIcon:(NTLNIconContainer*)sender {
	[iconUpdateDelegate release];
	iconUpdateDelegate = nil;
}

- (void) setIconUpdateDelegate:(NSObject<NTLNMessageIconUpdate>*)delegate {
	if (icon == nil) {
		[iconUpdateDelegate release];
		iconUpdateDelegate = delegate;
		[iconUpdateDelegate retain];
	}
}

@end
