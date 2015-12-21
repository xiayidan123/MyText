//
//  Communicator_GetLessonPerformance.m
//  dev01
//
//  Created by 杨彬 on 14-12-30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetLessonPerformance.h"
#import "LessonPerformanceModel.h"


@implementation Communicator_GetLessonPerformance

-(void)dealloc{
    [_lesson_id release];
    [_student_id release];
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
//        NSArray *performanceArray = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_lesson_performance"][@"lesson_performance"];
        id obj = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_lesson_performance"][@"lesson_performance"];
        
        
        NSMutableArray *obj_array = nil;
        if ([obj isKindOfClass:[NSArray class]]){
            obj_array = [[NSMutableArray alloc]initWithArray:obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            obj_array = [[NSMutableArray alloc]init];
            [obj_array addObject:obj];
        }
        
        int count = obj_array.count;
        for (int i=0 ;i<count; i++){
            LessonPerformanceModel *lessonPerformanceModel = [[LessonPerformanceModel alloc]initWithDic:obj_array[i]];
            lessonPerformanceModel.student_id = self.student_id;
            lessonPerformanceModel.lesson_id = self.lesson_id;
            [Database storeLessonPerformance:lessonPerformanceModel];
            [lessonPerformanceModel release];
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
