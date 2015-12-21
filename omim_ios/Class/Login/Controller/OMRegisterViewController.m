//
//  OMRegisterViewController.m
//  dev01
//
//  Created by Huan on 15/7/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  注册页面

#import "OMRegisterViewController.h"
#import "OMCodeCountdownButton.h"
#import "OMTelephoneTextField.h"
#import "OMNetwork_Login.h"
#import "OMSetPasswordAndTypeVC.h"

#import "YBAttrbutedLabel.h"

@interface OMRegisterViewController ()<UIAlertViewDelegate,OMAlertViewForNetDelegate,UITextFieldDelegate>

/** 手机号码输入框 */
@property (retain, nonatomic) IBOutlet OMTelephoneTextField *telephone_textfield;
/** 验证码输入框 */
@property (retain, nonatomic) IBOutlet UITextField *verificationCode_textfield;
/** 获取验证码按钮*/
@property (retain, nonatomic) IBOutlet OMCodeCountdownButton *code_button;
/** 错误提示框 */
@property (retain, nonatomic) IBOutlet YBAttrbutedLabel *errortips_label;
/** 确定按钮*/
@property (retain, nonatomic) IBOutlet UIButton *enter_button;
/** 邮箱格式正确 */
@property (assign, getter=isTelephoneCorrect,nonatomic) BOOL telephone_correct;
/** 邮箱格式正确 */
@property (copy, nonatomic) NSString * telephoneNum;

@property(nonatomic,assign)BOOL isClickCodeBtn;

@property (retain,nonatomic) NSError *error;


@end

@implementation OMRegisterViewController


- (void)dealloc {
    [_telephone_textfield release];
    [_verificationCode_textfield release];
    [_code_button release];
    [_errortips_label release];
    [_enter_button release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];


 
}


- (void)uiConfig{
    self.title = @"注册";
    
    
    [self.telephone_textfield addTarget:self action:@selector(telephone_editing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.verificationCode_textfield addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventEditingChanged];
    
    [self.code_button setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [self.enter_button setBackgroundImage:[[UIImage imageNamed:@"btn_blue"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    
    [self.enter_button setTitle:@"确定" forState:UIControlStateNormal];
    
    self.enter_button.enabled = NO;
    self.navigation_back_button_title=@"返回";
    self.isClickCodeBtn=NO;
}


-(void)baseVCBackAction:(UIButton *)back_button{
    if (!self.telephone_correct || self.error.code == 56 || self.error.code ==6 || self.error.code == 301 || self.error.code ==57){
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else  if(self.isClickCodeBtn==YES)
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


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - Action
- (void)telephone_editing:(OMTelephoneTextField *)telephone_textfield{
    self.telephoneNum = telephone_textfield.text;
    self.telephone_correct = self.telephoneNum.isTelephone;
}


- (IBAction)codeCountdownAction:(OMCodeCountdownButton *)sender {

    self.isClickCodeBtn=YES;
   [self.view endEditing:YES];
    if (!self.telephone_correct){// 手机号码格式不正确
        self.errortips_label.text = @"请输入正确的手机号码";
        self.errortips_label.hidden = NO;
        return;
    }
    // 检查手机号码是否已经注册过
    [OMNetwork_Login check_mobile_existWithTelephoneNumber:self.telephoneNum withCallback:@selector(didCheckTelephoneNumberBindStatus:) withObserver:self];
    
//    [OMNetwork_Login check_bind_mobileWithTelephoneNumber:self.telephoneNum withCallback:@selector(didCheckTelephoneNumberBindStatus:) withObserver:self];
    
//    self.omAlertViewForNet.title = @"正在检查该手机号码是否已注册";
//    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
//    [self.omAlertViewForNet showInView:self.view];
}

- (IBAction)sure:(id)sender {
    [self.view endEditing:YES];
    [self.code_button stop];
    
    if (self.verificationCode_textfield.text.length) {
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
        self.omAlertViewForNet.title = @"验证中...";
        [self.omAlertViewForNet showInView:self.view];
        [OMNetwork_Login sms_checkCodeWithTelephone_number:self.telephoneNum withCode:self.verificationCode_textfield.text withCallback:@selector(didCheckCode:) withObserver:self];
    }else if(![self.verificationCode_textfield.text length]){
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.omAlertViewForNet.title = @"请输入验证码";
        [self.omAlertViewForNet showInView:self.view];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Set and Get
-(void)setTelephone_correct:(BOOL)telephone_correct{
    _telephone_correct = telephone_correct;
    self.errortips_label.hidden = _telephone_correct;// 手机号码格式正确 隐藏错误提示label
}

#pragma mark - OMNetwork_login


- (void)didCheckTelephoneNumberBindStatus:(NSNotification *)notif{
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    if (self.error.code == NO_ERROR) {
        self.omAlertViewForNet.title = @"正在发送验证码";
        self.omAlertViewForNet.isEnd = NO;
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        [self.omAlertViewForNet showInView:self.view];
        
        self.code_button.duration = 60;
        [self.code_button fire];
        
        [OMNetwork_Login sms_sendSMS:self.telephoneNum withType:@"register" smstemplateid:SmstemplateID withCallback:@selector(didSendSuccess:) withObserver:self];
    }else if (self.error.code == 6){
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
        self.omAlertViewForNet.title = @"验证码发送中...";
        [self.omAlertViewForNet showInView:self.view];
        
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.errortips_label.text = @"该手机号码已被注册,请登录或者找回密码";
        self.errortips_label.hidden = NO;
    }else{
        self.omAlertViewForNet.title = @"验证手机号码失败";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
//        self.errortips_label.text = @"验证手机号码失败";
//        self.errortips_label.hidden = NO;
    }
}

- (void)didSendSuccess:(NSNotification *)notif{
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    if (self.error.code == NO_ERROR) {
        
    }else if (self.error.code == 56){
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:@"一个手机号每天只能获取5次验证码，请明天再获取验证码" delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
        [alertView show];
        [alertView release];
        [self.code_button stop];

        
//        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
//        self.omAlertViewForNet.title = @"验证发送超过5次!请明天再试!";
//        self.errortips_label.text = @"验证发送超过5次!请明天再试!";
//        self.errortips_label.hidden = NO;
    }
}


- (void)didCheckCode:(NSNotification *)notif{
    
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    if (self.error.code == 301) {
        self.errortips_label.hidden = YES;
        [self performSelector:@selector(removeLoading) withObject:nil afterDelay:0.1];
    }
    
    else if (self.error.code == NO_ERROR) {
        self.omAlertViewForNet.title = @"验证成功";
        self.omAlertViewForNet.isEnd = YES;
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
    }else if (self.error.code ==57){
        //超过3分钟，验证码失效
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.errortips_label.text = @"验证码失效，请重新获取";
        self.errortips_label.hidden = NO;
    }else{
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.omAlertViewForNet.title = @"验证失败,请输入正确验证码";
        self.errortips_label.hidden = NO;
    }
    
    
}
-(void)removeLoading
{
    [self.omAlertViewForNet dismiss];
}


//监测验证码输入框编辑状态
- (void)infoAction {
    if ([self.verificationCode_textfield.text length] >= 4 && [self.telephone_textfield.text isTelephone]) {
        self.enter_button.enabled = YES;
    }else {
        self.enter_button.enabled = NO;
    }
}

#pragma mark - OMAlertViewForNetDelegate

-(void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    if (alertViewForNet.type == OMAlertViewForNetStatus_Done && alertViewForNet.isEnd){
        OMSetPasswordAndTypeVC *newRigVC = [[[OMSetPasswordAndTypeVC alloc] initWithNibName:@"OMSetPasswordAndTypeVC" bundle:nil] autorelease];
        newRigVC.telephoneNum = self.telephoneNum;
        [self.navigationController pushViewController:newRigVC animated:YES];
    }
}

@end
