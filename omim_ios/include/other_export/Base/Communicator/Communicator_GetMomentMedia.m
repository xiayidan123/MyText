//
//  Communicator_GetMomentMedia.m
//  yuanqutong
//
//  Created by elvis on 2013/05/15.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_GetMomentMedia.h"
#import "ASIS3ObjectRequest.h"
#import "WowtalkXMLParser.h"
#import "WowtalkUIDelegates.h"
#import "MediaProcessing.h"
#import "WTFile.h"
#import "WTUserDefaults.h"
@interface Communicator_GetMomentMedia ()
- (void)downloadFailed:(ASIHTTPRequest *)theRequest;
- (void)downloadFinished:(ASIHTTPRequest *)theRequest;
@end

@implementation Communicator_GetMomentMedia

@synthesize request = request;
@synthesize didFinishDelegate;
@synthesize downloadProgressDelegate;
@synthesize bucket;

-(void)fInitS3Setting{
    NSString* accessKey = S3_ACCESS_KEY;
    NSString* secretAccessKey = S3_SECRET_ACCESS_KEY;
    self.bucket = S3_BUCKET;
    
    if(secretAccessKey == nil || accessKey == nil || self.bucket==nil)
        return;
    
    
    [ASIS3Request setSharedSecretAccessKey:secretAccessKey];
    [ASIS3Request setSharedAccessKey:accessKey];
}


- (id)fGetFileWithPath:(NSString *)path
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
            [self.didFinishDelegate networkTaskDidFailWithReturningData:nil error:[NSError errorWithDomain:@"Communicator_GetMomentMedia" code:-10 userInfo:nil]];
    }
}

- (void)downloadFinished:(ASIHTTPRequest *)theRequest
{
    //if(PRINT_LOG)NSLog(@"%@",[NSString stringWithFormat:@"Finished uploading %llu bytes of data",[theRequest postLength]]);
    if(PRINT_LOG)
        NSLog(@"getfile success");
    if(self.isThumb)
        [MediaProcessing writeMedia:[self.file.thumbnailid stringByAppendingPathExtension:self.file.ext] data:theRequest.responseData];
    
    else
        [MediaProcessing writeMedia:[self.file.fileid stringByAppendingPathExtension:self.file.ext] data:theRequest.responseData];
    
    if(self.didFinishDelegate)
        [self.didFinishDelegate networkTaskDidFinishWithReturningData:nil error:nil];
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
