#import "NTLNURLUtils.h"

@implementation NTLNURLUtils

+ (id) utils {
    return [[[[self class] alloc] init] autorelease];
}

- (NSArray*) tokenize:(NSString*)aString acceptedChars:(NSCharacterSet*)acceptedChars prefix:(NSString*)prefix {
    
    NSMutableArray *back = [NSMutableArray arrayWithCapacity:10];
    
    NSRange startRange = [aString rangeOfString:prefix];
    if (startRange.location == NSNotFound) {
        if ([aString length] > 0) {
            [back addObject:aString];
        }
        return back;
    }
    
    if (startRange.location > 0) {
        [back addObject:[aString substringWithRange:NSMakeRange(0, startRange.location)]];
    }
    
    NSRange searchRange = NSMakeRange(startRange.location + [prefix length], 1);
    while (searchRange.location < [aString length]) {
        NSRange r = [aString rangeOfCharacterFromSet:acceptedChars options:0 range:searchRange];
        if (r.location == NSNotFound) {
            break;
        }
        searchRange.location += r.length;
    }
    
    NSRange targetRange = NSMakeRange(startRange.location, searchRange.location - startRange.location);
    NSString *extracted = [aString substringWithRange:targetRange];
//    NSLog(@"extracted: %@", [aString substringWithRange:targetRange]);
    [back addObject:extracted];
    
    NSArray *subBack = [self tokenize:[aString substringWithRange:
                                       NSMakeRange(targetRange.location + targetRange.length, [aString length] - (targetRange.location + targetRange.length))]
                                     acceptedChars:acceptedChars
                                     prefix:prefix];
    
    [back addObjectsFromArray:subBack];
    
    return back;
}

- (NSArray*) tokenizeByURL:(NSString*)aString {
    
    NSCharacterSet *acceptedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:
                                            @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789;/?:@&=+$,-_.!~*'%"];
    return [self tokenize:aString 
            acceptedChars:acceptedCharacterSet
                   prefix:NTLN_URLEXTRACTOR_PREFIX_HTTP];
}

- (NSArray*) tokenizeByID:(NSString*)aString {

    NSCharacterSet *acceptedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:
                                            @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"];

    return [self tokenize:aString 
            acceptedChars:acceptedCharacterSet
                   prefix:NTLN_URLEXTRACTOR_PREFIX_ID];
    
}

- (NSArray*) tokenizeByAll:(NSString*)aString {
    NSMutableArray *back = [NSMutableArray arrayWithCapacity:100];

    NSArray *tokensById = [[self tokenizeByID:aString] mutableCopy];
    
    int i;
    for (i = 0; i < [tokensById count]; i++) {
        [back addObjectsFromArray:[self tokenizeByURL:[tokensById objectAtIndex:i]]];
    }
	
	[tokensById release];
    
    return back;
}

- (BOOL) isURLToken:(NSString*)token {
    if ([token rangeOfString:NTLN_URLEXTRACTOR_PREFIX_HTTP].location == 0 && [token length] > [NTLN_URLEXTRACTOR_PREFIX_HTTP length]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL) isIDToken:(NSString*)token {
    if ([token rangeOfString:NTLN_URLEXTRACTOR_PREFIX_ID].location == 0  && [token length] > [NTLN_URLEXTRACTOR_PREFIX_ID length]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL) isWhiteSpace:(NSString*)aString {
    unichar space = [@" " characterAtIndex:0];
    int i;
    for (i = 0; i < [aString length]; i++) {
        unichar c = [aString characterAtIndex:i];
        if (c != space) {
            break;
        }
    }
    
    if (i == [aString length]) {
        return TRUE;
    }
    return FALSE;
}

@end
