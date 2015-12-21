//
//  ChangePasswordVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "NSString+Compare.h"

#import "WowTalkWebServerIF.h"
#import "WTHeader.h"

#import "OMAlertViewForNet.h"

#import "NewLoginEmailVC.h"

@interface ChangePasswordVC ()<OMAlertViewForNetDelegate>

@property (retain, nonatomic) IBOutlet UIView *bg_view;

@property (retain, nonatomic) IBOutlet UIView *oldPassword_view;

@property (retain, nonatomic) IBOutlet UITextField *oldPassword_textField;


@property (retain, nonatomic) IBOutlet UIView *afreshPassword_view;

@property (retain, nonatomic) IBOutlet UITextField *afreshPassword_textField;


@property (retain, nonatomic) IBOutlet UITextField *againPassword_textField;

@property (retain, nonatomic) IBOutlet UIButton *showPassword_button;

@property (retain, nonatomic) IBOutlet UIButton *enter_button;


@property (retain, nonatomic) IBOutlet UILabel *remind_label;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *enterConstraint_top;

@property (retain, nonatomic) OMAlertViewForNet *alertViewForNet;

@end

@implementation ChangePasswordVC

- (void)dealloc {
    [_bg_view release];
    [_oldPassword_view release];
    
    [_showPassword_button release];
    [_enter_button release];
    [_afreshPassword_view release];
    [_oldPassword_textField release];
    [_afreshPassword_textField release];
    [_againPassword_textField release];
    [_remind_label release];
    [_enterConstraint_top release];
    
    [_alertViewForNet release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}

- (void)uiConfig{
    [self configNav];
    
    [_enter_button setBackgroundImage:[[UIImage imageNamed:@"btn_bule@1x.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]forState:UIControlStateNormal];
    
    self.remind_label.text = @"";
}

-(void)configNav
{
    self.title = NSLocalizedString(@"Change password",nil);
}


- (void)goBack{
    //[self.navigationController popViewControllerAnimated:YES];
   NewLoginEmailVC *vc=[[NewLoginEmailVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (IBAction)showPasswordAction:(id)sender {
    self.showPassword_button.selected = !self.showPassword_button.selected;
    
    if (self.showPassword_button.selected){
        self.oldPassword_textField.secureTextEntry = NO;
        self.afreshPassword_textField.secureTextEntry = NO;
        self.againPassword_textField.secureTextEntry = NO;
    }else{
        self.oldPassword_textField.secureTextEntry = YES;
        self.afreshPassword_textField.secureTextEntry = YES;
        self.againPassword_textField.secureTextEntry = YES;
    }
}


- (IBAction)enterAction:(id)sender {
    
    if ([self judgeLegitimacy]){
        [WowTalkWebServerIF changePassword:self.afreshPassword_textField.text withOldPassword:self.oldPassword_textField.text withCallback:@selector(passwordChanged:) withObserver:self];
    }
}



- (BOOL)judgeLegitimacy{
    BOOL isLegal = NO;
    NSString *remindString = @"";
    //判断是否有非法字符
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"] invertedSet];
    NSRange userNameRange1 = [self.afreshPassword_textField.text rangeOfCharacterFromSet:nameCharacters];
    NSRange userNameRange2 = [self.againPassword_textField.text rangeOfCharacterFromSet:nameCharacters];
    if ([NSString isEmptyString:self.oldPassword_textField.text]
        || ([self.oldPassword_textField.text length] < 6)
        || ([self.oldPassword_textField.text length] >20)){
        remindString = NSLocalizedString(@"请填写正确的原密码", nil);
    }else if ([NSString isEmptyString:self.afreshPassword_textField.text] || [NSString isEmptyString:self.againPassword_textField.text]) {
        remindString = @"密码不能为空";
    }else if ([self.afreshPassword_textField.text length] < 6) {
        remindString = @"密码不能少于6位";
    }else if ([self.afreshPassword_textField.text length] >20) {
        remindString = @"密码不能超过20位";
    }
    else if (![self.afreshPassword_textField.text isEqualToString:self.againPassword_textField.text]) {
        remindString =@"两次输入的密码不一致";
    }
    
    else if (userNameRange1.location!= NSNotFound || userNameRange2.location!= NSNotFound) {
        remindString = @"密码修改失败，新密码格式不正确，可以使用6-20个字母、数字、下划线和减号";
    }

    else{
        isLegal = YES;
    }
    if (isLegal == NO){
        self.remind_label.text = remindString;
        
        if (self.enterConstraint_top.constant != 30){
            self.enterConstraint_top.constant = 30;
            [UIView animateWithDuration:0.2 animations:^{
                [self.enter_button layoutIfNeeded];
            }];
        }
    }else{
        OMAlertViewForNet *alertView = [OMAlertViewForNet OMAlertViewForNet];
        alertView.title = @"正在修改密码";
        [alertView show];
        alertView.delegate = self;
        self.alertViewForNet = alertView;
    }
    
    return isLegal;
}


- (void)passwordChanged:(NSNotification *)notification
{
    NSError *error = [[notification userInfo] objectForKey:WT_ERROR];
    if (error.code == NO_ERROR&&![self.oldPassword_textField.text  isEqualToString:self.afreshPassword_textField.text]) {
        self.alertViewForNet.title = @"密码修改成功请重新登录";
        self.alertViewForNet.type = OMAlertViewForNetStatus_Done;
    }else if (error.code == 37){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Previous password is wrong",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        self.alertViewForNet.title=@"旧密码输入错误";
        self.alertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Failed to change password",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        self.alertViewForNet.title=@"新密码和旧密码不能相同";
        self.alertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
}


- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    [self goBack];
}

@end
