//
//  AddShoolViewController.m
//  dev01
//
//  Created by macbook air on 14-9-25.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "AddCourseController.h"
#import "PublicFunctions.h"
#import "NSString+Compare.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "WTUserDefaults.h"
#import "OMAlertViewForNet.h"
#import "MBProgressHUD.h"
@interface AddCourseController ()

@property (retain, nonatomic) OMAlertViewForNet * omAlert;

@property (retain, nonatomic) MBProgressHUD * hud;
@end

@implementation AddCourseController


- (void)dealloc {
    self.hud = nil;
    self.omAlert = nil;
    [_inputView release];
    [_tfCode release];
    [_btnAdd release];
    [super dealloc];
}
- (void)viewDidAppear:(BOOL)animated
{
    [_tfCode becomeFirstResponder];
}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (![_tfCode isExclusiveTouch]) {
//        [_tfCode resignFirstResponder];
//    }
//}
- (void)viewWillDisappear:(BOOL)animated{
    if (![_tfCode isExclusiveTouch]) {
        [_tfCode resignFirstResponder];
        
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
    
    _inputView.layer.borderWidth = 1;
    _inputView.layer.cornerRadius = 5;
    _inputView.layer.masksToBounds = YES;
    _inputView.layer.borderColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1].CGColor;
    
    [_btnAdd setBackgroundImage:[ [UIImage imageNamed:_isInvitationCodeInHomeVC ? @"btn_blue.png" :@"btn_blue.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
//    _tfCode.placeholder = NSLocalizedString(@"", nil);
    [_btnAdd setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    
}

- (void)configNavigation{
    
    self.title = NSLocalizedString(@"新课堂", nil);
    
//    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
//    [self.navigationItem addLeftBarButtonItem:backBarItem];
//    [backBarItem release];
}

- (void)backAction{
    [self.view endEditing:YES];

    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)addClick:(id)sender {
    
    if ( [NSString isEmptyString:_tfCode.text] ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Invitation code can't be empty", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    [WowTalkWebServerIF bindInvitationCode:_tfCode.text withCallback:@selector(didBindInvitationCode:) withObserver:self];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = @"验证中";
}

#define TAG_BIND_CLASS_SUCCESS 100

- (void)didBindInvitationCode:(NSNotification *)notif{
    //98 不存在  97  已经绑定  96  已经过期  95 已经绑定此学校  94 学生帐号老师帐号不匹配
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    NSString* msg = @"";
    [self.hud hide:YES];
    if (error.code == NO_ERROR) {
        msg = NSLocalizedString(@"Bind class success!", nil);
//        self.omAlert.title = msg;
//        self.omAlert.type = OMAlertViewForNetStatus_Done;
        if ([_delegate respondsToSelector:@selector(refreshSchoolTree)]){
            [_delegate refreshSchoolTree];
        }
    }
    else if (error.code == -98){
        msg = NSLocalizedString(@"该邀请码不存在", nil);
    }
    else if (error.code == -97){
         msg = NSLocalizedString(@"Someone already bind this!", nil);

    }else if (error.code == -96){
        msg = NSLocalizedString(@"邀请码已过期!", nil);
    }else if (error.code == -95){
        msg = NSLocalizedString(@"已绑定该学校!", nil);
    }else if (error.code == -94){
        if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {// 0表示官方，1表示学生，2是老师
            msg = NSLocalizedString(@"老师账号不能绑定学生类邀请码", nil);
        }
        else
        {
            msg = NSLocalizedString(@"学生帐号不能绑定老师类邀请码", nil);
        }
    }
    else{
        msg = NSLocalizedString(@"网络请求超时，请检查网络连接", nil);
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    if (error.code == NO_ERROR) alert.tag = TAG_BIND_CLASS_SUCCESS;
    [alert show];
    [alert release];
    return;

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==TAG_BIND_CLASS_SUCCESS && buttonIndex==0) {
        [WowTalkWebServerIF getSchoolListWithCallBack:nil withObserver:nil];
        
        [self backAction];
    }
}


@end
