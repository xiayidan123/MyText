//
//  OMViewController.m
//  dev01
//
//  Created by 杨彬 on 15/3/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
#import "OMNavigationBackButton.h"
#import "OMNavigationController.h"


@interface OMViewController ()<OMAlertViewForNetDelegate>

@end

@implementation OMViewController

-(void)dealloc{
    [self.omAlertViewForNet dismiss];
    self.omAlertViewForNet = nil;
    self.navigation_back_button_title = nil;
    [super dealloc];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if (self.omAlertViewForNet){
//        [self.omAlertViewForNet dismiss];
//        self.omAlertViewForNet = nil;
//    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //手势控制键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:17]};


    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
}
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}


- (void)baseVCBackAction:(UIButton *)back_button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(OMAlertViewForNet *)omAlertViewForNet{
    if (_omAlertViewForNet == nil){
        _omAlertViewForNet = [[OMAlertViewForNet OMAlertViewForNet] retain];
        _omAlertViewForNet.delegate = self;
    }

    return _omAlertViewForNet;
}

-(void)setNavigation_back_button_title:(NSString *)navigation_back_button_title{
    [_navigation_back_button_title release],_navigation_back_button_title = nil;
    _navigation_back_button_title = [navigation_back_button_title retain];
    
    if (_navigation_back_button_title.length == 0)return;// 按钮没有文字使用系统默认按钮
    
    OMNavigationBackButton *back_button = [OMNavigationBackButton buttonWithType:UIButtonTypeSystem];
    [back_button addTarget:self action:@selector(baseVCBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [back_button setTitle:_navigation_back_button_title forState:UIControlStateNormal];
    
//    CGFloat imageView_width = back_button.imageView.width;
//    CGFloat titleLabel_width = back_button.titleLabel.width;
//    
//    CGSize size = [_navigation_back_button_title sizeWithFont:back_button.titleLabel.font];
//    
//    back_button.width = 12 + size.width + 10;
    
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:back_button];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    [backItem release];
}


#pragma mark - Set and Get

-(void)setTurnoff_slide_back:(BOOL)turnoff_slide_back{
    _turnoff_slide_back = turnoff_slide_back;
    
    if ([self.navigationController isKindOfClass:[OMNavigationController class]]){
        OMNavigationController *navi = (OMNavigationController *)self.navigationController;
        navi.turnoff_slide_back = _turnoff_slide_back;
    }
}

@end
