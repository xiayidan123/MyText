//
//  Communicator_get_class_moment.m
//  dev01
//
//  Created by 杨彬 on 15/6/5.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_get_class_moment.h"
#import "OMNetWork_MyClass_Constant.h"

@implementation Communicator_get_class_moment


- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
//    NSMutableDictionary *infoDic = nil;
    
    
    
    if (errNo == NO_ERROR)
    {
//        id obj = [[result objectForKey:XML_BODY_NAME] objectForKey:MY_CLASS_MOMENTS];
//
//        homework_model = [[[NewhomeWorkModel alloc]initWithDict:infoDic] autorelease];
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
