//
//  Communicator_add_homework_result.m
//  dev01
//
//  Created by Huan on 15/5/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_add_homework_result.h"
#import "Homework_Moment.h"
#import "OMNetWork_MyClass_Constant.h"

@implementation Communicator_add_homework_result
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    Homework_Moment *homework_moment = nil;
    id body = nil;
    if (errNo == NO_ERROR)
    {
        body = [result objectForKey:XML_BODY_NAME][MY_CLASS_ADD_HOMEWOKR_RESULT];
        
        if ([body isKindOfClass:[NSDictionary class]]){
            homework_moment = [[Homework_Moment alloc]initWithDict:body[@"moment"]];
            homework_moment.moment_id = body[@"moment_id"];
            homework_moment.student_id = body[@"student_id"];
            homework_moment.homework_id = body[@"homework_id"];
            homework_moment.result_id = body[@"id"];
            homework_moment.last_modified_time = body[@"last_modified"];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:homework_moment error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
