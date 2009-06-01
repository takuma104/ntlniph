#import "NTLNTimelineViewController.h"
#import "NTLNTweetViewController.h"

@implementation NTLNTimelineViewController(TableView)

#pragma mark Private

- (CGFloat)cellHeightForIndex:(int)index {
	NTLNStatus *s = [timeline statusAtIndex:index];	
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
	int row = [indexPath row];
	NTLNStatus *s = [timeline statusAtIndex:row];
	BOOL isEven = [timeline isEven:row];
	
	NTLNStatusCell *cell = (NTLNStatusCell*)[tv dequeueReusableCellWithIdentifier:CELL_RESUSE_ID];
	if (cell == nil) {
		cell = [[[NTLNStatusCell alloc] initWithIsEven:isEven] autorelease];
	}
	
	if (disableColorize) {
		[cell setDisableColorize];
	}
	
	[cell updateCell:s isEven:isEven];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self normalScreenTimeline];
	
	NTLNStatus *s = nil;
	@synchronized(timeline) {
		s = [timeline statusAtIndex:[indexPath row]];
	}
	
	NTLNTweetViewController *lvc = [[[NTLNTweetViewController alloc] 
									init] autorelease];
	lvc.message = s.message;
	[[self navigationController] pushViewController:lvc animated:YES];
}

@end