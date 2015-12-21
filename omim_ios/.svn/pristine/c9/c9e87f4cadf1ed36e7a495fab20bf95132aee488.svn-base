//
//  GenderVC.h
//  dev01
//
//  Created by 杨彬 on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"

@class GenderVC;


@protocol GenderVCDelegate <NSObject>

- (void)genderVC:(GenderVC *)genderVC didChangeGender:(NSString *)genderType;


@end


@interface GenderVC : OMViewController

@property (assign, nonatomic)id<GenderVCDelegate>delegate;


@end
