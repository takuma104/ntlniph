#import "NTLNTimelineViewController.h"

static BOOL is_badge_unread_message(NTLNMessage *message) {
	return message.replyType == NTLN_MESSAGE_REPLY_TYPE_REPLY ||
	message.replyType == NTLN_MESSAGE_REPLY_TYPE_REPLY_PROBABLE ||
	message.replyType == NTLN_MESSAGE_REPLY_TYPE_DIRECT;
}

@implementation NTLNTimelineViewController(Read)

#pragma mark Private

- (void)checkCellRead {
	if (!enable_read) return;
	
	CGFloat h = 0.0;
	CGFloat viewTop = self.tableView.contentOffset.y;
	CGFloat viewBottom = viewTop + self.tableView.frame.size.height;
	@synchronized(timeline) {
		for (NTLNStatus *s in timeline) {
			if (s.message.status == NTLN_MESSAGE_STATUS_NORMAL) {
				CGFloat top = h + 3.0;
				CGFloat bottom = h + s.cellHeight - 3.0;
				
				if (viewTop <= top && bottom <= viewBottom) {
					[s didAppearWithScrollPos];
				} else {
					[s didDisapper];
				}
			}
			h += s.cellHeight;// + 1.0;
		}
	}
}

#pragma mark NTLNStatusReadProtocol

- (void)incrementReadStatus:(NTLNStatus*)status {
	
	if (badge_enable && is_badge_unread_message(status.message)) {
		unread_count++;
		if (unread_count > 0) {
			super.tabBarItem.badgeValue = [[[NSString alloc] initWithFormat:@"%d", unread_count] autorelease];
		} else {
			super.tabBarItem.badgeValue = nil;
		}
	}
}

- (void)decrementReadStatus:(NTLNStatus*)status {
	
	if (badge_enable && is_badge_unread_message(status.message)) {
		unread_count--;
		if (unread_count > 0) {
			super.tabBarItem.badgeValue = [[[NSString alloc] initWithFormat:@"%d", unread_count] autorelease];
		} else {
			super.tabBarItem.badgeValue = nil;
		}
	}
	
	NSArray *vc = [self.tableView visibleCells];
	for (NTLNStatusCell *cell in vc) {
		if (cell.status == status) {
			[cell updateBackgroundColor];
		}
	}
}

- (BOOL)scrollMoved {
	return scrollMoved;
}

@end