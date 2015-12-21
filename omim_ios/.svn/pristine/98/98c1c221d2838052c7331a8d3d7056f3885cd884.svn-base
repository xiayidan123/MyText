//
//  SegmentBar.m
//  dev01
//
//  Created by 杨彬 on 14-10-14.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "SegmentBar.h"

@implementation SegmentBar
{
    UIView *_slideBar;
    NSArray *_titleNameArray;
}



-(void)dealloc{
    [_titleNameArray release];
    [_slideBar release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame andTitleNameArray:(NSArray *)titleNameArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        _titleNameArray = [titleNameArray copy];
        [self loadSlideBarWitFrame:frame];
        
        [self loadButtonWithFrame:frame];
        
        UIView *borderView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        borderView1.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1];
        [self addSubview:borderView1];
        [borderView1 release];
        
        UIView *borderView2 = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
        borderView2.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1];
        [self addSubview:borderView2];
        [borderView2 release];
    }
    return self;
}


- (void)loadSlideBarWitFrame:(CGRect)frame{
    _slideBar = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 3, frame.size.width / _titleNameArray.count, 2)];
    _slideBar.backgroundColor = [UIColor colorWithRed:0 green:0.83 blue:0.19 alpha:1];
    [self addSubview:_slideBar];
}



- (void)loadButtonWithFrame:(CGRect)frame{
    for (int i=0; i<_titleNameArray.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(frame.size.width/ _titleNameArray.count * i, 0, frame.size.width/ _titleNameArray.count, 44);
        [button setTitle:_titleNameArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button release];
    }
}

- (void)buttonClick:(UIButton *)btn{
    _slideBar.center = CGPointMake(btn.center.x, _slideBar.center.y);
    if ([_delegate respondsToSelector:@selector(moveContentWihtTagIndex:)]){
        [_delegate moveContentWihtTagIndex:btn.tag];
    }
}

-(void)moveSlideBar:(CGFloat)distance{
    _slideBar.center = CGPointMake( distance + _slideBar.frame.size.width / 2, _slideBar.center.y);
}


@end
