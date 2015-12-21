//
//  EmailFindPasswordVC.m
//  dev01
//
//  Created by Huan on 15/3/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "EmailFindPasswordVC.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "leftBarBtn.h"
#import "FindPassVerifyVC.h"
#import "MBProgressHUD.h"
@interface EmailFindPasswordVC ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation EmailFindPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self configNav];
    [self uiConfig];
}
- (void)configNav
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"找回密码", nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f];
    
    
    
    leftBarBtn *leftBtn = [[[NSBundle mainBundle] loadNibNamed:@"leftBarBtn" owner:nil options:nil] firstObject];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, 0, 30, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
- (void)cancelAction
{
    [self backAction];
}
- (void)backAction
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)uiConfig
{
    [_getCodeBtn setBackgroundColor:[UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f]];
    [_getCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_getCodeBtn.layer setMasksToBounds:YES];
    [_getCodeBtn.layer setCornerRadius:5.0];
    [_getCodeBtn addTarget:self action:@selector(sendEmailgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [_getCodeBtn setEnabled:NO];
    _inputEmailTX.delegate = self;
    _inputEmailTX.placeholder = @"邮箱";
    
    _emailTips.text = @"";
    _emailTips.textColor = [UIColor redColor];
    _wowtalk_id.placeholder = @"帐号";
    
    [_inputEmailTX addTarget:self action:@selector(detection:) forControlEvents:UIControlEventEditingChanged];
    [_wowtalk_id addTarget:self action:@selector(detection:) forControlEvents:UIControlEventEditingChanged];
}

- (void)detection:(UITextField *)sender
{
    if (_inputEmailTX.text.length && _wowtalk_id.text.length) {
        [_getCodeBtn setEnabled:YES];
        [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [_getCodeBtn setEnabled:NO];
        [_getCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc {
    [_inputEmailTX release];
    [_getCodeBtn release];
    [_tips release];
    [_emailTips release];
    [_GetPasswordBtn release];
    [_wowtalk_id release];
    [super dealloc];
}
- (void)sendEmailgetPassword:(id)sender {
    [_wowtalk_id resignFirstResponder];
    [_inputEmailTX resignFirstResponder];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WowTalkWebServerIF retrievePasswordWithWowtalkID:_wowtalk_id.text andEmail:_inputEmailTX.text Callback:@selector(ChangeTips:) withObserver:self];
    HUD.delegate = self;
    HUD.color = [UIColor lightGrayColor];
    HUD.labelText = @"正在发送邮件";
    [HUD hide:YES afterDelay:2.0];
    
}


- (void)ChangeTips:(NSNotification *)notif
{
//    [HUD removeFromSuperview];
    NSError *error = [[notif userInfo] objectForKey:WT_ERROR];
    if (error.code == 0) {
        [HUD removeFromSuperview];
//        _emailTips.text = @"验证码已经发送邮箱,请查收";
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
//        dispatch_after(time, dispatch_get_main_queue(), ^{
            FindPassVerifyVC *findVer = [[FindPassVerifyVC alloc] init];
            findVer.emailContent = _inputEmailTX.text;
            findVer.wowtalk_id = _wowtalk_id.text;
            [self.navigationController pushViewController:findVer animated:YES];
//        });
       
    }
    else if (error.code == -99)
    {
        _emailTips.text = @"用户不存在";
    }
    else if (error.code == 21)
    {
        _emailTips.text = @"帐号邮箱不匹配";
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_wowtalk_id resignFirstResponder];
    [_inputEmailTX resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘,取消第一响应者
    [_wowtalk_id resignFirstResponder];
    [_inputEmailTX resignFirstResponder];
    return YES;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
@end
