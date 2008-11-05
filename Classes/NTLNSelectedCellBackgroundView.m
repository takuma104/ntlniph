#import "NTLNSelectedCellBackgroundView.h"
#import "NTLNColors.h"
#import "NTLNCellBackgroundView.h"
#import "NTLNStatusCell.h"

@implementation NTLNSelectedCellBackgroundView

@synthesize status;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	[NTLNCellBackgroundView drawBackground:rect backgroundColor:[[NTLNColors instance] selectedBackground]];
	[NTLNStatusCell drawTexts:status selected:YES];
}

- (void)dealloc {
	[status release];
	[super dealloc];
}

@end
