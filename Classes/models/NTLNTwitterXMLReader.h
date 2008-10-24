#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NTLNMessage.h"

@interface NTLNTwitterXMLReader : NSObject {
	NSXMLParser *parser;
	NSMutableString *currentStringValue;
	
	NTLNMessage *currentMessage;
	NSString *currentIconURL;	
	
	BOOL userTag;
	
	NSMutableArray *messages;
}

@property (readonly) NSMutableArray *messages;

- (void)parseXMLData:(NSData *)data;

@end
