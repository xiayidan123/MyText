//
//  Communicator_UploadLessonPerformance.m
//  dev01
//
//  Created by 杨彬 on 14-12-31.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_UploadLessonPerformance.h"

@implementation Communicator_UploadLessonPerformance

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
//        NSArray *performanceArray = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_lesson_performance"][@"lesson_performance"];
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
