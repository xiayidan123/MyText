//
//  OMChangeBindingEmailViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/29.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMChangeBindingEmailViewController.h"

#import "WowTalkWebServerIF.h"
#import "WTUserDefaults.h"
#import "WTError.h"

#import "OMCodeCountdownButton.h"
#import "YBAttrbutedLabel.h"

#import "OMBindingEmailViewController.h"

@interface OMChangeBindingEmailViewController ()<OMAlertViewForNetDelegate>

@property (retain, nonatomic) IBOutlet OMCodeCountdownButton *code_button;

@property (retain, nonatomic) IBOutlet UITextField *code_textField;

@property (retain, nonatomic) IBOutlet YBAttrbutedLabel *error_label;

@property (retain, nonatomic) IBOutlet UIButton *enter_button;

//判断是否点击获取验证码按钮
@property(nonatomic,assign)BOOL isClickCodeBtn;
@end

@implementation OMChangeBindingEmailViewController

- (void)dealloc {
    [_code_button release];
    [_code_textField release];
    [_error_label release];
    [_enter_button release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"绑定邮箱";
    
    self.code_textField.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 5)] autorelease];
    self.code_textField.leftViewMode = UITextFieldViewModeAlways;
    self.code_textField.keyboardType=UIKeyboardTypeEmailAddress;
    self.code_textField.placeholder = NSLocalizedString(@"验证码",nil);
    
    [self.code_button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.enter_button setBackgroundImage:[[UIImage imageNamed:@"btn_blue"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    self.enter_button.enabled = NO;
    [self.enter_button setTitle:@"确定" forState:UIControlStateNormal];
    self.navigation_back_button_title=@"返回";
    self.isClickCodeBtn=NO;
}

#pragma mark - Action

- (IBAction)code_button_action:(OMCodeCountdownButton *)sender {
    self.isClickCodeBtn=YES;
    sender.duration = 60;
    [sender fire];
    self.enter_button.enabled = YES;
    //1. 调用接口发送验证码邮件
    [WowTalkWebServerIF retrievePasswordWithWowtalkID:[WTUserDefaults getWTID] andEmail:[WTUserDefaults getEmail] Callback:@selector(didSendCode:) withObserver:self];
    
    self.omAlertViewForNet.title = @"验证码已发送";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done1;
    [self.omAlertViewForNet showInView:self.view];
}

// 2.用户输入验证码后 判断验证码正确与否
- (IBAction)enter_button_action:(UIButton *)sender {
    if (self.code_textField.text.length == 0){
        self.error_label.text = @"验证码不能为空";
        self.error_label.hidden = NO;
        return;
    }
    self.omAlertViewForNet.title = @"正在验证...";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertViewForNet showInView:self.view];
    
    [WowTalkWebServerIF checkCodeForRetrievePassword:[WTUserDefaults getWTID] andAccessCode:self.code_textField.text Callback:@selector(didCheckCode:) withObserver:self];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark---
#pragma mark---点击获取验证码，返回时警告框提示
-(void)baseVCBackAction:(UIButton *)back_button{
    if(self.isClickCodeBtn==YES)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:@"发送验证码可能需要一些时间请稍等片刻是否确定返回" delegate:self cancelButtonTitle:@"停留当前页面" otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - Network Callback

- (void)didSendCode:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code != NO_ERROR){
        self.error_label.text = @"今天的邮箱验证次数已用完请明天再试";
        self.error_label.hidden = NO;
    }else{
        self.error_label.text = nil;
        self.error_label.hidden = NO;
    }
}


- (void)didCheckCode:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == -99) {
        self.error_label.text = @"用户不存在";
        self.error_label.hidden = NO;
        self.omAlertViewForNet.title = @"用户不存在";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    else if (error.code == 1108)
    {
        self.error_label.text = @"验证码不正确";
        self.error_label.hidden = NO;
        self.omAlertViewForNet.title = @"验证码不正确";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    else if (error.code == 1109)
    {
        self.error_label.text = @"验证码已过期";
        self.error_label.hidden = NO;
        self.omAlertViewForNet.title = @"验证码已过期";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    else if (error.code == 0)
    {
        self.error_label.text = nil;
        self.error_label.hidden = YES;
        //3.0 验证码验证成功后 解除旧邮箱的绑定状态
        [WowTalkWebServerIF unBindEmail:@selector(didUnBindEmail:) withObserver:self];
        self.omAlertViewForNet.title = @"正在解除旧邮箱绑定...";
    }
}

- (void)didUnBindEmail:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [WTUserDefaults setEmail:nil];
        self.omAlertViewForNet.title = @"解除旧邮箱绑定成功";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
    }else{
        self.omAlertViewForNet.title = @"解除邮箱绑定失败,请重新获取验证码";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
}


#pragma mark - OMAlertViewForNetDelegate
-(void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    if (alertViewForNet.type == OMAlertViewForNetStatus_Done){
        OMBindingEmailViewController *bindingEmailVC = [[OMBindingEmailViewController alloc]initWithNibName:@"OMBindingEmailViewController" bundle:nil];
        bindingEmailVC.isRebind = YES;
        [self.navigationController pushViewController:bindingEmailVC animated:YES];
        [bindingEmailVC release];
    }
}



@end
