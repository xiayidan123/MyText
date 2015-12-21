//
//  Communicator_GetClassScheduleList.m
//  dev01
//
//  Created by 杨彬 on 14-12-29.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetClassScheduleList.h"
#import "ClassScheduleModel.h"

@implementation Communicator_GetClassScheduleList
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
        NSArray *lessonArray;
        id lesson = [result objectForKey:XML_BODY_NAME][@"get_lesson"][@"lesson"];
        if (lesson){
            if ([lesson isKindOfClass:[NSDictionary class]]){
                lessonArray = [NSArray arrayWithObject:lesson];
            }else {
                lessonArray = (NSArray *)lesson;
            }
            for (int i=0; i<lessonArray.count; i++){
                ClassScheduleModel *classScheduleModel = [[ClassScheduleModel alloc]init];
                classScheduleModel.class_id = lessonArray[i][@"class_id"];
                classScheduleModel.lesson_id = lessonArray[i][@"lesson_id"];
                classScheduleModel.title = lessonArray[i][@"title"];
                classScheduleModel.start_date = lessonArray[i][@"start_date"];
                classScheduleModel.end_date = lessonArray[i][@"end_date"];
                classScheduleModel.live = lessonArray[i][@"live"];
                [Database storeclassScheduleModel:classScheduleModel];
                [classScheduleModel release];
            }
        }
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
