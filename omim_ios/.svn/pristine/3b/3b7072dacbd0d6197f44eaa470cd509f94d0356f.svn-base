//
//  Communicator_get_lesson_homework.m
//  dev01
//
//  Created by Huan on 15/5/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_get_lesson_homework.h"

#import "NewhomeWorkModel.h"

#import "OMNetWork_MyClass_Constant.h"

#import "HomeworkState.h"
@implementation Communicator_get_lesson_homework
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    NSMutableDictionary *infoDic = nil;
    
    NewhomeWorkModel *homework_model = nil;
    
    
    if (errNo == NO_ERROR)
    {
        infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:MY_CLASS_GET_LESSON_HOMEWORK];
        
        homework_model = [[[NewhomeWorkModel alloc]initWithDict:infoDic[@"homework"]] autorelease];
    }
    
    [self networkTaskDidFinishWithReturningData:homework_model error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
