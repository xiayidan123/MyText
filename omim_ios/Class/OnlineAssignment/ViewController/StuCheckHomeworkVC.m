//
//  StuCheckHomeworkVC.m
//  dev01
//
//  Created by Huan on 15/7/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  学生查看作业

#import "StuCheckHomeworkVC.h"
#import "NewhomeWorkModel.h"
#import "StuCheckhomeworkView.h"
#import "CheckHomeworkFrameModel.h"
@interface StuCheckHomeworkVC ()

@end

@implementation StuCheckHomeworkVC

- (void)dealloc{
    self.homeworkModel = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查看作业";
    
    [self uiConfig];
}


- (void)uiConfig{
    
    StuCheckhomeworkView *view = [[StuCheckhomeworkView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    
    CheckHomeworkFrameModel *frameModel = [[[CheckHomeworkFrameModel alloc] init] autorelease];
    
    frameModel.homeworkModel = self.homeworkModel;
    
    view.homeworkModelFrame = frameModel;
    
    view.height = frameModel.checkViewHeight;
#pragma BL 2015.11.25
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(0, frameModel.checkViewHeight);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    [scrollView addSubview:view];
    
    [view release];
}



@end
