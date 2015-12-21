//
//  RadioButtonView.m
//  dev01
//
//  Created by 杨彬 on 14-12-30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "RadioButtonView.h"



@implementation RadioButtonView
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _enabledSelect = YES;
    }
    return self;
}

-(void)setNumberOfSelectPart:(NSInteger)numberOfSelectPart{
    _numberOfSelectPart = numberOfSelectPart;
    
    for (int i=0; i<numberOfSelectPart; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.frame.size.width/_numberOfSelectPart * i, 0, self.frame.size.width/_numberOfSelectPart, self.self.frame.size.height);
        [button setImage:[UIImage imageNamed:@"timeline_unchecked"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"timeline_checked"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 500+i;
        if (i== 0)button.selected = YES;
        [self addSubview:button];
    }
}


- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    for (int i=0; i<_numberOfSelectPart;i++){
        UIButton *button = (UIButton *)[self viewWithTag:500+ i];
        if (i == _selectIndex){
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    
}


- (void)click:(UIButton *)btn{
    if (!_enabledSelect){
        return;
    }
    for (int i=0; i<_numberOfSelectPart; i++){
        UIButton *btn = (UIButton *)[self viewWithTag:(500 + i)];
        btn.selected = NO;
    }
    btn.selected = YES;
    if ([_delegate respondsToSelector:@selector(didSeletedWithIndex:)]){
        [_delegate didSeletedWithIndex:btn.tag - 500];
    }
}



@end
