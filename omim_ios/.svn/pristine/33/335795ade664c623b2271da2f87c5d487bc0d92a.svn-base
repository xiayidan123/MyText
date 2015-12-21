//
//  Communicator_UploadFileAliyun.h
//  omimLibrary
//
//  Created by Yi Chen on 6/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOpenServiceSDK/OSS.h>
#import "WowtalkUIDelegates.h"

@class WTFile;
@class CoverImage;

@interface Communicator_UploadFileAliyun : NSObject<NSXMLParserDelegate, OSSClientDelegate>
{
    OSSClient * _client;
    NSMutableString* strFileID;
    
}

@property BOOL isMediaThumbnail;
@property (assign) id<NetworkIFDidFinishDelegate> didFinishDelegate;
@property (assign) id uploadProgressDelegate;

@property (assign) NSInteger tag;
@property (assign) NSObject *userData;

@property (nonatomic, retain) NSMutableString *strFileID;


- (void)fInit;

- (id)fUploadFile:(NSString *)localfilePath toDir:(NSString *)dirPath forBucket:(NSString *)bucket;
-(id)uploadFile:(WTFile*)file toDir:(NSString *)dirPath forBucket:(NSString *)bucket;


- (id)fUploadProfilePhoto:(NSString *)localfilePath toDir:(NSString *)dirPath forBucket:(NSString *)bucket;
-(id)uploadEventMedia:(WTFile*)file toDir:(NSString *)dirPath forBucket:(NSString *)bucket;
-(id)uploadMomentMedia:(WTFile*)file toDir:(NSString *)dirPath forBucket:(NSString *)bucket withExt:(BOOL)withExt;
-(id)uploadCover:(CoverImage*)image toDir:(NSString *)dirPath forBucket:(NSString *)bucket;
-(id)uploadGroupAvatar:(NSString *)localfilePath forGroup:(NSString *)groupid toDir:(NSString *)dirPath forBucket:(NSString *)bucket;
@end
