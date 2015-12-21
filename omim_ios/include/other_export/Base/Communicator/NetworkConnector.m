//
//  NetworkConnector.m
//  omim
//
//  Created by Coca on 7/5/11.
//  Copyright 2011 WowTech Inc. All rights reserved.
//

#import "NetworkConnector.h"
#include "GlobalSetting.h"
#import "ASIFormDataRequest.h"


// Private stuff
@interface NetworkConnector ()
- (void)postFailed:(ASIHTTPRequest *)theRequest;
- (void)postFinished:(ASIHTTPRequest *)theRequest;
@end


@implementation NetworkConnector

@synthesize xmlParserDelegate;
@synthesize strAlertViewTitle;
@synthesize strAlertViewMsg;
@synthesize didFinishDelegate;
@synthesize tag;
@synthesize request;


-(void)fAbortXMLParser{
	if (xmlParser) {
		[xmlParser abortParsing];
	}
}


-(void)fShowAlertView{
    return;
	if (strAlertViewTitle!=nil) {
		activityAlert = [[[UIActivityAlertView alloc] 
						  initWithTitle:strAlertViewTitle
						  message:strAlertViewMsg
						  delegate:self cancelButtonTitle:nil 
						  otherButtonTitles:nil]autorelease];
		
		[activityAlert show];	
	}
}
-(void)fCloseAlertView{	 
	if(activityAlert) [activityAlert close];
}

#pragma mark-
#pragma mark Network Core Code

-(void)fPost:(NSMutableArray*)postKeys withPostValue:(NSMutableArray*)postValues{
    if(postKeys==NULL || postValues==NULL) return;
    
	[request cancel];
	[self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:WEB_HOST_HTTP]]];
    for (int i = 0; i < [postKeys count]; i++) {
        
        [request addPostValue:(NSString*)[postValues objectAtIndex:i] forKey:(NSString*)[postKeys objectAtIndex:i]];
        
    }
    
    if(PRINT_LOG)NSLog(@"%@", request.url.absoluteString);
    
	[request setTimeOutSeconds:CONNECTION_TIMEOUT];
    [request setValidatesSecureCertificate:NO];
    
	[request setDelegate:self];
	[request setDidFailSelector:@selector(postFailed:)];
	[request setDidFinishSelector:@selector(postFinished:)];
    
	[request startAsynchronous];
}

- (void)postFailed:(ASIHTTPRequest *)theRequest
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WebServiceRequestFailed" object:nil];
    if(PRINT_LOG)NSLog(@"postbody=%@",  [[[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding]autorelease]);
    if(PRINT_LOG)NSLog(@"postFailed");
    
    if(self.didFinishDelegate){
        [self.didFinishDelegate networkTaskDidFailWithReturningData:theRequest.responseString error:[theRequest error]];
         }
}


- (void)postFinished:(ASIHTTPRequest *)theRequest
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WebServiceRequestSucceed" object:nil];
    
    if(PRINT_LOG)NSLog(@"postbody=%@",  [[[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding] autorelease]);

    if(PRINT_LOG)NSLog(@"%@",[NSString stringWithFormat:@"postFinished"]);
    
    [request setResponseEncoding:NSUTF8StringEncoding];

    NSString *theXML  = [theRequest responseString];
    
	//---shows the XML---
   	
	theXML=[theXML stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    if ([theXML isEqualToString:@""]) {
        return;
    }
    
    NSInteger startPoint =[theXML rangeOfString:@"<"].location;
    if (startPoint != 0 && startPoint!= NSNotFound) {
        theXML = [theXML substringFromIndex:startPoint];
    }

	 if(PRINT_LOG)NSLog(@"%@",theXML);
	
    /*notice!!!!: dont replace other character any more, trust the next line of code!!!  */
	if (xmlParserDelegate!=nil) {
    
        	xmlData=[theXML dataUsingEncoding:NSUTF8StringEncoding];
// ------------test here
   //     xmlData = @"<event_id>27</event_id>";
        xmlParser = [[NSXMLParser alloc] initWithData: xmlData];
		//end patch
		
		[xmlParser setDelegate: xmlParserDelegate];
		[xmlParser setShouldResolveExternalEntities:YES];
		if(PRINT_LOG)if(PRINT_LOG)NSLog(@"---xml parse result---");
		
		[xmlParser parse];
		
		[xmlParser setDelegate:nil];
	}
}

- (void)dealloc
{
    xmlParserDelegate = nil;
	[strAlertViewTitle release];
	[strAlertViewMsg release];
	
	[request setDelegate:nil];
	[request setUploadProgressDelegate:nil];
	[request cancel];
	[request release];
    
    [xmlParser release];
    
    [super dealloc];
}

@end

