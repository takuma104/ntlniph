#import "NTLNTwitterPost.h"
#import "NTLNShardInstance.h"
#import "NTLNCache.h"
#import "NTLNAccount.h"
#import "GTMRegex.h"
#import "NTLNHttpClientPool.h"

static NTLNTwitterPost* shardInstance;

@implementation NTLNTwitterPost

SHARD_INSTANCE_IMPL

@synthesize replyMessage;

- (id)init {
	if (self = [super init]) {
		backupFilename = [[[NTLNCache createTextCacheDirectory] 
						   stringByAppendingString:@"postbackup.txt"] retain];
		
		NSData *d = [NTLNCache loadWithFilename:backupFilename];
		if (d) {
			text = [[[[NSString alloc] initWithData:d 
										   encoding:NSUTF8StringEncoding] autorelease] retain];
		}
	}
	return self;
}

- (void)createReplyPost:(NSString*)reply_to withReplyMessage:(NTLNMessage*)message {
	[replyMessage release];
	replyMessage = [message retain];
	NSString *adding = [reply_to stringByAppendingString:@" "];
	if (text && [text length] > 0) {
		[self updateText:[text stringByAppendingString:adding]];
	} else {
		[self updateText:adding];
	}
}

- (void)createDMPost:(NSString*)reply_to withReplyMessage:(NTLNMessage*)message {
	[replyMessage release];
	replyMessage = [message retain];
	[self updateText:[NSString stringWithFormat:@"d %@ ", reply_to]];
}

- (BOOL)isDirectMessage {
	GTMRegex *regex = [GTMRegex regexWithPattern:@"^(d[[:space:]]).*" 
										 options:kGTMRegexOptionIgnoreCase];
	return [regex matchesString:text];
}

- (BOOL)isValidInReplyToScreenName:(NSString*)screenName {
	NSString *pattern = [NSString stringWithFormat:@"^(@%@[[:space:]]).*", screenName];
	GTMRegex *regex = [GTMRegex regexWithPattern:pattern 
										 options:kGTMRegexOptionSupressNewlineSupport];	
	return [regex matchesString:text];
}

- (void)post {
	NTLNTwitterClient *tc = [[NTLNHttpClientPool sharedInstance] 
							 idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
	tc.delegate = self;
	if (text.length > 0) {
		NSString *footer = [[NTLNAccount sharedInstance] footer];
		if (footer && footer.length > 0 && ! [self isDirectMessage]) {
			[tc post:[NSString stringWithFormat:@"%@ %@", text, footer] reply_id:replyMessage.statusId];
		} else {
			[tc post:text reply_id:replyMessage.statusId];
		}
	}	
}

- (void)backupText {
	[NTLNCache saveWithFilename:backupFilename 
						   data:[text dataUsingEncoding:NSUTF8StringEncoding]];
//	NSLog(@"saved.");
}

- (void)updateText:(NSString*)aText {
	[text release];
	text = [aText retain];
	if (text.length == 0) {
		[replyMessage release];
		replyMessage = nil;
	}
	if (replyMessage) {
		if (! [self isValidInReplyToScreenName:replyMessage.screenName] && ![self isDirectMessage]) {
			[replyMessage release];
			replyMessage = nil;
		}
	}

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(backupText) object:nil];
	[self performSelector:@selector(backupText) withObject:nil afterDelay:1.5];
}

- (NSString*)text {
	return text;
}

- (void)dealloc {
	[text release];
	[backupFilename release];
	[replyMessage release];
	[super dealloc];
}

- (void)twitterClientSucceeded:(NTLNTwitterClient*)sender messages:(NSArray*)statuses {	
	[self updateText:@""];
}

- (void)twitterClientFailed:(NTLNTwitterClient*)sender {
}

- (void)twitterClientBegin:(NTLNTwitterClient*)sender {
	LOG(@"TweetPostView#twitterClientBegin");
}

- (void)twitterClientEnd:(NTLNTwitterClient*)sender {
	LOG(@"TweetPostView#twitterClientEnd");
}


@end
