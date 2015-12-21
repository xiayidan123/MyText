//
//  Communicator_GetEventMedia.m
//  dev01
//
//  Created by jianxd on 14-11-29.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetEventMedia.h"
#import "ASIS3ObjectRequest.h"
#import "WTFile.h"

@interface Communicator_GetEventMedia()
- (void)downloadFiled:(ASIHTTPRequest *)theRequest;
- (void)downloadSuccess:(ASIHTTPRequest *)theRequest;
@end

@implementation Communicator_GetEventMedia
@synthesize request = _request;
@synthesize isThumbnail = _isThumbnail;
@synthesize fileId = _fileId;
@synthesize fileExt = _fileExt;
@synthesize file = _file;
@synthesize didFinishDelegate = _didFinishDelegate;
@synthesize downloadProgressDelegate = _downloadProgressDelegate;

- (void)setS3SecretAccessKey:(NSString *)secretkey andAccessKey:(NSString *)accessKey
{
    if (secretkey == nil || accessKey == nil) {
        return;
    }
    [ASIS3Request setSharedSecretAccessKey:secretkey];
    [ASIS3Request setSharedAccessKey:accessKey];
}

- (id)getFileWithPath:(NSString *)path fromBucket:(NSString *)bucket
{
    if (path == nil || bucket == nil) {
        return nil;
    }
    [_request cancel];
    self.request = [ASIS3ObjectRequest requestWithBucket:bucket key:path];
    if (_downloadProgressDelegate != nil) {
        [self.request setDownloadProgressDelegate:_downloadProgressDelegate];
    }
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(downloadFiled:)];
    [self.request setDidFinishSelector:@selector(downloadSuccess:)];
    [self.request startAsynchronous];
    return _request;
}

- (void)downloadFiled:(ASIHTTPRequest *)theRequest
{
    if (PRINT_LOG) {
        NSLog(@"get file failed : %@", theRequest.responseString);
    }
    if (self.didFinishDelegate) {
        if (theRequest.error) {
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:theRequest.error];
        } else {
            [self.didFinishDelegate networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:DEFAULT_DOMAIN code:-10 userInfo:nil]];
        }
    }
}

- (void)downloadSuccess:(ASIHTTPRequest *)theRequest
{
    if (PRINT_LOG) {
        NSLog(@"get file success");
    }
    NSString *name = nil;
    if (_isThumbnail) {
        name = self.file.thumbnailid;
    } else {
        name = self.file.fileid;
    }
    NSString *fileName = [[name stringByAppendingString:@"."] stringByAppendingString:self.file.ext];
    [MediaProcessing writeEventMedia:fileName data:theRequest.responseData];
    if (self.didFinishDelegate) {
        [self.didFinishDelegate networkTaskDidFinishWithReturningData:theRequest.responseData error:nil];
    }
}

- (void)dealloc
{
    
    [_request release];
    [super dealloc];
}
@end
