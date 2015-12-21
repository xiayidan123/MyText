//
//  StuSettingHomeworkVC.h
//  dev01
//
//  Created by Huan on 15/8/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class NewhomeWorkModel;
@class Lesson;
@class OMClass;
@interface StuSettingHomeworkVC : OMViewController
@property (retain, nonatomic) Lesson * lessonModel;
@property (retain, nonatomic) OMClass * classmodel;
@property (retain, nonatomic) NewhomeWorkModel * homeworkModel;
@end
