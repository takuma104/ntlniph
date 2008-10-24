#import <UIKit/UIKit.h>

@interface NTLNXMLHTTPEncoder : NSObject {
}

+ (NSString*) decodeXML:(NSString*)aString;
+ (NSString*) encodeHTTP:(NSString*)aString;

@end
