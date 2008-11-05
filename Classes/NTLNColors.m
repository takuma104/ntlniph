#import "NTLNColors.h"
#import "NTLNConfiguration.h"

static NTLNColors *_instance;

@implementation NTLNColors

@synthesize textForground, textAnnotateForground, textShadow, oddBackground, evenBackground, 
	replyBackground, probableReplyBackground, directMessageBackground, scrollViewBackground, textSelected, selectedBackground;

+ (id) instance {
    if (!_instance) {
        _instance = [[[self class] alloc] init];
    }
    return _instance;
}

- (void) releaseColors {
	[textForground release];
	[textAnnotateForground release];
	[textShadow release];
	[textSelected release];
	[replyBackground release];
	[probableReplyBackground release];
	[directMessageBackground release];
	[oddBackground release];
	[evenBackground release];
	[scrollViewBackground release];
	[selectedBackground release];
}

- (void) setupLightColors {
    [self releaseColors];
	
	textForground			= [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1.0];
	textAnnotateForground	= [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
	textShadow				= [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	textSelected			= [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	
	replyBackground			= [[UIColor alloc] initWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
	probableReplyBackground = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:0.4 alpha:1.0];
	directMessageBackground	= [[UIColor alloc] initWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
	
	const CGFloat odd = 245.f/255.f;
	const CGFloat even = 250.f/255.f;
	const CGFloat bk = 200.f / 255.f;
	
	oddBackground			= [[UIColor alloc] initWithRed:odd green:odd blue:odd alpha:1.0];
	evenBackground			= [[UIColor alloc] initWithRed:even green:even blue:even alpha:1.0];

	scrollViewBackground	= [[UIColor alloc] initWithRed:bk green:bk blue:bk alpha:1.0];
	
	selectedBackground		= [[UIColor alloc] initWithRed:0.3 green:0.3 blue:1.0 alpha:1.0];
}

- (void) setupDarkColors {
    [self releaseColors];

	textForground			= [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	textAnnotateForground	= [[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
	textShadow				= [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
	textSelected			= [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	
	replyBackground			= [[UIColor alloc] initWithRed:0.5 green:0.2 blue:0.2 alpha:1.0];
	probableReplyBackground = [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.2 alpha:1.0];
	directMessageBackground	= [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.5 alpha:1.0];
	
	oddBackground			= [[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
	evenBackground			= [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];

	scrollViewBackground	= [[UIColor alloc] initWithRed:0.05 green:0.05 blue:0.05 alpha:1.0];

	selectedBackground		= [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.6 alpha:1.0];
}

- (void) setupColors {
    if ([[NTLNConfiguration instance] darkColorTheme]) {
        [self setupDarkColors];
    } else {
        [self setupLightColors];
    }
}

- (id) init {
    [self setupColors];
    return self;
}

- (void) dealloc {
    [self releaseColors];
    [super dealloc];
}

@end
