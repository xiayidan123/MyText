//
//  OMNetWork_Setting.h
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTNetworkTaskConstant.h"
#import "Database.h"
#import "WTError.h"

#import "OMUserSetting.h"

@interface OMNetWork_Setting : NSObject

+ (void)getLatestVersionInfoWithCallback:(SEL)selector withObserver:(id)observer;

/** 修改用户权限 */
+ (void)putUserSettings:(OMUserSetting *)user_setting withCallback:(SEL)selector withObserver:(id)observer;

/** 获取用于权限 */
+ (void)GetUserSettingsWithCallback:(SEL)selector withObserver:(id)observer;


@end
