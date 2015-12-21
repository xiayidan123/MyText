//
//  GiftViewController.m
//  dev01
//
//  Created by 杨彬 on 14-10-9.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "GiftViewController.h"
#import "PublicFunctions.h"

@interface GiftViewController ()

@end

@implementation GiftViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigation];
    
}

- (void)configNavigation{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"抽奖礼品推荐",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
    [backBarItem release];
    
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
