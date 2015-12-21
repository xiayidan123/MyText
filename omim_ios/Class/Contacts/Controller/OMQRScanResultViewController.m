//
//  OMQRScanResultViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/24.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMQRScanResultViewController.h"
#import "OMHeadImgeView.h"
#import "Constants.h"
#import "WowTalkWebServerIF.h"

@interface OMQRScanResultViewController ()<UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet OMHeadImgeView *head_view;

@property (retain, nonatomic) IBOutlet UILabel *name_label;

@property (retain, nonatomic) IBOutlet UIButton *add_button;

@end

@implementation OMQRScanResultViewController

- (void)dealloc {
    self.buddy = nil;
    [_head_view release];
    [_name_label release];
    [_add_button release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self uiConfig];
}

-(void)uiConfig{
    self.title = NSLocalizedString(@"Add contacts", nil);
    
    [self.add_button setBackgroundImage:[[UIImage imageNamed:LARGE_BLUE_BUTTON] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
    self.add_button.enabled = YES;
    
    [self.add_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.add_button.titleLabel setFont:[UIFont systemFontOfSize:20]];
    
    self.head_view.buddy = self.buddy;
    self.name_label.text = self.buddy.nickName;
    switch (self.buddy.relationship_type) {
        case Buddy_Relationship_type_ADDED:{
            [self.add_button setTitle:@"已是好友" forState:UIControlStateNormal];
            self.add_button.enabled = NO;
        }break;
        case Buddy_Relationship_type_ISSELF:{
            [self.add_button setTitle:NSLocalizedString(@"Is Self",nil) forState:UIControlStateNormal];
            self.add_button.enabled = NO;
        }break;
        default:
            [self.add_button setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
            self.add_button.enabled = YES;
            
            break;
    }
}



- (IBAction)addAction:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add this user as a friend",nil) message:NSLocalizedString(@"self introduction",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"发送",nil), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert release];
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:{
            if (self.buddy){
                UITextField *tf = [alertView textFieldAtIndex:0];
                [WowTalkWebServerIF addBuddy:_buddy.userID withMsg:tf.text withCallback:@selector(didAddBuddy:) withObserver:self];
                self.omAlertViewForNet.title = NSLocalizedString(@"正在发送请求...", nil);
                self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
                [self.omAlertViewForNet showInView:self.view];
                self.add_button.enabled = NO;
            }
        }break;
        default:
            break;
    }
}

#pragma mark - Network

- (void)didAddBuddy:(NSNotification *)notification
{
    NSError *error = [[notification userInfo] objectForKey:@"error"];
    if (error && error.code != 0) {
        self.omAlertViewForNet.title = NSLocalizedString(@"Failed to send request", nil);
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.add_button.enabled = YES;
    } else {
        self.omAlertViewForNet.title = NSLocalizedString(@"Request is sent", nil);
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        self.add_button.enabled = NO;
    }
}



#pragma mark - OMAlertViewForNetDelegate
- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    if (alertViewForNet.type == OMAlertViewForNetStatus_Done){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



#pragma mark - Set and Get

-(void)setBuddy:(Buddy *)buddy{
    [_buddy release],_buddy = nil;
    _buddy = [buddy retain];
    
    self.head_view.buddy = _buddy;
    self.name_label.text = _buddy.nickName;
}



@end
