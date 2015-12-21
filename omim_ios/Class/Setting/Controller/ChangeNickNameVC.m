//
//  ChangeNickNameVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ChangeNickNameVC.h"
#import "PublicFunctions.h"
#import "NSString+Compare.h"
#import "WowTalkWebServerIF.h"
#import "Constants.h"
#import "WTHeader.h"

#import "OMAlertViewForNet.h"

@interface ChangeNickNameVC ()<OMAlertViewForNetDelegate>

@property (retain, nonatomic) IBOutlet UITextField *nickName_textField;
@property (retain, nonatomic) IBOutlet UILabel *remind_label;

@property (retain, nonatomic) OMAlertViewForNet *alertViewForNet;

@end



@implementation ChangeNickNameVC

- (void)dealloc {
    [_alertViewForNet release];
    [_nickName_textField release];
    [_remind_label release];
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.nickName_textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
    
}
- (void)uiConfig{
    
    [self configNav];
    
    self.remind_label.text = @"";
    self.nickName_textField.text = [WTUserDefaults getNickname];
}


-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirm
{
    if ([NSString isEmptyString: self.nickName_textField.text]){
        
        self.remind_label.text = NSLocalizedString(@"Nickname is empty", nil);
        
        return;
    }
    
    
    OMAlertViewForNet *alertView = [OMAlertViewForNet OMAlertViewForNet];
    alertView.title = @"正在修改昵称";
    [alertView show];
    alertView.delegate = self;
    self.alertViewForNet = alertView;
    
    [WowTalkWebServerIF updateMyProfileWithNickName:self.nickName_textField.text withStatus:nil withBirthday:nil withSex:nil withArea:nil withCallback:@selector(nickChanged:) withObserver:self];
}

-(void)configNav
{
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"取消",nil) style:UIBarButtonItemStylePlain target:self action:@selector(goBack)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"保存",nil) style:UIBarButtonItemStylePlain target:self action:@selector(confirm)] autorelease];
    
    self.title = NSLocalizedString(@"昵称",nil);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - OMAlertViewForNetDelegate
-(void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    [self goBack];
}


- (void)nickChanged:(NSNotification *)notification
{
    
    NSError *err = [[notification userInfo] valueForKey:WT_ERROR];
    
    if (err.code== NO_ERROR) {
        self.alertViewForNet.title = @"昵称修改成功";
        self.alertViewForNet.type = OMAlertViewForNetStatus_Done;
        if ([self.delegate respondsToSelector:@selector(changeNickNameVC:didChangeNickName:)]){
            [self.delegate changeNickNameVC:self didChangeNickName:self.nickName_textField.text];
        }
    }
    else{
#warning 修改失败用OMAlertViewForNet空间 需要添加失败的type
        self.alertViewForNet.tintAdjustmentMode = @"昵称修改失败";
        self.alertViewForNet.type = OMAlertViewForNetStatus_Failure;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to change nickname",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}


@end
