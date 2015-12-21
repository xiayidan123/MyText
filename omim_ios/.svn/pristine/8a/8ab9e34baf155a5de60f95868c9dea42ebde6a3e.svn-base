//
//  ClassScheduleModel.h
//  dev01
//
//  Created by 杨彬 on 14-12-29.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ClassScheduleModel : NSObject

@property (copy,nonatomic)NSString *class_id;
@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *start_date;
@property (copy,nonatomic)NSString *end_date;
@property (copy,nonatomic)NSString *lesson_id;
@property (copy,nonatomic)NSString *live;

@property (assign, nonatomic,readonly)BOOL isLiving;


- (instancetype)initWithDict:(NSDictionary *)dic;


+ (instancetype)ClassScheduleModelWithDic:(NSDictionary *)dic;

@end
