//
//  Lesson.h
//  dev01
//
//  Created by 杨彬 on 15/3/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lesson : NSObject

@property (copy,nonatomic)NSString *class_id;
@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *start_date;
@property (copy,nonatomic)NSString *end_date;
@property (copy,nonatomic)NSString *lesson_id;
@property (copy,nonatomic)NSString *live;
@property (copy, nonatomic)NSString *class_room_id;
@property (copy, nonatomic)NSString *class_room_name;


@property (assign, nonatomic,readonly)BOOL isLiving;


- (instancetype)initWithDict:(NSDictionary *)dic;


+ (instancetype)LessonWithDic:(NSDictionary *)dic;


@end
