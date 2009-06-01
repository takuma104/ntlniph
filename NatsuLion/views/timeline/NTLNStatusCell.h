#import <UIKit/UIKit.h>
#import "NTLNRoundedIconView.h"
#import "NTLNStatus.h"

#define CELL_RESUSE_ID		@"NTLNSTATUSCELL_REUSE_ID"

@interface NTLNStatusCell : UITableViewCell
{
	NTLNRoundedIconView *iconView;
	UIImageView *unreadView, *starView;
	NTLNStatus *status;
	BOOL isEven;
	BOOL disableColorize;
}

@property (readonly) NTLNStatus *status;

+ (UIFont*)textFont;
+ (UIFont*)metaFont;
+ (CGFloat)getTextboxHeight:(NSString *)str;
+ (void)drawTexts:(NTLNStatus*)status selected:(BOOL)selected;
	
- (id)initWithIsEven:(BOOL)iseven;
- (void)updateCell:(NTLNStatus*)status isEven:(BOOL)isEven;
- (void)updateIcon;
- (void)updateBackgroundColor;
- (void)setDisableColorize;

@end

