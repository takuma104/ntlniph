#import "NTLNStatus.h"
#import "NTLNStatusCell.h"

#define SCROLLPOS_INIT_VALUE	(-10000)

@implementation NTLNStatus
@synthesize message, textHeight, cellHeight, statusRead;

- (NTLNStatus*)initWithMessage:(NTLNMessage*)msg {
	self = [super init];
	message = msg;
	[message retain];
	[self setTextHeight:[NTLNStatusCell getTextboxHeight:msg.text]];
	return self;
}

- (void)dealloc {
	[self stopTimer];
	[message release];
	[super dealloc];
}

- (BOOL)isEqual:(NTLNStatus*)anObject {
	return [self.message isEqual:anObject.message];
}

- (void)setTextHeight:(CGFloat)height {
	textHeight = height;
	height += 24;
	if (height < 52) height = 52;
	cellHeight = height;
}

- (void)didAppearWithScrollPos {
	if (! readTimer) {
		readTimer = [[NSTimer scheduledTimerWithTimeInterval:2.0
                                                      target:self
                                                    selector:@selector(expireReadTimer)
                                                    userInfo:nil
                                                     repeats:NO] retain];
	}
}

- (void)didDisapper {
	[self stopTimer];
}

- (void)stopTimer {
	if (readTimer) {
		[readTimer invalidate];
		[readTimer release];
		readTimer = nil;
	}
}

- (void)expireReadTimer {
	[self stopTimer];
	[self read];
}

- (void)read {
	if (message.status == NTLN_MESSAGE_STATUS_NORMAL) {
		if ([statusRead scrollMoved]) {
			message.status = NTLN_MESSAGE_STATUS_READ;
			[statusRead decrementReadStatus:self];
		}
	}
}

@end
