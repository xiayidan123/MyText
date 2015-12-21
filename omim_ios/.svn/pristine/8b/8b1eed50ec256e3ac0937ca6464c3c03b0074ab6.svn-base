//
//  ChangeBindEmailVC.m
//  dev01
//
//  Created by Huan on 15/3/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ChangeBindEmailVC.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "WTUserDefaults.h"
#import "WTError.h"
#import "NewAccountSettingVC.h"
#import "leftBarBtn.h"
#import "CusBtn.h"
#import "MBProgressHUD.h"
@interface ChangeBindEmailVC ()<UITextFieldDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
@property (retain, nonatomic) CusBtn *cusBtn;
@property (retain, nonatomic) MBProgressHUD *HUD;
@end

@implementation ChangeBindEmailVC



- (void)dealloc {
    [_VerifyCodeTX release];
    [_getCodeBtn release];
    [_sureBtn release];
    [_cusBtn release];
    [_Tips release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    
    [self uiConfig];
}
- (void)uiConfig
{
    [_sureBtn setBackgroundColor:[UIColor colorWithRed:0.00f green:0.67f blue:0.99f alpha:1.00f]];
    [_sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_sureBtn.layer setMasksToBounds:YES];
    [_sureBtn.layer setCornerRadius:5.0];
    _sureBtn.enabled = NO;
    
    self.title = NSLocalizedString(@"修改邮箱", nil);
    
    [self ConstraintCusbtn];
    


    UILabel *blankLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 44)];
    _VerifyCodeTX.leftView = blankLab;
    _VerifyCodeTX.leftViewMode = UITextFieldViewModeAlways;
    _VerifyCodeTX.delegate = self;
    _VerifyCodeTX.placeholder = @"验证码";
    [_VerifyCodeTX addTarget:self action:@selector(ChangeAction) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)ConstraintCusbtn
{
    self.cusBtn = [CusBtn buttonWithType:UIButtonTypeCustom];
//    _cusBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_cusBtn setFrame:CGRectMake((self.view.center.x + 50), 90, 80, 20)];
    [_cusBtn setEnabled:YES];
    [self.view addSubview:_cusBtn];
    [_cusBtn addTarget:self action:@selector(changeButton) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)changeButton
{
    [_cusBtn setEnabled:NO];
    [_cusBtn Countdown];
    [_cusBtn setFrame:CGRectMake((self.view.center.x + 10), 90, 120, 20)];
    [WowTalkWebServerIF retrievePasswordWithWowtalkID:[WTUserDefaults getWTID] andEmail:[WTUserDefaults getEmail] Callback:@selector(getCodeAction:) withObserver:self];
}
- (void)getCodeAction:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] objectForKey:WT_ERROR];
    if (error.code == 23) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"今天的邮箱验证次数已用完请明天再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)ChangeAction
{
    _sureBtn.enabled = YES;
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (_VerifyCodeTX.text.length > 6) {
        _VerifyCodeTX.text = [_VerifyCodeTX.text substringToIndex:6];
    }
}
- (void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITextfield Delegate

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_VerifyCodeTX resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘,取消第一响应者
    [_VerifyCodeTX resignFirstResponder];
    return YES;
    
}

- (IBAction)codeIsCorrect:(id)sender {
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WowTalkWebServerIF checkCodeForRetrievePassword:[WTUserDefaults getWTID] andAccessCode:_VerifyCodeTX.text Callback:@selector(VerifyCodeisCorrect:) withObserver:self];
    _HUD.delegate = self;
    _HUD.color = [UIColor lightGrayColor];
    _HUD.labelText = @"验证中";
    [_HUD hide:YES afterDelay:2.0];
}

- (void)VerifyCodeisCorrect:(NSNotification *)notif
{
    [_HUD removeFromSuperview];
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeText;
    _HUD.margin = 10.f;
    _HUD.yOffset = 10.f;
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD hide:YES afterDelay:3];
    NSError *error = [[notif userInfo] objectForKey:WT_ERROR];
    if (error.code == -99) {
        _HUD.labelText = @"用户不存在";
    }
    else if (error.code == 1108)
    {
        _HUD.labelText = @"验证码不正确";
    }
    else if (error.code == 1109)
    {
        _HUD.labelText = @"验证码已经过期";
    }
    else if (error.code == 0)
    {
        [_HUD removeFromSuperview];
        [WowTalkWebServerIF unBindEmail:@selector(lastunBind:) withObserver:self];
    }
}

- (void)lastunBind:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] objectForKey:WT_ERROR];
    if (error.code == 0) {
        [WTUserDefaults setEmail:nil];
        NewAccountSettingVC *newAcc = [[NewAccountSettingVC alloc] init];
        [self.navigationController pushViewController:newAcc animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [_VerifyCodeTX becomeFirstResponder];
}
@end
