//
//  Communicator_ReportUnreadMessageCount.m
//  omimLibrary
//
//  Created by Yi Chen on 6/18/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_ReportUnreadMessageCount.h"
#include "GlobalSetting.h"

@implementation Communicator_ReportUnreadMessageCount

@synthesize request;

/*
- (void)fPostKeys:(NSMutableArray*)postKeys andPostValue:(NSMutableArray*)postValues
{
    if(postKeys==NULL || postValues==NULL) return;
    //TODO : do a file and mime type check
    
    
	[request cancel];
	[self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:WEB_HOST_HTTPS]]];
    for (int i = 0; i < [postKeys count]; i++)
        [request setPostValue:(NSString*)[postValues objectAtIndex:i] forKey:(NSString*)[postKeys objectAtIndex:i]];
    
	[request setTimeOutSeconds:CONNECTION_TIMEOUT];
    [request setValidatesSecureCertificate:NO];
    [request setResponseEncoding:NSUTF8StringEncoding];
	[request startSynchronous];
    
    NSError *error = [request error];
    if (error)
        [self didFailNetworkIFCommunicationWithTag:tag withData:request.responseString];
    else
    {
        NSString *theXML  = request.responseString;
        
        //---shows the XML---
        
        theXML=[theXML stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        
        int startPoint =[theXML rangeOfString:@"<"].location;
        if (startPoint != 0)
            theXML = [theXML substringFromIndex:startPoint];
        
         if(PRINT_LOG)
             NSLog(@"%@",theXML);
 
        /*notice!!!!: dont replace other character any more, trust the next line of code!!!  */
/*        xmlData = [theXML dataUsingEncoding:NSUTF8StringEncoding];
        
        NSXMLParser *tempParser = [[NSXMLParser alloc] initWithData:xmlData];
        tempParser.delegate = xmlParser;
        //end patch
        
        [tempParser setShouldResolveExternalEntities:YES];

        if(PRINT_LOG)
            NSLog(@"---xml parse result---");
        
        [tempParser parse];
    }
}
*/

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

- (void)dealloc
{
	[request cancel];
	[request release];
    [super dealloc];
}

@end
