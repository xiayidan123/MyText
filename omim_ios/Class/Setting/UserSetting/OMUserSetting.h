//
//  OMUserSetting.h
//  dev01
//
//  Created by Starmoon on 15/7/24.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>


// 记录用户权限设置

@interface OMUserSetting : NSObject

/** 领域 */
@property (copy, nonatomic) NSString * domain;

/** 语言 */
@property (copy, nonatomic) NSString * language;

/** 设备类型 */
@property (copy, nonatomic) NSString * device_type;

@property (assign, nonatomic) BOOL push_token;

@property (assign, nonatomic) BOOL push_show_detail_flag;

@property (assign, nonatomic) BOOL unknown_buddy_can_call_me;

@property (assign, nonatomic) BOOL unknown_buddy_can_message_me;

@property (assign, nonatomic) BOOL allow_school_invitation ;



+ (instancetype)getUserSetting;


- (void)storeUserSetting;



@end
