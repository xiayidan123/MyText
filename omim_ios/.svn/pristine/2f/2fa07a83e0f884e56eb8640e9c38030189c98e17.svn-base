//
//  EditClassInformationModel.m
//  dev01
//
//  Created by 杨彬 on 15/2/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "EditClassInformationModel.h"

@implementation EditClassInformationModel

-(void)dealloc{
    [_title release],_title = nil;
    [_content release],_content = nil;
    [super dealloc];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)editClassInformationWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
