//
//  TeachVideoListView.m
//  dev01
//
//  Created by 杨彬 on 14-10-15.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "TeachVideoListView.h"

@implementation TeachVideoListView

- (instancetype)initWithFrame:(CGRect)frame andVideoArray:(NSArray *)videoArray
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat _h = 0;
        if (videoArray.count % 4 == 0){
            _h = 20+ (videoArray.count / 4)*78.5 ;
        }else{
            _h = 20 + (videoArray.count / 4 + 1)*78.5;
        }
        self.frame = CGRectMake(0, 0, frame.size.width, _h);
        [self loadVideoImageView:videoArray];
    }
    return self;
}

- (void)loadVideoImageView:(NSArray *)videoArray{
    for (int i=0; i<videoArray.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(15 + (i % 4 )*73.5, 15 + (i/ 4)* 78.5, 68.5, 68.5);
        button.backgroundColor = [UIColor colorWithRed:random()%10 /10.0 green:random()%10 /10.0 blue:random()%10 /10.0 alpha:1];
        [button addTarget:self action:@selector(videoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}


- (void)videoButtonClick:(UIButton *)btn{
    
}

@end
