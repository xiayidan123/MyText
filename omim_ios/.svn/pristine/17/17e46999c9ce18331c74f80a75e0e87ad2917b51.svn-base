//
//  Communicator_ModifyLesson.m
//  dev01
//
//  Created by 杨彬 on 15/3/13.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_ModifyLesson.h"
#import "OMDateBase_MyClass.h"

@implementation Communicator_ModifyLesson

-(void)dealloc{
    [_lesson release];
    [super dealloc];
}



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
       [OMDateBase_MyClass storeLessonWithModel:self.lesson];
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
