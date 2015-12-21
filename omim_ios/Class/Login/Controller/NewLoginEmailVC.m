//
//  NewLoginEmailVC.m
//  dev01
//
//  Created by Huan on 15/3/12.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NewLoginEmailVC.h"
#import "PublicFunctions.h"
#import "EmailFindPasswordVC.h"
#import "WowTalkWebServerIF.h"
#import "MBProgressHUD.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "WTError.h"
#import "NewRegisterVC.h"
#import "OMNetWork_Setting.h"

#import "OMEmailFindPasswordVC.h"
#import "OMTelephoneFindPasswordVC.h"
#import "OMRegisterViewController.h"

@interface NewLoginEmailVC ()<UITextFieldDelegate,UIActionSheetDelegate>

/** 头像 */
@property (retain, nonatomic) IBOutlet UIImageView *head_imageV;

/** 账号输入框 */
@property (retain, nonatomic) IBOutlet UITextField *accounts_TF;
/** 密码输入框 */
@property (retain, nonatomic) IBOutlet UITextField *password_TF;

/** 登录按钮 */
@property (retain, nonatomic) IBOutlet UIButton *login_btn;

/** 找回密码按钮 */
@property (retain, nonatomic) IBOutlet UIButton *findPassword_btn;

/** 注册按钮 */
@property (retain, nonatomic) IBOutlet UIButton *regester_btn;

/** 注册页面 */
@property (retain, nonatomic) OMRegisterViewController *registerVC;
/** 邮箱找回密码页面 */
@property (retain, nonatomic) OMEmailFindPasswordVC *emailFindPasswordVC;
/** 短信找回密码页面 */
@property (retain, nonatomic) OMTelephoneFindPasswordVC *telephoneFindPasswordVC ;



@end

@implementation NewLoginEmailVC

- (void)dealloc {
    [_head_imageV release];
    [_accounts_TF release];
    [_password_TF release];
    [_login_btn release];
    [_findPassword_btn release];
    [_regester_btn release];
    
    self.registerVC = nil;
    self.emailFindPasswordVC = nil;
    self.telephoneFindPasswordVC = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
    
}

- (void)uiConfig
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f];
    
    [self configHeader];
    [self configBtn];
    [self configTextfield];
}

- (void)configHeader
{
    _head_imageV.layer.masksToBounds = YES;
    _head_imageV.layer.cornerRadius = _head_imageV.bounds.size.width / 2;
}
- (void)configBtn
{
    _login_btn.layer.masksToBounds = YES;
    _login_btn.layer.cornerRadius = 5.0;
    [_login_btn setBackgroundColor:[UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f]];
    
    UIImage *image = [UIImage imageNamed:@"btn_bule_register"];
    [_regester_btn setBackgroundImage:[image stretchableImageWithLeftCapWidth:10 topCapHeight:20] forState:UIControlStateNormal];
    [_regester_btn setTitleColor:[UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f] forState:UIControlStateNormal];
}
- (void)configTextfield
{
    _password_TF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}





#pragma mark UITextFieldDelegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.placeholder = @"";
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.accounts_TF){
        self.accounts_TF.placeholder = NSLocalizedString(@"账号/手机号",nil);
    }else if (textField == self.password_TF){
        self.password_TF.placeholder = NSLocalizedString(@"密码",nil);
    }
    return YES;
}


- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    BOOL rlt=YES;
    NSString *errMsg = @"";
    
    if (_accounts_TF.text == nil || _accounts_TF.text.length == 0){
        rlt = NO;
        errMsg = NSLocalizedString(@"Username can't be empty", nil);
    }
    else if (_password_TF == nil || _password_TF.text.length == 0){
        rlt = NO;
        errMsg = NSLocalizedString(@"Password can't be empty", nil);
    }
    
    
    if(rlt==NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login",nil) message:errMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    [self launchLoginWithLatitude:0 longtitude:0];
    
    self.omAlertViewForNet = [OMAlertViewForNet OMAlertViewForNet];
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    self.omAlertViewForNet.title = @"登录中...";
    [self.omAlertViewForNet showInView:self.view];
}
#pragma mark ----CLLocationManager
-(void)launchLoginWithLatitude:(CLLocationDegrees)lati longtitude:(CLLocationDegrees)longtitude
{
    [WowTalkWebServerIF loginWithUserinfo:_accounts_TF.text password:_password_TF.text withLatitude:lati withLongti:longtitude withCallback:@selector(fLoginFinished:) withObserver:self];
}
- (void)fLoginFinished:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSError *error = [dict objectForKey:WT_ERROR];
    if (error.code == 301) {
        //没有网络，首先判断是否有网络，再进行账号判断
//        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Failed to login", nil) message:@"没有可用的网络" delegate: self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
        [self performSelector:@selector(removeLoading) withObject:nil afterDelay:0.5];
    }
     else if ([dict objectForKey:WT_ERROR] && [[dict objectForKey:WT_ERROR] code] != NO_ERROR)
    {
        [self.omAlertViewForNet dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login",nil) message:NSLocalizedString(@"Authetication failed",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        [self.omAlertViewForNet dismiss];
        [[AppDelegate sharedAppDelegate] setupApplicaiton:YES];
        [OMNetWork_Setting GetUserSettingsWithCallback:nil withObserver:nil];
    }
}

-(void)removeLoading
{
     [self.omAlertViewForNet dismiss];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{// 邮箱找回
            [self.navigationController pushViewController:self.emailFindPasswordVC animated:YES];
        }break;
        case 1:{// 短信验证码找回
            [self.navigationController pushViewController:self.telephoneFindPasswordVC animated:YES];
        }break;
        default:
            break;
    }
}



- (IBAction)findPasswordAction:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"邮箱找回",nil),NSLocalizedString(@"短信验证码找回",nil), nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (IBAction)registerAction:(id)sender {
    [self.navigationController pushViewController:self.registerVC animated:YES];
}


#pragma mark - Set and Get


-(OMRegisterViewController *)registerVC{
//    if (_registerVC == nil){
        _registerVC = [[OMRegisterViewController alloc] initWithNibName:@"OMRegisterViewController" bundle:nil];
//    }
    return _registerVC;
}

-(OMEmailFindPasswordVC *)emailFindPasswordVC{
//    if (_emailFindPasswordVC == nil){
        _emailFindPasswordVC = [[OMEmailFindPasswordVC alloc]initWithNibName:@"OMEmailFindPasswordVC" bundle:nil];
//    }
    return _emailFindPasswordVC;
}

-(OMTelephoneFindPasswordVC *)telephoneFindPasswordVC{
//    if (_telephoneFindPasswordVC == nil){
        _telephoneFindPasswordVC = [[OMTelephoneFindPasswordVC alloc]initWithNibName:@"OMTelephoneFindPasswordVC" bundle:nil];
//    }
    return _telephoneFindPasswordVC;
}




@end
