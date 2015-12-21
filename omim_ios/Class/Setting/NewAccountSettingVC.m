//
//  NewAccountSettingVC.m
//  dev01
//
//  Created by Huan on 15/3/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NewAccountSettingVC.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "VerificationCodeVC.h"
#import "MBProgressHUD.h"
#import "leftBarBtn.h"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._@"

@interface NewAccountSettingVC ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation NewAccountSettingVC

- (void)dealloc {
    [_blidingTips release];
    [_blidingEmailTX release];
    [_EmailTips release];
    [_BlidingButton release];
    [HUD release];
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self configNav];
    [self uiConfig];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_blidingEmailTX becomeFirstResponder];
}
- (void)configNav;
{
    self.title = NSLocalizedString(@"绑定邮箱", nil);
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09f green:0.67f blue:0.94f alpha:1.00f];

}

- (void)uiConfig
{
    [_BlidingButton setBackgroundColor:[UIColor colorWithRed:0.00f green:0.67f blue:0.99f alpha:1.00f]];
    [_BlidingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_BlidingButton.layer setMasksToBounds:YES];
    [_BlidingButton.layer setCornerRadius:5.0];
    _BlidingButton.enabled = NO;
    _EmailTips.text = @"";
    
    
    
    UILabel *blankLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 44)];
    _blidingEmailTX.leftView = blankLab;
    [_BlidingButton setTitleColor:[UIColor colorWithRed:0.40f green:0.78f blue:0.96f alpha:1.00f] forState:UIControlStateNormal];
    _blidingEmailTX.leftViewMode = UITextFieldViewModeAlways;
    _blidingEmailTX.delegate = self;
    _blidingEmailTX.placeholder = @"邮箱";
    [_blidingEmailTX addTarget:self action:@selector(ChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [blankLab release];
}
- (void)ChangeAction:(UITextField *)sender
{
    if (sender.text.length) {
        _BlidingButton.enabled = YES;
        [_BlidingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        _BlidingButton.enabled = NO;
        [_BlidingButton setTitleColor:[UIColor colorWithRed:0.40f green:0.78f blue:0.96f alpha:1.00f] forState:UIControlStateNormal];
    }
}
- (void)Notice:(NSNotification *)notif
{
//    [HUD removeFromSuperview];
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == WT_FORMAT_ERROR) {
        _EmailTips.text = @"邮箱格式不正确";
    }
    else if (error.code == WT_EMAIL_DID_BIND)
    {
        _EmailTips.text = @"该邮箱已被绑定，请使用其他邮箱";
    }
    else if (error.code == WT_USER_DID_BIND)
    {
        _EmailTips.text = @"您已绑定邮箱";
    }
    else if (error.code == NO_ERROR)
    {
        
//        _EmailTips.text = @"验证码已发送邮箱";
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
//        dispatch_after(time, dispatch_get_main_queue(), ^{
            VerificationCodeVC *verVC = [[VerificationCodeVC alloc] init];
            verVC.emailContent = _blidingEmailTX.text;
            [self.navigationController pushViewController:verVC animated:YES];
//        });
    }
}
# pragma mark UITextfield
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSCharacterSet *cs;
//    
//    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
//    
//    NSString *filtered =[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//     
//     BOOL basic = [string isEqualToString:filtered];
//     
//     return basic;
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_blidingEmailTX resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘,取消第一响应者
    [_blidingEmailTX resignFirstResponder];
    return YES;
    
}

- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (void)cancelAction
{
    NSInteger count = [self.navigationController.viewControllers count];
    if (count > 2 ) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count - 2] animated:YES];
    }
    else if (count > 4)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count - 3] animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)BlindingEmail:(id)sender {
    [_blidingEmailTX resignFirstResponder];
    [WowTalkWebServerIF BlidingEmail:_blidingEmailTX.text WithCallback:@selector(Notice:) withObserver:self];
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    HUD.delegate = self;
//    HUD.color = [UIColor lightGrayColor];
//    HUD.labelText = @"正在发送邮件";
//    [HUD hide:YES afterDelay:1.0];
    
}
@end
