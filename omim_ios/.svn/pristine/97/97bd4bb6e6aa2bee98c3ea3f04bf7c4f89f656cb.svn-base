//
//  TeacherCheckHomeworkVC.m
//  dev01
//
//  Created by Huan on 15/8/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  教师查看作业

#import "TeacherCheckHomeworkVC.h"
#import "TCherCheckhomeworkView.h"
#import "NewhomeWorkModel.h"
#import "TCherHomeworkFrameModel.h"
#import "OMNetWork_MyClass.h"
#import "TeacherModifyHomeworkVC.h"
@interface TeacherCheckHomeworkVC ()<TCherCheckhomeworkViewDelegate>


@property (retain, nonatomic) TCherCheckhomeworkView * checkHomeworkView;

@property (retain, nonatomic) TCherHomeworkFrameModel * checkHomeworkFrameModel;

@property (assign, nonatomic) BOOL isEditing;
@end

@implementation TeacherCheckHomeworkVC

- (void)dealloc{
    
    self.checkHomeworkView = nil;
    
    self.homeworkModel = nil;
    
    self.checkHomeworkFrameModel = nil;
    
    self.lessonModel = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}


- (void)uiConfig{
    self.title = @"查看作业";
    
    self.isEditing = NO;
}

- (void)deleteHomework{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"确认删除作业吗？" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定",nil), nil] autorelease];
    [alertView show];

}

- (void)viewDidLayoutSubviews{
    self.checkHomeworkView.y = 74;
    self.checkHomeworkView.size = self.checkHomeworkFrameModel.checkViewSize;
}

#pragma mark set 和 get 方法

- (TCherCheckhomeworkView *)checkHomeworkView{
    if (!_checkHomeworkView) {
        _checkHomeworkView = [[TCherCheckhomeworkView alloc] init];
        _checkHomeworkView.delegate = self;
        self.checkHomeworkFrameModel.homeworkModel = self.homeworkModel;
        _checkHomeworkView.homeworkFrameModel = self.checkHomeworkFrameModel;
        [self.view addSubview:_checkHomeworkView];
    }
    return _checkHomeworkView;
}

- (TCherHomeworkFrameModel *)checkHomeworkFrameModel{
    if (!_checkHomeworkFrameModel) {
        _checkHomeworkFrameModel = [[TCherHomeworkFrameModel alloc] init];
        _checkHomeworkFrameModel.homeworkModel = self.homeworkModel;
    }
    return _checkHomeworkFrameModel;
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    if (isEditing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(modifyHomework)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteHomework)];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.omAlertViewForNet = [OMAlertViewForNet OMAlertViewForNet];
        self.omAlertViewForNet.title = @"正在删除作业";
        self.omAlertViewForNet.duration = 1.0;
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
        [self.omAlertViewForNet show];
        [OMNetWork_MyClass deleteHomeworkWithHomeWorkID:self.homeworkModel.homework_moment.homework_id withCallBack:@selector(didDeleteHomework:) withObserver:self];
    }
}

#pragma mark - didDeleteHomework
- (void)didDeleteHomework:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.omAlertViewForNet.title = @"已删除";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.omAlertViewForNet.title = @"删除失败";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
}

#pragma mark - TCherCheckhomeworkViewDelegate 
- (void)pushViewController{
    TeacherModifyHomeworkVC *modifyVC = [[[TeacherModifyHomeworkVC alloc] init] autorelease];
    modifyVC.lessonModel = self.lessonModel;
    modifyVC.homeworkModel = self.homeworkModel;
    [self.navigationController pushViewController:modifyVC animated:YES];
}
@end
