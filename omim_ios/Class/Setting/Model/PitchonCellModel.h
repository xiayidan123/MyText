//
//  PitchonCellModel.h
//  dev01
//
//  Created by 杨彬 on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PitchonCellModel : NSObject

@property (copy, nonatomic)NSString *title;


@property (assign, nonatomic)BOOL isPitchon;


- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)PitchonCellModelWithDic:(NSDictionary *)dic;

@end
