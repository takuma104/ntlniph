#import <UIKit/UIKit.h>

typedef enum {
	NTLNCellTypeNormal,
	NTLNCellTypeNoRound,
	NTLNCellTypeRound,
	NTLNCellTypeRoundSpeech,
	NTLNCellTypeRoundTop,
	NTLNCellTypeRoundBottom,

} NTLNCellType;


@protocol NTLNCellBackgroundDelegate
- (void)drawBackgroundRect:(CGRect)rect;

@end

@interface NTLNCellBackground : UIView
{
	NSObject<NTLNCellBackgroundDelegate> *delegate;
}

- (id)initWithDelegate:(NSObject<NTLNCellBackgroundDelegate>*)delegate;

@end

@interface NTLNCell : UITableViewCell<NTLNCellBackgroundDelegate> {
	NTLNCellType cellType;
	UIColor *bgcolor;
	CGGradientRef gradientForNormal;
}

@property (readwrite) NTLNCellType cellType;
@property (readwrite,assign) UIColor *bgcolor;

- (void)drawRect:(CGRect)rect;
- (void)drawSelectedBackgroundRect:(CGRect)rect;

@end
