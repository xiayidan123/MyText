//
//  ClassRoomCamera.m
//  dev01
//
//  Created by 杨彬 on 15/3/9.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassRoomCamera.h"


@implementation ClassRoomCamera

-(void)dealloc{
    [_timestamp release];
    [_httpUrl release];
    [_camera_id release];
    [_im_id release];
    [_mac release];
    [_camera_name release];
    [_order_id release];
    [_school_id release];
    
    [super dealloc];
}


- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.timestamp = dic[@"create_timestamp"];
        self.httpUrl = dic[@"http"];
        self.camera_id = dic[@"id"];
        self.im_id = dic[@"im_id"];
        self.mac = dic[@"mac"];
        self.camera_name = dic[@"name"];
        self.order_id = dic[@"order_id"];
        self.school_id = dic[@"school_id"];
        self.status = [dic[@"status"] boolValue];
    }
    return self;
}


+ (instancetype)ClassRoomCameraWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDict:dic] autorelease];
}


@end
