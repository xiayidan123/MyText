//
//  ResetPwdVC.m
//  omim
//
//  Created by wow on 14-3-28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "ResetPwdVC.h"
#import "WTHeader.h"

#import "Constants.h"
#import "AppDelegate.h"

@interface ResetPwdVC ()

- (void)startTimer;

@end

@implementation ResetPwdVC

@synthesize imgBG;
@synthesize imgAuthCodeBG;
@synthesize imgCenterviewBG;
@synthesize txtPasswordAgain;
@synthesize txtPassword;
@synthesize txtAuthcode;
@synthesize btnConfirm;
@synthesize btnBack;
@synthesize wowtalkid;



- (void)viewDidLoad
{
    [super viewDidLoad];

    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(fResignFirstResponder:)];
    [tapRecognizer setDelegate:self];
    imgBG.userInteractionEnabled = YES;
    [imgBG addGestureRecognizer:tapRecognizer];
    
    
    
    [self.imgCenterviewBG setImage:[[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [self.imgAuthCodeBG setImage:[[UIImage imageNamed:@"login_input_pre.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [btnBack setBackgroundImage:[[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
    [txtAuthcode setPlaceholder:NSLocalizedString(@"Please enter received code", nil)];
    [txtPassword setPlaceholder:NSLocalizedString(@"Please enter new password", nil)];
    [txtPasswordAgain setPlaceholder:NSLocalizedString(@"Please enter new password again", nil)];

   
    


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [txtAuthcode becomeFirstResponder];
    [self startTimer];
    
}



- (IBAction)fBack:(id)sender
{
    [self.view removeFromSuperview];
}

- (IBAction)fConfirm:(id)sender
{
    if (self.txtAuthcode.text == nil || self.txtAuthcode.text.length == 0 || self.txtPassword.text == nil || self.txtPassword.text.length == 0 || self.txtPasswordAgain.text == nil || self.txtPasswordAgain.text.length == 0 || ![self.txtPassword.text isEqualToString:self.txtPasswordAgain.text])
        return;
    
    self.wowtalkid = [[NSUserDefaults standardUserDefaults] objectForKey:@"resetPassword_wowtalkid"];
    
    NSLog(@"resetPwdVC:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"resetPassword_wowtalkid"]);
 
    [WowTalkWebServerIF resetPasswordForID:self.wowtalkid pwd:self.txtPassword.text accessCode:self.txtAuthcode.text withCallback:@selector(pwdReset:) withObserver:self];
}

- (void)pwdReset:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    if ([dict objectForKey:WT_ERROR] && [[dict objectForKey:WT_ERROR] code] != NO_ERROR)
    {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reset password failed",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reset password success",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        [[AppDelegate sharedAppDelegate] initWelcomeVC];
    }
}

- (void)startTimer
{
    checkTime = 60;

    [self.btnBack setTitle:[NSString stringWithFormat:NSLocalizedString(@"Return(%dsec)",nil),checkTime] forState:UIControlStateNormal];
    if (timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)onTimer
{
    [self.btnBack setTitle:[NSString stringWithFormat:NSLocalizedString(@"Return(%dsec)",nil),--checkTime] forState:UIControlStateNormal];
    if (checkTime == 0) {
        [self.btnConfirm setEnabled:NO];
        [timer invalidate];
        timer = nil;
    }
}

- (IBAction)fResignFirstResponder:(id)sender
{
    [self.txtPassword resignFirstResponder];
    [self.txtPasswordAgain resignFirstResponder];
    [self.txtAuthcode resignFirstResponder];
}

- (void)dealloc
{
    [imgCenterviewBG release];
    [txtPassword release];
    [txtPasswordAgain release];
    [txtAuthcode release];
    [btnBack release];
    [btnConfirm release];
    [wowtalkid release];
    [super dealloc];
}

@end
