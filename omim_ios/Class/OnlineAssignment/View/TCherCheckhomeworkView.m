//
//  TCherCheckhomeworkView.m
//  dev01
//
//  Created by Huan on 15/8/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  教师查看作业的View

#import "TCherCheckhomeworkView.h"
#import "homeworkPhotosView.h"
#import "TCherHomeworkFrameModel.h"
#import "NewhomeWorkModel.h"
#import "TeacherCheckHomeworkVC.h"
@interface TCherCheckhomeworkView ()<UITextViewDelegate>

@property (retain, nonatomic) homeworkPhotosView * photosView;

@property (retain, nonatomic) UITextView * contentTextView;

@property (retain, nonatomic) UIButton * rightBtn;

@property (retain, nonatomic) UIView * topViewLine;

@property (retain, nonatomic) UIView * bottomViewLine;
@end

@implementation TCherCheckhomeworkView


- (void)dealloc{
    self.photosView = nil;
    
    self.contentTextView = nil;
    
    self.topViewLine = nil;
    
    self.bottomViewLine = nil;
    
    [super dealloc];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.topViewLine.y = 0;
    self.topViewLine.width = self.width;
    self.bottomViewLine.y = self.height ;
    self.bottomViewLine.width = self.width;
}

#pragma mark - set 和 get 方法

- (void)setHomeworkFrameModel:(TCherHomeworkFrameModel *)homeworkFrameModel{
    if (_homeworkFrameModel != homeworkFrameModel) {
        [_homeworkFrameModel release];
        _homeworkFrameModel = [homeworkFrameModel retain];
            
        self.photosView.frame = homeworkFrameModel.photoViewFrame;
        self.photosView.moment_id = homeworkFrameModel.homeworkModel.homework_moment.moment_id;
        self.photosView.photos = homeworkFrameModel.homeworkModel.homework_moment.multimedias;
        
        self.contentTextView.frame = homeworkFrameModel.contentTextViewFrame;
        self.contentTextView.text = homeworkFrameModel.homeworkModel.homework_moment.text;
        
        self.rightBtn.frame = homeworkFrameModel.rightBtnFrame;
    }
}

- (UIView *)bottomViewLine{
    if (!_bottomViewLine) {
        _bottomViewLine =  [[UIView alloc] init];
        _bottomViewLine.backgroundColor = [UIColor lightGrayColor];
        _bottomViewLine.x = 0;
        _bottomViewLine.height = 0.5;
        [self addSubview:_bottomViewLine];
    }
    return _bottomViewLine;
}

- (UIView *)topViewLine{
    if (!_topViewLine) {
        _topViewLine =  [[UIView alloc] init];
        _topViewLine.backgroundColor = [UIColor lightGrayColor];
        _topViewLine.x = 0;
        _topViewLine.height = 0.5;
        [self addSubview:_topViewLine];
    }
    return _topViewLine;
    
}

- (homeworkPhotosView *)photosView{
    if (!_photosView) {
        _photosView = [[homeworkPhotosView alloc] init];
        [self addSubview:self.photosView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return _photosView;
}


- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.delegate = self;
        [self addSubview:_contentTextView];
    }
    return _contentTextView;
}


- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.backgroundColor = [UIColor whiteColor];
        [_rightBtn setTitle:@">" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(editHomework) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}

- (void)editHomework{
    if ([self.delegate respondsToSelector:@selector(pushViewController)]) {
        [self.delegate pushViewController];
    }
}
@end
