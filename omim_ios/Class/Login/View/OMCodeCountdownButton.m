 //
//  OMCodeCountdownButton.m
//  dev01
//
//  Created by Starmoon on 15/7/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMCodeCountdownButton.h"

@interface OMCodeCountdownButton ()

/** 计时器 */
@property (retain, nonatomic) NSTimer * timer;


@end

@implementation OMCodeCountdownButton

-(void)dealloc{
    
    self.timer = nil;
    [super dealloc];
}


/** 开始倒计时 */
- (void)fire{
    self.enabled = NO;
    [self.timer fire];
}

/** 结束倒计时 */
- (void)stop{
    
    if (self.enabled == YES){
        return;
    }
    self.enabled = YES;
    
    [self.timer invalidate];
    [self setTitle:@"重新获取验证码" forState:UIControlStateNormal];
    self.timer = nil;
}

-(void)countdownAction{
    if (self.duration <= 0){
        [self stop];
    }else{
        self.duration -= 1.0f;
    }
}


#pragma mark - Set and Get

-(NSTimer *)timer{
    if (_timer == nil){
        _timer = [[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdownAction) userInfo:nil repeats:YES] retain];
    }
    return _timer;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
}


-(void)setDuration:(NSTimeInterval)duration{
    _duration = duration;
    [self setTitle:[NSString stringWithFormat:@"%.0fS",_duration] forState:UIControlStateDisabled];
}



#pragma mark - 构造方法 和 重写父类方法
- (void)setup{
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor colorWithRed:0.03 green:0.6 blue:0.98 alpha:1] forState:UIControlStateNormal];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}





@end
