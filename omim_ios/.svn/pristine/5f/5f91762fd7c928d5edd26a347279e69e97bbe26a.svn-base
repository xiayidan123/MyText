//
//  MediaProcessing.h
//  omim
//
//  Created by coca on 2012/10/10.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MediaProcessing;
@class ALAsset;


@protocol MediaProcessingDelegate <NSObject>
@optional
-(void)didFinishProcessing:(MediaProcessing*)delegate;
-(void)didFailedProcessing:(MediaProcessing*)delegate;

@end

@interface MediaProcessing : NSObject
{
    BOOL isConverted;
}
@property (assign,nonatomic) id<MediaProcessingDelegate> delegate;

+ (MediaProcessing *)sharedInstance;

//Convert Video into proper format and save
-(BOOL) convertVideo:(NSURL*) originalfile intoNewVideo:(NSString*)newPath;


+(BOOL)writeMedia:(NSString *)filepath data:(NSData *)data;
+(NSData *)getMediaForFile:(NSString *)mediapath withExtension:(NSString*)ext;

+ (BOOL)writeEventMedia:(NSString *)fileId data:(NSData *)data;
+ (NSData *)getMediaForEvent:(NSString *)fileId withExtension:(NSString *)ext;


// for event
+(NSArray *)savePhotoFromLibraryToLocalEvent:(ALAsset *)asset;

// for moment.
+ (BOOL)writeMomentCoverImage:(NSString *)fileId data:(NSData  *)data;
+(NSData *)getMomentCoverImageForFile:(NSString *)mediapath withExtension:(NSString *)ext;

+(NSArray*)savePhotoFromLibraryToLocal:(ALAsset*)asset;  // return value is a array contains thumbpath and filepath;
+(NSString*)saveVoiceClipToLocal;

+(NSString*)saveCoverImageToLocal:(UIImage*)image;



@end
