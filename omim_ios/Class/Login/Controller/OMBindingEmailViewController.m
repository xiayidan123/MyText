//
//  OMBindingEmailViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBindingEmailViewController.h"

#import "OMCodeCountdownButton.h"
#import "OMNetwork_Login.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "WTUserDefaults.h"

#import "YBAttrbutedLabel.h"

@interface OMBindingEmailViewController ()<OMAlertViewForNetDelegate>


@property (retain, nonatomic) IBOutlet UITextField *email_textField;

@property (retain, nonatomic) IBOutlet UITextField *code_textField;

@property (retain, nonatomic) IBOutlet OMCodeCountdownButton *code_button;

@property (retain, nonatomic) IBOutlet YBAttrbutedLabel *error_label;

@property (retain, nonatomic) IBOutlet UIButton *enter_button;

/** 邮箱格式正确 */
@property (assign, getter=isEmailCorrect,nonatomic) BOOL email_correct;

@end

@implementation OMBindingEmailViewController

- (void)dealloc {
    [_email_textField release];
    [_code_textField release];
    [_code_button release];
    [_error_label release];
    [_enter_button release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"绑定邮箱";
    
    self.email_textField.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 5)] autorelease];
    self.email_textField.placeholder = NSLocalizedString(@"邮箱",nil);
    self.email_textField.leftViewMode = UITextFieldViewModeAlways;
    self.email_textField.keyboardType=UIKeyboardTypeEmailAddress;
    [self.email_textField addTarget:self action:@selector(email_editing:) forControlEvents:UIControlEventEditingChanged];
    
    self.code_textField.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 5)] autorelease];
    self.code_textField.leftViewMode = UITextFieldViewModeAlways;
    self.code_textField.placeholder = NSLocalizedString(@"验证码",nil);
    
    [self.code_button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.enter_button setBackgroundImage:[[UIImage imageNamed:@"btn_blue"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    self.enter_button.enabled = NO;
    [self.enter_button setTitle:@"确定" forState:UIControlStateNormal];
    
}

- (void)email_editing:(UITextField *)text_field{
    self.email_correct = text_field.text.isEmail;
    
}


#pragma mark - Action

- (IBAction)code_button_action:(OMCodeCountdownButton *)sender {
    if (!self.email_correct){// 邮箱格式不正确
        self.error_label.text = @"请输入正确的邮箱";
        self.error_label.hidden = NO;
        return;
    }
    sender.duration = 60;
    [sender fire];
    
    // 调用接口发送邮件
     [WowTalkWebServerIF BlidingEmail:self.email_textField.text WithCallback:@selector(didSendEmail:) withObserver:self];

}


- (IBAction)enter_button_action:(UIButton *)sender {
    // 再次验证邮箱 防止用户在等待验证码的时间中修改了邮箱
    self.email_correct = self.email_textField.text.isEmail;
    if (!self.email_correct){
        self.error_label.text = @"请输入正确的邮箱";
        self.error_label.hidden = NO;
        return;
    }
    // 验证码不能为空
    if (self.code_textField.text.length == 0){
        self.error_label.text = @"验证码不能为空";
        self.error_label.hidden = YES;
        return;
    }
    
    [self.code_button stop];
    
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    self.omAlertViewForNet.title = @"绑定中...";
    [self.omAlertViewForNet showInView:self.view];
    
    //    CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault));
    
   [WowTalkWebServerIF GetVerifyCodeWithAccessCode:self.code_textField.text andEmail:self.email_textField.text Callback:@selector(didBindingEmail:) withObserver:self];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark---mark
#pragma mark---发送邮件
- (void)didSendEmail:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == WT_FORMAT_ERROR) {
        self.error_label.text = @"邮箱格式不正确";
        self.error_label.hidden = NO;
    }
    else if (error.code == WT_EMAIL_DID_BIND)
    {
        self.error_label.text = @"该邮箱已被绑定，请使用其他邮箱";
        self.error_label.hidden = NO;
    }
    else if (error.code == WT_USER_DID_BIND)
    {
        self.error_label.text = @"您已绑定邮箱";
        self.error_label.hidden = NO;
    }
    else if (error.code == NO_ERROR)
    {
        self.error_label.text = nil;
        self.error_label.hidden = YES;
    }
}

- (void)didBindingEmail:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR){
        self.omAlertViewForNet.title = @"邮箱绑定成功";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        // 将邮箱存到数据库
        [WTUserDefaults setEmail:self.email_textField.text];
        
        if ([self.delegate respondsToSelector:@selector(didBindingEamil)]){
            [self.delegate didBindingEamil];
        }
        
    }else{
        self.omAlertViewForNet.title = @"验证失败,请填写正确的验证码";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
}

#pragma mark - OMAlertViewForNetDelegate
-(void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    if (alertViewForNet.type == OMAlertViewForNetStatus_Done){
        if (self.isRebind){
            NSUInteger vc_count = self.navigationController.viewControllers.count;
            if (vc_count >= 3){
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:vc_count - 3] animated:YES];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - Set and Get

-(void)setEmail_correct:(BOOL)email_correct{
    _email_correct = email_correct;
    self.error_label.hidden = _email_correct;// 邮箱格式正确 隐藏错误提示label
    self.enter_button.enabled = _email_correct;// 邮箱格式正确 确定按钮可以使用
    
    if (!self.email_textField.hasText){
        self.error_label.text = @"邮箱不能为空";
        self.error_label.hidden = NO;
    }else if (!_email_correct){
        self.error_label.text = @"邮箱格式不正确,请输入正确的邮箱";
        self.error_label.hidden = NO;
    }
}








@end
