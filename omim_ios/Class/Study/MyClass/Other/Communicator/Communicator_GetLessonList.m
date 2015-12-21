//
//  Communicator_GetLessonList.m
//  dev01
//
//  Created by 杨彬 on 15/3/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_GetLessonList.h"
#import "Lesson.h"
#import "OMDateBase_MyClass.h"

@implementation Communicator_GetLessonList

-(void)dealloc{
    self.class_id = nil;
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
    NSMutableDictionary *infoDic = nil;
    if (errNo == NO_ERROR)
    {
        infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_lesson"];
        
        id obj = infoDic[@"lesson"];
        
        NSMutableArray *objArray = nil;
        
        if ([obj isKindOfClass:[NSArray class]]){
            objArray = [[NSMutableArray alloc]initWithArray:obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            objArray = [[NSMutableArray alloc]init];
            [objArray addObject:obj];
        }
        
        [OMDateBase_MyClass deleteLessonWithClass_id:self.class_id];
        for(NSDictionary *dic in objArray){
            Lesson *model = [Lesson LessonWithDic:dic];
            [OMDateBase_MyClass storeLessonWithModel:model];
        }
        [objArray release];
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}



@end
