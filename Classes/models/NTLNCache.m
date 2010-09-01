//
//  NTLNCache.m
//  ntlniph
//
//  Created by Takuma Mori on 08/08/01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NTLNCache.h"


@implementation NTLNCache

+ (NSString*)createDocumentDirectoryWithName:(NSString*)name {
	NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
	[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
	path = [NSString stringWithFormat:@"%@/%@", path, name];
	[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
	return [path stringByAppendingString:@"/"];
}

+ (NSString*)createCacheDirectoryWithName:(NSString*)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
	path = [NSString stringWithFormat:@"%@/%@", path, name];
	[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
	return [path stringByAppendingString:@"/"];
}

+ (NSString*)createIconCacheDirectoryOld {
	return [self createDocumentDirectoryWithName:@"icon_cache"];
}

+ (NSString*)createIconCacheDirectory {
	return [self createCacheDirectoryWithName:@"icon_cache"];
}

+ (NSString*)createArchiverCacheDirectory {
	return [self createDocumentDirectoryWithName:@"archiver_cache"];
}

+ (NSString*)createTextCacheDirectory {
	return [self createDocumentDirectoryWithName:@"text_backup"];
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
	[[NSFileManager defaultManager] removeItemAtPath:[NTLNCache createIconCacheDirectoryOld] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[NTLNCache createIconCacheDirectory] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[NTLNCache createArchiverCacheDirectory] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[NTLNCache createTextCacheDirectory] error:nil];
}

@end
