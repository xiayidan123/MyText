//
//  NSFileManager+extension.h
//  omim
//
//  Created by coca on 2012/12/17.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTFile;
@interface NSFileManager (extension)

// file/dir method
+ (void) createDirectoryInDocumentsFolderWithName:(NSString *)dirName;  

+ (NSString *)relativePathToDocumentFolderForFile:(NSString*)filename WithSubFolder:(NSString*)dirname;

+ (NSString *)relativePathToDocumentFolderForFile:(NSString*)filename WithSubFolder:(NSString*)dirname withExtention:(NSString*) extension;

+ (NSString*) absolutePathForFileInDocumentFolder:(NSString*)filepath; // return the full path.

+ (NSString *)randomRelativeFilePathInDir:(NSString*)dirname ForFileExtension:(NSString*) extension;  // return a relative path.

+(NSString*)absoluteFilePathForMedia:(WTFile*)file;
+(NSString*)absoluteFilePathForMediaThumb:(WTFile*)file;

// remove files.
+(BOOL) removeFileAtAbsoulutePath:(NSString*) filepath;
+(BOOL) removeAllTheFilesInDir:(NSString*) Dirname;
+(void) removeDirectoryInDocumentsFolderWithName:(NSString *)dirName;

//detect the file exsitence 
+(BOOL) hasFileAtPath:(NSString*)filepath;
+(BOOL) mediafileExistedAtPath:(NSString*)filepath;

// move the file.
+ (BOOL) moveFileAtPath:(NSString*)oldPath ToNewPath:(NSString*)newPath;   // will not replace the exsiting file

+ (void)storeAnime:(UIImage*)anime InPack:(NSString*)packid withID:(NSString*) stampid;

+ (void)storeImage:(UIImage*)image InPack:(NSString*)packid withID:(NSString*) stampid;

@end
