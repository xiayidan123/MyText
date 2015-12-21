//
//  SetCellFrameModel.m
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SetCellFrameModel.h"

@implementation SetCellFrameModel



-(void)dealloc{
    [_title release];
    [_content release];
    [super dealloc];
}


- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)SetCellFrameModelWithDic:(NSDictionary *)dic{
    return [[[self alloc]initWithDic:dic] autorelease];
}






@end
