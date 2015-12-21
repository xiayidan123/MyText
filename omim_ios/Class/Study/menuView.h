//
//  menuView.h
//  dev01
//
//  Created by 杨彬 on 14-10-5.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_BUTTON_NOTICE 0
#define TAG_BUTTON_ASK 1
#define TAG_BUTTON_STUDY 2

#define TAG_BUTTON_LIFE 5
#define TAG_BUTTON_VIDEO 6

#define TAG_BUTTON_VOTE 99

@interface menuView : UIView

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UIView *maskView;
@property (retain, nonatomic) IBOutlet UIButton *btn_ask;
@property (retain, nonatomic) IBOutlet UIButton *btn_study;
@property (retain, nonatomic) IBOutlet UIButton *btn_life;
@property (retain, nonatomic) IBOutlet UIButton *btn_vote;
@property (retain, nonatomic) IBOutlet UIButton *btn_notice;
@property (retain, nonatomic) IBOutlet UIButton *btn_video;


@property (nonatomic,copy) void(^CB)(UIButton *);



- (IBAction)buttonClicked:(id)sender;





@end
