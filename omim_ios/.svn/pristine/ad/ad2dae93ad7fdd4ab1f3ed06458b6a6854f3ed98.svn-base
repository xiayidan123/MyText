//
//  DatePickerView.m
//  dev01
//
//  Created by jianxd on 14-12-4.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView()

@property (retain, nonatomic) UIView *superView;

@end

@implementation DatePickerView

@synthesize superView = _superView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    CGRect originRect = self.frame;
    self.frame = CGRectMake(originRect.origin.x, view.frame.size.height, originRect.size.width, originRect.size.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.frame = originRect;
                     }
                     completion:^(BOOL finished){
                     }];
    self.superView = view;
}

- (void)dismissFromSuperView
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x, self.superView.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self removeFromSuperview];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_superView release];
    [super dealloc];
}

@end
