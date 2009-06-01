#import "NTLNTwitterClientOperation.h"
//#import "NTLNTwitterXMLReader.h"
#import "NTLNTwitterXMLParser.h"

@implementation NTLNTwitterClientOperation

- (id)initWithClient:(NTLNTwitterClient*)theClient {
	if (self = [super init]) {
		client = [theClient retain];
	}
	return self;	
}

- (void)dealloc {
//	[client release];
	[super dealloc];
}

- (void)main {
	LOG(@"NTLNTwitterClientOperation#main");
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

//	NTLNTwitterXMLReader *xr = [[NTLNTwitterXMLReader alloc] init];
	NTLNTwitterXMLParser *xr = [[NTLNTwitterXMLParser alloc] init];
	[xr parseXMLData:client.recievedData];
	
	if ([xr.messages count] > 0) {
		[client.delegate twitterClientSucceeded:client messages:xr.messages];
	} else {
		[client.delegate twitterClientSucceeded:client messages:nil];
	}
	
	[xr release];

	[client.delegate twitterClientEnd:client];
	[client autorelease];
	
	[pool release];
}

@end
