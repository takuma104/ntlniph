#import "NTLNTimelineViewController.h"
#import "NTLNLinkViewController.h"

@implementation NTLNTimelineViewController(TableView)

#pragma mark Private

- (NTLNStatus*)timelineStatusAtIndex:(int)index {
	int cnt = [timeline count];
	if (index >= 0 && cnt > index) {
		return [timeline objectAtIndex:index];
	}
	return nil;
}

- (CGFloat)cellHeightForIndex:(int)index {
	NTLNStatus *s = [self timelineStatusAtIndex:index];	
	return s.cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 0.0;
	@synchronized(timeline) {
		height = [self cellHeightForIndex:[indexPath row]];
	}
	return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger n = 0;
	@synchronized(timeline) {
		n = [timeline count];
	}
	return n;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NTLNStatus *s = nil;
	int n = 0;
	@synchronized(timeline) {
		s = [self timelineStatusAtIndex:[indexPath row]];
		n = [timeline count];
	}
	
	BOOL isEven = ([indexPath row] % 2 == 0);
	if (n % 2 == 1) isEven = !isEven;
	
	NTLNStatusCell *cell = (NTLNStatusCell*)[tv dequeueReusableCellWithIdentifier:CELL_RESUSE_ID];
	//	NTLNTweetCell *cell = (NTLNTweetCell*)[tv dequeueReusableCellWithIdentifier:CELL_RESUSE_ID];
	if (cell == nil) {
		cell = [[[NTLNStatusCell alloc] initWithIsEven:isEven] autorelease];
		//		cell = [[[NTLNTweetCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_RESUSE_ID] autorelease];
	}
	
	[s.message setIconUpdateDelegate:self];
	[cell updateCell:s isEven:isEven];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self normalScreenTimeline];
	
	NTLNStatus *s = nil;
	@synchronized(timeline) {
		s = [self timelineStatusAtIndex:[indexPath row]];
	}
	
	NTLNLinkViewController *lvc = [[[NTLNLinkViewController alloc] 
									init] autorelease];
	lvc.appDelegate = appDelegate;
	lvc.tweetPostViewController = tweetPostViewController;
	lvc.message = s.message;
	[[self navigationController] pushViewController:lvc animated:YES];
}

@end