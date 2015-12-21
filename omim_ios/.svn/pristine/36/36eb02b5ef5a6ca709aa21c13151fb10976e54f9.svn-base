//
//  Communicator_GetFileS3.m
//  omimLibrary
//
//  Created by Yi Chen on 6/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetFileS3.h"
#import "GlobalSetting.h"

// Private stuff
@interface Communicator_GetFileS3 ()
- (void)downloadFailed:(ASIHTTPRequest *)theRequest;
- (void)downloadFinished:(ASIHTTPRequest *)theRequest;
@end

@implementation Communicator_GetFileS3

@synthesize request;
@synthesize tag;
@synthesize didFinishDelegate;
@synthesize downloadProgressDelegate;
@synthesize userData;

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
        if (userData)
            [self.didFinishDelegate didFailNetworkIFCommunicationWithTag:tag withData:theRequest.responseString];
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