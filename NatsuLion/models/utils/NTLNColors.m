#import "NTLNColors.h"
#import "NTLNConfiguration.h"

static NTLNColors *_instance;

@implementation NTLNColors

@synthesize textForground, textAnnotateForground, oddBackground, evenBackground, 
	replyBackground, probableReplyBackground, directMessageBackground, scrollViewBackground, textSelected, selectedBackground,
	linkBackgroundGradient, linkSelectedBackgroundGradient, timelineSelectedBackgroundGradient;

@synthesize separator;
@synthesize iconOverlayColor;
@synthesize selectedIconOverlayColor;
@synthesize quoteTextColor;
@synthesize quoteBackgroundColor;

+ (id) instance {
    if (!_instance) {
        _instance = [[[self class] alloc] init];
    }
    return _instance;
}

- (void) releaseColors {
	[textForground release];
	[textAnnotateForground release];
	[textSelected release];
	[replyBackground release];
	[probableReplyBackground release];
	[directMessageBackground release];
	[oddBackground release];
	[evenBackground release];
	[scrollViewBackground release];
	[selectedBackground release];
	[iconOverlayColor release];
	[selectedIconOverlayColor release];
	
	CGGradientRelease(linkBackgroundGradient);
	CGGradientRelease(linkSelectedBackgroundGradient);	
	CGColorRelease(separator);
	CGColorRelease(textShadowColor);
	CGColorRelease(quoteTextColor);
	CGColorRelease(quoteBackgroundColor);
}

static CGGradientRef createTwoColorsGradient(int r1, int g1, int b1, int r2, int g2, int b2)
{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[4*2];
	
	colors[0] = (float)r1 / 255.f;
	colors[1] = (float)g1 / 255.f;
	colors[2] = (float)b1 / 255.f;
	colors[3] = 1.f;
	colors[4] = (float)r2 / 255.f;
	colors[5] = (float)g2 / 255.f;
	colors[6] = (float)b2 / 255.f;
	colors[7] = 1.f;
	
	CGGradientRef ret = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);
	return ret;
}

- (void)setupLightGradients {
	linkBackgroundGradient = createTwoColorsGradient(252,252,252,200,200,200);
	linkSelectedBackgroundGradient = createTwoColorsGradient(5,140,245,1,93,230);
	timelineSelectedBackgroundGradient =  createTwoColorsGradient(5,140,245,1,93,230);
}

- (void)setupDarkGradients {
	linkBackgroundGradient = createTwoColorsGradient(61,61,61,24,24,24);
	linkSelectedBackgroundGradient = createTwoColorsGradient(5,140,245,1,93,230);
	timelineSelectedBackgroundGradient =  createTwoColorsGradient(5,140,245,1,93,230);
}

CGColorRef createGrayColor(int rgb255)
{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[4];
	colors[0] = rgb255 / 255.f;
	colors[1] = rgb255 / 255.f;
	colors[2] = rgb255 / 255.f;
	colors[3] = 1.f;
	CGColorRef c = CGColorCreate(rgb, colors);
	CGColorSpaceRelease(rgb);
	return c;
}

CGColorRef createRGBColor(int r, int g, int b)
{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[4];
	colors[0] = r / 255.f;
	colors[1] = g / 255.f;
	colors[2] = b / 255.f;
	colors[3] = 1.f;
	CGColorRef c = CGColorCreate(rgb, colors);
	CGColorSpaceRelease(rgb);
	return c;
}

- (void) setupLightColors {
    [self releaseColors];
	
	textForground			= [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1.0];
	textAnnotateForground	= [[UIColor alloc] initWithWhite:160.f/255.f alpha:1.f];
	textSelected			= [[UIColor alloc] initWithWhite:1.f alpha:1.f];
	
	replyBackground			= [[UIColor alloc] initWithRed:229.f/255.f green:224.f/255.f blue:172.f/255.f alpha:1.f];
	probableReplyBackground = [[UIColor alloc] initWithRed:229.f/255.f green:224.f/255.f blue:172.f/255.f alpha:1.f];
	directMessageBackground	= [[UIColor alloc] initWithRed:143.f/255.f green:204.f/255.f blue:242.f/255.f alpha:1.f];
		
	oddBackground			= [[UIColor alloc] initWithWhite:241.f/255.f alpha:1.f];
	evenBackground			= [[UIColor alloc] initWithWhite:227.f/255.f alpha:1.f];

	scrollViewBackground	= [[UIColor alloc] initWithWhite:42.f/255.f alpha:1.f];
	
	selectedBackground		= [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];

	iconOverlayColor		= [[UIColor alloc] initWithWhite:0.f alpha:1.f];
	selectedIconOverlayColor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
	
	separator				= createGrayColor(208);
	textShadowColor			= createGrayColor(255);
	textShadowSize			= CGSizeMake(0, -1);
	
	quoteTextColor			= createRGBColor(0, 35, 163);
	quoteBackgroundColor	= createGrayColor(200);

	[self setupLightGradients];
}

- (void) setupDarkColors {
    [self releaseColors];

	textForground			= [[UIColor alloc] initWithWhite:250.f/255.f alpha:1.f];
	textAnnotateForground	= [[UIColor alloc] initWithWhite:100.f/255.f alpha:1.f];
	textSelected			= [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	
//	replyBackground			= [[UIColor alloc] initWithRed:89.f/255.f green:73.f/255.f blue:63.f/255.f alpha:1.f];
//	probableReplyBackground = [[UIColor alloc] initWithRed:89.f/255.f green:73.f/255.f blue:63.f/255.f alpha:1.f];

	replyBackground			= [[UIColor alloc] initWithRed:0.5 green:0.2 blue:0.2 alpha:1.0];
	probableReplyBackground	= [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.2 alpha:1.0];	
	directMessageBackground	= [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.5 alpha:1.0];
	
	oddBackground			= [[UIColor alloc] initWithWhite:40.f/255.f alpha:1.f];
	evenBackground			= [[UIColor alloc] initWithWhite:28.f/255.f alpha:1.f];

	scrollViewBackground	= [[UIColor alloc] initWithRed:0.05 green:0.05 blue:0.05 alpha:1.0];

	selectedBackground		= [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];

	iconOverlayColor		=  [[UIColor alloc] initWithWhite:1.f alpha:1.f];
	selectedIconOverlayColor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];

	separator				= createGrayColor(64);
	textShadowColor			= createGrayColor(0);
	textShadowSize			= CGSizeMake(0, -0.5);

	quoteTextColor			= createRGBColor(181, 197, 255);
	quoteBackgroundColor	= createGrayColor(24);

	[self setupDarkGradients];
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

- (void)textShadowBegin:(CGContextRef)context {
	CGContextSetShadowWithColor(context, textShadowSize, 1, textShadowColor);
}

- (void)textShadowEnd:(CGContextRef)context {
	CGContextSetShadowWithColor(context, textShadowSize, 1, NULL);
}


@end
