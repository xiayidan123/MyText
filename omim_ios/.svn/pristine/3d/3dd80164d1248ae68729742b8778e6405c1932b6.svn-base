//
//  AddActivityMenuView.h
//  dev01
//
//  Created by 杨彬 on 14-10-27.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_BUTTON_ASK 0
#define TAG_BUTTON_VOTE 1
#define TAG_BUTTON_OFFLINEACTOVITY 2

@interface AddActivityMenuView : UIView

@property (nonatomic,assign)BOOL isShow;

@property (retain, nonatomic) IBOutlet UIButton *btn_ask;

@property (retain, nonatomic) IBOutlet UIButton *btn_vote;

@property (retain, nonatomic) IBOutlet UIButton *btn_offlineActovity;

- (IBAction)btnClick:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *maskView;
@property (retain, nonatomic) IBOutlet UIView *bgView;


@property (nonatomic,copy)void(^CB)(UIButton *);

- (void)action;
- (void)show;
- (void)hide;

@end
