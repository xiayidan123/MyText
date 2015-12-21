//
//  Communicator_UploadFile.m
//  omimLibrary
//
//  Created by Yi Chen on 5/5/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_UploadFile.h"
#include "GlobalSetting.h"

// Private stuff
@interface Communicator_UploadFile ()
- (void)uploadFailed:(ASIHTTPRequest *)theRequest;
- (void)uploadFinished:(ASIHTTPRequest *)theRequest;
@end

@implementation Communicator_UploadFile
@synthesize request;
@synthesize uploadProgressDelegate;
@synthesize strFileID;

- (id)fUploadFile:(NSString*)filePath
       withPostKeys:(NSMutableArray*)postKeys 
       andPostValue:(NSMutableArray*)postValues
{
    if(filePath == nil || postKeys == nil || postValues== nil)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:NETWORK_TASK_INPUT_DATA_ERROR userInfo:nil];
        [self networkTaskDidFailWithReturningData:nil error:error];
        return nil;
    }
    
    //TODO : do a file and mime type check
	[request cancel];
	[self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:WEB_HOST_HTTP]]];
    for (int i = 0; i < [postKeys count]; i++)
        [request setPostValue:(NSString *)[postValues objectAtIndex:i] forKey:(NSString *)[postKeys objectAtIndex:i]];
    
	//[request setTimeOutSeconds:CONNECTION_TIMEOUT];
    //[request setValidatesSecureCertificate:NO];
	if(uploadProgressDelegate != nil)
        [request setUploadProgressDelegate:uploadProgressDelegate];
    
	[request setDelegate:self];
	[request setDidFailSelector:@selector(uploadFailed:)];
	[request setDidFinishSelector:@selector(uploadFinished:)];
	
    [request setFile:filePath forKey:@"file"];
	[request startAsynchronous];
    return request;
}

- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    if(PRINT_LOG)
        NSLog(@"upload file failed");
    
    NSError* error;
    if (![theRequest error]) {
        error = [NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil];
    }
    else
        error = [theRequest error];
    
    [self networkTaskDidFailWithReturningData:nil error:error];
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
	
   // if(PRINT_LOG)NSLog(@"%@",[NSString stringWithFormat:@"Finished uploading %llu bytes of data",[theRequest postLength]])
    
    NSString *theXML = [theRequest responseString];
    
	//---shows the XML---
   	
	theXML = [theXML stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    int startPoint = [theXML rangeOfString:@"<"].location;
    if (startPoint != 0)
        theXML = [theXML substringFromIndex:startPoint];
	 if(PRINT_LOG)
         NSLog(@"%@",theXML);
    
    /*notice!!!!: dont replace other character any more, trust the next line of code!!!  */
    NSData *xmlData = [theXML dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    //end patch
    
    [parser setDelegate:xmlParser];
    [parser setShouldResolveExternalEntities:YES];
    if(PRINT_LOG)
        NSLog(@"---xml parse result---");
    
    [parser parse];
    [parser setDelegate:nil];	
}

- (void)dealloc
{
	[request setDelegate:nil];
	[request setUploadProgressDelegate:nil];
	[request cancel];
	//[request release];
    [super dealloc];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo != NO_ERROR)
        [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    else
    {
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        if (bodydict == nil || [bodydict objectForKey:XML_UPLOAD_FILE_KEY] == nil){
            errNo = NECCESSARY_DATA_NOT_RETURNED;
            [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        }
        
        else
            [self networkTaskDidFinishWithReturningData:[[bodydict objectForKey:XML_UPLOAD_FILE_KEY] objectForKey:XML_FILEID_KEY] error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    }
}

@end

