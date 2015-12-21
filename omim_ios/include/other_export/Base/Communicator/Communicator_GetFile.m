//
//  Communicator_GetPhoto.m
//  omimLibrary
//
//  Created by Yi Chen on 5/5/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetFile.h"
#import "ASIFormDataRequest.h"
#include "GlobalSetting.h"

// Private stuff
@interface Communicator_GetFile ()

- (void)uploadFailed:(ASIHTTPRequest *)theRequest;
- (void)uploadFinished:(ASIHTTPRequest *)theRequest;

@end

@implementation Communicator_GetFile

@synthesize request;
@synthesize tag;
@synthesize didFinishDelegate;
@synthesize downloadProgressDelegate;

- (id)fPost:(NSMutableArray *)postKeys withPostValue:(NSMutableArray *)postValues
{
   // if(postKeys == nil || postValues== nil)
   //     return nil;
 
	[request cancel];
	request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:WEB_HOST_HTTP]];
    for (int i = 0; i < [postKeys count]; i++)
    {
        [request setPostValue:(NSString *)[postValues objectAtIndex:i] forKey:(NSString *)[postKeys objectAtIndex:i]];
    }
 
	//[request setTimeOutSeconds:CONNECTION_TIMEOUT];
    //[request setValidatesSecureCertificate:NO];
	if (downloadProgressDelegate != nil)
        [request setDownloadProgressDelegate:downloadProgressDelegate];
    
	[request setDelegate:self];
	[request setDidFailSelector:@selector(uploadFailed:)];
	[request setDidFinishSelector:@selector(uploadFinished:)];
	
    //[request setResponseEncoding:NSUTF8StringEncoding];
    
	[request startAsynchronous];
    return request;
}

- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    if(PRINT_LOG)
        NSLog(@"getfile failed");

    if(self.didFinishDelegate)
        [self.didFinishDelegate didFailNetworkIFCommunicationWithTag:tag withData:theRequest.responseString];
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    if(self.didFinishDelegate)
        [self.didFinishDelegate didFinishNetworkIFCommunicationWithTag:tag withData:theRequest.responseData];
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