//
//  AvatarHelper.h
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AvatarHelper : NSObject

+ (BOOL)writeThumbnailForUser:(NSString *)userid data:(NSData *)data;
+ (NSData *)getThumbnailForUser:(NSString *)userid;

+ (BOOL)writeAvatarForUser:(NSString *)userid data:(NSData *)data;
+ (NSData *)getAvatarForUser:(NSString *)userid;

+ (BOOL)writeThumbnailForFile:(NSString *)thumbpath data:(NSData *)data;
+ (NSData *)getThumbnailForFile:(NSString *)thumbpath;

+ (BOOL)writeImageForFile:(NSString *)imagepath data:(NSData *)data;
+ (NSData *)getImageForFile:(NSString *)imagepath;


+(NSData*)getThumbnailForGroup:(NSString*)groupid;
+(NSData *)getAvatarForGroup:(NSString *)groupid;

+(BOOL)writeAvatarForGroup:(NSString *)groupid data:(NSData *)data;
+(BOOL)writeAvatarThumbnailForGroup:(NSString *)groupid data:(NSData *)data;


// create avatar and thumbnail
+ (UIImage *)getThumbnailFromImage:(UIImage *)image;
+ (UIImage *)getPhotoFromImage:(UIImage *)image;



@end
