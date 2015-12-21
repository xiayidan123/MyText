//
//  BindingTelephoneVCViewController.h
//  dev01
//
//  Created by Starmoon on 15/7/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"

@interface BindingTelephoneViewController : OMViewController

/** 是否是改变 绑定手机号码  */
@property (assign, nonatomic) BOOL isChangeBindingTelephone;

/** 登录时强制绑定 */
@property (assign, nonatomic) BOOL LoginBingding;

@end
