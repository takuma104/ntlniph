#import <UIKit/UIKit.h>
#import "NTLNCell.h"

@interface NTLNLinkTweetCell : NTLNCell {
	NSString *text;
	NSString *footer;
	CGFloat textHeight;
}

- (void)createCellWithText:(NSString*)text footer:(NSString*)footer textHeight:(CGFloat)textHeight;

@end

@interface NTLNLinkNameCell : NTLNCell {
	NSString *name;
	NSString *screenName;
}

- (void)createCellWithName:(NSString*)name screenName:(NSString*)screenName;

@end


