//
//  PersonalInfoVC.h
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class PersonalInfoVC;

@protocol PersonalInfoVCDelegate <NSObject>

- (void)personalInfoVC:(PersonalInfoVC *)personalInfoVC didChangeNickName:(NSString *)newNickName;

- (void)personalInfoVC:(PersonalInfoVC *)personalInfoVC didChangeHeadImageIsThumb:(BOOL )isThumb;





@end

@interface PersonalInfoVC : OMViewController

@property (assign, nonatomic)id<PersonalInfoVCDelegate>delegate;


@end
