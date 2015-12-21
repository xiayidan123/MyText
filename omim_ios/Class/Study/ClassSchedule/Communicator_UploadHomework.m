//
//  Communicator_UploadHomework.m
//  dev01
//
//  Created by 杨彬 on 14-12-31.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_UploadHomework.h"
#import "HomeworkModel.h"

@implementation Communicator_UploadHomework

-(void)dealloc{
    [_lesson_id release];
    [_title release];
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
        NSString *homework_id = [[result objectForKey:XML_BODY_NAME] objectForKey:@"add_lesson_homework"][@"homework_id"];
        HomeworkModel *homeworkModel = [[HomeworkModel alloc]init];
        homeworkModel.homework_id = homework_id;
        homeworkModel.lesson_id = _lesson_id;
        homeworkModel.title = _title;
        [Database storeHomework:homeworkModel];
        [homeworkModel release];
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
