//
//  MyClassFunctionButtonModel.m
//  dev01
//
//  Created by 杨彬 on 15/3/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MyClassFunctionButtonModel.h"

@interface MyClassFunctionButtonModel ()




@end


@implementation MyClassFunctionButtonModel

-(void)dealloc{
    [_imageName_pre release];
    [_imageName release];
    [_title release];
    [super dealloc];
}






- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.imageName = dic[@"imageName"];
        self.title = dic[@"title"];
        self.imageName_pre = dic[@"imageName_pre"];
    }
    return self;
}


+ (instancetype)myClassFunctionButtonModelWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDict:dic] autorelease];
}








@end
