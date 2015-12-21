//
//  TeacherListScrollView.m
//  dev01
//
//  Created by 杨彬 on 14-12-27.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "TeacherListView.h"


@implementation TeacherListView{
    UIScrollView *_scrollView_bg;
}



-(void)dealloc{
    [_teacherArray release];
    [_scrollView_bg release];
    [super dealloc];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView_bg = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView_bg.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView_bg];
        self.userInteractionEnabled = YES;
    }
    return self;
}



-(void)setTeacherArray:(NSMutableArray *)teacherArray{
    _teacherArray = [teacherArray retain];
    
    [self loadTeacherHeadView];
}


- (void)loadTeacherHeadView{
    
    CGFloat _w = self.frame.size.width / 3 ;
    for (int i =0; i<_teacherArray.count; i++){
        HeadImageView *headImageView = [[HeadImageView alloc]initWithFrame:CGRectMake(_w * i, 0, _w, _scrollView_bg.frame.size.height)];
        headImageView.teacherModel = _teacherArray[i];
        headImageView.delegate = self;
        [_scrollView_bg addSubview:headImageView];
    }
    _scrollView_bg.contentSize = CGSizeMake(_teacherArray.count * _w, 0);
}

#pragma mark - HeadImageViewDelegate

-(void)clickHeadImageWith:(PersonModel *)teacherModel{
    if ([_delegate respondsToSelector:@selector(enterTeacherDetailVC:)]){
        [_delegate enterTeacherDetailVC:teacherModel];
    }
}








@end
