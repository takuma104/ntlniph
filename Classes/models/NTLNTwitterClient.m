#import "NTLNTwitterClient.h"
#import "NTLNAccount.h"
#import "NTLNXMLHTTPEncoder.h"
#import "NTLNConfiguration.h"
#import "NTLNTwitterXMLReader.h"
#import "NTLNAlert.h"

@implementation NTLNTwitterClient

@synthesize requestPage;

/// private methods

+ (NSString*)URLForTwitterWithAccount {
	NSString *username = [[NTLNAccount instance] username];
	NSString *password = [[NTLNAccount instance] password];
	return [NSString stringWithFormat:@"http://%@:%@@twitter.com/", username, password];
}

- (void)getTimeline:(NSString*)path page:(int)page {
	NSString* url = [NSString stringWithFormat:@"%@%@.xml", 
					 [NTLNTwitterClient URLForTwitterWithAccount], path];
		
	if (page >= 2) {
		url = [NSString stringWithFormat:@"%@?page=%d", url, page];
	}
	
	requestPage = page;
	parseResultXML = YES;
	requestForTimeline = YES;
	
	if ([[NTLNConfiguration instance] usePost]) {
		[super requestPOST:url body:nil];
	} else {
		[super requestGET:url];
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
			NTLNTwitterXMLReader *xr = [[NTLNTwitterXMLReader alloc] init];
			[xr parseXMLData:recievedData];
			
			if ([xr.messages count] > 0) {
				[delegate twitterClientSucceeded:self messages:xr.messages];
			} else {
				[delegate twitterClientSucceeded:self messages:nil];
			}
			
			[xr release];
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

- (void)getFriendsTimelineWithPage:(int)page {
	[self getTimeline:@"statuses/friends_timeline" page:page];
}

- (void)getRepliesTimelineWithPage:(int)page {
	[self getTimeline:@"statuses/replies" page:page];
}

- (void)getSentsTimelineWithPage:(int)page {
	[self getTimeline:@"statuses/user_timeline" page:page];
}

- (void)getUserTimelineWithScreenName:(NSString*)screenName page:(int)page {
	[screenNameForUserTimeline release];
	screenNameForUserTimeline = screenName;
	[screenNameForUserTimeline retain];
	[self getTimeline:[NSString stringWithFormat:@"statuses/user_timeline/%@", screenName]
				 page:page];
}

- (void)post:(NSString*)tweet {
	NSString* url = [NSString stringWithFormat:@"%@statuses/update.xml", 
						[NTLNTwitterClient URLForTwitterWithAccount]];
    NSString *postString = [NSString stringWithFormat:@"status=%@&source=NatsuLiphone", 
							[NTLNXMLHTTPEncoder encodeHTTP:tweet]];
    [self requestPOST:url body:postString];
}

- (void)createFavoriteWithID:(NSString*)messageId {
	NSString* url = [NSString stringWithFormat:@"%@favorites/create/%@.xml", 
					 [NTLNTwitterClient URLForTwitterWithAccount], messageId];
	
	[self requestPOST:url body:nil];
}

- (void)destroyFavoriteWithID:(NSString*)messageId {
	NSString* url = [NSString stringWithFormat:@"%@favorites/destroy/%@.xml", 
					 [NTLNTwitterClient URLForTwitterWithAccount], messageId];
	[self requestPOST:url body:nil];
}

@end
