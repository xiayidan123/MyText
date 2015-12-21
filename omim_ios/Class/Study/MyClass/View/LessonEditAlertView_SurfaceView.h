//
//  LessonEditAlertView_SurfaceView.h
//  dev01
//
//  Created by 杨彬 on 15/3/12.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LessonEditAlertView_SurfaceView;
@class ClassScheduleModel;


@protocol LessonEditAlertView_SurfaceViewDelegate <NSObject>

@optional
- (void)didClickOKBtnWithSurfaceView:(LessonEditAlertView_SurfaceView *)surfaceView;

- (void)didClickCancelBtnWithSurfaceView:(LessonEditAlertView_SurfaceView *)surfaceView;

@end


@interface LessonEditAlertView_SurfaceView : UIView

@property (retain, nonatomic) IBOutlet UITextField *input_textfield;
@property (retain, nonatomic) UIDatePicker *datePicker;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,assign)BOOL dateType;

@property (nonatomic,retain)ClassScheduleModel *classScheduleModel;


@property (assign, nonatomic)id<LessonEditAlertView_SurfaceViewDelegate>delegate;


+ (instancetype)LessonEditAlertView_SurfaceView;


- (void)becomeFirstResponder;
- (void)releaseFirstResponder;


@end
