//
//  FindPassVerifyVC.m
//  dev01
//
//  Created by Huan on 15/3/11.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "FindPassVerifyVC.h"
#import "leftBarBtn.h"
#import "CountdownBtn.h"
#import "NewPasswordVC.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "MBProgressHUD.h"
@interface FindPassVerifyVC ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    CountdownBtn *countDown;
    MBProgressHUD *HUD;
}
@end

@implementation FindPassVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"找回密码", nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    //    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f];
    
    
    leftBarBtn *leftBarBtn = [[[NSBundle mainBundle] loadNibNamed:@"leftBarBtn" owner:nil options:nil] firstObject];
    [leftBarBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, 0, 30, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    [self uiConfig];
    
}
- (void)uiConfig
{
    [_sureBtn.layer setMasksToBounds:YES];
    [_sureBtn.layer setCornerRadius:5.0];
    [_sureBtn setEnabled:NO];
    [_sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_sureBtn setBackgroundColor:[UIColor colorWithRed:0.09f green:0.64f blue:0.89f alpha:1.00f]];
    
    countDown = [[[NSBundle mainBundle] loadNibNamed:@"CountdownBtn" owner:nil options:nil] firstObject];
    countDown.frame = CGRectMake(10, 280, self.view.bounds.size.width - 20, 44);
    [countDown.layer setMasksToBounds:YES];
    [countDown.layer setCornerRadius:5.0];
    [countDown setBackgroundColor:[UIColor colorWithRed:0.68f green:0.90f blue:1.00f alpha:1.00f]];
    [countDown setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:countDown];
    [countDown Countdown];
    [countDown addTarget:self action:@selector(TimeLine) forControlEvents:UIControlEventTouchUpInside];
    
    _emailLab.text = [NSString stringWithFormat:@"您输入的邮箱%@",self.emailContent];
    _VerifyTx.placeholder = @"验证码";
    _VerifyTx.delegate = self;
    [_VerifyTx addTarget:self action:@selector(changeTextfield) forControlEvents:UIControlEventEditingChanged];
}
- (void)changeTextfield
{
    if (_VerifyTx.text.length) {
        [_sureBtn setEnabled:YES];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [_sureBtn setEnabled:NO];
        [_sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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



- (void)dealloc {
    [_emailLab release];
    [_VerifyTx release];
    [_sureBtn release];
    [_Tips release];
    [super dealloc];
}
- (IBAction)MatchVerify:(id)sender {
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WowTalkWebServerIF checkCodeForRetrievePassword:_wowtalk_id andAccessCode:_VerifyTx.text Callback:@selector(CheckVerify:) withObserver:self];
    HUD.delegate = self;
    HUD.color = [UIColor lightGrayColor];
    HUD.labelText = @"验证中";
    [HUD hide:YES afterDelay:2.0];
}
- (void)CheckVerify:(NSNotification *)notif
{
    
    NSError *error = [[notif userInfo] objectForKey:WT_ERROR];
    if (error.code == -99) {
        _Tips.text = @"用户不存在";
    }
    else if (error.code == 1108)
    {
        _Tips.text = @"验证码不正确";
    }
    else if (error.code == 1109)
    {
        _Tips.text = @"验证码已经过期（两小时内有效）";
    }
    else if (error.code == 23)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"今天的邮箱验证次数已用完 请明天再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    else if (error.code == 0)
    {
        [HUD removeFromSuperview];
//        _Tips.text = @"验证码正确";
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
//        dispatch_after(time, dispatch_get_main_queue(), ^{
            NewPasswordVC *newPassVC = [[NewPasswordVC alloc] init];
            newPassVC.wowtalk_id = _wowtalk_id;
            newPassVC.emailContent = _emailContent;
            [self.navigationController pushViewController:newPassVC animated:YES];
//        });
    }
}
#pragma mark UITextfield Delegate

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_VerifyTx resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘,取消第一响应者
    [_VerifyTx resignFirstResponder];
    return YES;
    
}
- (void)TimeLine
{
    [WowTalkWebServerIF retrievePasswordWithWowtalkID:_wowtalk_id andEmail:_emailContent Callback:@selector(GetCodeAgain:) withObserver:self];
    [countDown Countdown];
    [countDown setEnabled:NO];
}
- (void)GetCodeAgain:(NSNotification *)notif
{
    
}
@end
