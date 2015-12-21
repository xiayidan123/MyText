//
//  VerificationCodeVC.m
//  dev01
//
//  Created by Huan on 15/3/5.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "VerificationCodeVC.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "MBProgressHUD.h"
#import "WTUserDefaults.h"
#import "leftBarBtn.h"
#import "CountdownBtn.h"
@interface VerificationCodeVC ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    CountdownBtn *countDown;
}
@end

@implementation VerificationCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"绑定邮箱", nil);
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
    
    [_sure.layer setMasksToBounds:YES];
    [_sure.layer setCornerRadius:5.0];
    [_sure setEnabled:NO];
    [_sure setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    
    countDown = [[[NSBundle mainBundle] loadNibNamed:@"CountdownBtn" owner:nil options:nil] firstObject];
    countDown.frame = CGRectMake(10, 300, self.view.bounds.size.width - 20, 44);
    [countDown.layer setMasksToBounds:YES];
    [countDown.layer setCornerRadius:5.0];
    [countDown setBackgroundColor:[UIColor colorWithRed:0.68f green:0.90f blue:1.00f alpha:1.00f]];
    [countDown setTitle:@"获取验证码" forState:UIControlStateNormal];
    [countDown Countdown];
    [self.view addSubview:countDown];
    [countDown addTarget:self action:@selector(TimeLine) forControlEvents:UIControlEventTouchUpInside];
    
//    _timeBtn = [[[NSBundle mainBundle] loadNibNamed:@"Countdown" owner:nil options:nil] firstObject];
//    [_timeBtn.layer setMasksToBounds:YES];
//    [_timeBtn.layer setCornerRadius:5.0];
//    [_timeBtn setBackgroundColor:[UIColor colorWithRed:0.68f green:0.90f blue:1.00f alpha:1.00f]];
//    [_timeBtn setTitleColor:[UIColor colorWithRed:0.33f green:0.54f blue:0.69f alpha:1.00f] forState:UIControlStateNormal];
    [self uiConfig];
}
- (void)uiConfig
{
    _emailText.text = [NSString stringWithFormat:@"你输入的邮箱%@",self.emailContent];
    _emailText.textColor = [UIColor grayColor];
    _verificationCodeTX.placeholder = @"验证码";
    [_verificationCodeTX addTarget:self action:@selector(changeTextfield) forControlEvents:UIControlEventEditingChanged];
}
- (void)changeTextfield
{
    if (_verificationCodeTX.text.length) {
        [_sure setEnabled:YES];
        [_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [countDown setEnabled:YES];
    }
    else
    {
//        [countDown setEnabled:NO];
        [_sure setEnabled:NO];
        [_sure setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
    [_verificationCodeTX resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘,取消第一响应者
    [_verificationCodeTX resignFirstResponder];
    return YES;
    
}

- (void)dealloc {
    [_emailText release];
    [_notice release];
    [_verificationCodeTX release];
    [_noticeUserLab release];
    [_sure release];
    [_timeBtn release];
    [super dealloc];
}
- (IBAction)sendVerifyCode:(id)sender {
    [_verificationCodeTX resignFirstResponder];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.color = [UIColor lightGrayColor];
    HUD.labelText = @"验证中";
    [HUD hide:YES afterDelay:2.0];
//    [HUD removeFromSuperview];
    [WowTalkWebServerIF GetVerifyCodeWithAccessCode:self.verificationCodeTX.text andEmail:self.emailContent Callback:@selector(CodeNotice:) withObserver:self];
    
}
- (void)CodeNotice:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == 0) {
        [HUD removeFromSuperview];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_category_select"]] autorelease];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = @"邮箱绑定成功";
        [HUD show:YES];
        [self.view addSubview:HUD];
        [HUD hide:YES afterDelay:1.5];
        [WTUserDefaults setEmail:self.emailContent];
        NSInteger count = self.navigationController.viewControllers.count;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            if (count > 2 && count == 4) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count - 3] animated:YES];
            }
            else if (count > 4){
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count - 4] animated:YES];
            }
            else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        });
        
    }
    else
    {
        [HUD removeFromSuperview];
        _noticeUserLab.text = @"验证码不正确";
        _noticeUserLab.textColor = [UIColor redColor];
        _noticeUserLab.font = [UIFont systemFontOfSize:12];
    }
    
}
# pragma mark MBProgressHUD
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    [hud release];
    hud = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}



//- (IBAction)getVerifyCodeAgain:(id)sender {
//    _timeBtn.enabled = NO;
//    [_timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [WowTalkWebServerIF BlidingEmail:self.emailContent WithCallback:@selector(Notice:) withObserver:self];
//    __block int timeout=60; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout<=0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_release(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                [_timeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//            });
//        }else{
//            NSString *strTime = [NSString stringWithFormat:@"重新获取验证码(%dS)",timeout];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                [_timeBtn setTitle:strTime forState:UIControlStateNormal];
//            });
//            timeout--;
//            
//        }
//    });
//    dispatch_resume(_timer);
//}
- (void)Notice:(NSNotification *)notif
{
    
}
- (void)TimeLine
{
    [WowTalkWebServerIF BlidingEmail:self.emailContent WithCallback:@selector(Notice:) withObserver:self];
    [countDown Countdown];
    [countDown setEnabled:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [_verificationCodeTX becomeFirstResponder];
}
@end
