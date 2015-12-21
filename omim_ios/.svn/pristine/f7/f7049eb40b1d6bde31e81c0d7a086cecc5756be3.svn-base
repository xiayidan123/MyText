//
//  LessonListVC.h
//  dev01
//
//  Created by 杨彬 on 15/3/12.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class OMClass;
@class LessonListVC;
@class Lesson;

@protocol LessonListVCDelegate <NSObject>

- (void)lessonListVC:(LessonListVC *)lessonListVC didDeleteLessonWithLessonModel:(Lesson *)lessonModel;

- (void)lessonListVC:(LessonListVC *)lessonListVC didAddLessonWithLessonModel:(Lesson *)lessonModel;

- (void)lessonListVC:(LessonListVC *)lessonListVC didModifyLessonWithLessonModel:(Lesson *)lessonModel;
@end


@interface LessonListVC : OMViewController

@property (assign, nonatomic)id<LessonListVCDelegate>delegate;

@property (retain,nonatomic)OMClass *classModel;

@property (retain,nonatomic)NSMutableArray *lessonArray;

@end
