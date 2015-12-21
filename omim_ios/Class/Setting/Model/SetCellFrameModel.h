//
//  SetCellFrameModel.h
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetCellFrameModel : NSObject

@property (copy, nonatomic)NSString *title;

@property (copy, nonatomic)NSString *content;

@property (assign, nonatomic)CGFloat cellHeight;

@property (assign, nonatomic)BOOL canEnter;

@property (assign, nonatomic) BOOL on;




- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)SetCellFrameModelWithDic:(NSDictionary *)dic;

@end
