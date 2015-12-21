//
//  ClassModel.m
//  MG
//
//  Created by macbook air on 14-9-23.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _personArray = [[NSMutableArray alloc]init];
        _group_id = [dic[@"group_id"] copy];
        _group_name = [dic[@"group_name"] copy];
        _name = [dic[@"name"] copy];
        _school_id = [dic[@"school_id"] copy];
        _introduction = [dic[@"intro"] copy];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(void)dealloc{
    [_introduction release];
    [_group_id release];
    [_group_name release];
    [_name release];
    [_school_id release];
    
    [_className release];
    [_personArray release];
    [super dealloc];
}
@end
