//
//  StuCheckhomeworkView.m
//  dev01
//
//  Created by Huan on 15/7/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  学生查看作业的View

#import "StuCheckhomeworkView.h"
#import "homeworkPhotosView.h"
#import "CheckHomeworkFrameModel.h"
#import "NewhomeWorkModel.h"
@interface StuCheckhomeworkView()

@property (retain, nonatomic) homeworkPhotosView * photosView;

@property (retain, nonatomic) UILabel * contentLabel;

@property (retain, nonatomic) UIView * topViewLine;

@property (retain, nonatomic) UIView * bottomViewLine;

@end

@implementation StuCheckhomeworkView
- (void)dealloc{
    self.photosView = nil;
    self.contentLabel = nil;
    self.topViewLine = nil;
    self.bottomViewLine = nil;
    self.homeworkModelFrame = nil;
    [super dealloc];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig{
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setHomeworkModelFrame:(CheckHomeworkFrameModel *)homeworkModelFrame{
    if (_homeworkModelFrame != homeworkModelFrame) {
        [_homeworkModelFrame release];
        _homeworkModelFrame = [homeworkModelFrame retain];
        
        self.photosView.frame = homeworkModelFrame.photoViewFrame;
        self.photosView.moment_id = homeworkModelFrame.homeworkModel.homework_moment.moment_id;
        self.photosView.photos = homeworkModelFrame.homeworkModel.homework_moment.multimedias;
        
        CGRect contentLableFrame = homeworkModelFrame.contentLabelFrame;
        contentLableFrame.origin.y = homeworkModelFrame.contentLabelFrame.origin.y + 1;
        self.contentLabel.frame = contentLableFrame;
        
        self.contentLabel.text = homeworkModelFrame.homeworkModel.homework_moment.text;
        
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.topViewLine.y = 0;
    self.topViewLine.width = self.width;
    self.bottomViewLine.y = self.height ;
    self.bottomViewLine.width = self.width;
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
    }
    return _photosView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = ContentFont;
        _contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];
    }
    return _contentLabel;
}
@end
