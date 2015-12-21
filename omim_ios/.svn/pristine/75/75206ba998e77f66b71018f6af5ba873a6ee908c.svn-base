//
//  OMNewPasswordViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMNewPasswordViewController.h"

#import "OMNetwork_Login.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "AppDelegate.h"

#import "YBAttrbutedLabel.h"

@interface OMNewPasswordViewController ()<OMAlertViewForNetDelegate>

/** 新密码textField */
@property (retain, nonatomic) IBOutlet UITextField *password_textfield;

/** 确认新密码 textField */
@property (retain, nonatomic) IBOutlet UITextField *again_password_textfield;

/** 显示密码按钮 */
@property (retain, nonatomic) IBOutlet UIButton *show_password_button;

/** 错误提示Label */
@property (retain, nonatomic) IBOutlet YBAttrbutedLabel *error_label;

/** 确认按钮 */
@property (retain, nonatomic) IBOutlet UIButton *enter_button;

@end

@implementation OMNewPasswordViewController

- (void)dealloc {
    [_password_textfield release];
    [_again_password_textfield release];
    [_show_password_button release];
    [_error_label release];
    [_enter_button release];
    
    self.uid = nil;
    self.code = nil;
    self.email = nil;
    self.telephone = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}

- (void)uiConfig{
    self.title = NSLocalizedString(@"找回密码",nil);
    
    self.password_textfield.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 5)] autorelease];
    self.password_textfield.placeholder = NSLocalizedString(@"新密码",nil);
    self.password_textfield.leftViewMode = UITextFieldViewModeAlways;
    [self.password_textfield addTarget:self action:@selector(password_editing:) forControlEvents:UIControlEventEditingChanged];
    
    self.again_password_textfield.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 5)] autorelease];
    self.again_password_textfield.leftViewMode = UITextFieldViewModeAlways;
    self.again_password_textfield.placeholder = NSLocalizedString(@"确认新密码",nil);
    [self.again_password_textfield addTarget:self action:@selector(again_password_editing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.show_password_button setImage:[UIImage imageNamed:@"btn_show_password_off"] forState:UIControlStateNormal];
    [self.show_password_button setImage:[UIImage imageNamed:@"btn_show_password_on"] forState:UIControlStateSelected];
    [self.show_password_button setTitle:@"显示密码" forState:UIControlStateNormal];
    
    self.enter_button.enabled = NO;
    [self.enter_button setBackgroundImage:[[UIImage imageNamed:@"btn_blue"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.enter_button setTitle:@"确定" forState:UIControlStateNormal];
}


#pragma mark - Action
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)password_editing:(UITextField *)textField{
    if (textField.hasText && self.again_password_textfield.hasText){
        self.enter_button.enabled = YES;
    }else{
        self.enter_button.enabled = NO;
    }
}


- (void)again_password_editing:(UITextField *)textField{
    if (textField.hasText && self.password_textfield.hasText){
        self.enter_button.enabled = YES;
    }else{
        self.enter_button.enabled = NO;
    }
}


- (IBAction)show_password_action:(UIButton *)show_password_button {
    show_password_button.selected = !show_password_button.selected;
    
    self.password_textfield.secureTextEntry = !show_password_button.selected;
    self.again_password_textfield.secureTextEntry = !show_password_button.selected;
}

- (IBAction)enter_action:(UIButton *)sender {
    if (![self.password_textfield.text isEqualToString:self.again_password_textfield.text]){
        // 两次输入的密码不相等
        self.omAlertViewForNet.title = @"两次输入的密码不一致";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        [self.omAlertViewForNet showInView:self.view];
        return;
    }
    
    self.error_label.text = @"";
    self.error_label.hidden = YES;
    
    self.omAlertViewForNet.title = @"正在重置密码...";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertViewForNet showInView:self.view];
    
    switch (self.source_type) {
        case OMNewPasswordViewControllerSourceType_ByEmail:{
            [OMNetwork_Login reset_password_via_email:self.email access_code:self.code new_password:self.password_textfield.text withCallback:@selector(changePassword:) withObserver:self];
        }break;
        case OMNewPasswordViewControllerSourceType_ByTelephone:{
            [OMNetwork_Login reset_password_by_mobileWithTelephoneNumber:self.telephone new_password:self.password_textfield.text withCallback:@selector(changePassword:) withObserver:self];
        }break;
        default:
            break;
    }
}

#pragma mark---密码的格式判断未完成
- (void)changePassword:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == -99) {
        self.omAlertViewForNet.title = @"用户不存在";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    else if (error.code == 1108)
    {
        self.omAlertViewForNet.title = @"未验证验证码";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
        //判断是否有非法字符
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"] invertedSet];
    NSRange userNameRange = [self.password_textfield.text rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location!= NSNotFound) {
        self.omAlertViewForNet.title = @"密码修改失败，新密码格式不正确，可以使用6-20个字母、数字、下划线和减号";
        
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    else if ([self.password_textfield.text length]<6)
    {
        self.omAlertViewForNet.title = @"密码的长度不能少于6位";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        
    }
    else if ([self.password_textfield.text length]>20)
    {
        self.omAlertViewForNet.title = @"密码的长度不能超过20位";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    else if (![self isValidatePassWord:self.password_textfield.text])
    {
        self.omAlertViewForNet.title = @"密码格式不正确，可以使用6-20个字母，数字，下划线和减号";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        
    }
    else if (error.code == 0)
    {
        self.omAlertViewForNet.title = @"密码重置成功,正在登陆...";
        
        NSString *userInfo = @"";
        switch (self.source_type) {
            case OMNewPasswordViewControllerSourceType_ByEmail:{
                userInfo = self.email;
            }break;
            case OMNewPasswordViewControllerSourceType_ByTelephone:{
                userInfo = self.telephone;
            }break;
                
            default:
                break;
        }
        [WowTalkWebServerIF loginWithUserinfo:userInfo password:self.password_textfield.text withLatitude:0 withLongti:0 withCallback:@selector(fLoginFinished:) withObserver:self];
    }
}

- (BOOL)isValidatePassWord:(NSString *)passWord
{
    NSString *passWordRegex = @"^[-_a-zA-Z0-9]+$";
    NSPredicate *passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordTest evaluateWithObject:passWord];
}


- (void)fLoginFinished:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code != NO_ERROR)
    {
        self.omAlertViewForNet.title = NSLocalizedString(@"Failed to login",nil);
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    else
    {
        [[AppDelegate sharedAppDelegate] setupApplicaiton:YES];
    }
}

#pragma mark - OMAlertViewForNetDelegate
-(void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    if (alertViewForNet.type == OMAlertViewForNetStatus_Failure){
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
