//
//  NSFileManager+extension.m
//  omim
//
//  Created by coca on 2012/12/17.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "NSFileManager+extension.h"
#import "SDKConstant.h"
#import "WTFile.h"

@interface NSFileManager (hiddenhelper)

+(NSString*)calNewAbsouluePathFromOldAbsolutePath:(NSString*)filepath;

+(NSString*)extractRelativePathForFileInDocumentFolderFromAbsolutePath:(NSString*)filepath;


@end

@implementation NSFileManager (extension)


//create the dir.
+ (void)createDirectoryInDocumentsFolderWithName:(NSString *)dirName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *yourDirPath = [documentsDirectory stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL isDirExists = [fileManager fileExistsAtPath:yourDirPath isDirectory:&isDir];
    if (!isDirExists) [fileManager createDirectoryAtPath:yourDirPath withIntermediateDirectories:YES attributes:nil error:nil];
}

+(NSString*)absoluteFilePathForMedia:(WTFile*)file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString* filepath = [[documentsPath stringByAppendingPathComponent:SDK_MOMENT_MEDIA_DIR] stringByAppendingPathComponent:[file.fileid stringByAppendingPathExtension:file.ext]];
    
    return filepath;
    
}

+(NSString*)absoluteFilePathForMediaThumb:(WTFile*)file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    //Warning: have to be careful that the thumbnail extension could only jpg or png.
    
    NSString* filepath = [[documentsPath stringByAppendingPathComponent:SDK_MOMENT_MEDIA_DIR] stringByAppendingPathComponent:[file.thumbnailid stringByAppendingPathExtension:@"jpg"]];
    
    return filepath;
    
}

//get the document path.

+ (NSString *)randomRelativeFilePathInDir:(NSString *)dirname ForFileExtension:(NSString *)extension
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString* filepath = [documentsPath stringByAppendingPathComponent:dirname];
    
    NSString* relativepath = dirname;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL isDirExists = [fileManager fileExistsAtPath:filepath isDirectory:&isDir];
    if (!isDirExists) [fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    
    relativepath = [relativepath stringByAppendingPathComponent:(NSString *)newUniqueIdString];
    if (extension != nil && ![extension isEqualToString:@""])
    {
        relativepath = [relativepath stringByAppendingPathExtension:extension];
    }
    
    
	CFRelease(newUniqueId);
	CFRelease(newUniqueIdString);
    
    return relativepath;

}


+ (NSString *)relativePathToDocumentFolderForFile:(NSString *)filename WithSubFolder:(NSString *)dirname
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *yourDirPath = [documentsDirectory stringByAppendingPathComponent:dirname];
    NSString* relativePath = dirname;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL isDirExists = [fileManager fileExistsAtPath:yourDirPath isDirectory:&isDir];
    if (!isDirExists) [fileManager createDirectoryAtPath:yourDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    relativePath = [relativePath stringByAppendingPathComponent:filename];
    
    return relativePath;

}

+(NSString *)relativePathToDocumentFolderForFile:(NSString *)filename WithSubFolder:(NSString *)dirname withExtention:(NSString *)extension
{
    return [[NSFileManager relativePathToDocumentFolderForFile:filename WithSubFolder:dirname] stringByAppendingPathExtension:extension];
}




+(BOOL)moveFileAtPath:(NSString *)oldPath ToNewPath:(NSString *)newPath
{
    if (oldPath == nil || newPath == nil) {
        return FALSE;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if (![fileManager fileExistsAtPath:oldPath])
    {
        return FALSE;
    }
    
    if ([fileManager fileExistsAtPath:newPath]) {
        return FALSE;
    }
    
    
    [fileManager moveItemAtPath:oldPath toPath:newPath error:&error];
    
    return TRUE ;
    
}

/*this can be move to ABUtil.m  coca*/
+ (void)removeDirectoryInDocumentsFolderWithName:(NSString *)dirName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *yourDirPath = [documentsDirectory stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL isDirExists = [fileManager fileExistsAtPath:yourDirPath isDirectory:&isDir];
    if (isDirExists) [fileManager removeItemAtPath:yourDirPath error:nil];
}


+(BOOL) removeFileAtAbsoulutePath:(NSString *)filepath
{
    NSFileManager *filemgr;
    
    filemgr = [NSFileManager defaultManager];
    
    if (filepath == nil) {
        return FALSE;
    }
    
    if (![filemgr fileExistsAtPath:filepath])
    {
        return TRUE;
    }
    
    if ([filemgr removeItemAtPath: filepath error: NULL]  == YES)
    {
        return TRUE;
    }
    
    else
    {
        return FALSE;
    }
    
    [filemgr release];
}

+(BOOL) removeAllTheFilesInDir:(NSString*) Dirname
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *yourDirPath = [documentsDirectory stringByAppendingPathComponent:Dirname];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    if([fm removeItemAtPath:yourDirPath error:nil])
    {
        //    NSLog (@"Remove all the media caches successful");
        return TRUE;
    }
    else
    {
        //    NSLog (@"failed to Remove the caches ");
        return FALSE;
    }
    
}


+(BOOL) hasFileAtPath:(NSString*)filepath
{
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    if (filepath == nil) {
        return FALSE;
    }
    else if ([filepath isEqualToString:@""]){
        return FALSE;
    }
    else if ([filemgr fileExistsAtPath:filepath])
    {
        NSLog(@"hasFileAtPath:%@",filepath);

        return TRUE;
        
    }
    else
    {
        return FALSE;
    }

}


+(BOOL)mediafileExistedAtPath:(NSString*)filepath
{
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    if (filepath == nil) {
        return FALSE;
    }
    else if ([filepath isEqualToString:@""]){
        return FALSE;
    }
    else if ([filemgr fileExistsAtPath:filepath])
    {
        NSLog(@"mediafileExistedAtPath1:%@",filepath);

        return TRUE;// support old users
        
    }
    else if([filemgr fileExistsAtPath:[NSFileManager absolutePathForFileInDocumentFolder:filepath]]){
        NSLog(@"mediafileExistedAtPath2:%@",[NSFileManager absolutePathForFileInDocumentFolder:filepath]);
        return TRUE;  // for new wowtalker.
    }
    else
    {
        return FALSE;
    }
}

+(NSString*)absolutePathForFileInDocumentFolder:(NSString *)filepath
{
    
    NSRange range = [filepath rangeOfString:@"Documents/"];// detect whether it is a full path or not, support old wowtalk.
    if (range.length == 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullpath = [documentsDirectory stringByAppendingPathComponent:filepath];
        return fullpath;
    }
    else
    {
        return [NSFileManager calNewAbsouluePathFromOldAbsolutePath:filepath];
    }
    
}

+(NSString*)extractRelativePathForFileInDocumentFolderFromAbsolutePath:(NSString *)filepath
{
    NSInteger sleng = [filepath length];
    NSRange range = [filepath rangeOfString:@"Documents/"];
    if (range.length == 0) {
        return filepath;
    }
    else
    {
        NSInteger startpos= range.location + range.length;
        NSRange subrange;
        subrange.length = sleng - startpos;
        subrange.location = startpos;
        NSString* relativepath = [filepath substringWithRange:subrange];
        return relativepath;
    }
    
}

+(NSString*)calNewAbsouluePathFromOldAbsolutePath:(NSString *)filepath
{
    NSString* relativepath = [NSFileManager extractRelativePathForFileInDocumentFolderFromAbsolutePath:filepath];
    
    return [NSFileManager absolutePathForFileInDocumentFolder:relativepath];
    
}

+ (void)storeAnime:(UIImage*)anime InPack:(NSString*)packid withID:(NSString*) stampid
{
    // store the anime self.;
    NSString *dirPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@/%@", @"Documents", @"anime", packid,  @"contents"]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if(![fm fileExistsAtPath:dirPath isDirectory:&isDir])
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *stamppath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", stampid]];
    [UIImagePNGRepresentation(anime) writeToFile:stamppath atomically:YES];
}

+ (void)storeImage:(UIImage*)image InPack:(NSString*)packid withID:(NSString*) stampid
{
    // save th image
    NSString *dirPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@/%@", @"Documents",  @"images", packid,  @"contents"]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if(![fm fileExistsAtPath:dirPath isDirectory:&isDir])
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *stamppath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", stampid]];
    [UIImagePNGRepresentation(image) writeToFile:stamppath atomically:YES];
    
}


@end
