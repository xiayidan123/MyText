//
//  NewhomeWorkModel.h
//  dev01
//
//  Created by Huan on 15/5/19.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Homework_Moment.h"


@interface NewhomeWorkModel : NSObject


@property (copy, nonatomic) NSString * teacher_id;
@property (retain, nonatomic) Homework_Moment * homework_moment;

@property (retain, nonatomic) NSMutableArray * results_moments;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)NewhomeWorkModelWithDic:(NSDictionary *)dic;



@end
