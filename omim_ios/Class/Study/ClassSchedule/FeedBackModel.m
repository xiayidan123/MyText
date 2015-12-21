//
//  FeedBackModel.m
//  dev01
//
//  Created by 杨彬 on 15-1-1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "FeedBackModel.h"

@implementation FeedBackModel

-(void)dealloc{
    [_feedback_id release];
    [_lesson_id release];
    [_moment_id release];
    [_student_id release];
    [super dealloc];
}

@end
