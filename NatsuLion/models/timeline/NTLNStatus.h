#import <UIKit/UIKit.h>
#import "NTLNMessage.h"

@class NTLNStatus;

@interface NTLNStatus : NSObject {
	NTLNMessage *message;
	CGFloat textHeight;
	CGFloat cellHeight;

	int readTrackContinueCounter;
	int readTrackCounter;
}

- (NTLNStatus*)initWithMessage:(NTLNMessage*)msg;
- (void)dealloc;
- (BOOL)isEqual:(NTLNStatus*)anObject;
- (void)setTextHeight:(CGFloat)height;

- (BOOL)markAsRead;

- (int)updateReadTrackCounter:(int)continueCounter;

@property(readonly) NTLNMessage *message;
@property(readonly) CGFloat textHeight, cellHeight;

@end
