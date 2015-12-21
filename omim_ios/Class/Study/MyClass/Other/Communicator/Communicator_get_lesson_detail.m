//
//  Communicator_get_lesson_detail.m
//  dev01
//
//  Created by 杨彬 on 15/3/9.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_get_lesson_detail.h"
#import "LessonDetailModel.h"

@implementation Communicator_get_lesson_detail


- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    

    NSMutableArray *lessonArray = [[NSMutableArray alloc]init];
    if (errNo == NO_ERROR)
    {
        id body = [result objectForKey:XML_BODY_NAME][WT_GET_SCHOOL_LESSON_DETAIL];
        NSMutableArray *lessonDicArray = nil;
        if ([body isKindOfClass:[NSDictionary class]]){
            lessonDicArray = [[NSMutableArray alloc]init];
            [lessonDicArray addObject:body];
        }else{
            lessonDicArray = [[NSMutableArray alloc]initWithArray:body];
        }
        
        
        int arrayCount = lessonDicArray.count;
        for (int i=0; i< arrayCount; i++){
            NSDictionary *dic = (NSDictionary *)lessonDicArray[i];
            LessonDetailModel *lesson = [LessonDetailModel LessonDetailModelWithDic:dic];
            [lessonArray addObject:lesson];
        }
        [lessonDicArray release];
    }
    
    [self networkTaskDidFinishWithReturningData:[lessonArray autorelease] error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
