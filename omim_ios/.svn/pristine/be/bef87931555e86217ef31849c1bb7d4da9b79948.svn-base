//
//  SettingHomeworkVC.h
//  dev01
//
//  Created by Huan on 15/5/15.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class OMClass;
@class Lesson;
@class NewhomeWorkModel;
@class SettingHomeworkVC;


@protocol SettingHomeworkVCDelegate <NSObject>

- (void)SettingHomeworkVC:(SettingHomeworkVC *)settingHomeworkVC didModifyHomework:(NewhomeWorkModel *)homeworkModel;

@end


@interface SettingHomeworkVC : OMViewController

@property (assign, nonatomic) id <SettingHomeworkVCDelegate>delegate;

@property (retain, nonatomic) OMClass * classModel;
@property (retain, nonatomic) Lesson * lessonModel;
@property (retain, nonatomic) NewhomeWorkModel * homeworkModel;
@property (assign, nonatomic) BOOL isSettingHomework;

@property (assign, nonatomic) BOOL isEditing;
@end
