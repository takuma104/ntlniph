#import "NTLNColors.h"
#import "NTLNConfiguration.h"

static NTLNColors *_instance;

@implementation NTLNColors

+ (id) instance {
    if (!_instance) {
        _instance = [[[self class] alloc] init];
    }
    return _instance;
}

- (void) releaseColors {
    [_colorForReply release];
    [_colorForHighlightedReply release];
    [_colorForProbableReply release];
    [_colorForHighlightedProbableReply release];
    [_colorForLink release];
    [_colorForHighlightedLink release];
    [_colorForText release];
    [_colorForHighlightedText release];
    [_colorForSubText release];
    [_colorForSubText2 release];
    [_colorForHighlightedBackground release];
    [_colorForBackground release];
    [_controlAlternatingRowBackgroundColors release];
	
	[_colorForInputText release];
	[_colorForInputTextBackground release];
	
}

- (void) setupLightColors {
    [self releaseColors];
    
    float alpha = [[NTLNConfiguration instance] windowAlpha];
    _colorForText = [[UIColor blackColor] retain];
    _colorForHighlightedText = [[UIColor whiteColor] retain];
    _colorForSubText = [[[UIColor blackColor] highlightWithLevel:0.3] retain];
    _colorForSubText2 = [[[UIColor blackColor] highlightWithLevel:0.5] retain];
    _colorForLink = [[UIColor colorWithDeviceRed:0.333 green:0.616 blue:0.902 alpha:1.0] retain];
    _colorForHighlightedLink = [[UIColor colorWithDeviceRed:0.749 green:0.949 blue:1 alpha:1.0] retain];

    _colorForReply = [[UIColor colorWithDeviceHue:0 saturation:0.3 brightness:1 alpha:alpha] retain];
    _colorForHighlightedReply = [[UIColor colorWithDeviceHue:0 saturation:0.55 brightness:1.0 alpha:alpha] retain];
    _colorForProbableReply = [[UIColor colorWithDeviceHue:0.1167 saturation:0.3 brightness:1.0 alpha:alpha] retain];
    _colorForHighlightedProbableReply = [[UIColor colorWithDeviceHue:0.1167 saturation:0.55 brightness:1.0 alpha:alpha] retain];
    _colorForBackground = [[[UIColor whiteColor] colorWithAlphaComponent:alpha] retain];
    _colorForHighlightedBackground = [[[UIColor alternateSelectedControlColor] colorWithAlphaComponent:alpha] retain];
    _colorForWarning = [[UIColor colorWithDeviceHue:0.1167 saturation:0.3 brightness:1.0 alpha:alpha] retain];
    _colorForError = [[UIColor colorWithDeviceHue:0 saturation:0.3 brightness:1 alpha:alpha] retain];
    
	_colorForInputText = [[UIColor controlTextColor] retain];
	_colorForInputTextBackground = [[UIColor controlBackgroundColor] retain];
	
    NSMutableArray *alternatingColors = [[[NSMutableArray alloc] initWithCapacity:2] retain];
    for (UIColor *c in [UIColor controlAlternatingRowBackgroundColors]) {
        [alternatingColors addObject:[c colorWithAlphaComponent:alpha]];
    }
    _controlAlternatingRowBackgroundColors = alternatingColors;
}

- (void) setupDarkColors {
    [self releaseColors];

    float alpha = [[NTLNConfiguration instance] windowAlpha];
    _colorForText = [[UIColor whiteColor] retain];
    _colorForHighlightedText = [[UIColor blackColor] retain];
    _colorForSubText = [[[UIColor whiteColor] shadowWithLevel:0.3] retain];
    _colorForSubText2 = [[[UIColor whiteColor] shadowWithLevel:0.5] retain];
    _colorForLink = [[UIColor colorWithDeviceHue:0.583 saturation:0.61 brightness:0.87 alpha:1.0] retain];
    _colorForHighlightedLink = [[UIColor colorWithDeviceHue:0.583 saturation:0.8 brightness:0.4 alpha:1.0] retain];

    _colorForReply = [[UIColor colorWithDeviceHue:0 saturation:0.55 brightness:0.5 alpha:alpha] retain];
    _colorForHighlightedReply = [[_colorForReply highlightWithLevel:0.4] retain];
    _colorForProbableReply = [[UIColor colorWithDeviceHue:0.1167 saturation:0.55 brightness:0.5 alpha:alpha] retain];
    _colorForHighlightedProbableReply = [[_colorForProbableReply highlightWithLevel:0.5] retain];
    _colorForBackground = [[[UIColor blackColor] colorWithAlphaComponent:alpha] retain];
    _colorForHighlightedBackground = [[_colorForBackground highlightWithLevel:0.5] retain];
    _colorForWarning = [[UIColor colorWithDeviceHue:0.1167 saturation:0.55 brightness:0.5 alpha:alpha] retain];
    _colorForError = [[UIColor colorWithDeviceHue:0 saturation:0.55 brightness:0.5 alpha:alpha] retain];
    
	_colorForInputText = [[UIColor whiteColor] retain];
	_colorForInputTextBackground = [[UIColor blackColor] retain];
	
    _controlAlternatingRowBackgroundColors = [[[NSArray alloc] initWithObjects:
                                              [[UIColor blackColor] colorWithAlphaComponent:alpha],
                                              [[[UIColor blackColor] highlightWithLevel:0.05] colorWithAlphaComponent:alpha],
                                              nil] retain];
    
}

- (void) setupColors {
    if ([[NTLNConfiguration instance] colorScheme] == NTLN_CONFIGURATION_COLOR_SCHEME_LIGHT) {
        [self setupLightColors];
    } else {
        [self setupDarkColors];
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

- (void) notifyConfigurationChange {
    [self setupColors];
}

- (UIColor*) colorForReply {
    return _colorForReply;
}

- (UIColor*) colorForHighlightedReply {
    return _colorForHighlightedReply;
}

- (UIColor*) colorForProbableReply {
    return _colorForProbableReply;
}

- (UIColor*) colorForHighlightedProbableReply {
    return _colorForHighlightedProbableReply;
}

- (UIColor*) colorForLink {
    return _colorForLink;
}

- (UIColor*) colorForHighlightedLink {
    return _colorForHighlightedLink;
}

- (UIColor*) colorForText {
    return _colorForText;
}

- (UIColor*) colorForHighlightedText {
    return _colorForHighlightedText;
}

- (UIColor*) colorForSubText {
    return _colorForSubText;
}

- (UIColor*) colorForSubText2 {
    return _colorForSubText2;
}

- (UIColor*) colorForHighlightedBackground {
    return _colorForHighlightedBackground;
}

- (UIColor*) colorForBackground {
    return _colorForBackground;
}

- (UIColor*) colorForWarning {
    return _colorForWarning;
}

- (UIColor*) colorForError {
    return _colorForError;
}
     
- (NSArray*) controlAlternatingRowBackgroundColors {
    return _controlAlternatingRowBackgroundColors;
}

- (UIColor*) colorForInputText {
	return _colorForInputText;
}

- (UIColor*) colorForInputTextBackground {
	return _colorForInputTextBackground;
}


@end
