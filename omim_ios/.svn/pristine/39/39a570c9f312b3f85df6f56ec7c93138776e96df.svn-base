//
//  OMNetwork_Login.h
//  dev01
//
//  Created by Starmoon on 15/7/24.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTNetworkTaskConstant.h"
#import "WTError.h"

#define SmstemplateID  @"27154"

@interface OMNetwork_Login : NSObject


/** 发送短信验证码
 * telephone_number 手机号码
 * type 用于什么目的（注册 找回密码 绑定手机号码）
 * smstemplateid 短信模板ID
 */
+ (void)sms_sendSMS:(NSString *)telephone_number withType:(NSString *)type smstemplateid:(NSString *)smstemplateid withCallback:(SEL)selector withObserver:(id)observer;

/** 手机短语验证码验证 */
+ (void)sms_checkCodeWithTelephone_number:(NSString *)telephone_number withCode:(NSString *)code withCallback:(SEL)selector withObserver:(id)observer;

/** 发送邮箱验证码（找回密码） */
+ (void)retrieve_passwork_via_emailWithEmail:(NSString *)email withCallback:(SEL)selector withObserver:(id)observer;

/** 验证邮箱验证码(找回密码 ，有设置新密码功能，因为API局限，现在随机生成新密码，再在用户填写新密码界面，调用密码修改接口，将随机生成的密码修改成用户增加的密码 随机生成的密码在内部实现，不会暴露给用户) */
+ (void)reset_password_via_email:(NSString *)email access_code:(NSString *)code new_password:(NSString *)new_password withCallback:(SEL)selector withObserver:(id)observer;

/** 绑定手机号码 */
+ (void)bindTelephoneWithNumber:(NSString *)phone_number withCallback:(SEL)selector withObserver:(id)observer;

/** 手机找回密码，修改密码接口 */
+ (void)reset_password_by_mobileWithTelephoneNumber:(NSString *)phone_number new_password:(NSString *)new_password withCallback:(SEL)selector withObserver:(id)observer;
/** 检查当前手机号码是否存在于服务器（止原来的手机号码重置密码防） */
+ (void)check_mobile_existWithTelephoneNumber:(NSString *)phone_number withCallback:(SEL)selector withObserver:(id)observer;
@end
