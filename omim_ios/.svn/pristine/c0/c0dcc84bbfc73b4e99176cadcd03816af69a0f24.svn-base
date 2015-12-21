//
//  OMNewPasswordViewController.h
//  dev01
//
//  Created by Starmoon on 15/7/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"


typedef NS_ENUM(NSInteger, OMNewPasswordViewControllerSourceType) {
    OMNewPasswordViewControllerSourceType_ByEmail,
    OMNewPasswordViewControllerSourceType_ByTelephone
    
};

@interface OMNewPasswordViewController : OMViewController

/** 通过邮箱or短信 验证码验证成功以后获取的用户ID */
@property (copy, nonatomic) NSString * uid;

/** 验证码 */
@property (copy, nonatomic) NSString * code;

@property (copy, nonatomic) NSString * email;

@property (copy, nonatomic) NSString * telephone;

/** 来源类型(邮箱修改还是手机短信修改) */
@property (assign, nonatomic) OMNewPasswordViewControllerSourceType source_type;




@end
