#import "NTLNTimelineViewController.h"
#import "NTLNConfiguration.h"

@implementation NTLNTimelineViewController(Timer)

#pragma mark Private

- (void) resetTimer {
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        [_refreshTimer release];
		_refreshTimer = nil;
    }
}

- (void) stopTimer {
    [self resetTimer];
}

- (void) startTimer {
    [self resetTimer];
    
	int refreshInterval = [[NTLNConfiguration instance] refreshIntervalSeconds];
	
    if (refreshInterval < 30) {
        return;
    }
    
	_refreshTimer = [[NSTimer scheduledTimerWithTimeInterval:refreshInterval
                                                      target:self
                                                    selector:@selector(timerExpired)
                                                    userInfo:nil
                                                     repeats:YES] retain];
}

- (void)timerExpired {
	// override by subclass
}


@end