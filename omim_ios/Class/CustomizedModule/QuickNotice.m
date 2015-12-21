//
//  QuickNotice.m
//  omimbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "QuickNotice.h"

@implementation QuickNotice

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
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



-(void)setMsg:(NSString *)msg
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.minimumScaleFactor = 9;
    label.textColor = [UIColor whiteColor];
    
    [self addSubview:label];
}


-(void)show{
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 1.0;
        
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:2.0 animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                
            }];
        }
    }];
}

@end
