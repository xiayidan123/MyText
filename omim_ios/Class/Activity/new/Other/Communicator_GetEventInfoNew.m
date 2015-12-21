//
//  Communicator_GetEventInfoNew.m
//  dev01
//
//  Created by 杨彬 on 14-11-5.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetEventInfoNew.h"
#import "ActivityModel.h"


@implementation Communicator_GetEventInfoNew

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_event_info"];
        if ([[infoDic objectForKey:@"event"] isKindOfClass:[NSMutableArray class]]) {
            for (NSMutableDictionary *eventDictionary in [infoDic objectForKey:@"event"]) {
                ActivityModel *activityModel = [[ActivityModel alloc]initWithDic:eventDictionary];
                [Database storeEventWithModel:activityModel];
                [activityModel release];
            }
        } else if ([[infoDic objectForKey:@"event"] isKindOfClass:[NSMutableDictionary class]]) {
            ActivityModel *activityModel = [[ActivityModel alloc] initWithDic:[infoDic objectForKey:@"event"]];
            [Database storeEventWithModel:activityModel];
            [activityModel release];
        }
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
