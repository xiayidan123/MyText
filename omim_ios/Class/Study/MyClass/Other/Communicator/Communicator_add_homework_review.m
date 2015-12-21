//
//  Communicator_add_homework_review.m
//  dev01
//
//  Created by Huan on 15/6/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_add_homework_review.h"
#import "HomeworkReviewModel.h"

#import "OMNetWork_MyClass_Constant.h"


@implementation Communicator_add_homework_review
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    
    HomeworkReviewModel *homework_review_model = nil;
    
    if (errNo == NO_ERROR)
    {
        NSDictionary *infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:MY_CLASS_ADD_HOMEWORK_REVIEW];
        
        homework_review_model = [[HomeworkReviewModel alloc]initWithDict:infoDic];
    }
    [self networkTaskDidFinishWithReturningData:homework_review_model error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
