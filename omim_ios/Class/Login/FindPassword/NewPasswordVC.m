//
//  NewPasswordVC.m
//  dev01
//
//  Created by Huan on 15/3/11.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NewPasswordVC.h"
#import "leftBarBtn.h"
#import "QCheckBox.h"
#import "WowTalkWebServerIF.h"
#import "MBProgressHUD.h"
#import "WTError.h"
#import "AppDelegate.h"
#import "OMAlertView.h"
#import "LoginEmailViewController.h"
#define TAG_ALERT_REGISTER_SUCCESS 100
#define TAG_ALERT_REGISTER_FAIL 101

@interface NewPasswordVC ()<QCheckBoxDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    OMAlertView *_omAlertView;
}


@property (retain, nonatomic) IBOutlet UIButton *sureBtn;
@property (retain, nonatomic) IBOutlet UILabel *Tips;
@property (retain, nonatomic) IBOutlet UITextField *repeatPassword;
@property (retain, nonatomic) IBOutlet UITextField *inputPassword;



@end

@implementation NewPasswordVC


- (void)dealloc {
    [_sureBtn release];
    [_Tips release];
    [_repeatPassword release];
    [_inputPassword release];
    self.emailContent = nil;
    self.wowtalk_id = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self uiConfig];
}


- (void)uiConfig
{
    self.title = NSLocalizedString(@"找回密码", nil);
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f];
    
    _omAlertView = [[OMAlertView alloc] init];
    _inputPassword.placeholder = @"新密码";
    _inputPassword.delegate = self;
    _repeatPassword.placeholder = @"确认新密码";
    _repeatPassword.delegate = self;
    _Tips.text = @"";
    
    
    UIView *firstLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    UIView *secoundLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    _inputPassword.leftViewMode = UITextFieldViewModeAlways;
    _inputPassword.leftView = firstLeftView;
    _repeatPassword.leftViewMode = UITextFieldViewModeAlways;
    _repeatPassword.leftView = secoundLeftView;
    
    
    QCheckBox *_check = [[QCheckBox alloc] initWithDelegate:self];
    _check.frame = CGRectMake(10, 180, 25, 25);
    [_check setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [_check setBackgroundImage:[UIImage imageNamed:@"btn_show_password_off"] forState:UIControlStateNormal];
    [_check setBackgroundImage:[UIImage imageNamed:@"btn_show_password_on"] forState:UIControlStateSelected];
    [self.view addSubview:_check];
    [_check setChecked:NO];
    
    [_sureBtn.layer setMasksToBounds:YES];
    [_sureBtn.layer setCornerRadius:5.0];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn setBackgroundColor:[UIColor colorWithRed:0.18f green:0.71f blue:0.96f alpha:1.00f]];
}

#pragma mark UITextfield Delegate

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_inputPassword resignFirstResponder];
    [_repeatPassword resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘,取消第一响应者
    [_inputPassword resignFirstResponder];
    [_repeatPassword resignFirstResponder];
    return YES;
    
}
#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    if (checked) {
        _repeatPassword.secureTextEntry = NO;
        _inputPassword.secureTextEntry = NO;
    }
    else
    {
        _repeatPassword.secureTextEntry = YES;
        _inputPassword.secureTextEntry = YES;
    }
}




- (void)ChangePass:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] objectForKey:WT_ERROR];
    if (error.code == -99) {
        _Tips.text = @"用户不存在";
    }
    else if (error.code == 1108)
    {
        _Tips.text = @"未验证验证码";
    }
    else if (error.code == 0)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.center = self.view.center;
        UIView *Topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        UIImageView *imgV = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success"]] autorelease];
        imgV.center = Topview.center;
        [Topview addSubview:imgV];
        HUD.customView = Topview;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = @"新密码设置成功";
        [HUD show:YES];
        [self.view addSubview:HUD];
        [HUD hide:YES afterDelay:1.0];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [WowTalkWebServerIF loginWithUserinfo:_emailContent password:_inputPassword.text withLatitude:0 withLongti:0 withCallback:@selector(fLoginFinished:) withObserver:self];
        });
    }
}
- (void)fLoginFinished:(NSNotification *)notification
{
    [_omAlertView dismissWithClickedButtonIndex:0 animated:NO];
    NSDictionary *dict = [notification userInfo];
    if ([dict objectForKey:WT_ERROR] && [[dict objectForKey:WT_ERROR] code] != NO_ERROR)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login",nil) message:NSLocalizedString(@"Authetication failed",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        [[AppDelegate sharedAppDelegate] setupApplicaiton:YES];
    }
}
#pragma mark------UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        if (alertView.tag==TAG_ALERT_REGISTER_SUCCESS) {
            LoginEmailViewController *loginEmailViewController = [[LoginEmailViewController alloc]init];
            [self.navigationController pushViewController:loginEmailViewController animated:YES];
        }
        else if (alertView.tag == TAG_ALERT_REGISTER_FAIL){
            return;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [HUD removeFromSuperview];
}
- (IBAction)getPassword:(id)sender {
    if (_repeatPassword && _inputPassword) {
        if ([_repeatPassword.text isEqualToString:_inputPassword.text]) {
            [WowTalkWebServerIF retrievePasswordWithWowtalkID:_wowtalk_id andNewPassword:_inputPassword.text Callback:@selector(ChangePass:) withObserver:self];
        }
        else
        {
            _Tips.text = @"两次输入不一致";
        }
    }
    else
    {
        _Tips.text = @"输入不能为空";
    }
}
@end
