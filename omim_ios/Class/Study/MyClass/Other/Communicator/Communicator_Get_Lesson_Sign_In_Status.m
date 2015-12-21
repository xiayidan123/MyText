//
//  Communicator_Get_Lesson_Sign_In_Status.m
//  dev01
//
//  Created by 杨彬 on 15/4/7.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_Get_Lesson_Sign_In_Status.h"

#import "LessonPerformanceModel.h"

#import "OMDateBase_MyClass.h"

@implementation Communicator_Get_Lesson_Sign_In_Status

-(void)dealloc{
    self.lesson_id = nil;
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
        NSMutableDictionary *infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_lesson_performance"];
        
        NSMutableArray *obj_array = nil;
        id obj = infoDic[@"lesson_performance"];
//        if (obj == nil){
//            [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
//            return;
//        }
        if ([obj isKindOfClass:[NSArray class]]){
            obj_array = [[NSMutableArray alloc]initWithArray:obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            obj_array = [[NSMutableArray alloc]init];
            [obj_array addObject:obj];
        }
        int count = obj_array.count;
        for (int i=0; i<count; i++){
            LessonPerformanceModel *model = [[LessonPerformanceModel alloc]initWithDic:obj_array[i]];
            model.lesson_id = self.lesson_id;
            [OMDateBase_MyClass storeLessonPerformance:model];
            [model release];
        }
        
        [obj_array release];
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
