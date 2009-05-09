#import "NTLNTweetPostView.h"
#import "NTLNMessage.h"
#import "NTLNStatus.h"
#import "NTLNStatusCell.h"
#import "NTLNTwitterPost.h"
#import "NTLNTweetQuoteView.h"
#import "NTLNTweetTextView.h"

@interface NTLNTweetPostView(Private)
- (void)layout;

@end

@implementation NTLNTweetPostView

@synthesize textView;
@synthesize textViewDelegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		textView = [[NTLNTweetTextView alloc] initWithFrame:CGRectMake(0, 0, 320-40, 20)];
		textView.font = [UIFont systemFontOfSize:16];
		textView.delegate = self;
		textView.scrollEnabled = YES;
		textView.alwaysBounceVertical = YES;
		[self addSubview:textView];
				
		NTLNMessage *m = [[NTLNTwitterPost shardInstance] replyMessage];
		if (m) {
			NTLNTweetQuoteView *v = [[NTLNTweetQuoteView alloc] initWithFrame:CGRectZero withMessage:m];
			quoteView = [v retain];
			[v setNeedsDisplay];
			[self addSubview:v];
			[v release];
		}

		[self layout];
		self.alwaysBounceVertical = YES;
	}
    return self;
}

- (void)layout {
	if (quoteView) {
		
		CGSize textSize = textView.contentSize;
//		textSize.height -= 16;
		if (textSize.height < 20) {
			textSize.height = 20;
		}
		
//		LOG(@"height: %f %f", textSize.height, textView.contentSize.height);
		
		if(textSize.height > 96) {
			textSize.height = 96;
		}
		
		textView.frame = CGRectMake(0, 0, 320, textSize.height+56);
		CGRect r = quoteView.frame;
		quoteView.frame = CGRectMake(0, textSize.height+40, r.size.width, r.size.height);
		self.contentSize = CGSizeMake(320, textSize.height+r.size.height+40);
		self.scrollEnabled = YES;
	} else {
		textView.frame = CGRectMake(0, 0, 320, 200);
		self.scrollEnabled = NO;
	}
}

- (void)textViewDidChange:(UITextView *)anTextView {
	[textViewDelegate textViewDidChange:anTextView];
	[self layout];
}

- (void)dealloc {
	[textView release];
	[quoteView release];
    [super dealloc];
}

- (void)updateQuoteView {
	if (quoteView) {
		if ([[NTLNTwitterPost shardInstance] replyMessage] == nil) {
			[quoteView removeFromSuperview];
			[quoteView release];
			quoteView = nil;
		}
	}
}

@end
