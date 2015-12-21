//
//  ChangeNickNameVC.h
//  dev01
//
//  Created by 杨彬 on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class ChangeNickNameVC;


@protocol ChangeNickNameVCDelegate <NSObject>
@optional
- (void)changeNickNameVC:(ChangeNickNameVC *)changeNickNameVC didChangeNickName:(NSString *)newNickName;


@end


@interface ChangeNickNameVC : OMViewController


@property (assign, nonatomic)id <ChangeNickNameVCDelegate>delegate;

@end
