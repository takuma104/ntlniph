#import <UIKit/UIKit.h>

@interface NTLNUser : NSObject {
    NSString* _id;
    NSString* _name;
    NSString* _screenName;
    NSString* _location;
    NSString* _description;
    NSData* _icon;
    NSString* _url;
    BOOL _protected;
}

- (NSString*) id_;
- (void) setId_:(NSString*)id_;

- (NSString*) name;
- (void) setName:(NSString*)name;

- (NSString*) screenName;
- (void) setScreenName:(NSString*)screenName;

- (NSString*) location;
- (void) setLocation:(NSString*)location;

- (NSString*) description;
- (void) setDescription:(NSString*)description;

- (NSData*) icon;
- (void) setIcon:(NSData*)icon;

- (NSString*) url;
- (void) setUrl:(NSString*)url;

- (BOOL) protected_;
- (void) setProtected_:(BOOL)protected_;

@end
