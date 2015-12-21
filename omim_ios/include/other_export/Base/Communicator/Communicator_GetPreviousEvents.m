//
//  Communicator_GetPreviousEvents.m
//  dev01
//
//  Created by elvis on 2013/07/09.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetPreviousEvents.h"
#import "Activity.h"

@implementation Communicator_GetPreviousEvents
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        //TODO: set this event membership to 2
        NSMutableDictionary *infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:WT_GET_LATEST_EVENTS];
        if ([[infoDic objectForKey:@"item"] isKindOfClass:[NSMutableArray class]]) {
            for (NSMutableDictionary *eventDictionary in [infoDic objectForKey:@"item"]) {
                Activity *activity = [[Activity alloc] initWithDict:eventDictionary];
                [Database storeEvent:activity];
                [activity release];
            }
        } else if ([[infoDic objectForKey:@"item"] isKindOfClass:[NSMutableDictionary class]]) {
            Activity *activity = [[Activity alloc] initWithDict:[infoDic objectForKey:@"item"]];
            [Database storeEvent:activity];
            [activity release];
        }
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
}
@end
