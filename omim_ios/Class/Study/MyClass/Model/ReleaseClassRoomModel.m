//
//  ReleaseClassRoomModel.m
//  dev01
//
//  Created by 杨彬 on 15/3/11.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ReleaseClassRoomModel.h"



@interface ReleaseClassRoomModel ()



@end

@implementation ReleaseClassRoomModel


-(void)dealloc{
    
    [_room_id release];
    [_msg release];
    [super dealloc];
}


- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.room_id = dic[@"room_id"];
        self.msg = dic[@"msg"];
        self.status = [dic[@"status"] boolValue];
    }
    return self;
}


+ (instancetype)ReleaseClassRoomModelWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDict:dic] autorelease];
}


@end
