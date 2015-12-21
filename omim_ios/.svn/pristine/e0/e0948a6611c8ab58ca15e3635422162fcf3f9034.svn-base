//
//  RegisterViewController.m
//  dev01
//
//  Created by macbook air on 14-9-25.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "RegisterViewController.h"
#import "IdtypeView.h"
#import "AddCourseController.h"
#import "LoginEmailViewController.h"
#import "WTHeader.h"
#import "AppDelegate.h"
#import "OMAlertView.h"

#define TAG_ALERT_REGISTER_SUCCESS 100
#define TAG_ALERT_REGISTER_FAIL 101


@interface RegisterViewController ()
{
    CGPoint _center;
    CGRect _upViewRect;
    CGFloat _distance;
    IdtypeView *_idtypeView;
    BOOL _isStudent;
}

@property (nonatomic,retain)OMAlertView *omAlertView;

@end

@implementation RegisterViewController

- (void)dealloc {
    [_inputView release];
    [_tfEmail release];
    [_tfPassword release];
    [_tfConfirmpassword release];
    [_tfIdtype release];
    [_lalPrompt release];
    [_btnRegister release];
    [_upView release];
    [_lblLogo release];
    
    [_omAlertView release],_omAlertView = nil;
    [super dealloc];
}


#pragma mark - View Handler
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tfPassword.secureTextEntry = YES;
    _tfConfirmpassword.secureTextEntry = YES;
    
    _center = _inputView.center;
    _upViewRect = _inputView.frame;
    [_upView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fResignFirstResponder:)]];
    [self.view bringSubviewToFront:_upView];
    [self.view bringSubviewToFront:_btnBack];
    
    
    _tfIdtype.userInteractionEnabled = NO;
    
    [_btnRegister setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
    _isStudent = YES;
    _idtypeView = [[IdtypeView alloc]initWithFrame:CGRectMake(0, 0, 200, 22)];
    _idtypeView.center = CGPointMake(200, 150.5);
    [_idtypeView.teacherView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkType:)]];
    [_idtypeView.studentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkType:)]];
    [_idtypeView.lalTeacher addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkType:)]];
    [_idtypeView.lalStudent addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkType:)]];
    [_inputView addSubview:_idtypeView];
    [_idtypeView release];
    
     _lblLogo.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    _tfEmail.placeholder = NSLocalizedString(@"Please enter your ID", nil);
    _tfPassword.placeholder = NSLocalizedString(@"Please enter the password", nil);

    [_btnRegister setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];

    }

- (void)checkType:(UITapGestureRecognizer *)tap{
    if ((tap.view == _idtypeView.teacherView) || (tap.view == _idtypeView.lalTeacher)){
        _idtypeView.teacherView.image = [UIImage imageNamed:@"register_checked"];
        _idtypeView.studentView.image = [UIImage imageNamed:@"register_unchecked"];
        _isStudent = NO;
    }else if ((tap.view == _idtypeView.studentView) || (tap.view == _idtypeView.lalStudent)){
        _idtypeView.studentView.image = [UIImage imageNamed:@"register_checked"];
        _idtypeView.teacherView.image = [UIImage imageNamed:@"register_unchecked"];
        _isStudent = YES;
    }
    [self fResignFirstResponder:nil];
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
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}







#pragma mark - Functions
- (void)fResignFirstResponder:(id)sender{
    [_tfEmail resignFirstResponder];
    [_tfPassword resignFirstResponder];
    [_tfConfirmpassword resignFirstResponder];
}


- (IBAction)registerClick:(id)sender {

    // 账号不能为空,可以使用2-20个字母、数字、下划线和减号
    BOOL rlt=YES;
    NSString* errMsg=@"";
    
    if (_tfEmail.text == nil || _tfEmail.text.length == 0){
        rlt = NO;
        errMsg = NSLocalizedString(@ "账号不能为空,可以使用2-20个字母、数字、下划线和减号",nil);
    }
    else if (_tfEmail.text.length < 2){
        rlt = NO;
        errMsg = NSLocalizedString(@ "账号最少2位,可以使用2-20个字母、数字、下划线和减号",nil);
    }
    else if (_tfEmail.text.length > 20){
        rlt = NO;
        errMsg = NSLocalizedString(@ "账号最多20位,可以使用2-20个字母、数字、下划线和减号",nil);
    }else if (![self isValidatePassWord:_tfEmail.text]){
        rlt = NO;
        errMsg = NSLocalizedString(@"账号格式不正确，只能使用2-20个字母，数字，下划线和减号",nil);
    }
    else if (_tfPassword.text == nil || _tfPassword.text.length == 0){
        rlt = NO;
        errMsg = NSLocalizedString(@"密码不能为空,可以使用6-20个字母、数字、下划线和减号",nil);
    }
    else if (_tfPassword.text.length < 6){
        rlt = NO;
        errMsg = NSLocalizedString(@"密码最少6位,可以使用6-20个字母、数字、下划线和减号",nil);
    }
    else  if (_tfConfirmpassword.text == nil || ![_tfPassword.text isEqualToString:_tfConfirmpassword.text]){
        rlt = NO;
        errMsg = NSLocalizedString(@"Two passwords are different",nil);
    }else if (_tfPassword.text.length > 20){
        rlt = NO;
        errMsg = NSLocalizedString(@"密码最多20位,可以使用6-20个字母、数字、下划线和减号",nil);
    }else if (![self isValidatePassWord:_tfPassword.text]){
        rlt = NO;
        errMsg = NSLocalizedString(@"密码格式不正确，可以使用6-20个字母，数字，下划线和减号",nil);
    }
    
    if(rlt==NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to register",nil) message:errMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        alert.tag = TAG_ALERT_REGISTER_FAIL;
        [alert show];
        [alert release];
        return;
    }
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2.5,60)];
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge|UIActivityIndicatorViewStyleGray];
    activeView.tag = 5000;
    //    activeView.transform = CGAffineTransformMakeScale(1, 1);
    activeView.center = CGPointMake(customView.frame.size.width/4, customView.frame.size.height/2);
    [customView addSubview:activeView];
    [activeView release];
    [activeView startAnimating];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, customView.frame.size.width/2, customView.frame.size.height)];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.textColor = [UIColor grayColor];
    textLabel.text = NSLocalizedString(@"正在注册...",nil);
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.tag = 5001;
    textLabel.center = CGPointMake(activeView.frame.origin.x + activeView.frame.size.width + textLabel.frame.size.width/2, customView.frame.size.height/2);
    [customView addSubview:textLabel];
    [textLabel release];
    
    self.omAlertView = [[OMAlertView alloc]initWithCustomView:customView delegate:nil cancelButtonTitle:nil enterButtonTitle:nil TitleArray:nil];
    [_omAlertView show];
    [_omAlertView release];
    [customView release];

    [WowTalkWebServerIF registerWithUserid:_tfEmail.text password:_tfPassword.text withUserType:(_isStudent?@"1":@"2") withCallback:@selector(fRegisterFinished:) withObserver:self];
}


- (void)fRegisterFinished:(NSNotification *)notification
{
    if(notification==nil) return;
    
    UIView *customView = _omAlertView.custiomView;
    UILabel *textLabel = (UILabel *)[customView viewWithTag:5001];
    textLabel.text = NSLocalizedString(@"正在登录...",nil);
    
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
        [WowTalkWebServerIF loginWithUserinfo:_tfEmail.text password:_tfPassword.text withLatitude:0 withLongti:0 withCallback:@selector(fLoginFinished:) withObserver:self];
    }
    
}

- (void)fLoginFinished:(NSNotification *)notification
{
    [_omAlertView dismissWithClickedButtonIndex:0 animated:NO];
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


- (IBAction)backClick:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark------UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        if (alertView.tag==TAG_ALERT_REGISTER_SUCCESS) {
            LoginEmailViewController *loginEmailViewController = [[LoginEmailViewController alloc]init];
            [self.navigationController pushViewController:loginEmailViewController animated:YES];
        }
        else if (alertView.tag == TAG_ALERT_REGISTER_FAIL){
            return;
        }
    }
}



#pragma - mark Keyboard

- (void) keyboardWillShow:(NSNotification *)note{
    float y = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat distance = _upViewRect.origin.y + _upViewRect.size.height - y;
    if (distance > 0 && (_inputView.center.y == _center.y)){
        [UIView animateWithDuration:0.24 animations:^{
            _inputView.center = CGPointMake(_center.x, _center.y - distance);
        }];
    }else if (distance > _distance){
        [UIView animateWithDuration:0.24 animations:^{
            _inputView.center = CGPointMake(_center.x, _center.y - distance);
        }];
    }
    [self.view bringSubviewToFront:_btnBack];
    _distance = distance;
}

-(void) keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.24 animations:^{
        _inputView.center = _center;
    }];
}



-(BOOL) isValidatePassWord:(NSString *)passWord
{
    NSString *passWordRegex = @"^[-_a-zA-Z0-9]+$";
    NSPredicate *passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordTest evaluateWithObject:passWord];
}












@end
