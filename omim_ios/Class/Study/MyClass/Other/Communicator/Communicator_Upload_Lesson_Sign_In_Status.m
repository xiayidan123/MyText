//
//  Communicator_Upload_Lesson_Sign_In_Status.m
//  dev01
//
//  Created by 杨彬 on 15/4/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_Upload_Lesson_Sign_In_Status.h"

@implementation Communicator_Upload_Lesson_Sign_In_Status


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
