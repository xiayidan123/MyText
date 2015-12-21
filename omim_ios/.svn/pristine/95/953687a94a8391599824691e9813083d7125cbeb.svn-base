//
//  OMSetPasswordAndTypeVC.m
//  dev01
//
//  Created by Huan on 15/7/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMSetPasswordAndTypeVC.h"
#import "QCheckBox.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "AppDelegate.h"

#define TAG_ALERT_REGISTER_SUCCESS 100
#define TAG_ALERT_REGISTER_FAIL 101
@interface OMSetPasswordAndTypeVC ()<UIActionSheetDelegate>
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UITextField *setPassword_textfield;
@property (retain, nonatomic) IBOutlet UITextField *repeatPassword_textfield;
@property (retain, nonatomic) IBOutlet UILabel *accountType_label;
@property (retain, nonatomic) IBOutlet UIButton *registerSure_btn;
@property (retain, nonatomic) QCheckBox * checkBox;
@property (assign, nonatomic) int userType;
@property (assign, nonatomic) BOOL isStudent;

@end

@implementation OMSetPasswordAndTypeVC

- (void)dealloc {
    [_setPassword_textfield release];
    [_repeatPassword_textfield release];
    [_accountType_label release];
    [_registerSure_btn release];
    [_checkBox release];
    [_bottomView release];
    self.telephoneNum = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self uiConfig];
}

- (void)uiConfig{
    
    self.title = @"注册";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    
    
    [self.view addSubview:self.checkBox];
    [self.checkBox setChecked:NO];
    
    [self.registerSure_btn setBackgroundColor:[UIColor colorWithRed:0.10f green:0.64f blue:0.89f alpha:1.00f]];
    [self.registerSure_btn.layer setMasksToBounds:YES];
    [self.registerSure_btn.layer setCornerRadius:5.0];
    
    
}

- (IBAction)chooseAccountType:(id)sender {
    [self.view endEditing:YES];
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"老师", @"学生",nil];
    [actionSheet showInView:self.view];
}
- (IBAction)registerSure:(id)sender {
    [self.view endEditing:YES];
    BOOL rlt = YES;
    NSString* errMsg=@"";
    if (self.setPassword_textfield.text == nil){
        rlt = NO;
        errMsg = NSLocalizedString(@"密码不能为空,可以使用6-20个字母、数字、下划线和减号",nil);
    }
    
    else if (self.setPassword_textfield.text.length < 6){
        rlt = NO;
        errMsg = NSLocalizedString(@"密码最少6位,可以使用6-20个字母、数字、下划线和减号",nil);
    }
    else  if (![self.setPassword_textfield.text isEqualToString:self.repeatPassword_textfield.text]){
        rlt = NO;
        errMsg = NSLocalizedString(@"注册失败，确认密码和密码不一致",nil);
    }else if (self.setPassword_textfield.text.length > 20){
        rlt = NO;
        errMsg = NSLocalizedString(@"密码最多20位,可以使用6-20个字母、数字、下划线和减号",nil);
    }else if (![self isValidatePassWord:self.setPassword_textfield.text]){
        rlt = NO;
        errMsg = NSLocalizedString(@"密码格式不正确，可以使用6-20个字母，数字，下划线和减号",nil);
    }else if (![self.accountType_label.text isEqualToString:NSLocalizedString(@"老师",nil)] && ![self.accountType_label.text isEqualToString:NSLocalizedString(@"学生",nil)]){
        rlt = NO;
        errMsg = NSLocalizedString(@"请选择账号类型",nil);
    }
    if(rlt == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to register",nil) message:errMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        alert.tag = TAG_ALERT_REGISTER_FAIL;
        [alert show];
        [alert release];
        return;
    }
    self.omAlertViewForNet.title = @"正在注册";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertViewForNet showInView:self.view];
    [WowTalkWebServerIF registerWithUserid:self.telephoneNum password:self.setPassword_textfield.text withUserType:(_isStudent?@"1":@"2") withCallback:@selector(fRegisterFinished:) withObserver:self];
}

- (void)fRegisterFinished:(NSNotification *)notification
{
    if(notification==nil) return;
    self.omAlertViewForNet.title = @"注册成功";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
    
    
//    self.omAlertViewForNet.title = @"正在登录";
//    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
//    [self.omAlertViewForNet showInView:self.view];
    NSDictionary *dict = [notification userInfo];
    if (dict==nil) return;
    if ([dict objectForKey:WT_ERROR] && [[dict objectForKey:WT_ERROR] code] != NO_ERROR && [[dict objectForKey:WT_ERROR] code] != NETWORK_IS_NOT_AVAILABLE)
    {
        NSString* alertMsg =[NSString stringWithFormat:@"error%zi", [[dict objectForKey:WT_ERROR] code]];
        alertMsg  = NSLocalizedString(alertMsg, nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to register",nil) message:alertMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        alert.tag = TAG_ALERT_REGISTER_FAIL;
        
        [alert show];
        [alert release];
    }
    else
    {
        [WowTalkWebServerIF loginWithUserinfo:self.telephoneNum password:self.setPassword_textfield.text withLatitude:0 withLongti:0 withCallback:@selector(fLoginFinished:) withObserver:self];
    }
}

- (void)fLoginFinished:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    if ([dict objectForKey:WT_ERROR] && [[dict objectForKey:WT_ERROR] code] != NO_ERROR)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login",nil) message:NSLocalizedString(@"Authetication failed",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        [[AppDelegate sharedAppDelegate] setupApplicaiton:YES];
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (BOOL)isValidatePassWord:(NSString *)passWord
{
    NSString *passWordRegex = @"^[-_a-zA-Z0-9]+$";
    NSPredicate *passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordTest evaluateWithObject:passWord];
}
#pragma mark set - get
- (QCheckBox *)checkBox{
    if (!_checkBox) {
        _checkBox = [[QCheckBox alloc] initWithDelegate:self];
        _checkBox.frame = CGRectMake(10, CGRectGetMaxY(self.bottomView.frame), 80, 60);
    }
    return _checkBox;
}

- (void)setUserType:(int)userType{
    _userType = userType;
    if (_userType == 2) {
        self.accountType_label.text = @"老师";
        self.accountType_label.textColor = [UIColor blackColor];
        /*提示老师注册后台*/
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"老师，您好！" message:@"请注册家校后台更好管理班级和学生！\n请联系一米智联: 400-670-3306" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alter show];
        [alter release];
        _isStudent = NO;
        
    }else if (_userType == 1){
        self.accountType_label.textColor = [UIColor blackColor];
        self.accountType_label.text = @"学生";
        _isStudent = YES;
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.userType = 2;
    }
    else if (buttonIndex == 1)
    {
        self.userType = 1;
    }
}

#pragma mark - QCheckBoxDelegate
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    if (checked) {
        self.setPassword_textfield.secureTextEntry = NO;
        self.repeatPassword_textfield.secureTextEntry = NO;
    }
    else
    {
        self.setPassword_textfield.secureTextEntry = YES;
        self.repeatPassword_textfield.secureTextEntry = YES;
        
    }
}
@end
