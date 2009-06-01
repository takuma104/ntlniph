#import "NTLNAlert.h"

static NTLNAlert *_instance;

@implementation NTLNAlert

+ (id) instance {
	@synchronized(self) {
		if (!_instance) {
			_instance = [[[self class] alloc] init];
		}
	}
    return _instance;
}

- (void)alert:(NSString*)title withMessage:(NSString*)message
{
	if (!shown) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title
													message:message
													delegate:self
													cancelButtonTitle:@"OK"
													otherButtonTitles: nil] autorelease];
		shown = YES;
		[alert show];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	shown = NO;
}

@end
