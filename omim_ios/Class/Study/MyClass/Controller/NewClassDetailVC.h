//
//  NewClassDetailVC.h
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
#import "ClassScheduleModel.h"
@class OMClass;
@class Lesson;

@interface NewClassDetailVC : OMViewController

@property (retain, nonatomic) Lesson *lessonModel;
@property (retain, nonatomic) OMClass *classModel;

@end
