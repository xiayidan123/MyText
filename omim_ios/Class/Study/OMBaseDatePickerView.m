//
//  OMBaseDatePickerView.m
//  dev01
//
//  Created by 杨彬 on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBaseDatePickerView.h"
#import "OMBaseCellFrameModel.h"

#define OriginY 44
#define Height  200
#define ButtonHeight 44

#define Scale 0.7


@interface OMBaseDatePickerView ()

@property (retain, nonatomic) UIDatePicker *datePicker;

@property (retain, nonatomic) UIButton *enterButton;

@end

@implementation OMBaseDatePickerView

-(void)dealloc{
    [_cellFrameModel release],_cellFrameModel = nil;
    [_datePicker release],_datePicker = nil;
    [super dealloc];
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        [self loadDatePicker];
        
        [self loadEnterButton];
        
        self.frame = CGRectMake(0, OriginY,frame.size.width, 1);
    }
    return self;
}


+ (instancetype)baseDatePickerViewWithFrame:(CGRect)frame{
    OMBaseDatePickerView *baseDatePickerView = [[OMBaseDatePickerView alloc]initWithFrame:CGRectMake( 0, OriginY ,frame.size.width, Height)];
//    baseDatePickerView.backgroundColor = [UIColor yellowColor];
    return [baseDatePickerView autorelease];
}

- (void)loadDatePicker{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
//    datePicker.backgroundColor = [UIColor redColor];
    datePicker.transform = CGAffineTransformMakeScale(0.7, 0.7);
    datePicker.center = CGPointMake(self.bounds.size.width/2, 80);
    [self addSubview:datePicker];
    [datePicker release];
    self.datePicker = datePicker;
}

- (void)loadEnterButton{
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    enterButton.backgroundColor = [UIColor greenColor];
    enterButton.frame = CGRectMake(0, self.datePicker.frame.size.height + self.datePicker.frame.origin.y, self.frame.size.width, ButtonHeight);
    [enterButton setTitle:NSLocalizedString(@"OK",nil) forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    enterButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [enterButton addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:enterButton];
    self.enterButton = enterButton;
}

-(void)setType:(OMBaseDatePickerViewType)type{
    _type = type;
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    if (_type == OMBaseDatePickerViewTypeDefault){
//#warning 后续补充缺省条件
    }else if (_type == OMBaseDatePickerViewTypeDate){
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    }else if (_type == OMBaseDatePickerViewTypeTime){
        [dateFormat setDateFormat:@"HH:mm"];
        self.datePicker.datePickerMode = UIDatePickerModeTime;
    }else if (_type == OMBaseDatePickerViewTypeCountDownTimer){
        [dateFormat setDateFormat:@"HH:mm"];
        self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    }
    NSDate *date =[dateFormat dateFromString:self.cellFrameModel.cellModel.content];
    if (date == nil){
        date = [NSDate date];
        if (_type == OMBaseDatePickerViewTypeCountDownTimer){
            [NSDate dateWithTimeIntervalSinceNow:0];
        }
    }
    [self.datePicker setDate:date];
    [dateFormat release];
}


- (void)enterAction:(UIButton *)button{
    [self refreshModel];
    
    if ([self.delegate respondsToSelector:@selector(baseDatePickerView:enterClick:)]){
        [self.delegate baseDatePickerView:self enterClick:self.cellFrameModel];
    }
}


- (void)showDatePickerWithAnimated:(BOOL)animated {
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, Height);
    }];
}

- (void)hiddenDatePickerWithAnimated:(BOOL)animated withCompletion:(void(^)(void))CB{
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,1);
    }completion:^(BOOL finished) {
        CB();
    }];
}

- (void)refreshModel{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    if (_type == OMBaseDatePickerViewTypeDefault){
//#warning 后续补充缺省条件
    }else if (_type == OMBaseDatePickerViewTypeDate){
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    }else if (_type == OMBaseDatePickerViewTypeTime){
        [dateFormat setDateFormat:@"HH:mm"];
        self.datePicker.datePickerMode = UIDatePickerModeTime;
    }else if (_type == OMBaseDatePickerViewTypeCountDownTimer){
        [dateFormat setDateFormat:@"HH:mm"];
        self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    }
    else{
        
    }
    NSDate *modifiDate = [self.datePicker date];
    NSString *modifiDateStr = [dateFormat stringFromDate:modifiDate];
    [dateFormat release];
    
    self.cellFrameModel.cellModel.content = modifiDateStr;
}


@end
