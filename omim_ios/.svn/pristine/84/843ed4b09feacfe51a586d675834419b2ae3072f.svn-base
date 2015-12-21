//
//  ClassScheduleModel.m
//  dev01
//
//  Created by 杨彬 on 14-12-29.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ClassScheduleModel.h"
#import "ClassModel.h"
#import "Database.h"
#import "NSDate+ClassScheduleDate.h"


@interface ClassScheduleModel ()

@property (assign, nonatomic) BOOL isLiving;

@end

@implementation ClassScheduleModel

- (void)dealloc{
    
    [_class_id release];
    [_title release];
    [_start_date release];
    [_end_date release];
    [_lesson_id release];
    [_live release];
    [super dealloc];
}


+ (instancetype)ClassScheduleModelWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDict:dic] autorelease];
}


- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.class_id = dic[@"class_id"];
        self.title = dic[@"title"];
        self.start_date = dic[@"start_date"];
        self.end_date = dic[@"end_date"];
        self.lesson_id = dic[@"lesson_id"];
        self.live = dic[@"live"];
    }
    return self;
}

- (BOOL)isLiving{
    
    ClassModel *classModel = [Database getClassWithClassID:_class_id];
    
    NSTimeInterval startDateTimeInterval = [NSDate ZeropointWihtTimeIntervalString:_start_date];
    
    NSArray *introductionArray = [classModel.introduction componentsSeparatedByString:@","];
    
    NSString *startTimeStr = nil;
    NSString *timelongStr = nil;
    if (introductionArray.count >= 5){
        startTimeStr = introductionArray[4];
    }
    if (introductionArray.count >= 7){
        timelongStr = introductionArray[6];
    }else{
        timelongStr = @"00:45";
    }
    NSTimeInterval startTimeInterval = [NSDate getTimeIntervalWithString:startTimeStr];
    NSTimeInterval timelongTimeInterval = [NSDate getTimeIntervalWithString:timelongStr];
    
        NSTimeInterval start = startDateTimeInterval + startTimeInterval;
        NSTimeInterval end = startDateTimeInterval + startTimeInterval + timelongTimeInterval;
    
//    NSTimeInterval start = startDateTimeInterval ;
//    NSTimeInterval end = startDateTimeInterval + timelongTimeInterval;
    
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    
    
    if (current >= start && current<= end){
        _isLiving = YES;
    }else{
        _isLiving = NO;
    }
    
    return _isLiving;
}


@end
