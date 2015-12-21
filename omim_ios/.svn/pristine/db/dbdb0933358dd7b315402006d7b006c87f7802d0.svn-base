//
//  PitchonCellModel.m
//  dev01
//
//  Created by 杨彬 on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "PitchonCellModel.h"

@implementation PitchonCellModel

-(void)dealloc{
    [_title release];
    [super dealloc];
}


- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self){
        self.title = dic[@"title"];
        self.isPitchon = [dic[@"isPitchon"] boolValue];
    }
    return self;
}

+ (instancetype)PitchonCellModelWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc]initWithDic:dic] autorelease];
}



@end
