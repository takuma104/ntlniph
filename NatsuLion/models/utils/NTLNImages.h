#import <UIKit/UIKit.h>

@interface NTLNImages : NSObject {
	UIImage *unreadDark;
	UIImage *unreadLight;
	UIImage *starHilighted;

	UIImage *iconChat;
	UIImage *iconConversation;
	UIImage *iconURL;
	UIImage *iconSafari;
}

+ (id) sharedInstance;

@property (readonly) UIImage *unreadDark, *unreadLight, *starHilighted;

@property (readonly) UIImage *iconChat;
@property (readonly) UIImage *iconConversation;
@property (readonly) UIImage *iconURL;
@property (readonly) UIImage *iconSafari;

@end
