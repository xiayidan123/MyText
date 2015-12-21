//
//  LessonEditAlertView.h
//  dev01
//
//  Created by 杨彬 on 15/3/12.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Lesson;
@class OMClass;
@class LessonEditAlertView;

@protocol LessonEditAlertViewDelegate <NSObject>

- (void)lessonEditAlertView:(LessonEditAlertView *)lessonEditAlerView addLesson:(Lesson *)lessonModel;

- (void)lessonEditAlertView:(LessonEditAlertView *)lessonEditAlerView modifyLesson:(Lesson *)lessModel;

@end


typedef NS_ENUM(NSInteger, LessonEditAlertViewTpye) {
    LessonEditAlertViewDefault,
    LessonEditAlertViewTpyeDate
};


@interface LessonEditAlertView : UIView


@property (retain, nonatomic)Lesson *lessonModel;
@property (retain, nonatomic)OMClass *classModel;


- (instancetype)initWithTitle:(NSString *)title delegate:(id<LessonEditAlertViewDelegate>)delegate withType:(LessonEditAlertViewTpye)type;


+ (instancetype)lessonEditAlertViewWithTitle:(NSString *)title delegate:(id<LessonEditAlertViewDelegate>)delegate withType:(LessonEditAlertViewTpye)type;

- (void)show;

- (void)remove;

@end
