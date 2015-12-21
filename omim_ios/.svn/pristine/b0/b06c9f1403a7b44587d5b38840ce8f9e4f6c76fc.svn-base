//
//  Communicator_UploadFileS3.m
//  omimLibrary
//
//  Created by Yi Chen on 6/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_UploadFileS3.h"
#import "WTUserDefaults.h"
#import "GlobalSetting.h"
#import "WTError.h"
#import "NSFileManager+extension.h"
#import "CoverImage.h"
#import "SDKConstant.h"
#import "WTFile.h"

// Private stuff
@interface Communicator_UploadFileS3 ()
- (void)uploadFileFailed:(ASIHTTPRequest *)theRequest;
- (void)uploadFileFinished:(ASIHTTPRequest *)theRequest;
- (void)uploadPhotoFailed:(ASIHTTPRequest *)theRequest;
- (void)uploadPhotoFinished:(ASIHTTPRequest *)theRequest;

-(void)uploadMediaFileFinished:(ASIHTTPRequest *)theRequest;
-(void)uploadMediaFileFailed:(ASIHTTPRequest *)theRequest;

-(void)uploadCoverFinished:(ASIHTTPRequest *)theRequest;
-(void)uploadCoverFailed:(ASIHTTPRequest *)theRequest;

@end

@implementation Communicator_UploadFileS3

@synthesize request;
@synthesize tag;
@synthesize didFinishDelegate;
@synthesize uploadProgressDelegate;
@synthesize strFileID;
@synthesize userData;



-(void)fSetS3SecretAccessKey:(NSString *)secretAccessKey andAccessKey:(NSString *)accessKey
{
    if(secretAccessKey == nil || accessKey == nil)
        return;
    [ASIS3Request setSharedSecretAccessKey:secretAccessKey];
    [ASIS3Request setSharedAccessKey:accessKey];
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
    
	[request cancel];
     strFileID = [[NSMutableString alloc] initWithString:[WTUserDefaults getUid]];
    [strFileID appendString:[NSString stringWithFormat:@"_%d", (int)[[NSDate date] timeIntervalSince1970]]];
    [strFileID appendString:[NSString stringWithFormat:@"_%d", (int)arc4random()]];

    request = [ASIS3ObjectRequest PUTRequestForFile:localfilePath withBucket:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,strFileID]];
    
	if (uploadProgressDelegate != nil)
        [request setUploadProgressDelegate:uploadProgressDelegate];
    
	[request setDelegate:self];
	[request setDidFailSelector:@selector(uploadFileFailed:)];
	[request setDidFinishSelector:@selector(uploadFileFinished:)];
   // [request setTimeOutSeconds:CONNECTION_TIMEOUT];
   // [request setShouldCompressRequestBody:YES];
    
    [request startAsynchronous];

    
    return request;
}

- (void)uploadFileFailed:(ASIHTTPRequest *)theRequest
{
    if ([request error])
        if(PRINT_LOG)
            NSLog(@"upload file failed:%@", [[request error] localizedDescription]);
    
    
    
    if(self.didFinishDelegate)
    {
        NSError* error;
        if (![request error]) {
            error = [NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil];
        }
        else
            error = [request error];
        
        [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
    }
    
    [strFileID release];
    
    [self autorelease];  // autorelease itself.
}

- (void)uploadFileFinished:(ASIHTTPRequest *)theRequest
{
    if ([request error])
        if(PRINT_LOG)
            NSLog(@"upload file failed:%@", [[request error] localizedDescription]);
    if(PRINT_LOG)
        NSLog(@"upload file success:%@", strFileID);
    if(self.didFinishDelegate)
    {
        NSError* error;
        if (![request error]) {
            error = [NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil];
        }
        else
            error = [request error];
        
        [self.didFinishDelegate networkTaskDidFinishWithReturningData:strFileID error:error];
        
    }
    
    [strFileID release];
    
    [self autorelease]; // autorelease itself.
}

-(id)uploadMomentMedia:(WTFile*)file toDir:(NSString *)dirPath forBucket:(NSString *)bucket  withExt:(BOOL)withExt;
{
	[request cancel];
    
    NSString* localfilePath = [NSFileManager absoluteFilePathForMedia:file];
    if (self.isMediaThumbnail) {
        localfilePath = [NSFileManager absoluteFilePathForMediaThumb:file];
         request = [ASIS3ObjectRequest PUTRequestForFile:localfilePath withBucket:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,file.thumbnailid]];
        //   NSLog(@"upload a moment media thumbnail: %@",file.thumbnailid);
    }
    else{
        request = [ASIS3ObjectRequest PUTRequestForFile:localfilePath withBucket:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,file.fileid]];
       // NSLog(@"upload a moment media: %@",file.fileid);
    }

    [request setDelegate:self];
	[request setDidFailSelector:@selector(uploadMediaFileFailed:)];
	[request setDidFinishSelector:@selector(uploadMediaFileFinished:)];

    
    [request startAsynchronous];

    return request;
    
}



-(void)uploadMediaFileFinished:(ASIHTTPRequest *)theRequest
{
    if ([request error])
        if(PRINT_LOG)
            NSLog(@"upload media failed:%@", [[request error] localizedDescription]);
    
    if(PRINT_LOG)
        NSLog(@"upload media success");
    
    if(self.didFinishDelegate)
    {
        NSError* error;
        if (![request error]) {
            error = [NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil];
        }
        else
            error = [request error];
        
        [self.didFinishDelegate networkTaskDidFinishWithReturningData:nil error:error];
        
    }
    [self autorelease];
}

-(void)uploadMediaFileFailed:(ASIHTTPRequest *)theRequest
{
    if ([request error])
        if(PRINT_LOG)
            NSLog(@"upload media file failed:%@", [[request error] localizedDescription]);
    
    if (self.didFinishDelegate)
    {
        NSError* error;
        if (![request error]) {
            error = [NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil];
        }
        else
            error = [request error];
        [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
    }
    [self autorelease];
    
}



-(id)uploadCover:(CoverImage*)image toDir:(NSString *)dirPath forBucket:(NSString *)bucket
{
    [request cancel];
    
    NSString* localfilePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:image.file_id
                                                                                                                      WithSubFolder:SDK_MOMENT_MEDIA_DIR withExtention:image.ext]];
    
    
    request = [ASIS3ObjectRequest PUTRequestForFile:localfilePath withBucket:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,image.file_id]];
    
	[request setDelegate:self];
	[request setDidFailSelector:@selector(uploadCoverFailed:)];
	[request setDidFinishSelector:@selector(uploadCoverFinished:)];
    
    
    [request startAsynchronous];
    
    return request;
    
}



-(void)uploadCoverFinished:(ASIHTTPRequest *)theRequest
{
    if ([request error])
        if(PRINT_LOG)
            NSLog(@"upload media failed:%@", [[request error] localizedDescription]);
    
    if(PRINT_LOG)
        NSLog(@"upload media success");
    
    if(self.didFinishDelegate)
    {
        
        NSError* error;
        if (![request error]) {
            error = [NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil];
        }
        else
            error = [request error];
        
        [self.didFinishDelegate networkTaskDidFinishWithReturningData:nil error:error];
        
    }
    [self autorelease];
}

-(void)uploadCoverFailed:(ASIHTTPRequest *)theRequest
{
    if ([request error])
        if(PRINT_LOG)
            NSLog(@"upload media file failed:%@", [[request error] localizedDescription]);
    
    if (self.didFinishDelegate)
    {
        NSError* error;
        if (![request error]) {
            error = [NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil];
        }
        else
            error = [request error];
        [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
    }
    [self autorelease];
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
    
	[request cancel];
    
    strFileID = [[NSMutableString alloc] initWithString:[WTUserDefaults getUid]];
     
    request = [ASIS3ObjectRequest PUTRequestForFile:localfilePath withBucket:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,strFileID]];
    
//	if (uploadProgressDelegate != nil)
//        [request setUploadProgressDelegate:uploadProgressDelegate];
    
	[request setDelegate:self];
	[request setDidFailSelector:@selector(uploadPhotoFailed:)];
	[request setDidFinishSelector:@selector(uploadPhotoFinished:)];
    
    //[request setTimeOutSeconds:CONNECTION_TIMEOUT];
    //[request setShouldCompressRequestBody:YES];
    
    [request startAsynchronous];
    
    return request;
}

- (void)uploadPhotoFailed:(ASIHTTPRequest *)theRequest
{
    if ([request error])
        if(PRINT_LOG)
            NSLog(@"upload photo/thumbnail failed:%@", [[request error] localizedDescription]);
      
    if (self.didFinishDelegate)
    {
        NSError* error;
        if (![request error]) {
            error = [NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil];
        }
        else
            error = [request error];
        [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
    }
    
    [self autorelease];
}

- (void)uploadPhotoFinished:(ASIHTTPRequest *)theRequest
{
    if ([request error])
        if(PRINT_LOG)
            NSLog(@"upload photo failed:%@", [[request error] localizedDescription]);

    if(PRINT_LOG)
        NSLog(@"upload photo/thumbnail success for uID:%@", strFileID);
    
    if(self.didFinishDelegate)
    {
        NSError* error;
        if (![request error]) {
            error = [NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil];
        }
        else
            error = [request error];
        
        [self.didFinishDelegate networkTaskDidFinishWithReturningData:strFileID error:error];

    }
    
    
    [self autorelease];
}

- (void)dealloc
{
	[request setDelegate:nil];
	[request setUploadProgressDelegate:nil];
	[request cancel];  // released already
    
    [super dealloc];
}

@end