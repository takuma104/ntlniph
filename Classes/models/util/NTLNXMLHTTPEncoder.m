#import "NTLNXMLHTTPEncoder.h"


@implementation NTLNXMLHTTPEncoder

+ (NSString*) decodeXML:(NSString*)aString {
    NSMutableString *s = [[aString mutableCopy] autorelease];
    [s replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@" " options:0 range:NSMakeRange(0, [s length])];
    return s;
}

+ (NSString*) encodeHTTP:(NSString*)aString {
	NSString *escaped = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aString, NULL, NULL, kCFStringEncodingUTF8);
	NSMutableString *s = [[escaped mutableCopy] autorelease];
	[s replaceOccurrencesOfString:@"&" withString:@"%26" options:0 range:NSMakeRange(0, [s length])];
	[s replaceOccurrencesOfString:@"+" withString:@"%2B" options:0 range:NSMakeRange(0, [s length])];
	[s replaceOccurrencesOfString:@"?" withString:@"%3F" options:0 range:NSMakeRange(0, [s length])];
	[escaped release];
	return s;
}

@end
