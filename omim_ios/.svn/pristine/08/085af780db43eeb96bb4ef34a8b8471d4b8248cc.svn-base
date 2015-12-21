//
//  LoginEmailViewController.m
//  dev01
//
//  Created by macbook air on 14-9-25.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "LoginEmailViewController.h"
#import "Constants.h"
#import "FindPasswordViewController.h"
#import "LoginFromQRViewController.h"
#import "WTHeader.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "EmailFindPasswordVC.h"


@interface LoginEmailViewController ()<UIAlertViewDelegate>
{
    CGPoint _center;
    CGRect _upViewRect;
    CGFloat _distance;
    CLLocationManager *_myLocationManager;
    MBProgressHUD * _hud;
}

@end

@implementation LoginEmailViewController

- (void)dealloc {
    
    [_inputView release];
    [_tfEmail release];
    [_tfPassword release];
    [_lblOr release];
    [_btnForgetpassword release];
    [_btnEnter release];
    [_upView release];
    [_btnBack release];
    [_lblLogo release];
//    [_myLocationManager release];
    [_btn_register release];
    
    [_hud release],_hud = nil;
    [super dealloc];
}




#pragma mark - View Handler
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    _tfPassword.secureTextEntry = YES;
    
    _upView.userInteractionEnabled = YES;
    [_upView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fResignFirstResponder:)]];
    _center = _upView.center;
    _upViewRect = _upView.frame;
    
    [_btnEnter setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]forState:UIControlStateNormal];

    [_btn_register setBackgroundImage:[[UIImage imageNamed:@"btn_blue"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
    _lblLogo.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    [_btnEnter setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [_btnForgetpassword setTitle:NSLocalizedString(@"Forget pwd?", nil) forState:UIControlStateNormal];
    [_btn_register setTitle:NSLocalizedString(@"使用账号注册", nil) forState:UIControlStateNormal];
    _lblOr.text = NSLocalizedString(@"或者", nil);
    _tfEmail.placeholder = NSLocalizedString(@"Please enter your ID", nil);
    _tfPassword.placeholder = NSLocalizedString(@"Please enter the password", nil);
    
    _btnBack.hidden = YES;
    
    
    CGSize  _btnForgetpasswordSize =[NSLocalizedString(@"Forget pawd?", nil) boundingRectWithSize:CGSizeMake(300,16) options:NSStringDrawingUsesLineFragmentOrigin  attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName,nil] context:nil].size;
    
    _btnForgetpassword.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 25 - _btnForgetpasswordSize.width, _btnForgetpassword.frame.origin.y, _btnForgetpasswordSize.width, _btnForgetpassword.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:WT_LOGIN_WITH_USER object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WT_LOGIN_WITH_USER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DidLogin

- (void)didLogin:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
    }
    [_hud removeFromSuperview];
}




#pragma mark - Functions
- (IBAction)forgetpasswordClick:(id)sender {
//    FindPasswordViewController *findPasswordViewController = [[FindPasswordViewController alloc]initWithNibName:@"FindPasswordViewController" bundle:nil];
////    [self presentViewController:findPasswordViewController animated:YES completion:nil];
//    [self.navigationController pushViewController:findPasswordViewController animated:YES];
//    [findPasswordViewController release];
    
    EmailFindPasswordVC *emailVC = [[EmailFindPasswordVC alloc] init];
    [self.navigationController pushViewController:emailVC animated:YES];
    [emailVC release];
}



- (IBAction)enterClick:(id)sender {
    [self fResignFirstResponder:nil];
    
    BOOL rlt=YES;
    NSString *errMsg = @"";
    
    if (_tfEmail.text == nil || _tfEmail.text.length == 0){
        rlt = NO;
        errMsg = NSLocalizedString(@"Username can't be empty", nil);
    }
    else if (_tfPassword == nil || _tfPassword.text.length == 0){
        rlt = NO;
        errMsg = NSLocalizedString(@"Password can't be empty", nil);
    }
    
    
    if(rlt==NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login",nil) message:errMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    [self launchLoginWithLatitude:0 longtitude:0];
    
    [_hud release],_hud = nil;
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.alpha = 0.85;
    _hud.color = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.85];
    _hud.labelFont = [UIFont systemFontOfSize:12.0];
    _hud.labelColor = [UIColor blackColor];
    _hud.labelText = NSLocalizedString(@"正在登录",nil);
    _hud.mode = MBProgressHUDModeIndeterminate;

}


-(BOOL) isValidatePassWord:(NSString *)passWord
{
    NSString *passWordRegex = @"^[-_a-zA-Z0-9]+$";
    NSPredicate *passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordTest evaluateWithObject:passWord];
}


- (IBAction)backClick:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)reisterAction:(id)sender {
    [self fResignFirstResponder:nil];
    RegisterViewController* registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
    [registerVC release];
}

- (void)fResignFirstResponder:(id)sender{
    [_tfEmail resignFirstResponder];
    [_tfPassword resignFirstResponder];
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


#pragma mark ----CLLocationManager



-(void)launchLoginWithLatitude:(CLLocationDegrees)lati longtitude:(CLLocationDegrees)longtitude
{
    [WowTalkWebServerIF loginWithUserinfo:_tfEmail.text password:_tfPassword.text withLatitude:lati withLongti:longtitude withCallback:@selector(fLoginFinished:) withObserver:self];
}


#pragma mark Keyboard

- (void) keyboardWillShow:(NSNotification *)note{
    float y = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat distance = _upViewRect.origin.y + _upViewRect.size.height - y;
    if (distance > 0 && (_upView.center.y == _center.y)){
        [UIView animateWithDuration:0.24 animations:^{
            _upView.center = CGPointMake(_center.x, _center.y - distance);
        }];
    }else if (distance > _distance){
        [UIView animateWithDuration:0.24 animations:^{
            _upView.center = CGPointMake(_center.x, _center.y - distance);
        }];
    }
    _distance = distance;
}

-(void) keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.24 animations:^{
        _upView.center = _center;
    }];
}




#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_hud removeFromSuperview];
}




@end
