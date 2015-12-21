//
//  FindPasswordVC.m
//  omim
//
//  Created by wow on 14-3-28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "FindPasswordVC.h"
#import "WTHeader.h"
#import "Constants.h"

#import "ResetPwdVC.h"



@implementation FindPasswordVC

@synthesize imgBG;
@synthesize imgUIDBG;
@synthesize imgMailBG;
@synthesize txtMailOrPhone;
@synthesize txtUID;
@synthesize btnBack;
@synthesize btnFindPassword;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [imgUIDBG setImage:[[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [imgMailBG setImage:[[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];

    [btnBack setBackgroundImage:[[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [btnFindPassword setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];

    
    [txtUID setPlaceholder:NSLocalizedString(@"Please input ID", nil)];
    [txtMailOrPhone setPlaceholder:NSLocalizedString(@"Please input email or phone number", nil)];
    [btnBack setTitle:NSLocalizedString(@"Return", nil) forState:UIControlStateNormal];
    [btnFindPassword setTitle:NSLocalizedString(@"Find Password", nil) forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(fResignFirstResponder:)];
    [tapRecognizer setDelegate:self];
    imgBG.userInteractionEnabled = YES;
    [imgBG addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];

 
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [txtUID becomeFirstResponder];
    
    
}


- (IBAction)fBack:(id)sender
{
    [self fResignFirstResponder:nil];
    [self.view removeFromSuperview];
}

- (IBAction)fFindPassword:(id)sender
{
    [self fResignFirstResponder:nil];

    if (self.txtUID.text == nil || [self.txtUID.text isEqualToString:@""]) {
        // 提示要输入
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message: NSLocalizedString(@"ID can't be empty",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    } else if( self.txtMailOrPhone.text == nil || [self.txtMailOrPhone.text isEqualToString:@""] ){

        // 提示要输入
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Email or Number can't be empty",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    } else{
        [WowTalkWebServerIF sendAccessCodeForUid:self.txtUID.text toDes:self.txtMailOrPhone.text withCallback:@selector(fFindPasswordFinish:) withObserver:self];
        
    }
    
   
}

- (void)fFindPasswordFinish:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    if ([dict objectForKey:WT_ERROR] && [[dict objectForKey:WT_ERROR] code] != NO_ERROR)
    {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Find password failed",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access code already sent",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [self fResignFirstResponder:nil];
        
        ResetPwdVC *resetPwdVC = [[ResetPwdVC alloc] initWithNibName:@"ResetPwdVC" bundle:nil];
        resetPwdVC.wowtalkid = self.txtUID.text;
        NSLog(@"%@",resetPwdVC.wowtalkid);
        [[NSUserDefaults standardUserDefaults] setObject:self.txtUID.text forKey:@"resetPassword_wowtalkid"];
        [self.view addSubview:resetPwdVC.view];
    }
}

- (IBAction)fResignFirstResponder:(id)sender
{
    [self.txtUID resignFirstResponder];
    [self.txtMailOrPhone resignFirstResponder];
}

- (void)dealloc
{
    [txtMailOrPhone release];
    [txtUID release];
    [super dealloc];
}

@end
