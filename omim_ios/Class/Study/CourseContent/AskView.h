//
//  AskView.h
//  dev01
//
//  Created by 杨彬 on 14-10-16.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskView : UIView

@property (retain, nonatomic) IBOutlet UIView *upBgView;

@property (retain, nonatomic) IBOutlet UIView *downBgView;



@property (retain, nonatomic) IBOutlet UILabel *title_question;

@property (retain, nonatomic) IBOutlet UIView *question_bgView;

@property (retain, nonatomic) IBOutlet UILabel *lal_question;

@property (retain, nonatomic) IBOutlet UILabel *lal_answerA;

@property (retain, nonatomic) IBOutlet UILabel *lal_answerB;

@property (retain, nonatomic) IBOutlet UILabel *lal_answerC;

@property (retain, nonatomic) IBOutlet UIView *dividinglineA;

@property (retain, nonatomic) IBOutlet UIView *dividinglineB;

@property (retain, nonatomic) IBOutlet UIView *imgv_question;

@property (retain, nonatomic) IBOutlet UIButton *btn_audio;



@property (retain, nonatomic) IBOutlet UILabel *title_answers;

@property (retain, nonatomic) IBOutlet UILabel *lal_repeatQuestion;

@property (retain, nonatomic) IBOutlet UIView *dividinglineC;

@property (retain, nonatomic) IBOutlet UIView *imgv_answer;

- (void)loadViewWithFrame:(CGRect)frame andData:(id)data;

@end
