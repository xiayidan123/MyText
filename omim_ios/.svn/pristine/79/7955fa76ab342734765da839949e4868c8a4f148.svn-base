//
//  HomeworkDetailVC.h
//  dev01
//
//  Created by 杨彬 on 15/5/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"

@class SchoolMember;
@class HomeworkDetailVC;
@class Homework_Moment;
@class Lesson;
@class OMClass;
@protocol HomeworkDetailVCDelegate <NSObject>

@optional
- (void)homeworkDetailVC:(HomeworkDetailVC *)homeworkDetailVC didChangeHomeWorkStateWithStudent:(SchoolMember *)student;

- (void)homeworkDetailVC:(HomeworkDetailVC *)homeworkDetailVC didChangeHomeWorkStateWithHomework_moment:(Homework_Moment *)homework_moment;

@end


@interface HomeworkDetailVC : OMViewController

@property (assign, nonatomic) id <HomeworkDetailVCDelegate>delegate;

@property (copy, nonatomic) NSString * lesson_id;

@property (retain, nonatomic) SchoolMember * student;

@property (retain, nonatomic) OMClass * classmodel;

@property (retain, nonatomic) Lesson * lessonmodel;

- (void)checkHomework;

@end
