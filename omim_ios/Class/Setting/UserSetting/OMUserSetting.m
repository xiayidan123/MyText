//
//  OMUserSetting.m
//  dev01
//
//  Created by Starmoon on 15/7/24.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMUserSetting.h"

#import "MJExtension.h"

#define UserSettingFileName @"OMUserSetting"

@implementation OMUserSetting


-(void)dealloc{
    self.domain = nil;
    self.language = nil;
    self.device_type = nil;
    self.push_token = nil;
    self.push_show_detail_flag = nil;
    
    [super dealloc];
}


+ (instancetype)getUserSetting{
    return [self objectWithFile:[[NSBundle mainBundle] pathForResource:UserSettingFileName ofType:@"plist"]];
}


- (void)storeUserSetting{
   
    NSDictionary *dic = [self keyValues];
    
    [dic writeToFile:[[NSBundle mainBundle] pathForResource:UserSettingFileName ofType:@"plist"] atomically:YES];
}

@end
