//
//  CountdownBtn.m
//  dev01
//
//  Created by Huan on 15/3/11.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "CountdownBtn.h"

@implementation CountdownBtn
{
    int time;
    NSTimer *timer;
    NSString *btnTitle;
}
- (void)awakeFromNib
{
    [self setEnabled:NO];
    
}
- (void)setHighlighted:(BOOL)highlighted
{
    
}
- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        [self setTitleColor:[UIColor colorWithRed:0.31f green:0.52f blue:0.67f alpha:1.00f] forState:UIControlStateNormal];
        [self setTitle:@"重新获取验证码" forState:UIControlStateNormal];
//        self.titleLabel.text = @"重新获取验证码";
    }
    else{
        [self setTitleColor:[UIColor colorWithRed:0.56f green:0.78f blue:0.90f alpha:1.00f] forState:UIControlStateDisabled];
    }
}
- (void)Countdown
{
    time = 60;
    btnTitle = [NSString stringWithFormat:@"重新获取验证码(%d S)",time];
    
    [self setTitle:btnTitle forState:UIControlStateDisabled];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(btnTime) userInfo:nil repeats:YES];
}

- (void)btnTime
{
    time--;
    btnTitle = [NSString stringWithFormat:@"重新获取验证码(%d S)",time];
    [self setTitle:btnTitle forState:UIControlStateDisabled];
    if (time == 0) {
        [self setEnabled:YES];
        [timer invalidate];
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
