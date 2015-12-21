//
//  StudentUploadHomeworkVC.h
//  dev01
//
//  Created by Huan on 15/6/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class NewhomeWorkModel;
@class StudentUploadHomeworkVC;
@class Homework_Moment;
@class Lesson;
@class OMClass;
@protocol StudentUploadHomeworkVCDelegate <NSObject>

@optional
- (void)studentUploadHomeworkVC:(StudentUploadHomeworkVC *)studentUploadHomeworkVC didUploadHomeworkWithHomework_model:(NewhomeWorkModel *)homework_model andHomework_moment:(Homework_Moment *)homework_moment;

@end



@interface StudentUploadHomeworkVC : OMViewController

@property (assign, nonatomic) id <StudentUploadHomeworkVCDelegate>delegate;

@property (retain, nonatomic) NewhomeWorkModel * homeworkModel;

@property (retain, nonatomic) OMClass * classmodel;

@property (retain, nonatomic) Lesson * lessonmodel;
@end
