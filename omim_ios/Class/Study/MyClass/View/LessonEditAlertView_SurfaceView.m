//
//  LessonEditAlertView_SurfaceView.m
//  dev01
//
//  Created by 杨彬 on 15/3/12.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LessonEditAlertView_SurfaceView.h"
#import "ClassScheduleModel.h"

@interface LessonEditAlertView_SurfaceView ()

@property (retain, nonatomic) IBOutlet UILabel *title_label;


@property (retain, nonatomic) IBOutlet UIButton *btn_cancel;
@property (retain, nonatomic) IBOutlet UIButton *btn_ok;



- (IBAction)okAction;

- (IBAction)cancelAction;

@end



@implementation LessonEditAlertView_SurfaceView

- (void)dealloc {
    [_classScheduleModel release];
    [_datePicker release];
    [_title_label release];
    [_input_textfield release];
    [_btn_cancel release];
    [_btn_ok release];
    [super dealloc];
}



-(void)awakeFromNib{
    self.title_label.userInteractionEnabled = YES;
    [self.title_label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(releaseFirstResponder)]];
    
    [self.btn_cancel setTitle:NSLocalizedString(@"Cancel",nil) forState:UIControlStateNormal];
    [self.btn_ok setTitle:NSLocalizedString(@"OK",nil) forState:UIControlStateNormal];
}


+ (instancetype)LessonEditAlertView_SurfaceView{
    LessonEditAlertView_SurfaceView *surfaceView = [[[NSBundle mainBundle]loadNibNamed:@"LessonEditAlertView_SurfaceView" owner:nil options:nil] lastObject];
    surfaceView.layer.cornerRadius = 5;
    surfaceView.layer.masksToBounds = YES;
    return surfaceView;
}

-(void)setDateType:(BOOL)dateType{
    _dateType = dateType;
    
    if (_dateType){
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 88, self.frame.size.width, 162)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.transform = CGAffineTransformMakeScale(self.frame.size.width / 320.0,self.frame.size.width / 320.0);
        datePicker.frame = CGRectMake(0, 88, self.frame.size.width, 260);
        [self addSubview:datePicker];
        self.datePicker = datePicker;
        [datePicker release];
        
        if (self.classScheduleModel == nil){
            datePicker.date = [NSDate date];
        }
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 50, self.frame.size.width, self.frame.size.height + 162);
    }
}

-(void)setClassScheduleModel:(ClassScheduleModel *)classScheduleModel{
    [_classScheduleModel release],_classScheduleModel = nil;
    _classScheduleModel = [classScheduleModel retain];
}



- (void)becomeFirstResponder{
    [self.input_textfield becomeFirstResponder];
}

- (void)releaseFirstResponder{
    [self.input_textfield resignFirstResponder];
}


-(void)setTitle:(NSString *)title{
    self.title_label.text = title;
}


- (IBAction)okAction {
    
    if ([self.delegate respondsToSelector:@selector(didClickOKBtnWithSurfaceView:)]){
        [self.delegate didClickOKBtnWithSurfaceView:self];
    }
}

- (IBAction)cancelAction {
    if ([self.delegate respondsToSelector:@selector(didClickCancelBtnWithSurfaceView:)]){
        [self.delegate didClickCancelBtnWithSurfaceView:self];
    }
}




@end
