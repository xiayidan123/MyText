//
//  OMNetWork_Setting.m
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMNetWork_Setting.h"

#import "NSString+Compare.h"

#import "WTUserDefaults.h"
#import "WTNetworkTask.h"
#import "WTNetworkTaskConstant.h"
#import "WowTalkVoipIF.h"
#import "WTHeader.h"
#import "NSString+Compare.h"
#import "GlobalSetting.h"

#import "Communicator_GetLatestVersion.h"
#import "Communicator_Put_user_setting.h"
#import "Communicator_Get_user_setting.h"




@implementation OMNetWork_Setting

+ (void)getLatestVersionInfoWithCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [WTHelper WTLog:@"engine is not set up"];
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_LATEST_VERSION taskInfo:nil taskType:WT_LATEST_VERSION notificationName:WT_LATEST_VERSION notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    if (strUID==nil || strPwd==nil) {
        return;
    }
    Communicator_GetLatestVersion* netIFCommunicator = [[Communicator_GetLatestVersion alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_LATEST_VERSION];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    
    [postKeys addObject:@"lang"];
    [postValues addObject:[countryCode lowercaseString]];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];

}


/** 修改用户权限 */
+ (void)putUserSettings:(OMUserSetting *)user_setting withCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [WTHelper WTLog:@"engine is not set up"];
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_PUT_USER_SETTING taskInfo:nil taskType:WT_PUT_USER_SETTING notificationName:WT_PUT_USER_SETTING notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    if (strUID==nil || strPwd==nil) {
        return;
    }
    Communicator_Put_user_setting * netIFCommunicator = [[Communicator_Put_user_setting alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_PUT_USER_SETTING];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    if (user_setting.domain.length != 0){
        [postKeys addObject:@"domain"]; [postValues addObject:user_setting.domain];
    }
    if (user_setting.language.length != 0){
        [postKeys addObject:@"language"]; [postValues addObject:user_setting.language];
    }
    
    if (user_setting.device_type.length != 0){
        [postKeys addObject:@"device_type"]; [postValues addObject:user_setting.device_type];
    }
    
    [postKeys addObject:@"push_token"]; [postValues addObject:[NSString stringWithFormat:@"%d",user_setting.push_token]];
    
    [postKeys addObject:@"push_show_detail_flag"]; [postValues addObject:[NSString stringWithFormat:@"%d",user_setting.push_show_detail_flag]];
    
    [postKeys addObject:@"unknown_buddy_can_call_me"]; [postValues addObject:[NSString stringWithFormat:@"%d",user_setting.unknown_buddy_can_call_me]];
    
    [postKeys addObject:@"unknown_buddy_can_message_me"]; [postValues addObject:[NSString stringWithFormat:@"%d",user_setting.unknown_buddy_can_message_me]];
    
    [postKeys addObject:@"allow_school_invitation"]; [postValues addObject:[NSString stringWithFormat:@"%d",user_setting.allow_school_invitation]];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}

/** 获取用户权限 */
+ (void)GetUserSettingsWithCallback:(SEL)selector withObserver:(id)observer;{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [WTHelper WTLog:@"engine is not set up"];
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_USER_SETTING taskInfo:nil taskType:WT_GET_USER_SETTING notificationName:WT_GET_USER_SETTING notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    if (strUID==nil || strPwd==nil) {
        return;
    }
    Communicator_Get_user_setting * netIFCommunicator = [[Communicator_Get_user_setting alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_GET_USER_SETTING];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}



@end
