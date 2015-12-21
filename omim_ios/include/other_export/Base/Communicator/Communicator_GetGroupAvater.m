//
//  Communicator_GetGroupAvater.m
//  omim
//
//  Created by coca on 2013/04/26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetGroupAvater.h"
#import "ASIS3ObjectRequest.h"
#import "WowtalkXMLParser.h"
#import "WowtalkUIDelegates.h"

@interface Communicator_GetGroupAvater ()
- (void)downloadFailed:(ASIHTTPRequest *)theRequest;
- (void)downloadFinished:(ASIHTTPRequest *)theRequest;
@end

@implementation Communicator_GetGroupAvater

@synthesize request;
@synthesize didFinishDelegate;
@synthesize downloadProgressDelegate;


- (void)fSetS3SecretAccessKey:(NSString *)secretAccessKey andAccessKey:(NSString *)accessKey
{
    if (secretAccessKey== nil || accessKey == nil)
        return;
    [ASIS3Request setSharedSecretAccessKey:secretAccessKey];
    [ASIS3Request setSharedAccessKey:accessKey];
}

- (id)fGetFileWithPath:(NSString *)path FromBucket:(NSString *)bucket
{
    if(path== nil || bucket== nil)
        return nil;
    
	[request cancel];
    
    request = [ASIS3ObjectRequest requestWithBucket:bucket key:path];
    
	if (downloadProgressDelegate != nil)
        [request setDownloadProgressDelegate:downloadProgressDelegate];
    
	[request setDelegate:self];
	[request setDidFailSelector:@selector(downloadFailed:)];
	[request setDidFinishSelector:@selector(downloadFinished:)];
	
	[request startAsynchronous];
    
    return request;
}

- (void)downloadFailed:(ASIHTTPRequest *)theRequest
{
    if(PRINT_LOG)
        NSLog(@"getfile failed:%@",theRequest.responseString);
    
    if(self.didFinishDelegate)
    {
        if (theRequest.error)
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:theRequest.error];
        else
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:[NSError errorWithDomain:DEFAULT_DOMAIN code:-10 userInfo:nil]];
    }
}

- (void)downloadFinished:(ASIHTTPRequest *)theRequest
{
    //if(PRINT_LOG)NSLog(@"%@",[NSString stringWithFormat:@"Finished uploading %llu bytes of data",[theRequest postLength]]);
    if(PRINT_LOG)
        NSLog(@"getfile success");
    if(self.didFinishDelegate)
        [self.didFinishDelegate networkTaskDidFinishWithReturningData:theRequest.responseData error:nil];
}

- (void)dealloc
{
	[request setDelegate:nil];
	[request setDownloadProgressDelegate:nil];
	[request cancel];

    
    self.didFinishDelegate = nil;
    self.downloadProgressDelegate = nil;
    [super dealloc];
}

@end
