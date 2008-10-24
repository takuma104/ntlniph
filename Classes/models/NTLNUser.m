//
//  NTLNUser.m
//  NatsuLion
//
//  Created by 上田 明良 on 08/03/22.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NTLNUser.h"


@implementation NTLNUser
- (void) dealloc {
    [_id release];
    [_name release];
    [_screenName release];
    [_location release];
    [_description release];
    [_icon release];
    [_url release];
    [super dealloc];
}

- (NSString*) id_ {
    return _id;
}

- (void) setId_:(NSString*)id_ {
    _id = id_;
    [_id retain];
}

- (NSString*) name {
    return _name;
}

- (void) setName:(NSString*)name {
    _name = name;
    [_name retain];
}

- (NSString*) screenName {
    return _screenName;
}

- (void) setScreenName:(NSString*)screenName {
    _screenName = screenName;
    [_screenName retain];
}

- (NSString*) location {
    return _location;
}

- (void) setLocation:(NSString*)location {
    _location = location;
    [_location retain];
}

- (NSString*) description {
    return _description;
}

- (void) setDescription:(NSString*)description {
    _description = description;
    [_description retain];
}

- (NSData*) icon {
    return _icon;
}

- (void) setIcon:(NSData*)icon {
    _icon = icon;
    [_icon retain];
}

- (NSString*) url {
    return _url;
}

- (void) setUrl:(NSString*)url {
    _url = url;
    [_url retain];
}

- (BOOL) protected_ {
    return _protected;
}

- (void) setProtected_:(BOOL)protected_ {
    _protected = protected_;
}
@end
