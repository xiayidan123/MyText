//
//  EditLessonVC.h
//  dev01
//
//  Created by 杨彬 on 15/3/26.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Lesson;
@class OMClass;
@class EditLessonVC;

@protocol EditLessonVCDelegate <NSObject>

//- (void)editLessonVC:(EditLessonVC *)editLessonVC didDeleteLessonWithLessonModel:(Lesson *)lessonModel;

- (void)editLessonVC:(EditLessonVC *)editLessonVC didAddLessonWithLessonModel:(Lesson *)lessonModel;

- (void)editLessonVC:(EditLessonVC *)editLessonVC didModifyLessonWithLessonModel:(Lesson *)lessonModel;


@end




@interface EditLessonVC : UIViewController


@property (assign, nonatomic)id<EditLessonVCDelegate>delegate;

@property (retain, nonatomic)Lesson *lessonModel;

@property (retain, nonatomic)OMClass *classModel;

@property (retain, nonatomic)NSMutableArray *lessonArray;

@end
