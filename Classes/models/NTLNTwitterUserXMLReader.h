#import <UIKit/UIKit.h>
#import "NTLNUser.h"

@interface NTLNTwitterUserXMLReader : NSObject {
	NSMutableString *currentStringValue;
	BOOL userTagChild;
	BOOL readText;

	NTLNUser *user;
}

- (void)parseXMLData:(NSData *)data;

@property (readonly) NTLNUser *user;

@end
