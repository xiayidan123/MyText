//
//  GradeViewController.h
//  dev01
//
//  Created by Huan on 15/5/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
#import "HomeworkReviewModel.h"

@class SchoolMember;
@class GradeViewController;
@class OMClass;
@class Lesson;
@protocol GradeViewControllerDelegate <NSObject>

- (void)GradeViewController:(GradeViewController *)gradeVC didUploadReview:(HomeworkReviewModel *)homework_review_model;

@end






@interface GradeViewController : OMViewController


@property (assign, nonatomic) id <GradeViewControllerDelegate>delegate;

@property (retain, nonatomic) SchoolMember * student;

@property (retain, nonatomic) OMClass * classmodel;

@property (retain, nonatomic) Lesson * lessonmodel;

@end
