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

@protocol NTLNMessageIconUpdate
- (void)iconUpdate:(NTLNMessage*)sender;
@end

@interface NTLNMessage : NSObject<NTLNIconDownloadDelegate> {
    NSString *statusId;
    NSString *name;
    NSString *screenName;
    NSString *text;
	NSString *source;
    NSDate *timestamp;
    UIImage *icon;
    enum NTLNReplyType replyType;
    enum NTLNMessageStatus status;
    NTLNUser *user;
	BOOL favorited;
	NSObject<NTLNMessageIconUpdate> *iconUpdateDelegate;
}

@property(readwrite, retain) NSString *statusId, *name, *screenName, *text, *source;
@property(readonly) UIImage *icon;
@property(readwrite, retain) NSDate *timestamp;
@property(readwrite) enum NTLNReplyType replyType;
@property(readwrite) enum NTLNMessageStatus status;
@property(readwrite, retain) NTLNUser *user;
@property BOOL favorited;

- (BOOL) isEqual:(id)anObject;
- (void) finishedToSetProperties;
- (void) hilightUserReplyWithScreenName:(NSString*)screenName;
- (void) setIconForURL:(NSString*)url;
- (void) setIconUpdateDelegate:(NSObject<NTLNMessageIconUpdate>*)iconUpdateDelegate;
@end
