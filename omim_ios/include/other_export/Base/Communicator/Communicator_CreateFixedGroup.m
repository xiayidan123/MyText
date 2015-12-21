//
//  Communicator_CreateFixedGroup.m
//  omim
//
//  Created by coca on 2013/04/26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_CreateFixedGroup.h"

@implementation Communicator_CreateFixedGroup

-(void)handleEvent:(NSMutableDictionary*)eventDict
{
   /* Activity *activity = [[Activity alloc] initWithDict:eventDict];
    [Database storeEvent:activity];
    
    NSString *thumbpath = [eventDict objectForKey:@"thumbnail_filepath"];
    if (thumbpath != nil)
    {
        NSData *data = [PublicFunctions getThumbnailForFile:thumbpath];
        if (data == nil){
            [WowTalkWebServerIF getFileFromServer:thumbpath withCallback:nil withObserver:nil];
        }
    }
    */
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    
    NSDictionary* data = nil;
    if (errNo == NO_ERROR)
    {
        NSDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        if (bodydict == nil || [bodydict objectForKey:WT_CREATE_FIXED_GROUP] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        else
        {
            data = [bodydict objectForKey:WT_CREATE_FIXED_GROUP];
        }
    }
    [self networkTaskDidFinishWithReturningData:data error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
}


@end
