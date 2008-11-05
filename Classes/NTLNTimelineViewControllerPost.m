#import "NTLNTimelineViewController.h"
#import "NTLNTweetPostViewController.h"

@implementation NTLNTimelineViewController(Post)

#pragma mark Private

- (void)setupPostButton {
	UIBarButtonItem *postButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
									target:self 
									action:@selector(postButton:)] autorelease];
	
	[[self navigationItem] setLeftBarButtonItem:postButton];
}

- (void)postButton:(id)sender {
	[tweetPostViewController showWindow];
}

@end