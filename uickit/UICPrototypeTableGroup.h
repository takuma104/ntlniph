#import <UIKit/UIKit.h>

@interface UICPrototypeTableGroup : NSObject {
	NSArray *cells;
	NSString *title;
}

+ (id)groupWithCells:(NSArray*)cells withTitle:(NSString*)title;

@property (readonly) NSArray *cells;
@property (readonly) NSString *title;

@end
