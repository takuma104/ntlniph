#import "NTLNCell.h"
#import "NTLNUser.h"
#import "NTLNRoundedIconView.h"

@interface NTLNUserCell : NTLNCell {
	NTLNUser* user;
	BOOL isEven;
	NTLNRoundedIconView *iconView;
}

@property (readonly) NTLNUser* user;

- (void)updateByUser:(NTLNUser*)user isEven:(BOOL)isEven;
- (void)updateIcon;

@end
