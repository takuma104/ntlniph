#import "NTLNImages.h"

static NTLNImages *_instance;

@implementation NTLNImages

@synthesize unreadDark, unreadLight, starHilighted;
@synthesize iconChat;
@synthesize iconConversation;
@synthesize iconURL;
@synthesize iconSafari;

/*
+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
	
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
*/

+ (id) sharedInstance {
    if (!_instance) {
        _instance = [[[self class] alloc] init];
    }
    return _instance;
}

/*
+ (UIImage*)loadFromResource:(NSString*)name withColor:(UIColor*)color {
	UIImage *img = [UIImage imageNamed:name];
	return [NTLNImages colorizeImage:img color:color];
}

- (void)loadImagesWithPreferences {
	UIColor *color = [UIColor colorWithWhite:1.f alpha:1.f];
	iconChat			= [[NTLNImages loadFromResource:@"icons_03.png" withColor:color] retain];
	iconConversation	= [[NTLNImages loadFromResource:@"icons_03.png" withColor:color] retain];
	iconURL				= [[NTLNImages loadFromResource:@"icons_02.png" withColor:color] retain];
	iconSafari			= [[NTLNImages loadFromResource:@"icons_02.png" withColor:color] retain];
}


- (void)releaseImages {
	[iconChat release];
	[iconConversation release];
	[iconURL release];
	[iconSafari release];
}
*/

- (void)loadImages {
	unreadDark = [[UIImage imageNamed:@"new-dark.png"] retain];
	unreadLight = [[UIImage imageNamed:@"new-light.png"] retain];
	starHilighted = [[UIImage imageNamed:@"star-highlighted.png"] retain];

	iconChat = [[UIImage imageNamed:@"icons_03.png"] retain];
	iconConversation = [[UIImage imageNamed:@"icons_06.png"] retain];
	iconURL = [[UIImage imageNamed:@"icons_02.png"] retain];
	iconSafari = [[UIImage imageNamed:@"icons_02.png"] retain];
	
//	[self loadImagesWithPreferences];
}

- (id)init {
	self = [super init];
	[self loadImages];
	return self;
}

- (void)dealloc {
	[unreadDark release];
	[unreadLight release];
	[starHilighted release];
	
	[iconChat release];
	[iconConversation release];
	[iconURL release];
	[iconSafari release];

//	[self releaseImages];
	
	[super dealloc];
}


@end
