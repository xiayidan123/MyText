//
//  AskQuestionVC.m
//  dev01
//
//  Created by 杨彬 on 14-10-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "AskQuestionVC.h"
#import "PublicFunctions.h"
#import "AskQuestionView.h"

@interface AskQuestionVC ()
{
    AskQuestionView *_askQuestionView;
}


@end

@implementation AskQuestionVC

-(void)dealloc{
    [_askQuestionView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255 green:251.0/255 blue:250.0/255 alpha:1];
    
    [self uiConfig];
}

- (void)uiConfig{
    [self configNavigation];
    
    [self loadAskQuestionView];
    
}


- (void)configNavigation{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, 0, 50, 44);
    [cancelButton setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
    [cancelButton setTintColor:[UIColor whiteColor]];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    [self.navigationItem addLeftBarButtonItem:leftBarButton];
    [leftBarButton release];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(-100, 0, 50, 44);
    [doneButton setTitle:NSLocalizedString(@"完成",nil) forState:UIControlStateNormal];
    [doneButton setTintColor:[UIColor whiteColor]];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [doneButton addTarget:self action:@selector(doneButtonAciton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
    [self.navigationItem addRightBarButtonItem:rightBarButton];
    [rightBarButton release];
}


- (void)cancelButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonAciton{
   
}


- (void)loadAskQuestionView{
    _askQuestionView = [[[NSBundle mainBundle]loadNibNamed:@"AskQuestionView" owner:self options:nil] firstObject];
    _askQuestionView.frame = CGRectMake(0, 100, _askQuestionView.frame.size.width, _askQuestionView.frame.size.height);
    [_askQuestionView loadAskQuestionView];
    [_askQuestionView adjustPosition];
    [self.view addSubview:_askQuestionView];;
}




@end
