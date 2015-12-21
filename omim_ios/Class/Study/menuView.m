//
//  menuView.m
//  dev01
//
//  Created by 杨彬 on 14-10-5.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "menuView.h"
#import "WTUserDefaults.h"
@implementation menuView

-(void)drawRect:(CGRect)rect{

    
    _btn_ask.tag = TAG_BUTTON_ASK;
    _btn_ask.titleEdgeInsets = UIEdgeInsetsMake(54, -35, 12, 0);
    _btn_ask.imageEdgeInsets = UIEdgeInsetsMake(20, 36, 26, 36);
    [_btn_ask setTitle:NSLocalizedString(@"问答", nil) forState:UIControlStateNormal];
    
    _btn_study.tag = TAG_BUTTON_STUDY;
    _btn_study.titleEdgeInsets = UIEdgeInsetsMake(54, -35, 12, 0);
    _btn_study.imageEdgeInsets = UIEdgeInsetsMake(20, 36, 26, 36);
    [_btn_study setTitle:NSLocalizedString(@"学习", nil) forState:UIControlStateNormal];
    
    _btn_life.tag = TAG_BUTTON_LIFE;
    _btn_life.titleEdgeInsets = UIEdgeInsetsMake(54, -35, 12, 0);
    _btn_life.imageEdgeInsets = UIEdgeInsetsMake(20, 36, 26, 36);
    [_btn_life setTitle:NSLocalizedString(@"生活", nil) forState:UIControlStateNormal];
    
 
    _btn_vote.tag = TAG_BUTTON_VOTE;
    _btn_vote.titleEdgeInsets = UIEdgeInsetsMake(54, -35, 12, 0);
    _btn_vote.imageEdgeInsets = UIEdgeInsetsMake(20, 36, 26, 36);
    [_btn_vote setTitle:NSLocalizedString(@"投票", nil) forState:UIControlStateNormal];
    
    
    
  
    
    _btn_notice.tag = TAG_BUTTON_NOTICE;
    _btn_notice.titleEdgeInsets = UIEdgeInsetsMake(54, -35, 12, 0);
    _btn_notice.imageEdgeInsets = UIEdgeInsetsMake(20, 36, 26, 36);
    [_btn_notice setTitle:NSLocalizedString(@"通知", nil) forState:UIControlStateNormal];
    
    _btn_video.tag = TAG_BUTTON_VIDEO;
    _btn_video.titleEdgeInsets = UIEdgeInsetsMake(54, -35, 12, 0);
    _btn_video.imageEdgeInsets = UIEdgeInsetsMake(20, 36, 26, 36);
    [_btn_video setTitle:NSLocalizedString(@"视频", nil) forState:UIControlStateNormal];
    
    if ([[WTUserDefaults getUsertype] isEqualToString:@"1"]) {
        _btn_notice.hidden = YES;
        _btn_video.hidden = YES;
    }
}


- (void)dealloc {
    [_btn_notice release];
    [_btn_study release];
    [_btn_life release];
    [_btn_ask release];
    [_btn_vote release];
    [_btn_video release];
    [_CB release];
    [_maskView release];
    [_bgView release];
    [super dealloc];
}


- (IBAction)buttonClicked:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]){
        _CB(sender);
        
    }
}





@end
