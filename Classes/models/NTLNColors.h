#import <UIKit/UIKit.h>

#define NTLN_COLORS_LIGHT_SCHEME_DEFAULT_ALPHA 0.8f
#define NTLN_COLORS_DARK_SCHEME_DEFAULT_ALPHA 0.6f

@interface NTLNColors : NSObject {
    UIColor *_colorForLink;
    UIColor *_colorForHighlightedLink;
    UIColor *_colorForText;
    UIColor *_colorForHighlightedText;
    UIColor *_colorForSubText;
    UIColor *_colorForSubText2;
    
    UIColor *_colorForReply;
    UIColor *_colorForHighlightedReply;
    UIColor *_colorForProbableReply;
    UIColor *_colorForHighlightedProbableReply;
    UIColor *_colorForHighlightedBackground;
    UIColor *_colorForBackground;
    UIColor *_colorForWarning;
    UIColor *_colorForError;
	
	UIColor *_colorForInputText;
	UIColor *_colorForInputTextBackground;
	
    NSArray *_controlAlternatingRowBackgroundColors;
}
+ (id) instance;
- (void) notifyConfigurationChange;
#pragma mark Foreground Color
- (UIColor*) colorForLink;
- (UIColor*) colorForHighlightedLink;
- (UIColor*) colorForText;
- (UIColor*) colorForHighlightedText;
- (UIColor*) colorForSubText;
- (UIColor*) colorForSubText2;
- (UIColor*) colorForInputText;

#pragma mark Background Color
- (UIColor*) colorForReply;
- (UIColor*) colorForHighlightedReply;
- (UIColor*) colorForProbableReply;
- (UIColor*) colorForHighlightedProbableReply;
- (UIColor*) colorForHighlightedBackground;
- (UIColor*) colorForBackground;
- (UIColor*) colorForWarning;
- (UIColor*) colorForError;
- (UIColor*) colorForInputTextBackground;

- (NSArray*) controlAlternatingRowBackgroundColors;
@end
