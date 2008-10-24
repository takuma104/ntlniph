//
//  NTLNImages.h
//  ntlniph
//
//  Created by Takuma Mori on 08/08/31.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NTLNImages : NSObject {
	UIImage *unreadDark;
	UIImage *unreadLight;
	UIImage *starHilighted;
	
}

+ (id) sharedInstance;

@property (readonly) UIImage *unreadDark, *unreadLight, *starHilighted;

@end
