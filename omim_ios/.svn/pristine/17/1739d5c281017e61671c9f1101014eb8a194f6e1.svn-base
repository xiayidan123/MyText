//
//  Communicator_modify_homework.m
//  dev01
//
//  Created by 杨彬 on 15/6/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_modify_homework.h"
#import "NewhomeWorkModel.h"
#import "OMNetWork_MyClass_Constant.h"

@implementation Communicator_modify_homework


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
        infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:MY_CLASS_MODIFY_LESSON_HOMEWORK];
        
        homework_model = [[[NewhomeWorkModel alloc]initWithDict:infoDic] autorelease];
    }
    
    [self networkTaskDidFinishWithReturningData:homework_model error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
