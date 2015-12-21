//
//  OMTelephoneFindPasswordVC.m
//  dev01
//
//  Created by Starmoon on 15/7/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMTelephoneFindPasswordVC.h"

#import "OMCodeCountdownButton.h"

#import "OMNetwork_Login.h"

#import "OMNewPasswordViewController.h"

#import "OMTelephoneTextField.h"

@interface OMTelephoneFindPasswordVC ()<OMAlertViewForNetDelegate,UITextFieldDelegate,UIAlertViewDelegate>


/** 提示按钮 （显示：请输入要绑定的手机号码，以获取验证码） */
@property (retain, nonatomic) IBOutlet UILabel *tips_label;

/** 手机号码输入框 */
@property (retain, nonatomic) IBOutlet OMTelephoneTextField *telephone_textfield;

/** 验证码输入框 */
@property (retain, nonatomic) IBOutlet UITextField *code_textfield;

/** 获取验证码按钮 */
@property (retain, nonatomic) IBOutlet OMCodeCountdownButton *code_button;

/** 确定按钮 */
@property (retain, nonatomic) IBOutlet UIButton *enter_button;

/** 错误提示label */
@property (retain, nonatomic) IBOutlet UILabel *error_label;

/** 邮箱格式正确 */
@property (assign, getter=isTelephoneCorrect,nonatomic) BOOL telephone_correct;

/**
 *  判断是否点击获取验证码按钮
 */
@property(nonatomic,assign)BOOL  isClickCodeBtn;

@property (retain,nonatomic) NSError *error;



@end

@implementation OMTelephoneFindPasswordVC

-(void)dealloc{
    [_tips_label release];
    [_telephone_textfield release];
    [_code_textfield release];
    [_code_button release];
    [_enter_button release];
    [_error_label release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self uiConfig];
    self.isClickCodeBtn=NO;

 
}


- (void)uiConfig{
    self.title = NSLocalizedString(@"找回密码",nil);
    
    self.telephone_textfield.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 5)] autorelease];
    self.telephone_textfield.placeholder = NSLocalizedString(@"手机号",nil);
    self.telephone_textfield.leftViewMode = UITextFieldViewModeAlways;
    [self.telephone_textfield addTarget:self action:@selector(telephone_editing:) forControlEvents:UIControlEventEditingChanged];
    
    self.code_textfield.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 5)] autorelease];
    self.code_textfield.leftViewMode = UITextFieldViewModeAlways;
    self.code_textfield.placeholder = NSLocalizedString(@"验证码",nil);
    
    [self.code_button setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    self.enter_button.enabled = NO;
    [self.enter_button setBackgroundImage:[[UIImage imageNamed:@"btn_blue"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.enter_button setTitle:@"确定" forState:UIControlStateNormal];
    self.navigation_back_button_title=@"返回";
    self.code_textfield.delegate = self;
}


#pragma mark - Action

- (void)telephone_editing:(OMTelephoneTextField *)telephone_textfield{
    self.telephone_correct = telephone_textfield.text.isTelephone;
}




- (IBAction)codeCountdownAction:(OMCodeCountdownButton *)sender {
    self.isClickCodeBtn=YES;
    if (!self.telephone_correct){// 手机号码格式不正确
        self.error_label.text = @"手机号码格式不正确,请输入正确的手机号码";
        self.error_label.hidden = NO;
        return;
    }
    sender.duration = 60;
    [sender fire];
  
    [OMNetwork_Login check_mobile_existWithTelephoneNumber:self.telephone_textfield.text withCallback:@selector(didCheckMobile:) withObserver:self];
    
    
}


- (IBAction)enter_action:(id)sender {
    
//    [self.code_button stop];
    [self.view endEditing:YES];
    if (self.code_textfield.text.length)
    {
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
        self.omAlertViewForNet.title = @"验证中...";
        [self.omAlertViewForNet showInView:self.view];
        
        [OMNetwork_Login sms_checkCodeWithTelephone_number:self.telephone_textfield.text withCode:self.code_textfield.text withCallback:@selector(didCheckCode:) withObserver:self];

    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark---
#pragma mark---点击获取验证码，返回时警告框提示

-(void)baseVCBackAction:(UIButton *)back_button{
    if (!self.telephone_correct || self.error.code == 56 || self.error.code ==57 || self.error.code == 301){

        [[self navigationController] popViewControllerAnimated:YES];
    }

    else if (self.isClickCodeBtn==YES)

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


#pragma mark - Network 

- (void)didSendSMS:(NSNotification *)notif{
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    if (self.error.code == NO_ERROR)
    {
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done1;
        self.omAlertViewForNet.title = @"验证码已发送";
        [self.omAlertViewForNet showInView:self.view];

    }else if (self.error.code == 56){
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.omAlertViewForNet.title = @"验证发送超过5次!请明天再试!";
        [self.omAlertViewForNet showInView:self.view];
        [self.code_button stop];
    }
}


- (void)didCheckCode:(NSNotification *)notif{
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    if (self.error.code == 301) {
        self.error_label.hidden = YES;
        [self performSelector:@selector(removeLoading) withObject:nil afterDelay:0.1];
    }

    else if (self.error.code == NO_ERROR) {
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        self.omAlertViewForNet.title = @"验证成功";

           }
    else if (self.error.code ==57){
        //超过3分钟，验证码失效
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.error_label.text = @"验证码失效，请重新获取";
        self.error_label.hidden = NO;
    }

    else {

        self.error_label.text = @"验证失败，请输入正确的验证码";
        self.error_label.hidden = NO;
        [self.omAlertViewForNet dismiss];
    }
}
-(void)removeLoading
{
    [self.omAlertViewForNet dismiss];
}

- (void)didCheckMobile:(NSNotification *)notif{
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    if (self.error.code == 6) {
        [OMNetwork_Login sms_sendSMS:self.telephone_textfield.text withType:@"register" smstemplateid:SmstemplateID withCallback:@selector(didSendSMS:) withObserver:self];
    }else if (self.error.code == 0){
      
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.omAlertViewForNet.title = @"你输入的手机号码没有注册";
        self.error_label.text = @"你输入的手机号码没有注册";
        self.error_label.hidden = NO;
        self.enter_button.enabled = NO;
        [self.code_button stop];
    }
    else{
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.omAlertViewForNet.title = @"发送验证码失败";
        self.error_label.text = @"发送验证码失败";
        self.error_label.hidden = YES;
        [self.code_button stop];
    }
}
//#pragma mark - UITextFieldDelegate
//控制输入框内的字数
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_code_textfield)
    {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 0)
        {
            self.enter_button.enabled=YES;
        }
        else
        {
            self.enter_button.enabled=NO;
        }
    }
    return YES;
    
    
}

#pragma mark - OMAlertViewForNetDelegate
-(void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    if (alertViewForNet.type == OMAlertViewForNetStatus_Done){
        OMNewPasswordViewController *newPasswordVC = [[OMNewPasswordViewController alloc]initWithNibName:@"OMNewPasswordViewController" bundle:nil];
        newPasswordVC.source_type = OMNewPasswordViewControllerSourceType_ByTelephone;
        newPasswordVC.telephone = self.telephone_textfield.text;
        [self.navigationController pushViewController:newPasswordVC animated:YES];
        [newPasswordVC release];
    }
}



#pragma mark - Set and Get
-(void)setTelephone_correct:(BOOL)telephone_correct{
    _telephone_correct = telephone_correct;
    self.error_label.hidden = _telephone_correct;// 手机号码格式正确 隐藏错误提示label
//    self.enter_button.enabled = _telephone_correct;// 手机号码格式正确 确定按钮可用
}





@end
