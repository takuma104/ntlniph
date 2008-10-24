#import <UIKit/UIKit.h>
#import "NTLNMessage.h"

@class NTLNStatus;

@protocol NTLNStatusReadProtocol
- (void)incrementReadStatus:(NTLNStatus*)status;
- (void)decrementReadStatus:(NTLNStatus*)status;
- (BOOL)scrollMoved;
@end

@interface NTLNStatus : NSObject {
	NTLNMessage *message;
	CGFloat textHeight;
	CGFloat cellHeight;
	//	NTLNStatusCell *cell;
	NSObject<NTLNStatusReadProtocol> *statusRead;
	NSTimer *readTimer;
}

- (NTLNStatus*)initWithMessage:(NTLNMessage*)msg;
- (void)dealloc;
- (BOOL)isEqual:(NTLNStatus*)anObject;
- (void)setTextHeight:(CGFloat)height;

- (void)didAppearWithScrollPos;
- (void)didDisapper;

- (void)stopTimer;
- (void)read;


@property(readonly) NTLNMessage *message;
@property(readonly) CGFloat textHeight, cellHeight;
@property(readwrite, assign) NSObject<NTLNStatusReadProtocol> *statusRead;

@end
