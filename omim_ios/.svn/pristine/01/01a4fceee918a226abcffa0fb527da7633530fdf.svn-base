//
//  Communicator_GetAllEvents.m
//  dev01
//
//  Created by 杨彬 on 14-10-29.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetAllEvents.h"
#import "Activity.h"
#import "ActivityModel.h"

@implementation Communicator_GetAllEvents


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
        if (_isFirstPage) {
            [Database deleteAllEvents];
        }
        
        NSMutableDictionary *infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_all_events"];
        if ([[infoDic objectForKey:@"event"] isKindOfClass:[NSMutableArray class]]) {
            for (NSMutableDictionary *eventDictionary in [infoDic objectForKey:@"event"]) {
                ActivityModel *activityModel = [[ActivityModel alloc]initWithDic:eventDictionary];
                [Database storeEventWithModel:activityModel];
                [activityModel release];
            }
        } else if ([[infoDic objectForKey:@"event"] isKindOfClass:[NSMutableDictionary class]]) {
            
            ActivityModel *activityModel = [[ActivityModel alloc]initWithDic:infoDic[@"event"]];
            [Database storeEventWithModel:activityModel];
            [activityModel release];

        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
