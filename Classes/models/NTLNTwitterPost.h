#import <Foundation/Foundation.h>
#import "NTLNTwitterClient.h"
#import "NTLNMessage.h"

@interface NTLNTwitterPost : NSObject<NTLNTwitterClientDelegate> {
	NSString *text;
	NSString *backupFilename;
	NTLNMessage *replyMessage; 
}

@property (readonly) NTLNMessage *replyMessage; 

+ (id)shardInstance;

- (void)updateText:(NSString*)text;
- (void)post;

- (void)createReplyPost:(NSString*)reply_to withReplyMessage:(NTLNMessage*)message;
- (void)createDMPost:(NSString*)reply_to withReplyMessage:(NTLNMessage*)message;

- (NSString*)text;

- (BOOL)isDirectMessage;

- (void)backupText;


@end
