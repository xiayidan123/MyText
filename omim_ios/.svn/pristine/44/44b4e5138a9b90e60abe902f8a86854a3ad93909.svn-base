//
//  Communicator_get_homework_state.m
//  dev01
//
//  Created by Huan on 15/5/26.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_get_homework_state.h"
#import "HomeworkState.h"
@implementation Communicator_get_homework_state
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    HomeworkState *homeworkState = nil;
    if (errNo == NO_ERROR)
    {
        id body = [result objectForKey:XML_BODY_NAME][@"get_homework_state"];
        homeworkState = [HomeworkState HomeworkWithDict:body[@"homework"]];
    }
    [self networkTaskDidFinishWithReturningData:homeworkState error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
