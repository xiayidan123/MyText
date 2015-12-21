//
//  Communicator_UploadGroupAvatar.m
//  omim
//
//  Created by coca on 2013/04/26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_UploadGroupAvatar.h"
#import "WTUserDefaults.h"
#import "GlobalSetting.h"
#import "WTError.h"
#import "NSString+Compare.h"

// Private stuff
@interface Communicator_UploadGroupAvatar ()

- (void)uploadPhotoFailed:(ASIHTTPRequest *)theRequest;
- (void)uploadPhotoFinished:(ASIHTTPRequest *)theRequest;

@end

@implementation Communicator_UploadGroupAvatar

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

-(id)uploadGroupAvatar:(NSString *)filepath forGroup:(NSString *)groupid toDir:(NSString *)dirPath forBucket:(NSString *)bucket
{
    if ([NSString isEmptyString:filepath]) {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:NETWORK_TASK_INPUT_DATA_ERROR userInfo:nil];
        if(self.didFinishDelegate)
        {
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:error];
        }
        return nil;
    }
    
    [request cancel];
    request = [ASIS3ObjectRequest PUTRequestForFile:filepath withBucket:bucket key:[NSString stringWithFormat:@"%@%@", dirPath,groupid]];
    [request setDelegate:self];
	[request setDidFailSelector:@selector(uploadPhotoFailed:)];
	[request setDidFinishSelector:@selector(uploadPhotoFinished:)];
    
    [request startAsynchronous];
    
    return request;
}


-(id)uploadGroupAvatarThumbnail:(NSString *)filepath forGroup:(NSString *)groupid toDir:(NSString *)dirPath forBucket:(NSString *)bucket
{
    return [self uploadGroupAvatar:filepath forGroup:groupid toDir:dirPath forBucket:bucket];
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
	[request cancel];

    [super dealloc];
}

@end
