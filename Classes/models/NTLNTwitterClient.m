#import "NTLNTwitterClient.h"
#import "NTLNAccount.h"
#import "NTLNXMLHTTPEncoder.h"
#import "NTLNConfiguration.h"
#import "NTLNTwitterXMLReader.h"
#import "NTLNAlert.h"

@implementation NTLNTwitterClient

@synthesize requestPage, requestForDirectMessage;

/// private methods

+ (NSString*)URLForTwitterWithAccount {
	return @"http://twitter.com/";
}

- (void)getTimeline:(NSString*)path page:(int)page count:(int)count since_id:(NSString*)since_id forceGet:(BOOL)forceGet {
	NSString* url = [NSString stringWithFormat:@"%@%@.xml?count=%d", 
					 [NTLNTwitterClient URLForTwitterWithAccount], path, count];
		
	if (page >= 2) {
		url = [NSString stringWithFormat:@"%@&page=%d", url, page];
	} else if (since_id) {
		url = [NSString stringWithFormat:@"%@&since_id=%@", url, since_id];
	}
	
	requestPage = page;
	parseResultXML = YES;
	requestForTimeline = YES;
	
	NSString *username = [[NTLNAccount instance] username];
	NSString *password = [[NTLNAccount instance] password];

	if ( !forceGet && [[NTLNConfiguration instance] usePost]) {
		[super requestPOST:url body:nil username:username password:password];
//		[super requestPOST:@"http://www.livedoor.com/" body:nil];
	} else {
		[super requestGET:url username:username password:password];
//		[super requestGET:@"http://www.livedoor.com/"];
	}
	
	[delegate twitterClientBegin:self];
}

- (void) dealloc {
	[delegate release];
	[screenNameForUserTimeline release];
	[super dealloc];
}

- (void)requestSucceeded {

	if (statusCode == 200) {
		if (parseResultXML) {
			if (contentTypeIsXml) {
				NTLNTwitterXMLReader *xr = [[NTLNTwitterXMLReader alloc] init];
				[xr parseXMLData:recievedData];
				
				if ([xr.messages count] > 0) {
					[delegate twitterClientSucceeded:self messages:xr.messages];
				} else {
					[delegate twitterClientSucceeded:self messages:nil];
				}
				
				[xr release];
			} else {
				[[NTLNAlert instance] alert:@"Invaild XML Format" 
								withMessage:@"Twitter responded invalid format message, or please check your network environment."];
				[delegate twitterClientFailed:self];
			}
		} else {
			[delegate twitterClientSucceeded:self messages:nil];
		}
	} else {
		if (statusCode != 304) {
			switch (statusCode) {
				case 401:
				case 403:
					if (screenNameForUserTimeline) {
						[[NTLNAlert instance] alert:@"Protected" 
										withMessage:[NSString 
													 stringWithFormat:@"@%@ has protected their updates.", 
													 screenNameForUserTimeline]];
					} else {
						[[NTLNAlert instance] alert:@"Authorization Failed" 
										withMessage:@"Wrong Username/Email and password combination."];
					}
					break;
				default:
					{
						NSString *msg = [NSString stringWithFormat:@"Twitter responded %d", statusCode];
						if (requestForTimeline) {
							[[NTLNAlert instance] alert:@"Retrieving timeline failed" withMessage:msg];
						} else {
							[[NTLNAlert instance] alert:@"Sending a message failed" withMessage:msg];
						}
					}
					break;
			}
		}
		
		[delegate twitterClientFailed:self];
	}
	
	[delegate twitterClientEnd:self];
	[self autorelease];
}

- (void)requestFailed:(NSError*)error {
	if (error) {
		[[NTLNAlert instance] alert:@"Network error" withMessage:[error localizedDescription]];
	}
	
	[delegate twitterClientFailed:self];
	[delegate twitterClientEnd:self];
	[self autorelease];
}

/// public interfaces

- (id)initWithDelegate:(NSObject<NTLNTwitterClientDelegate>*)aDelegate {
	self = [super init];
	delegate = aDelegate;
	[delegate retain];
	return self;
}

- (void)getFriendsTimelineWithPage:(int)page since_id:(NSString*)since_id {
	[self getTimeline:@"statuses/friends_timeline" 
				 page:page 
				count:[[NTLNConfiguration instance] fetchCount] 
			 since_id:since_id
			 forceGet:NO];
}

- (void)getRepliesTimelineWithPage:(int)page {
	[self getTimeline:@"statuses/replies" 
				 page:page 
				count:20 
			 since_id:nil 
			 forceGet:NO];
}

- (void)getSentsTimelineWithPage:(int)page since_id:(NSString*)since_id {
	[self getTimeline:@"statuses/user_timeline" 
				 page:page 
				count:20 
			 since_id:since_id 
			 forceGet:NO];
}

- (void)getDirectMessagesWithPage:(int)page {
	requestForDirectMessage = YES;
	[self getTimeline:@"direct_messages" 
				 page:page 
				count:20 
			 since_id:nil 
			 forceGet:YES];
}

- (void)getSentDirectMessagesWithPage:(int)page {
	requestForDirectMessage = YES;
	[self getTimeline:@"direct_messages/sent" 
				 page:page 
				count:20 
			 since_id:nil 
			 forceGet:YES];
}

- (void)getUserTimelineWithScreenName:(NSString*)screenName page:(int)page since_id:(NSString*)since_id {
	[screenNameForUserTimeline release];
	screenNameForUserTimeline = screenName;
	[screenNameForUserTimeline retain];
	[self getTimeline:[NSString stringWithFormat:@"statuses/user_timeline/%@", screenName]
				 page:page 
				count:20 
			 since_id:since_id
			 forceGet:NO];
}

- (void)post:(NSString*)tweet {
	NSString* url = [NSString stringWithFormat:@"%@statuses/update.xml", 
						[NTLNTwitterClient URLForTwitterWithAccount]];
    NSString *postString = [NSString stringWithFormat:@"status=%@&source=NatsuLiphone", 
							[NTLNXMLHTTPEncoder encodeHTTP:tweet]];

	NSString *username = [[NTLNAccount instance] username];
	NSString *password = [[NTLNAccount instance] password];

	[self requestPOST:url body:postString username:username password:password];
}

- (void)createFavoriteWithID:(NSString*)messageId {
	NSString* url = [NSString stringWithFormat:@"%@favorites/create/%@.xml", 
					 [NTLNTwitterClient URLForTwitterWithAccount], messageId];
	
	NSString *username = [[NTLNAccount instance] username];
	NSString *password = [[NTLNAccount instance] password];

	[self requestPOST:url body:nil username:username password:password];
}

- (void)destroyFavoriteWithID:(NSString*)messageId {
	NSString* url = [NSString stringWithFormat:@"%@favorites/destroy/%@.xml", 
					 [NTLNTwitterClient URLForTwitterWithAccount], messageId];
	NSString *username = [[NTLNAccount instance] username];
	NSString *password = [[NTLNAccount instance] password];

	[self requestPOST:url body:nil username:username password:password];
}

@end
