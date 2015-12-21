//
//  Communicator_UploadFileAliyun.m
//  omimLibrary
//
//  Created by Yi Chen on 6/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_UploadFileAliyun.h"
#import "WTUserDefaults.h"
#import "GlobalSetting.h"
#import "WTError.h"
#import "NSFileManager+extension.h"
#import "CoverImage.h"
#import "SDKConstant.h"
#import "WTFile.h"


//#define accessid @"u9HhKKGaN779cDQQ"
//#define accesskey @"E67LFFrjqeSQ4FKmVFhXgpACUrSgEf"
#define accessid S3_ACCESS_KEY
#define accesskey S3_SECRET_ACCESS_KEY


// Private stuff


@implementation Communicator_UploadFileAliyun

@synthesize tag;
@synthesize didFinishDelegate;
@synthesize uploadProgressDelegate;
@synthesize strFileID;
@synthesize userData;

/**
 PutObject 方法执行成功，返回PutObjectResult 对象
 @param client OSSClient
 @param result PutObjectResult
 */
-(void)OSSObjectPutObjectFinish:(OSSClient*) client result:(PutObjectResult*) result{

    if(PRINT_LOG)
        NSLog(@"upload file success:%@", strFileID);
    if(self.didFinishDelegate)
    {
        
        [self.didFinishDelegate networkTaskDidFinishWithReturningData:strFileID error:nil];
        
    }
    if (strFileID) {
        [strFileID release];
    }
    
    [self autorelease]; // autorelease itself.

}
/**
 PutObject 方法执行失败，返回OSSError对象
 @param client OSSClient
 @param error OSSError
 */
-(void)OSSObjectPutObjectFailed:(OSSClient*) client error:(OSSError*) error{
    if (error)
        if(PRINT_LOG)
            NSLog(@"upload file failed:%@", [error errorMessage]);
    
    
    if(self.didFinishDelegate)
    {
        [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:[NSError errorWithDomain:@"uploadfile" code:[error errorCode] userInfo:nil]];
    }
    
    [strFileID release];
    
    [self autorelease];  // autorelease itself.
}


- (void)fInit{
    _client = [[OSSClient alloc] initWithAccessId:accessid andAccessKey:accesskey];
    _client.delegate = self;
    
}

- (id)fUploadFile:(NSString *)localfilePath toDir:(NSString *)dirPath forBucket:(NSString *)bucket
{
    if (localfilePath == nil || dirPath == nil || bucket == nil)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:NETWORK_TASK_INPUT_DATA_ERROR userInfo:nil];
        if(self.didFinishDelegate)
        {
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
        }
        return nil;
    }
    
     strFileID = [[NSMutableString alloc] initWithString:[WTUserDefaults getUid]];
    [strFileID appendString:[NSString stringWithFormat:@"_%d", (int)[[NSDate date] timeIntervalSince1970]]];
    [strFileID appendString:[NSString stringWithFormat:@"_%d", (int)arc4random()]];

    
    if (!_client) {
        [self fInit];
    }
    _client.delegate = self;
    ObjectMetadata * objMetadata = [[ObjectMetadata alloc] init];

    [_client putObject:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,strFileID] data:[NSData dataWithContentsOfFile:localfilePath] objectMetadata:objMetadata];

    
    return nil;
}


-(id)uploadFile:(WTFile*)file toDir:(NSString *)dirPath forBucket:(NSString *)bucket
{
    if (file == nil || dirPath == nil || bucket == nil)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:NETWORK_TASK_INPUT_DATA_ERROR userInfo:nil];
        if(self.didFinishDelegate)
        {
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
        }
        return nil;
    }
    
    if (!_client) {
        [self fInit];
    }
    _client.delegate = self;
    ObjectMetadata * objMetadata = [[ObjectMetadata alloc] init];
    
    NSString* localfilePath;
    if (self.isMediaThumbnail) {
        localfilePath = [NSFileManager absoluteFilePathForMediaThumb:file];
        strFileID = [[NSMutableString alloc] initWithString:file.thumbnailid];
    }
    else{
        localfilePath = [NSFileManager absoluteFilePathForMedia:file];
        strFileID = [[NSMutableString alloc] initWithString:file.fileid];
        
    }
    [_client putObject:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,strFileID] data:[NSData dataWithContentsOfFile:localfilePath] objectMetadata:objMetadata];
    
    return nil;
}







-(id)uploadEventMedia:(WTFile*)file toDir:(NSString *)dirPath forBucket:(NSString *)bucket
{
    if (file == nil || dirPath == nil || bucket == nil)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:NETWORK_TASK_INPUT_DATA_ERROR userInfo:nil];
        if(self.didFinishDelegate)
        {
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
        }
        return nil;
    }
    
    if (!_client) {
        [self fInit];
    }
    _client.delegate = self;
    ObjectMetadata * objMetadata = [[ObjectMetadata alloc] init];
    
    NSString* localfilePath;
    if (self.isMediaThumbnail) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        localfilePath = [[documentsPath stringByAppendingPathComponent:SDK_EVENT_MEDIA_DIR] stringByAppendingPathComponent:[file.thumbnailid stringByAppendingPathExtension:file.ext]];
        strFileID = [[NSMutableString alloc] initWithString:file.thumbnailid];
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        localfilePath = [[documentsPath stringByAppendingPathComponent:SDK_EVENT_MEDIA_DIR] stringByAppendingPathComponent:[file.fileid stringByAppendingPathExtension:file.ext]];
        strFileID = [[NSMutableString alloc] initWithString:file.fileid];
        
    }
    [_client putObject:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,strFileID] data:[NSData dataWithContentsOfFile:localfilePath] objectMetadata:objMetadata];
    return nil;
}


-(id)uploadMomentMedia:(WTFile*)file toDir:(NSString *)dirPath forBucket:(NSString *)bucket  withExt:(BOOL)withExt
{
    if (file == nil || dirPath == nil || bucket == nil)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:NETWORK_TASK_INPUT_DATA_ERROR userInfo:nil];
        if(self.didFinishDelegate)
        {
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
        }
        return nil;
    }

    if (!_client) {
        [self fInit];
    }
    _client.delegate = self;
    ObjectMetadata * objMetadata = [[ObjectMetadata alloc] init];
    
    NSString* localfilePath;
    if (self.isMediaThumbnail) {
        localfilePath = [NSFileManager absoluteFilePathForMediaThumb:file];
        strFileID = [[NSMutableString alloc] initWithString:file.thumbnailid];
    }
    else{
        localfilePath = [NSFileManager absoluteFilePathForMedia:file];
        strFileID = [[NSMutableString alloc] initWithString:file.fileid];

    }
    if (withExt) {
         [_client putObject:bucket key:[NSString stringWithFormat:@"%@%@.%@", dirPath,strFileID,file.ext] data:[NSData dataWithContentsOfFile:localfilePath] objectMetadata:objMetadata];
    }
    else{
         [_client putObject:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,strFileID] data:[NSData dataWithContentsOfFile:localfilePath] objectMetadata:objMetadata];
    }
   
    
    return nil;
}




-(id)uploadCover:(CoverImage*)image toDir:(NSString *)dirPath forBucket:(NSString *)bucket
{
    if (image == nil || dirPath == nil || bucket == nil)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:NETWORK_TASK_INPUT_DATA_ERROR userInfo:nil];
        if(self.didFinishDelegate)
        {
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
        }
        return nil;
    }

    if (!_client) {
        [self fInit];
    }
    _client.delegate = self;
    ObjectMetadata * objMetadata = [[ObjectMetadata alloc] init];
    
    NSString* localfilePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:image.file_id
                                                                                                                      WithSubFolder:SDK_MOMENT_COVER_DIR]];
    
    
    strFileID = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", image.file_id]];
    [_client putObject:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,strFileID] data:[NSData dataWithContentsOfFile:localfilePath] objectMetadata:objMetadata];

    
    return nil;
    
}




- (id)fUploadProfilePhoto:(NSString *)localfilePath toDir:(NSString *)dirPath forBucket:(NSString *)bucket
{
    if (localfilePath == nil || dirPath == nil || bucket == nil)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:NETWORK_TASK_INPUT_DATA_ERROR userInfo:nil];
        if(self.didFinishDelegate)
        {
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
        }
        return nil;
    }
    
    if (!_client) {
        [self fInit];
    }
    _client.delegate = self;
    ObjectMetadata * objMetadata = [[ObjectMetadata alloc] init];

    strFileID = [[NSMutableString alloc] initWithString:[WTUserDefaults getUid]];
    [_client putObject:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,strFileID] data:[NSData dataWithContentsOfFile:localfilePath] objectMetadata:objMetadata];
    
//	if (uploadProgressDelegate != nil)
//        [request setUploadProgressDelegate:uploadProgressDelegate];
    
    return nil;
}


-(id)uploadGroupAvatar:(NSString *)localfilePath forGroup:(NSString *)groupid toDir:(NSString *)dirPath forBucket:(NSString *)bucket
{
    if (localfilePath == nil ||groupid==nil ||  dirPath == nil || bucket == nil)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:NETWORK_TASK_INPUT_DATA_ERROR userInfo:nil];
        if(self.didFinishDelegate)
        {
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
        }
        return nil;
    }
    
    
    if (!_client) {
        [self fInit];
    }
    _client.delegate = self;
    ObjectMetadata * objMetadata = [[ObjectMetadata alloc] init];
    
    strFileID = [[NSMutableString alloc] initWithString:groupid];
    [_client putObject:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,strFileID] data:[NSData dataWithContentsOfFile:localfilePath] objectMetadata:objMetadata];
    
    //	if (uploadProgressDelegate != nil)
    //        [request setUploadProgressDelegate:uploadProgressDelegate];
    
    return nil;
}




- (void)dealloc
{
    [_client release];
    _client = nil;
    
    [super dealloc];
}

@end