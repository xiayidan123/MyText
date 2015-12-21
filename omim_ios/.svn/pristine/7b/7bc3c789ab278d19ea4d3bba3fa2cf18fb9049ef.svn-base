//
//  HomeViewController.m
//  dev01
//
//  Created by macbook air on 14-9-24.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "AddCourseController.h"
#import "MyclassAndHomeworkVC.h"
#import "GrowupDocumentVC.h"
#import "GiftViewController.h"
#import "EventsListVC.h"
#import "ActivityListViewController.h"
#import "ActivityListVC.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "NewAccountSettingVC.h"
#import "EmailStatus.h"
#import "EmailFindPasswordVC.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>


#import "OMSettingVC.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark-----View Handler

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [WowTalkWebServerIF GetBindEmailStatusWithCallback:@selector(bindingEmail:) withObserver:self];
    
    [self configNavigation];
    
    
    [_expandButton setImage:[UIImage imageNamed:@"home_icon_expand_pre"] forState:UIControlStateHighlighted];
    [_expandButton setTitleColor:[UIColor colorWithRed:0 green:198.0/255 blue:48.0/255 alpha:1] forState:UIControlStateHighlighted];
    _expandButton.titleEdgeInsets = UIEdgeInsetsMake(40, -40, 0, 0);
    _expandButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 25, 30);
    
    
    [_growupfilesButton setImage:[UIImage imageNamed:@"home_icon_growupfiles_pre"] forState:UIControlStateHighlighted];
    [_growupfilesButton setTitleColor:[UIColor colorWithRed:0 green:198.0/255 blue:48.0/255 alpha:1] forState:UIControlStateHighlighted];
    _growupfilesButton.titleEdgeInsets = UIEdgeInsetsMake(40, -40, 0, 0);
    _growupfilesButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 25, 30);
    
    [_giftButton setImage:[UIImage imageNamed:@"home_icon_gift_pre"] forState:UIControlStateHighlighted];
    [_giftButton setTitleColor:[UIColor colorWithRed:0 green:198.0/255 blue:48.0/255 alpha:1] forState:UIControlStateHighlighted];
    _giftButton.titleEdgeInsets = UIEdgeInsetsMake(40, -40, 0, 0);
    _giftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 25, 30);
}
- (void)bindingEmail:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        EmailStatus *emailStaus = [[notif userInfo] valueForKey:@"fileName"];
        if (![emailStaus.verified isEqualToString:@"1"]) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"请绑定邮箱,用于找回密码" delegate:self cancelButtonTitle:NSLocalizedString(@"以后再说", nil) otherButtonTitles:NSLocalizedString(@"去绑定",nil), nil];
            [alerView show];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NewAccountSettingVC *newAcc = [[NewAccountSettingVC alloc] init];
        [self.navigationController pushViewController:newAcc animated:YES];
    }
}

- (void)myclassViewTapAction:(UITapGestureRecognizer *)tap{
    MyclassAndHomeworkVC *myclassVC = [[MyclassAndHomeworkVC alloc]init];
    myclassVC.isMyclass = YES;
    [self.navigationController pushViewController:myclassVC animated:YES];
    [myclassVC release];
}

- (void)homeworkViewTapAction:(UITapGestureRecognizer *)tap{
    MyclassAndHomeworkVC *myclassVC = [[MyclassAndHomeworkVC alloc]init];
    myclassVC.isMyclass = NO;
    [self.navigationController pushViewController:myclassVC animated:YES];
    [myclassVC release];
}


- (void)configNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    

    [self loadLeftItem];
    
    
    
    UIBarButtonItem *barItem = [PublicFunctions getCustomNavButtonOnLeftSide:NO
                                                                      target:self
                                                                       image:[UIImage imageNamed:NAV_ADD_IMAGE]
                                                                    selector:@selector(addCourse)];
    [self.navigationItem addRightBarButtonItem:barItem];
}

- (void)loadLeftItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 44);
    [button setImage:[UIImage imageNamed:@"tabbar_home_set"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"tabbar_home_set_press"] forState:UIControlStateSelected];
//    [button setTitle:@"设置" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    [menuButton release];
}

- (void)pushSettingVC{
    OMSettingVC *settingVC = [[OMSettingVC alloc]initWithNibName:@"OMSettingVC" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
    [settingVC release];
}


- (void)addCourse{
    AddCourseController *addcourse = [[AddCourseController alloc]init];
    addcourse.isInvitationCodeInHomeVC = YES;
    [self.navigationController pushViewController:addcourse animated:YES];
    [addcourse release];
}





-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)dealloc {

    [_expandButton release];
    [_growupfilesButton release];
    [_giftButton release];
    [_btn_myclass release];
    [_btn_homework release];
    [super dealloc];
}



- (IBAction)growupfilesClick:(id)sender {
    GrowupDocumentVC *growupDocumentVC = [[GrowupDocumentVC alloc]init];
    [self.navigationController pushViewController:growupDocumentVC animated:YES];
    [growupDocumentVC release];
}

- (IBAction)giftClick:(id)sender {
    GiftViewController *gitVC = [[GiftViewController alloc]init];
    [self.navigationController pushViewController:gitVC animated:YES];
    [gitVC release];
}

- (IBAction)myclassClick:(id)sender {
    MyclassAndHomeworkVC *myclassVC = [[MyclassAndHomeworkVC alloc]init];
    myclassVC.isMyclass = YES;
    [self.navigationController pushViewController:myclassVC animated:YES];
    [myclassVC release];
}

- (IBAction)homeworkClick:(id)sender {
    ActivityListViewController *activityListVC = [[ActivityListViewController alloc]initWithNibName:@"ActivityListViewController" bundle:nil];
    [self.navigationController pushViewController:activityListVC animated:YES];
    [activityListVC release];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (IBAction)expandClick:(id)sender {

    OMSettingVC *settingVC = [[OMSettingVC alloc]initWithNibName:@"OMSettingVC" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
    [settingVC release];
    
}







@end
