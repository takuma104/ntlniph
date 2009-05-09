#import <UIKit/UIKit.h>
#import "NTLNUser.h"
#import "NTLNIconRepository.h"

enum NTLNReplyType {
    NTLN_MESSAGE_REPLY_TYPE_NORMAL = 0,
    NTLN_MESSAGE_REPLY_TYPE_DIRECT,
    NTLN_MESSAGE_REPLY_TYPE_REPLY,
    NTLN_MESSAGE_REPLY_TYPE_REPLY_PROBABLE,
    NTLN_MESSAGE_REPLY_TYPE_MYUPDATE,
};

enum NTLNMessageStatus {
    NTLN_MESSAGE_STATUS_NORMAL = 0,
    NTLN_MESSAGE_STATUS_READ,
};

@class NTLNMessage;

@interface NTLNMessage : NSObject {
    NSString *statusId;
    NSString *name;
    NSString *screenName;
    NSString *text;
	NSString *source;
	NSString *in_reply_to_status_id;
	NSString *in_reply_to_screen_name;
    NSDate *timestamp;
    enum NTLNReplyType replyType;
    enum NTLNMessageStatus status;
    NTLNUser *user;
	BOOL favorited;
	NTLNIconContainer *iconContainer;
}

@property(readwrite, copy) NSString *statusId, *name, *screenName, *text, *source, *in_reply_to_status_id;
@property(readwrite, copy) NSString *in_reply_to_screen_name;
@property(readwrite, retain) NSDate *timestamp;
@property(readwrite) enum NTLNReplyType replyType;
@property(readwrite) enum NTLNMessageStatus status;
@property(readwrite, retain) NTLNUser *user;
@property(readonly) NTLNIconContainer *iconContainer;
@property BOOL favorited;

- (BOOL) isEqual:(id)anObject;
- (void) finishedToSetProperties:(BOOL)forDirectMessage;
- (void) hilightUserReplyWithScreenName:(NSString*)screenName;
- (void) setIconForURL:(NSString*)url;
@end
