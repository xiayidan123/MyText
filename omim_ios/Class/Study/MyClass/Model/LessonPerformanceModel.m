//
//  LessonPerformanceModel.m
//  dev01
//
//  Created by 杨彬 on 14-12-30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "LessonPerformanceModel.h"

@implementation LessonPerformanceModel


-(void)dealloc{
    [_lesson_id release];
    [_student_id release];
    [_property_id release];
    [_property_value release];
    [_performance_id release];
    [_property_name release];
    [super dealloc];
}



- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)LessonPerformanceModelWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc]initWithDic:dic] autorelease];
}

@end
