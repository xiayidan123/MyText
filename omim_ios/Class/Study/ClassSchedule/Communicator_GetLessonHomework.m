//
//  Communicator_GetLessonHomework.m
//  dev01
//
//  Created by 杨彬 on 14-12-31.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetLessonHomework.h"
#import "HomeworkModel.h"

@implementation Communicator_GetLessonHomework

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
        NSMutableArray *homeworkArray = nil;
        id homework = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_lesson_homework"][@"homework"];
        if (homework){
            if ([homework isKindOfClass:[NSDictionary class]]){
                homeworkArray = [[NSMutableArray alloc]init];
                [homeworkArray addObject:homework];
            }else{
                homeworkArray = [[NSMutableArray alloc]initWithArray:(NSArray *)homework];
            }
            for (int i=0; i<homeworkArray.count; i++){
                HomeworkModel *homeworkModel = [[HomeworkModel alloc]init];
                homeworkModel.homework_id = homeworkArray[i][@"homework_id"];
                homeworkModel.lesson_id = homeworkArray[i][@"lesson_id"];
                homeworkModel.title = homeworkArray[i][@"title"];
                [Database storeHomework:homeworkModel];
                [homeworkModel release];
            }
            [homeworkArray release];
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
