//
//  BindingTelephoneViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "BindingTelephoneViewController.h"

#import "OMNetwork_Login.h"
#import "WTUserDefaults.h"

#import "OMCodeCountdownButton.h"
#import "OMTelephoneTextField.h"
#import "OMNavigationController.h"
#import "NewLoginEmailVC.h"
#import "NewHomeViewController.h"
#import "OMTabBarVC.h"
#import "NewHomeViewController.h"
@interface BindingTelephoneViewController ()<OMAlertViewForNetDelegate,UITextFieldDelegate,UIAlertViewDelegate>

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

/** 返回首页*/
- (IBAction)back_home:(id)sender;


/** 错误提示label */
@property (retain, nonatomic) IBOutlet UILabel *error_label;


/** 手机格式正确 */
@property (assign, getter=isTelephoneCorrect,nonatomic) BOOL telephone_correct;

@property(nonatomic,assign)BOOL isClickCodeBtn;



@property (retain,nonatomic) NSError *error;

@end

@implementation BindingTelephoneViewController

- (void)dealloc {
    [_tips_label release];
    [_telephone_textfield release];
    [_code_textfield release];
    [_code_button release];
    [_enter_button release];
    [_error_label release];
    [super dealloc];
}

//WT_BIND_PHONE_NUMBER


- (void)viewDidLoad {
    [super viewDidLoad];

    [self uiConfig];
    

    
}

- (void)uiConfig{
    self.title = @"绑定手机号";
    
    self.telephone_textfield.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 5)] autorelease];
    self.telephone_textfield.placeholder = NSLocalizedString(@"手机号码",nil);
    self.telephone_textfield.leftViewMode = UITextFieldViewModeAlways;
    [self.telephone_textfield addTarget:self action:@selector(telephone_editing:) forControlEvents:UIControlEventEditingChanged];
    self.code_textfield.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 5)] autorelease];
    self.code_textfield.leftViewMode = UITextFieldViewModeAlways;
    self.code_textfield.placeholder = NSLocalizedString(@"验证码",nil);
//    [self.code_textfield addTarget:self action:@selector(code_editing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.code_button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.enter_button setBackgroundImage:[[UIImage imageNamed:@"btn_blue"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    self.enter_button.enabled = NO;
    [self.enter_button setTitle:@"确定" forState:UIControlStateNormal];
    
    if (self.isChangeBindingTelephone){
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    }
    
    self.isClickCodeBtn=NO;
    
    
}

#pragma mark - Action
- (void)telephone_editing:(OMTelephoneTextField *)telephone_textfield{
    self.telephone_correct = telephone_textfield.text.isTelephone;
}

- (void)code_editing:(UITextField *)code_Textfield{
    //    self.code_correct = code_Textfield.text.isSMSCode;
    
    
    
}


- (IBAction)codeCountdownAction:(OMCodeCountdownButton *)sender {
    
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
    
    // 再次验证手机号码 防止用户在等待验证码的时间中修改了手机号码
    if (!self.isTelephoneCorrect){
        self.error_label.text = @"请输入正确手机号码";
        self.error_label.hidden = NO;
        return;
    }
    
    // 验证码不能为空
    if (self.code_textfield.text.length == 0){// 验证码为空
        self.error_label.text = @"验证码不能为空";
        self.error_label.hidden = NO;
        return;
    }
    
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    self.omAlertViewForNet.title = @"验证中...";
    [self.omAlertViewForNet showInView:self.view];
    
    [OMNetwork_Login sms_checkCodeWithTelephone_number:self.telephone_textfield.text withCode:self.code_textfield.text withCallback:@selector(didCheckCode:) withObserver:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - Network Callback

- (void)didSendSMS:(NSNotification *)notif{
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    if (_error.code == NO_ERROR) {
        
    }else if (_error.code == 56){
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"今天的短信验证次数已用完，请明天再试。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alertView show];
//        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
//        self.omAlertViewForNet.title = @"验证发送超过5次!请明天再试!";
//        [self.omAlertViewForNet showInView:self.view];
        self.error_label.text = @"验证发送超过5次!请明天再试!";
        self.error_label.hidden = NO;
        [self.code_button stop];
    }
}


- (void)didCheckCode:(NSNotification *)notif{
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    if (_error.code == NO_ERROR) {
//        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        self.omAlertViewForNet.title = @"验证成功,正在绑定手机号码...";
        [OMNetwork_Login bindTelephoneWithNumber:self.telephone_textfield.text withCallback:@selector(didBindingPhone:) withObserver:self];
        
    }else if (_error.code == 57){ // 验证码失效过期
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.omAlertViewForNet.title = @"验证码过期，请重新获取";
        self.error_label.text = @"验证码过期，请重新获取";
        self.error_label.hidden = NO;
    }else {
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.omAlertViewForNet.title = @"验证失败,请输入正确验证码";
        self.error_label.text = @"验证失败,请输入正确验证码";
        self.error_label.hidden = NO;
    }
}

- (void)didBindingPhone:(NSNotification *)notif{
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    if (_error.code == NO_ERROR) {
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        self.omAlertViewForNet.title = @"手机号码绑定成功";
        [WTUserDefaults setPhoneNumber:self.telephone_textfield.text];
        
        if(self.LoginBingding)
        {
            //绑定成功后，跳转到首页重新登录
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"绑定成功，请用手机号码重新登录",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认",nil), nil];
//        [alertView show];
//        [alertView release];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"绑定成功，变更手机号码需重新登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag = 1101;
            [alertView show];
            
//        self.navigationController.navigationBar.hidden = NO;
//        NewHomeViewController *back = [[NewHomeViewController alloc] initWithNibName:@"NewHomeViewController" bundle:nil];
//        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:back];]
//        navi.navigationBarHidden=NO;
//        [self.view addSubview:navi.view];
//        [navi release];
        }
    }else{
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.omAlertViewForNet.title = @"手机号码绑定失败,请重新绑定";
        self.error_label.text = @"手机号码绑定失败,请重新绑定";
        self.error_label.hidden = NO;
    }
}


- (void)didCheckMobile:(NSNotification *)notif{
    self.error = [[notif userInfo] valueForKey:WT_ERROR];
    
    
    
    if (_error.code == NO_ERROR) {//手机号码在服务器中不存在的时候才能去绑定
        [OMNetwork_Login sms_sendSMS:self.telephone_textfield.text withType:@"bindingTelephone" smstemplateid:SmstemplateID withCallback:@selector(didSendSMS:) withObserver:self];
        
    }else if (_error.code == 6){

//        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
//        self.omAlertViewForNet.title = @"手机号码已被绑定";
        self.error_label.text = @"该手机号码已被绑定，请输入未被绑定过的手机号码";
        self.error_label.hidden = NO;
        [self.code_button stop];
    }
//    else{
//        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
//        self.omAlertViewForNet.title = @"绑定错误";
//        self.error_label.text = @"绑定错误";
//        self.error_label.hidden = NO;
//    }
    
}
//#pragma mark - UITextFieldDelegate
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    self.telephone_textfield.previousTextFieldContent = textField.text;
//    self.telephone_textfield.previousSelection = textField.selectedTextRange;
//    return YES;
//}


#pragma mark - OMAlertViewForNetDelegate
-(void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    if (alertViewForNet.type == OMAlertViewForNetStatus_Done){
        if (self.isChangeBindingTelephone){
            if (self.navigationController.viewControllers.count >= 3){
                UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
                [self.navigationController popToViewController:vc animated:YES];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - Set and Get
-(void)setTelephone_correct:(BOOL)telephone_correct{
    _telephone_correct = telephone_correct;
    self.error_label.hidden = _telephone_correct;// 手机号码格式正确 隐藏错误提示label
    self.enter_button.enabled = _telephone_correct;// 手机号码格式正确 确定按钮可用
}


- (IBAction)back_home:(id)sender {
    if (!self.telephone_correct || _error.code == 56 || _error.code ==6) {
        NewLoginEmailVC *vc = [[NewLoginEmailVC alloc]initWithNibName:@"NewLoginEmailVC" bundle:nil];
        OMNavigationController *navi = [[OMNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:@"发送验证码可能需要一些时间，请稍等，留在该页还是确定返回" delegate:self cancelButtonTitle:@"停留当前页面" otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
        [alertView show];
        alertView.tag=1102;
        [alertView release];
     
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1101 && buttonIndex == 0) {
        
        NewLoginEmailVC *vc = [[NewLoginEmailVC alloc]initWithNibName:@"NewLoginEmailVC" bundle:nil];
        OMNavigationController *navi = [[OMNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
        
    }else if (alertView.tag == 1101 && buttonIndex == 1) {
        
        self.navigationController.navigationBar.hidden = NO;
        NewHomeViewController *back = [[NewHomeViewController alloc] initWithNibName:@"NewHomeViewController" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:back];
        navi.navigationBarHidden=NO;
        [self presentViewController:navi animated:YES completion:nil];
        [navi release];
    }
    else if (alertView.tag==1102&&buttonIndex==1&&self.LoginBingding==YES)
    {
        NewLoginEmailVC *vc = [[NewLoginEmailVC alloc]initWithNibName:@"NewLoginEmailVC" bundle:nil];
        OMNavigationController *navi = [[OMNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];

    }
    else if (alertView.tag==1102&&buttonIndex==1&&self.isChangeBindingTelephone==YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end