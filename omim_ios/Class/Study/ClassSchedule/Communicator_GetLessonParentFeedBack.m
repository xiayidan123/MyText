//
//  Communicator_GetLessonParentFeedBack.m
//  dev01
//
//  Created by 杨彬 on 15-1-1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_GetLessonParentFeedBack.h"
#import "FeedBackModel.h"

@implementation Communicator_GetLessonParentFeedBack

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
        NSMutableArray *feedbackArray = nil;
        id feedback = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_lesson_parent_feedback"][@"feedback"];
        if (feedback){
            if ([feedback isKindOfClass:[NSDictionary class]]){
                feedbackArray = [[NSMutableArray alloc]init];
                [feedbackArray addObject:feedback];
            }else{
                feedbackArray = [[NSMutableArray alloc]initWithArray:(NSArray *)feedback];
            }
            for (int i=0; i<feedbackArray.count; i++){
                FeedBackModel *feedBackModel = [[FeedBackModel alloc]init];
                feedBackModel.feedback_id = feedbackArray[i][@"feedback_id"];
                feedBackModel.lesson_id = feedbackArray[i][@"lesson_id"];
                feedBackModel.moment_id = feedbackArray[i][@"moment_id"];
                feedBackModel.student_id = feedbackArray[i][@"student_id"];
                [Database storeFeedBackModel:feedBackModel];
                [feedBackModel release];
            }
            [feedbackArray release];
        }
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
