//
//  SchoolModel.m
//  MG
//
//  Created by macbook air on 14-9-24.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import "SchoolModel.h"

@implementation SchoolModel

-(void)dealloc{
    [_schoolName release];
    [_classArray release];
    
    [_corp_id release];
    [_corp_name release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _corp_id = [dic[@"corp_id"] copy];
        _corp_name = [dic[@"corp_name"] copy];
    }
    return self;
}

+ (instancetype)schoolModelWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc]initWithDic:dic] autorelease];
}





@end
