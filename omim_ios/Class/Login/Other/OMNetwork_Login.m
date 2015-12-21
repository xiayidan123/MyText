//
//  OMNetwork_Login.m
//  dev01
//
//  Created by Starmoon on 15/7/24.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMNetwork_Login.h"
#import "NSString+Compare.h"

#import "WTUserDefaults.h"
#import "WTNetworkTask.h"
#import "WTNetworkTaskConstant.h"
#import "WowTalkVoipIF.h"
#import "WTHeader.h"
#import "NSString+Compare.h"
#import "GlobalSetting.h"
#import "Database.h"


#import "Communicator_sms_sendSMS.h"
#import "Communicator_sms_checkCode.h"
#import "Communicator_retrieve_password_via_email.h"
#import "Communicator_reset_password_via_email.h"
#import "Communicator_user_bind_phone.h"
#import "Communicator_reset_password_by_mobile.h"
#import "Communicator_check_mobile_exist.h"

@implementation OMNetwork_Login


+ (void)sms_sendSMS:(NSString *)telephone_number withType:(NSString *)type smstemplateid:(NSString *)smstemplateid withCallback:(SEL)selector withObserver:(id)observer{
    
    if (telephone_number.length == 0
        || type.length == 0
        || smstemplateid.length == 0){
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_SEND_SMS taskInfo:nil taskType:WT_SEND_SMS notificationName:WT_SEND_SMS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_sms_sendSMS * netIFCommunicator = [[Communicator_sms_sendSMS alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_SEND_SMS];
    
    [postKeys addObject:@"mobile"]; [postValues addObject:telephone_number];
    
    [postKeys addObject:@"type"]; [postValues addObject:type];
    
    [postKeys addObject:@"smstemplateid"]; [postValues addObject:smstemplateid];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
}


+ (void)sms_checkCodeWithTelephone_number:(NSString *)telephone_number withCode:(NSString *)code withCallback:(SEL)selector withObserver:(id)observer{
    
    if (telephone_number.length == 0
        || code.length == 0){
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_CHECK_SMSCODE taskInfo:nil taskType:WT_CHECK_SMSCODE notificationName:WT_CHECK_SMSCODE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_sms_checkCode * netIFCommunicator = [[Communicator_sms_checkCode alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_CHECK_SMSCODE];
    
    [postKeys addObject:@"mobile"]; [postValues addObject:telephone_number];
    
    [postKeys addObject:@"code"]; [postValues addObject:code];
        
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}


+ (void)retrieve_passwork_via_emailWithEmail:(NSString *)email withCallback:(SEL)selector withObserver:(id)observer{
    if (email.length == 0){
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_RSTRIEVE_PASSWORD_VIA_EMAIL taskInfo:nil taskType:WT_RSTRIEVE_PASSWORD_VIA_EMAIL notificationName:WT_RSTRIEVE_PASSWORD_VIA_EMAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_retrieve_password_via_email * netIFCommunicator = [[Communicator_retrieve_password_via_email alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_RSTRIEVE_PASSWORD_VIA_EMAIL];
    [postKeys addObject:@"email"]; [postValues addObject:email];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}



+ (void)reset_password_via_email:(NSString *)email access_code:(NSString *)code new_password:(NSString *)new_password withCallback:(SEL)selector withObserver:(id)observer{
    
    if (email.length == 0){
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_RESET_PASSWORD_VIA_EMAIL taskInfo:nil taskType:WT_RESET_PASSWORD_VIA_EMAIL notificationName:WT_RESET_PASSWORD_VIA_EMAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_reset_password_via_email * netIFCommunicator = [[Communicator_reset_password_via_email alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_RESET_PASSWORD_VIA_EMAIL];
    [postKeys addObject:@"email"]; [postValues addObject:email];
    [postKeys addObject:@"new_password"]; [postValues addObject:new_password];
    [postKeys addObject:@"access_code"]; [postValues addObject:code];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}

+ (void)bindTelephoneWithNumber:(NSString *)phone_number withCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if (phone_number == nil)return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_USER_BIND_PHONE taskInfo:nil taskType:WT_USER_BIND_PHONE notificationName:WT_USER_BIND_PHONE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) return;
    
    
    Communicator_user_bind_phone *netIFCommunicator = [[Communicator_user_bind_phone alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, @"mobile", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_USER_BIND_PHONE, [WTUserDefaults getUid], phone_number, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}



+ (void)reset_password_by_mobileWithTelephoneNumber:(NSString *)phone_number new_password:(NSString *)new_password withCallback:(SEL)selector withObserver:(id)observer{
    if (phone_number == nil || new_password.length == 0)return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_RESET_PASSWORD_BY_MOBILE taskInfo:nil taskType:WT_RESET_PASSWORD_BY_MOBILE notificationName:WT_RESET_PASSWORD_BY_MOBILE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) return;
    
    
    Communicator_reset_password_by_mobile *netIFCommunicator = [[Communicator_reset_password_by_mobile alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, @"mobile", @"new_password" ,nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_RESET_PASSWORD_BY_MOBILE, phone_number, new_password , nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)check_mobile_existWithTelephoneNumber:(NSString *)phone_number withCallback:(SEL)selector withObserver:(id)observer{
    
    if (phone_number == nil)return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_CHECK_MOBILE_EXIST taskInfo:nil taskType:WT_CHECK_MOBILE_EXIST notificationName:WT_CHECK_MOBILE_EXIST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) return;
    
    
    Communicator_check_mobile_exist *netIFCommunicator = [[Communicator_check_mobile_exist alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, @"mobile",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_CHECK_MOBILE_EXIST, phone_number, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


@end
