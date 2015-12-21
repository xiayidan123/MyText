//
//  ParentFeedbackModel.m
//  dev01
//
//  Created by Huan on 15/4/15.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ParentFeedbackModel.h"

@implementation ParentFeedbackModel
-(void)dealloc{
    self.feedback_id = nil;
    self.lesson_id = nil;
    self.moment_id = nil;
    self.student_id = nil;
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

+ (instancetype)ParentFeedbackWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc]initWithDic:dic] autorelease];
}
@end
