//
//  LPButton.m
//  wallpapers
//
//  Created by Harry on 12-10-4.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

#import "LPButton.h"

@implementation LPButton

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        isLongPress = NO;
    }
    return self;
}

- (void)longPress
{
    isLongPress = YES;
    [delegate longPressLPButton:self];
    [timer invalidate];
    timer = nil;
}

- (void)releaseButton
{
    [delegate releaseLPButton:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isLongPress = NO;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longPress) userInfo:nil repeats:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if (!isLongPress)
    {
        [delegate singleTapLPButton:self];
    }
    else
    {
        isLongPress = NO;
        [self performSelector:@selector(releaseButton) withObject:nil afterDelay:1.5f];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if (isLongPress)
    {
        isLongPress = NO;
        [delegate releaseLPButton:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
