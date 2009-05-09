#import "NTLNCell.h"

@interface NTLNIconTextCell : NTLNCell {
	NSString *text;
	UIImage *icon;
	BOOL isEven;
}

- (void)createCellWithText:(NSString*)text icon:(UIImage*)icon isEven:(BOOL)isEven;

@end
