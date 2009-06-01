#import <UIKit/UIKit.h>
#import "NTLNUser.h"

@interface NTLNTwitterUserXMLReader : NSObject {
	NSMutableString *currentStringValue;
	BOOL userTagChild;
	BOOL readText;

	NSMutableArray *users;
	NTLNUser *user;
}

- (void)parseXMLData:(NSData *)data;

@property (readonly) NSMutableArray *users;

@end
