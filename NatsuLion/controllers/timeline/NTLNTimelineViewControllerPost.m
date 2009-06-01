#import "NTLNTimelineViewController.h"
#import "NTLNTweetPostViewController.h"
#import "NTLNAppDelegate.h"
#import "NTLNConfiguration.h"

@implementation NTLNTimelineViewController(Post)

#pragma mark Private

- (void)setupPostButton {
	UIBarButtonItem *postButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
									target:self 
									action:@selector(postButton:)] autorelease];
	

	if ([[NTLNConfiguration instance] lefthand]) {
		if (! [(NTLNAppDelegate*)[[UIApplication sharedApplication] delegate] 
			   isInMoreTab:self]){
			[[self navigationItem] setLeftBarButtonItem:postButton];
		}
		[[self navigationItem] setRightBarButtonItem:nil];
	} else {
		[[self navigationItem] setLeftBarButtonItem:nil];
		[[self navigationItem] setRightBarButtonItem:postButton];
	}
}

- (void)postButton:(id)sender {
	[NTLNTweetPostViewController present:self.tabBarController];
}

@end