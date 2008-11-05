#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NTLNMessage.h"

@interface NTLNTwitterXMLReader : NSObject {
	NSMutableString *currentStringValue;
	
	NTLNMessage *currentMessage;
	NSString *currentIconURL;	
	NSString *currentInReplyToUserId;
	
	BOOL statusTagChild;
	BOOL userTagChild;
	BOOL readText;
	BOOL currentMsgDirectMessage;
	
	NSMutableArray *messages;
}

@property (readonly) NSMutableArray *messages;

- (void)parseXMLData:(NSData *)data;

@end
