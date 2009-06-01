#import <UIKit/UIKit.h>
#import "NTLNIconRepository.h"

@interface NTLNUser : NSObject {
	@private
	NSString *user_id;
	NSString *name;
	NSString *screen_name;	
	NSString *location;
	NSString *description;
	NSString *url;
	BOOL protected_;
	BOOL following;
	int followers_count;
	int favourites_count;
	int friends_count;
	int statuses_count;
	NTLNIconContainer *iconContainer;
}

@property (readwrite, copy) NSString *user_id;
@property (readwrite, copy) NSString *name;
@property (readwrite, copy) NSString *screen_name;

@property (readwrite, copy) NSString *location;
@property (readwrite, copy) NSString *description;
@property (readwrite, copy) NSString *url;

@property (readwrite) BOOL protected_;
@property (readwrite) BOOL following;
@property (readwrite) int followers_count;
@property (readwrite) int favourites_count;
@property (readwrite) int friends_count;
@property (readwrite) int statuses_count;

@property (readonly) NTLNIconContainer *iconContainer;

- (void) setIconForURL:(NSString*)url;

@end
