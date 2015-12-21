//
//  AvatarHelper.m
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "AvatarHelper.h"
#import "NSFileManager+extension.h"
#import "SDKConstant.h"

@implementation AvatarHelper
#define SDK_PNG         @"png"

+ (BOOL)writeThumbnailForUser:(NSString *)userid data:(NSData *)data
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:userid WithSubFolder:SDK_AVATAR_THUMB_DIR]; 
    
    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    BOOL isSucc = NO;
    if (absolutepath != nil)
        isSucc = [data writeToFile:absolutepath atomically:YES];
    
    return  isSucc;
}

+ (NSData *)getThumbnailForUser:(NSString *)userid
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:userid WithSubFolder:SDK_AVATAR_THUMB_DIR];
    
    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    NSData *data = nil;
    if (absolutepath != nil)
        data = [NSData dataWithContentsOfFile:absolutepath];
    return data;
}

//+ (NSData *)getThumbnailForSchool:(NSString *)school_id
//{
//    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:school_id WithSubFolder:SDK_AVATAR_THUMB_DIR];
//    
//    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
//    
//    NSData *data = nil;
//    if (absolutepath != nil)
//        data = [NSData dataWithContentsOfFile:absolutepath];
//    return data;
//}



+(NSData*)getThumbnailForGroup:(NSString*)groupid
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:groupid WithSubFolder:SDK_GROUP_AVATAR_THUMB_DIR];
    
    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    NSData *data = nil;
    if (absolutepath != nil)
        data = [NSData dataWithContentsOfFile:absolutepath];
    
    return data;
    
}

+ (NSData *)getAvatarForGroup:(NSString *)groupid
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:groupid WithSubFolder:SDK_GROUP_AVATAR_IMAGE_DIR];
    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    NSData *data = nil;
    if (absolutepath != nil)
        data = [NSData dataWithContentsOfFile:absolutepath];
    return data;
}

+(BOOL)writeAvatarForGroup:(NSString *)groupid data:(NSData *)data
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:groupid WithSubFolder:SDK_GROUP_AVATAR_IMAGE_DIR];
    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    BOOL isSucc = NO;
    if (absolutepath != nil)
        isSucc = [data writeToFile:absolutepath atomically:YES];
    return  isSucc;
}

+(BOOL)writeAvatarThumbnailForGroup:(NSString *)groupid data:(NSData *)data
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:groupid WithSubFolder:SDK_GROUP_AVATAR_THUMB_DIR];
    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    BOOL isSucc = NO;
    if (absolutepath != nil)
        isSucc = [data writeToFile:absolutepath atomically:YES];
    return  isSucc;
}

+ (BOOL)writeAvatarForUser:(NSString *)userid data:(NSData *)data
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:userid WithSubFolder:SDK_AVATAR_IMAGE_DIR];
    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    BOOL isSucc = NO;
    if (absolutepath != nil)
        isSucc = [data writeToFile:absolutepath atomically:YES];
    return  isSucc;
}

+ (NSData *)getAvatarForUser:(NSString *)userid
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:userid WithSubFolder:SDK_AVATAR_IMAGE_DIR ];

    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    NSData *data = nil;
    if (absolutepath != nil)
        data = [NSData dataWithContentsOfFile:absolutepath];
    return data;
}

+ (BOOL)writeThumbnailForFile:(NSString *)thumbpath data:(NSData *)data
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:thumbpath WithSubFolder:SDK_FILE_THUMB_DIR];

    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];

    BOOL isSucc = NO;
    if (absolutepath != nil)
        [data writeToFile:absolutepath atomically:YES];
    
    return  isSucc;
}

+ (NSData *)getThumbnailForFile:(NSString *)thumbpath
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:thumbpath WithSubFolder:SDK_FILE_THUMB_DIR];

    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    NSData *data = nil;
    if (absolutepath != nil)
        data = [NSData dataWithContentsOfFile:absolutepath];
    return data;
}

+ (BOOL)writeImageForFile:(NSString *)imagepath data:(NSData *)data
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:imagepath WithSubFolder:SDK_FILE_IMAGE_DIR];
    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];

    BOOL isSucc = NO;
    if (absolutepath != nil)
        [data writeToFile:absolutepath atomically:YES];
    
    return  isSucc;
}

+ (NSData *)getImageForFile:(NSString *)imagepath
{
    NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:imagepath WithSubFolder:SDK_FILE_IMAGE_DIR];
 
    NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
    
    NSData *data = nil;
    if (absolutepath != nil)
        data = [NSData dataWithContentsOfFile:absolutepath];
    return data;
}


#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

+ (UIImage *)getThumbnailFromImage:(UIImage *)image
{
    CGImageRef imgref = [image CGImage];
    
    CGFloat wbound = CGImageGetWidth(imgref), hbound = CGImageGetHeight(imgref);
    CGFloat xoffset = 0.0f, yoffset = 0.0f;
    if (wbound > hbound)
    {
        if (wbound >= 200)
        {
            xoffset = (wbound - hbound) / 2;
            wbound = hbound;
        }
    }
    else
    {
        if (hbound >= 200)
        {
            yoffset = (hbound - wbound) / 2;
            hbound = wbound;
        }
    }
    
    CGFloat width = 200.0f, height = 200.0f;
    
    // we could think the cgimage drop out the UIImage orientation info. the width is always larger than height.
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(xoffset, yoffset, wbound, hbound));
    //   CGImageRef imageRef = [sourceImage CGImage];
    //   NSLog(@"crop origin x: %f, y: %f", cropRect.origin. x, cropRect.origin.y);
    //      NSLog(@"crop  length: %f, %f",cropRect.size.width, cropRect.size.height);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 800, colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), 800, colorSpaceInfo, bitmapInfo);
        
    }
    
    if (image.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, DEGREES_RADIANS(90));
        CGContextTranslateCTM (bitmap, 0, -200);
    }
    else if (image.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, DEGREES_RADIANS(-90));
        CGContextTranslateCTM (bitmap, -200, 0);
        
    } else if (image.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (image.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, 200, 200);
        CGContextRotateCTM (bitmap, DEGREES_RADIANS(-180));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, 200, 200), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
     CGImageRelease(imageRef);
    
    return newImage;
}

+ (UIImage *)getPhotoFromImage:(UIImage *)image
{
    CGImageRef imgref = [image CGImage];
    
    CGFloat wbound = CGImageGetWidth(imgref), hbound = CGImageGetHeight(imgref);
    CGFloat xoffset = 0.0f, yoffset = 0.0f;
    if (wbound > hbound)
    {
        if (wbound >= 640)
        {
            xoffset = (wbound - hbound) / 2;
            wbound = hbound;
        }
    }
    else
    {
        if (hbound >= 640)
        {
            yoffset = (hbound - wbound) / 2;
            hbound = wbound;
        }
    }
    
    CGFloat width = 640.0f, height = 640.0f;
    
    // we could think the cgimage drop out the UIImage orientation info. the width is always larger than height.
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(xoffset, yoffset, wbound, hbound));
    //   CGImageRef imageRef = [sourceImage CGImage];
    //   NSLog(@"crop origin x: %f, y: %f", cropRect.origin. x, cropRect.origin.y);
    //      NSLog(@"crop  length: %f, %f",cropRect.size.width, cropRect.size.height);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 2560, colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), 2560, colorSpaceInfo, bitmapInfo);
        
    }
    
    if (image.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, DEGREES_RADIANS(90));
        CGContextTranslateCTM (bitmap, 0, -640);
    }
    else if (image.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, DEGREES_RADIANS(-90));
        CGContextTranslateCTM (bitmap, -640, 0);
        
    } else if (image.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (image.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, 640, 640);
        CGContextRotateCTM (bitmap, DEGREES_RADIANS(-180));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, 640, 640), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    CGImageRelease(imageRef);  // added later
    
    return newImage;
}


@end
