//
//  AddClassBulletinVC.h
//  dev01
//
//  Created by 杨彬 on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class OMClass;
@class AddClassBulletinVC;
@class Moment;


@protocol AddClassBulletinVCDelegate <NSObject>

- (void)addClassBulletinVC:(AddClassBulletinVC *)AddClassBulletinVC moment:(Moment *)moment;


@end

@interface AddClassBulletinVC : OMViewController

@property (assign, nonatomic)id<AddClassBulletinVCDelegate>delegate;

@property (retain, nonatomic) NSMutableArray *class_array;

@property (retain, nonatomic) OMClass *class_model;


@end
