//
//  LoginCodeVC.m
//  dev01
//
//  Created by macbook air on 14-9-24.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "LoginCodeVC.h"
#import "RegisterViewController.h"
#import "LoginEmailViewController.h"
#import "FindPasswordViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "WowTalkWebServerIF.h"
#import "NSString+Compare.h"
#import "WTError.h"
@interface LoginCodeVC ()
{
    CGPoint _center;
    CGRect _upViewRect;
    CGFloat _distance;
}

@end

@implementation LoginCodeVC




#pragma mark - View Handler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    _labLogo.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    _upBgView.userInteractionEnabled = YES;
    [_upBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fResignFirstResponder:)]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fResignFirstResponder:)]];
    _center = _upBgView.center;
    _upViewRect = _upBgView.frame;
    
    
    [_btnEnter setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    

    [_btnElseLogin setBackgroundImage:[[UIImage imageNamed:@"btn_blue.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    

    [_btnRegister setBackgroundImage:[[UIImage imageNamed:@"btn_blue.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    

    [_btnEnter setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];

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

- (void)dealloc {
    [_inputView release];
    [_tfCode release];
    [_btnEnter release];
    [_btnElseLogin release];
    [_btnRegister release];
    [_lblOr release];
    [_upBgView release];
    [_downBgView release];
    [_labLogo release];
    [super dealloc];
}



#pragma mark - Functions

- (void)fResignFirstResponder:(id)sender{
    [_tfCode resignFirstResponder];
}




#pragma - mark Keyboard

- (void) keyboardWillShow:(NSNotification *)note{
    float y = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat distance = _upViewRect.origin.y + _upViewRect.size.height - y;
    if (distance > 0 && (_upBgView.center.y == _center.y)){
        [UIView animateWithDuration:0.24 animations:^{
            _upBgView.center = CGPointMake(_center.x, _center.y - distance);
        }];
    }else if (distance > _distance){
        [UIView animateWithDuration:0.24 animations:^{
            _upBgView.center = CGPointMake(_center.x, _center.y - distance);
        }];
    }
    _distance = distance;
}

-(void) keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.24 animations:^{
        _upBgView.center = _center;
    }];
}




#pragma mark - ui action

-(void)didLogin:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    if ([dict objectForKey:WT_ERROR] && [[dict objectForKey:WT_ERROR] code] == 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Someone already bind this!", nil) message:NSLocalizedString(@"Authetication failed",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    else if ([dict objectForKey:WT_ERROR] && [[dict objectForKey:WT_ERROR] code] != NO_ERROR){
        
        if ([[dict objectForKey:WT_ERROR] code] == -96) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login",nil) message:NSLocalizedString(@"邀请码已过期。请联系您的管理员。",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login",nil) message:NSLocalizedString(@"Authetication failed",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            

        }
        
      
    }
    else
    {
        [[AppDelegate sharedAppDelegate] setupApplicaiton:YES];
    }
}

- (IBAction)loginClick:(id)sender {
    if ( [NSString isEmptyString:_tfCode.text] ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Invitation code can't be empty", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    [WowTalkWebServerIF loginWithInvitaionCode:_tfCode.text withCallback:@selector(didLogin:) withObserver:self];

    
}

- (IBAction)elseLoginClick:(id)sender {
    LoginEmailViewController *loginEmailVC = [[LoginEmailViewController alloc]initWithNibName:@"LoginEmailViewController" bundle:nil];
    [self.navigationController pushViewController:loginEmailVC animated:YES];
    [loginEmailVC release];
}

- (IBAction)registerClick:(id)sender {
    [self fResignFirstResponder:nil];
    RegisterViewController* registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
    [registerVC release];
}
@end
