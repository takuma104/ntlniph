//
//  NTLNImages.m
//  ntlniph
//
//  Created by Takuma Mori on 08/08/31.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NTLNImages.h"

static NTLNImages *_instance;

@implementation NTLNImages

@synthesize unreadDark, unreadLight, starHilighted;

+ (id) sharedInstance {
    if (!_instance) {
        _instance = [[[self class] alloc] init];
    }
    return _instance;
}

- (void)loadImages {
	unreadDark = [[UIImage imageNamed:@"new-dark.png"] retain];
	unreadLight = [[UIImage imageNamed:@"new-light.png"] retain];
	starHilighted = [[UIImage imageNamed:@"star-highlighted.png"] retain];
}

- (id)init {
	self = [super init];
	[self loadImages];
	return self;
}

- (void)dealloc {
	[unreadDark release];
	[unreadLight release];
	[starHilighted release];
	
	[super dealloc];
}


@end
