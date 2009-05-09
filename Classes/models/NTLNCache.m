//
//  NTLNCache.m
//  ntlniph
//
//  Created by Takuma Mori on 08/08/01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NTLNCache.h"


@implementation NTLNCache

+ (NSString*)createCacheDirectoryWithName:(NSString*)name {
	NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
	[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
	path = [NSString stringWithFormat:@"%@/%@", path, name];
	[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
	return [path stringByAppendingString:@"/"];
}

+ (NSString*)createIconCacheDirectory {
	return [self createCacheDirectoryWithName:@"icon_cache"];
}

+ (NSString*)createArchiverCacheDirectory {
	return [self createCacheDirectoryWithName:@"archiver_cache"];
}

+ (NSString*)createTextCacheDirectory {
	return [self createCacheDirectoryWithName:@"text_backup"];
}

+ (void)saveWithFilename:(NSString*)filename data:(NSData*)data {
//	LOG(@"Write cache to:%@", filename);
	[[NSFileManager defaultManager] createFileAtPath:filename contents:data attributes:nil];
}

+ (NSData*)loadWithFilename:(NSString*)filename {
	NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:filename];
	NSData *ret = nil;
	if (fh) {
//		LOG(@"Read cache from:%@", filename);
		ret = [fh readDataToEndOfFile];
		[fh closeFile];
		//[ret retain];
		//[fh release];
	}
	return ret;
}

+ (void)removeAllCachedData {
	[[NSFileManager defaultManager] removeItemAtPath:[NTLNCache createIconCacheDirectory] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[NTLNCache createArchiverCacheDirectory] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[NTLNCache createTextCacheDirectory] error:nil];
}

@end
