//
//  ViewController.m
//  TestJoyShow
//
//  Created by zhangrui on 15/2/16.
//  Copyright (c) 2015年 zhangrui. All rights reserved.
//




#import "ViewController.h"
#import "OMCamPlayVC.h"
#import "camheader.h"


@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"play" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(20, 100, 80, 80);
    backBtn.backgroundColor = [UIColor grayColor];
    [backBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}




- (void)playAction
{
    OMCamPlayVC *publicDetailVC = [[OMCamPlayVC alloc] init];

        
    publicDetailVC.url = @"https://pcs.baidu.com/rest/2.0/pcs/device?method=liveplay&shareid=8799efea195ed63715f77e533be4f2ba&uk=2070154627";
    [self.navigationController pushViewController:publicDetailVC animated:YES];
    
}


@end
