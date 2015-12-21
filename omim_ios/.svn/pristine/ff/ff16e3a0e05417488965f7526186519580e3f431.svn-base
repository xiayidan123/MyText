//
//  OMBaseCellModel.m
//  dev01
//
//  Created by 杨彬 on 15/2/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBaseCellModel.h"

@implementation OMBaseCellModel
-(void)dealloc{
    [_title release],_title = nil;
    [_content release],_content = nil;
    self.old_content = nil;
    [super dealloc];
}


- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)OMBaseCellModelWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDic:dic] autorelease];
}

@end
