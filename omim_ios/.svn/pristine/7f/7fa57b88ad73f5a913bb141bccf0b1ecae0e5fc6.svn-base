//
//  Communicator_GetMomentmediaAliyun.m
//  dev01
//
//  Created by coca on 11/11/14.
//  Copyright (c) 2014 wowtech. All rights reserved.
//

#import "Communicator_GetMomentmediaAliyun.h"
#import "GlobalSetting.h"
#import "MediaProcessing.h"

//#define accessid @"u9HhKKGaN779cDQQ"
//#define accesskey @"E67LFFrjqeSQ4FKmVFhXgpACUrSgEf"
#define accessid S3_ACCESS_KEY
#define accesskey S3_SECRET_ACCESS_KEY

@implementation Communicator_GetMomentmediaAliyun

@synthesize tag;
@synthesize didFinishDelegate;
@synthesize downloadProgressDelegate;
@synthesize userData;



- (void)fInit{
    _client = [[OSSClient alloc] initWithAccessId:accessid andAccessKey:accesskey];
    _client.delegate = self;
    
}

- (id)fGetFileWithPath:(NSString *)path FromBucket:(NSString *)bucket
{
    if(path== nil || bucket== nil)
        return nil;
    
    if (!_client) {
        [self fInit];
    }
    _client.delegate = self;
    [_client fetchObject:bucket key:path];
    
    
    
    //	if (downloadProgressDelegate != nil)
    //        [request setDownloadProgressDelegate:downloadProgressDelegate];
    
    
    return nil;
}

/**
 FetchObject 方法执行成功，返回OSSObject 对象
 @param client OSSClient
 @param result OSSObject
 */
-(void)OSSObjectFetchObjectFinish:(OSSClient*) client result:(OSSObject*) result{
    if(PRINT_LOG)
        NSLog(@"getfile success");
    if(self.isThumb)
        [MediaProcessing writeMedia:[self.file.thumbnailid stringByAppendingPathExtension:self.file.ext] data:result.objectContent];
    
    else
        [MediaProcessing writeMedia:[self.file.fileid stringByAppendingPathExtension:self.file.ext] data:result.objectContent];

    
    if(self.didFinishDelegate)
        [self.didFinishDelegate networkTaskDidFinishWithReturningData:result.objectContent error:nil];
    
}
/**
 FetchObject 方法执行失败，返回OSSError 对象
 @param client OSSClient
 @param error OSSError
 */
-(void)OSSObjectFetchObjectFailed:(OSSClient*) client error:(OSSError*) error{
    if(PRINT_LOG)
        NSLog(@"getfile failed:%@",error.errorMessage);
    if(self.didFinishDelegate)
    {
        if (userData)
            [self.didFinishDelegate didFailNetworkIFCommunicationWithTag:tag withData:error.errorMessage];
        else
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:[NSError errorWithDomain:DEFAULT_DOMAIN code:-10 userInfo:nil]];
    }

}




- (void)dealloc
{
    [_client release];
    _client = nil;
    
    
    
    self.didFinishDelegate = nil;
    self.downloadProgressDelegate = nil;
    [super dealloc];
}
@end