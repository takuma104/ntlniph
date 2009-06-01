#import "NTLNTimelineViewController.h"

@interface NTLNConversationViewController : NTLNTimelineViewController {
	NTLNMessage *rootMessage;
}

@property (readwrite, retain) NTLNMessage *rootMessage;

@end
