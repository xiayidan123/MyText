//
//  Communicator_del_lesson_homework.m
//  dev01
//
//  Created by Huan on 15/5/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_del_lesson_homework.h"

@implementation Communicator_del_lesson_homework
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
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
