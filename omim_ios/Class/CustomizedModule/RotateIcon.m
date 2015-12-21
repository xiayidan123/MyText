//
//  rotateIcon.m
//  wowcity
//
//  Created by elvis on 2013/06/06.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "RotateIcon.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation RotateIcon

+(RotateIcon*)sharedRotateIcon
{
    
    @synchronized(self)
    {
        static RotateIcon *icon = nil;
        
        if (icon == nil)
        {
            icon = [[RotateIcon alloc]initWithFrame:CGRectZero];
        }
        return icon;
    }

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(10, -20, 28, 28);
        self.image = [UIImage imageNamed:@"refresh.png"];  
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)show
{
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:-360 * M_PI/180];
    rotate.duration = 0.5;
    rotate.repeatCount = 20;
    [self.layer addAnimation:rotate forKey:@"11"];
    
    [self.parent.view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(10, 20, 28, 28);
    }];
}

-(void)hide
{
    if (self.superview == nil) {
        return;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(10, -20, 28, 28);
    } completion:^(BOOL finished) {
        if (finished) {
             [self removeFromSuperview];
        }
    }];
   
    
}


@end
