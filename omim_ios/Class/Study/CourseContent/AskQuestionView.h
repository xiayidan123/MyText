//
//  AskQuestionView.h
//  dev01
//
//  Created by 杨彬 on 14-10-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskQuestionView : UIView<UITextViewDelegate>


@property (retain, nonatomic) IBOutlet UILabel *lal_Prompt;
@property (retain, nonatomic) IBOutlet UITextView *TV_Question;
@property (retain, nonatomic) IBOutlet UIView *dividinglineA;
@property (retain, nonatomic) IBOutlet UIView *dividinglineB;
@property (retain, nonatomic) IBOutlet UIButton *btn_audio;


- (void)loadAskQuestionView;

- (void)adjustPosition;

@end
