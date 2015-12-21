//
//  Anonymous_Moment.h
//  dev01
//
//  Created by 杨彬 on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Moment.h"

@interface Anonymous_Moment : Moment

/** 1-家长意见  2-班级通知 */
@property (assign, nonatomic)NSInteger anonymousType;

@property (copy, nonatomic)NSString *bulletin_id;

@property (copy, nonatomic)NSString *anonymous_uid;

@property (copy, nonatomic)NSString *class_id;


- (instancetype)initWithDict:(NSDictionary *)dic;

- (instancetype)initWithMomentDic:(NSDictionary *)dic;

- (instancetype)initWithMoment:(Moment *)moment;




@end
