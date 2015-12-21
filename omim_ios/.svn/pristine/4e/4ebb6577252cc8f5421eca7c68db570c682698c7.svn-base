//
//  AddClassVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "AddClassVC.h"
#import "NSString+Compare.h"
#import "PublicFunctions.h"

#import "OMNetWork_MyClass.h"

#import "WTUserDefaults.h"

#import "OMAlertViewForNet.h"

@interface AddClassVC ()<UITextFieldDelegate,OMAlertViewForNetDelegate>
@property (retain, nonatomic) IBOutlet UILabel *title_label;
@property (retain, nonatomic) IBOutlet UITextField *input_textField;

@property (retain, nonatomic) IBOutlet UIButton *enter_button;

@property (retain, nonatomic) OMAlertViewForNet *alertViewForNet;
@end

@implementation AddClassVC


- (void)dealloc {
    [_alertViewForNet release];
    [_title_label release];
    [_input_textField release];
    [_enter_button release];
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}

- (void)uiConfig{
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
    
    [self configNavigation];
    
    self.enter_button.enabled = NO;
    [self.enter_button setBackgroundImage:[[UIImage imageNamed:@"btn_blue"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]forState:UIControlStateNormal];
    
    [self.input_textField addTarget:self action:@selector(enter_buttonChangeEnable:) forControlEvents:UIControlEventEditingChanged];
}


- (void)configNavigation{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"添加班级", nil);
    titleLabel.font = [UIFont fontWithName:@"Hiragino Sans GB W3" size:17];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)enterAction {
    if ( [NSString isEmptyString:self.input_textField.text] ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Invitation code can't be empty", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    [OMNetWork_MyClass bindInvitationCode:self.input_textField.text withCallback:@selector(didBindInvitationCode:) withObserver:self];
    OMAlertViewForNet *alertView = [OMAlertViewForNet OMAlertViewForNet];
    alertView.title = @"正在绑定邀请码";
    [alertView showInView:self.view];
    alertView.delegate = self;
    self.alertViewForNet = alertView;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - NetWork CallBack

#define TAG_BIND_CLASS_SUCCESS 100
- (void)didBindInvitationCode:(NSNotification *)notif{
    //98 不存在  97  已经绑定  96  已经过期  95 已经绑定此学校  94 学生帐号老师帐号不匹配
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    NSString* msg = @"";
    if (error.code == NO_ERROR) {
        self.alertViewForNet.title = @"邀请码绑定成功";
        self.alertViewForNet.type = OMAlertViewForNetStatus_Done;
        if ([self.delegate respondsToSelector:@selector(didAddClass:)]){
            [self.delegate didAddClass:self];
        }
    }else{
        if (error.code == -98){
            msg = NSLocalizedString(@"该邀请码不存在", nil);
        }
        else if (error.code == -97){
            msg = NSLocalizedString(@"Someone already bind this!", nil);
            
        }else if (error.code == -96){
            msg = NSLocalizedString(@"邀请码已过期!", nil);
        }else if (error.code == -95){
            msg = NSLocalizedString(@"已绑定该学校!", nil);
        }else if (error.code == -94){
            if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {// 0表示官方，1表示学生，2是老师
                msg = NSLocalizedString(@"老师账号不能绑定学生类邀请码", nil);
            }
            else
            {
                msg = NSLocalizedString(@"学生帐号不能绑定老师类邀请码", nil);
            }
        }
        else{
            msg = NSLocalizedString(@"网络请求超时，请检查网络连接", nil);
        }
        self.alertViewForNet.title = msg;
        self.alertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    
    
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
//    if (error.code == NO_ERROR) alert.tag = TAG_BIND_CLASS_SUCCESS;
//    [alert show];
//    [alert release];
    return;
    
}



- (void)enter_buttonChangeEnable:(UITextField *)textField{
    if ([NSString isEmptyString:textField.text]){
        self.enter_button.enabled = NO;
    }else{
        self.enter_button.enabled = YES;
    }
}

#pragma mark - OMAlertViewForNetDelegate
- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
