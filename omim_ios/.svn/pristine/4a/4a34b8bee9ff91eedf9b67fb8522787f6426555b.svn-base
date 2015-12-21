//
//  CusBtn.m
//  dev01
//
//  Created by Huan on 15/3/12.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "CusBtn.h"

@interface CusBtn()
@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,assign) int time;
@end

@implementation CusBtn

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        UIImage *cannotImg = [UIImage imageNamed:@"btn_small_valid"];
        [self setBackgroundImage:[cannotImg stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    else{
        UIImage *cannotImg = [UIImage imageNamed:@"btn_small_invalid"];
        [self setBackgroundImage:[cannotImg stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
}
- (void)Countdown
{
    _time = 60;
    _title = [NSString stringWithFormat:@"重新发送验证码(%d S)",_time];
    [self setTitle:_title forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(btnTime) userInfo:nil repeats:YES];
}

- (void)btnTime
{
    _time--;
    _title = [NSString stringWithFormat:@"重新发送验证码(%d S)",_time];
    [self setTitle:_title forState:UIControlStateNormal];
    if (_time == 0) {
        [self setEnabled:YES];
        [self setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
