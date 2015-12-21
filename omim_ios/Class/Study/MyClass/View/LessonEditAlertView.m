//
//  LessonEditAlertView.m
//  dev01
//
//  Created by 杨彬 on 15/3/12.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LessonEditAlertView.h"
#import "LessonEditAlertView_SurfaceView.h"

#import "Lesson.h"
#import "OMClass.h"

#import "NSDate+ClassScheduleDate.h"


@interface LessonEditAlertView ()<LessonEditAlertView_SurfaceViewDelegate>

@property (retain, nonatomic)LessonEditAlertView_SurfaceView *surfaceView;

@property (assign, nonatomic)id<LessonEditAlertViewDelegate>delegate;

@property (copy, nonatomic)NSString *title;

@property (assign, nonatomic)LessonEditAlertViewTpye type;

@end


@implementation LessonEditAlertView

-(void)dealloc{
    [_classModel release];
    [_lessonModel release];
    [_surfaceView release],_surfaceView = nil;
    [super dealloc];
}


+ (instancetype)lessonEditAlertViewWithTitle:(NSString *)title delegate:(id<LessonEditAlertViewDelegate>)delegate withType:(LessonEditAlertViewTpye)type{
    return [[[[self class] alloc] initWithTitle:title delegate:delegate withType:type] autorelease];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LessonEditAlertViewDelegate>)delegate withType:(LessonEditAlertViewTpye)type{
    CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
    self = [super initWithFrame:frame];
    if (self){
        
        self.delegate = delegate;
        self.title = title;
        self.type = type;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self loadMarkView];
        
        [self loadSurfaceView];
    }
    return self;
}


- (void)loadMarkView{
    UIView *markView = [[UIView alloc]initWithFrame:self.bounds];
    markView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    markView.userInteractionEnabled = YES;
    [markView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(markViewClick)]];
    [self addSubview:markView];
    [markView release];
}

- (void)loadSurfaceView{
    LessonEditAlertView_SurfaceView *surfaceView = [LessonEditAlertView_SurfaceView LessonEditAlertView_SurfaceView];
    surfaceView.delegate = self;
    self.surfaceView = surfaceView;
    self.surfaceView.title = self.title;
    [self addSubview:self.surfaceView];
    self.surfaceView.center = CGPointMake(self.center.x, self.center.y - 100);
    
    if (self.type == LessonEditAlertViewTpyeDate){
        self.surfaceView.dateType = YES;
    }
}

- (void)setLessonModel:(Lesson *)lessonModel{
    [_lessonModel release],_lessonModel = nil;
    _lessonModel = [lessonModel retain];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[_lessonModel.start_date floatValue]];
    [self.surfaceView.datePicker setDate:startDate];
    
    self.surfaceView.input_textfield.text = _lessonModel.title;
}


//-(void)setClassScheduleModel:(ClassScheduleModel *)classScheduleModel{
//    [_classScheduleModel release],_classScheduleModel = nil;
//    _classScheduleModel = [classScheduleModel retain];
//    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[self.classScheduleModel.start_date floatValue]];
//    [self.surfaceView.datePicker setDate:startDate];
//    
//    self.surfaceView.input_textfield.text = _classScheduleModel.title;
//}


- (void)markViewClick{
    [self.surfaceView releaseFirstResponder];
}


- (void)show{
    self.surfaceView.alpha = 0;
    self.surfaceView.transform = CGAffineTransformMakeScale(0.1,0.1);
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.surfaceView becomeFirstResponder];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.surfaceView.alpha = 1;
        self.surfaceView.transform = CGAffineTransformMakeScale(1,1);
    }];
    
}

- (void)remove{
    [self removeFromSuperview];
}

#pragma mark - LessonEditAlertView_SurfaceViewDelegate

- (void)didClickOKBtnWithSurfaceView:(LessonEditAlertView_SurfaceView *)surfaceView{
    self.lessonModel.title = surfaceView.input_textfield.text;
    if (self.lessonModel == nil){// 添加课程
        [self addLessonWithSurfaceView:surfaceView];
    }else{
        [self modifyLessonWithSurfaceView:surfaceView];
    }
    
    
    
}

- (void)didClickCancelBtnWithSurfaceView:(LessonEditAlertView_SurfaceView *)surfaceView{
    [self removeFromSuperview];
}

#pragma mark - action handel

- (void)modifyLessonWithSurfaceView:(LessonEditAlertView_SurfaceView *)surfaceView{
    if ([surfaceView.input_textfield.text isEqualToString:@""] || surfaceView.input_textfield.text.length == 0 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"活动标题不能为空",nil) delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alert show];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [alert release];
        });
        return;
    }
    
    if (self.type == LessonEditAlertViewTpyeDate){
        NSTimeInterval startTime = [NSDate ZeropointWihtDate:[surfaceView.datePicker date]];
        NSTimeInterval classStartTime =[self.classModel.start_day floatValue];
        if (startTime < classStartTime){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"上课日期不能早于开班日期",nil) delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [alert show];
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [alert release];
            });
            return;
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(lessonEditAlertView:modifyLesson:)]){
        self.lessonModel.title = surfaceView.input_textfield.text;
        NSTimeInterval startTime = [NSDate ZeropointWihtDate:[surfaceView.datePicker date]];
        
        if (self.type == LessonEditAlertViewTpyeDate){
            self.lessonModel.start_date = [NSString stringWithFormat:@"%lf",startTime];
            self.lessonModel.end_date = self.lessonModel.start_date;
        }
        
        [self.delegate lessonEditAlertView:self modifyLesson:self.lessonModel];
        [self removeFromSuperview];
    }
}



- (void)addLessonWithSurfaceView:(LessonEditAlertView_SurfaceView *)surfaceView{
    NSTimeInterval startTime = [NSDate ZeropointWihtDate:[surfaceView.datePicker date]];
    NSTimeInterval classStartTime = [self.classModel.start_day floatValue];
    
    
    
//    2,2,2,2014-03-04,10:00,111,03:00
    
    if ([surfaceView.input_textfield.text isEqualToString:@""] || surfaceView.input_textfield.text.length == 0 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"活动标题不能为空",nil) delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alert show];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [alert release];
        });
    }else if (startTime < classStartTime){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"上课日期不能早于开班日期",nil) delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alert show];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [alert release];
        });
    }else{
        
        if ([self.delegate respondsToSelector:@selector(lessonEditAlertView:addClassSchedul:)]){
//            Lesson *lessonModel = [[Lesson alloc]init];
//            lessonModel.title = surfaceView.input_textfield.text;
//            NSTimeInterval classStartClock = [NSDate getTimeIntervalWithString:[_classModel.introduction componentsSeparatedByString:@","][4]];
//            NSTimeInterval classDuration = [NSDate getTimeIntervalWithString:[_classModel.introduction componentsSeparatedByString:@","][6]];
//            classSchedulModel.start_date = [NSString stringWithFormat:@"%lf",startTime + classStartClock];
//            classSchedulModel.end_date = [NSString stringWithFormat:@"%lf",startTime + classStartClock + classDuration];
//            [self.delegate lessonEditAlertView:self addClassSchedul:classSchedulModel];
//            [classSchedulModel release];
//            [self removeFromSuperview];
        }
    }
}



@end
