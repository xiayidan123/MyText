//
//  Communicator_GetEventInfo.m
//  omim
//
//  Created by Harry on 14-2-2.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetEventInfo.h"
#import "Activity.h"
#import "Database.h"

@implementation Communicator_GetEventInfo

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];

            NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_EVENT_INFO_KEY];
            NSMutableDictionary *eventdict = [infodict objectForKey:XML_EVENT_KEY];
            Activity *activity = [[Activity alloc] initWithDict:eventdict];
            [Database storeEvent:activity];
            [activity release];
        
    }
}

@end
