//
//  AddActivityMenuView.m
//  dev01
//
//  Created by 杨彬 on 14-10-27.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "AddActivityMenuView.h"

@implementation AddActivityMenuView
{
//    CGRect _menuRect;
    BOOL _isMoving;
}

- (void)dealloc {
    [_btn_ask release];
    [_btn_vote release];
    [_btn_offlineActovity release];
    [_maskView release];
    [_bgView release];
    [super dealloc];
}

-(void)drawRect:(CGRect)rect{
    self.layer.masksToBounds = YES;
    _bgView.layer.masksToBounds = YES;
    
    
    _btn_ask.tag = TAG_BUTTON_ASK;
    _btn_ask.titleEdgeInsets = UIEdgeInsetsMake(54, -35, 12, 0);
    _btn_ask.imageEdgeInsets = UIEdgeInsetsMake(20, 36, 26, 36);
    [_btn_ask setTitle:NSLocalizedString(@"问答", nil) forState:UIControlStateNormal];
    
    _btn_vote.tag = TAG_BUTTON_VOTE;
    _btn_vote.titleEdgeInsets = UIEdgeInsetsMake(54, -35, 12, 0);
    _btn_vote.imageEdgeInsets = UIEdgeInsetsMake(20, 36, 26, 36);
    [_btn_vote setTitle:NSLocalizedString(@"投票", nil) forState:UIControlStateNormal];
    
    _btn_offlineActovity.tag = TAG_BUTTON_OFFLINEACTOVITY;
    _btn_offlineActovity.titleEdgeInsets = UIEdgeInsetsMake(54, -35, 12, 0);
    _btn_offlineActovity.imageEdgeInsets = UIEdgeInsetsMake(20, 36, 26, 36);
    [_btn_offlineActovity setTitle:NSLocalizedString(@"线下活动", nil) forState:UIControlStateNormal];
    
    _bgView.frame = CGRectMake(0, 0, _bgView.frame.size.width, 0);
    
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap)]];
}


- (void)maskViewTap{
    [self hide];
}





- (void)action{
    if (_isMoving){
        return;
    }
    _isShow ? [self hide] : [self show];
}

- (void)show{
    _isMoving = YES;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y);
    _maskView.frame = CGRectMake(_maskView.frame.origin.x, _maskView.frame.origin.y, _maskView.frame.size.width, self.frame.size.height);
    _bgView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.25 animations:^{
//        _bgView.bounds = CGRectMake(0, 0, _bgView.bounds.size.width, 80);
        _bgView.frame = CGRectMake(_bgView.frame.origin.x, _bgView.frame.origin.y, _bgView.frame.size.width, 80);
    }completion:^(BOOL finished) {
        _isShow = YES;
        _isMoving = NO;
    }];
    
}

- (void)hide{
    _isMoving = YES;
    [UIView animateWithDuration:0.25 animations:^{
        _bgView.frame = CGRectMake(_bgView.frame.origin.x, _bgView.frame.origin.y, _bgView.frame.size.width, 0);
    }completion:^(BOOL finished) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        _maskView.frame = CGRectMake(_maskView.frame.origin.x, _maskView.frame.origin.y, _maskView.frame.size.width, 1
                                     );
        _isShow = NO;
        _isMoving = NO;
    }];
}



- (IBAction)btnClick:(id)sender {
    if ([sender isKindOfClass: [UIButton class]]){
        _CB(sender);
    }
}
@end
