//
//  AddBuddyFromSchoolVC.m
//  dev01
//
//  Created by 杨彬 on 14-12-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "AddBuddyFromSchoolVC.h"
#import "NSFileManager+extension.h"
#import "Database.h"
#import "WowTalkWebServerIF.h"
#import "Constants.h"
#import "WTHeader.h"
#import "PublicFunctions.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "Buddy.h"
#import "MessagesVC.h"
#import "CustomIOS7AlertView.h"
#import "OMMessageVC.h"
#import "SchoolMember.h"

@interface AddBuddyFromSchoolVC ()<UIAlertViewDelegate>
{
    BOOL _isSchoolMembers;
    UIView *IOS7ApplyAlertView;
    CGRect IOS7ApplyAlertViewFrameOriginal;
    BOOL isIOS7ApplyInfoDialogShown;
}



@end

@implementation AddBuddyFromSchoolVC

@synthesize buddy;

-(void)dealloc{
    [_person release],_person = nil;
    [_imageView_headimage release],_imageView_headimage = nil;
    [_lab_user_name release],_lab_user_name = nil;
    [_btn_addBuddy release],_btn_addBuddy = nil;
    [_btn_messege release],_btn_messege = nil;
    [_lab_status release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self configNavigationBar];
    
    [self loadHeadImage];
    
    [self loadSexImage];
    
    [self loadUserName];
    
    [self loadStatus];
    
    [self loadAddButton];
    if (_person) {
        [WowTalkWebServerIF getBuddyWithUID:_person.uid withCallback:@selector(didGetBuddyWithUID:) withObserver:self];
    }
    else{
//        [WowTalkWebServerIF getBuddyWithUID:self.buddy.userID withCallback:@selector(didGetBuddyWithUID:) withObserver:self];
    }
    
}


- (void)prepareData{
//    self.buddy = [Database buddyWithUserID:_person.uid];
    _isSchoolMembers = [Database isSchollMember:buddy.userID];
}

- (void)configNavigationBar
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"好友详情",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadHeadImage{
    BOOL alreadyExist = [self loadHeadImageFromLoacation];
    if (!alreadyExist){//并且本地的没有
        [WowTalkWebServerIF getSchoolMemberThumbnailWithUID:_person.uid withCallback:@selector(didGetSchoolMemberThumbnail:) withObserver:self];
    }
}

- (void)loadSexImage{
    _imageView_headimage.buddy = self.buddy;
}

- (void)didGetBuddyWithUID:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if (_person) {
            self.buddy = [Database buddyWithUserID:_person.uid];
        }
        else{
            self.buddy = [Database buddyWithUserID:self.buddy.userID];
        }
        
        [self loadHeadImage];
        
        [self loadSexImage];
        
        [self loadUserName];
        
        [self loadAddButton];

    }
}

- (void)didGetSchoolMemberThumbnail:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self loadHeadImageFromLoacation];
    }
}

- (BOOL)loadHeadImageFromLoacation{
    NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@",buddy.userID] WithSubFolder:@"avatarthumb"]];
    BOOL isDirectory;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    BOOL alreadyExist = NO;
    if (exist && !isDirectory){
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
        _imageView_headimage.headImage = image;
        [image release];
        alreadyExist = YES;
    }else{
        _imageView_headimage.headImage = [UIImage imageNamed:@"avatar_140.png"];
    }
    return alreadyExist;
}

- (void)loadUserName{
    
    if(self.buddy != nil && self.person == nil){
        self.lab_user_name.text = self.buddy.alias;
    }else if (self.buddy == nil && self.person != nil){
        self.lab_user_name.text = self.person.nickName;
    }else{
        self.lab_user_name.text = self.person.alias;
    }
    
}


- (void)loadStatus{
    _lab_status.text = buddy.status;
}


- (void)loadAddButton{
//    switch (_color) {
//        case 0:{
//            [_btn_addBuddy setBackgroundImage:nil forState:UIControlStateNormal];
//            _btn_addBuddy.backgroundColor = [UIColor colorWithRed:0.91 green:0.07 blue:0.15 alpha:1];
//            _btn_addBuddy.layer.cornerRadius = 5;
//            _btn_addBuddy.layer.masksToBounds = YES;
//            [_btn_messege setBackgroundImage:nil forState:UIControlStateNormal];
//            _btn_messege.backgroundColor = [UIColor colorWithRed:0.91 green:0.07 blue:0.15 alpha:1];
//            _btn_messege.layer.cornerRadius = 5;
//            _btn_messege.layer.masksToBounds = YES;
//        }break;
//        case 1:{
//            [_btn_addBuddy setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
//            [_btn_messege setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
//        }break;
//        case 2:{
//            [_btn_addBuddy setBackgroundImage:[[UIImage imageNamed:@"btn_blue.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
//            [_btn_messege setBackgroundImage:[[UIImage imageNamed:@"btn_blue.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
//        }break;default:break;
//    }
    
    
    [_btn_addBuddy setBackgroundImage:[[UIImage imageNamed:@"btn_blue.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [_btn_messege setBackgroundImage:[[UIImage imageNamed:@"btn_blue.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
    
    [_btn_addBuddy setTitle:NSLocalizedString(@"加为好友", nil) forState:UIControlStateNormal];
    
    
    [_btn_messege setTitle:NSLocalizedString(@"发消息", nil) forState:UIControlStateNormal];
    
    
    if ([[WTUserDefaults getUid] isEqualToString:_person.uid]){
        _btn_addBuddy.hidden = TRUE;
        _btn_messege.hidden = true;
    }
    else if ([Database schoolMemberAlreadyAddBuddy:_person.uid]){
        _btn_addBuddy.hidden = true;
    }
    
    if (self.buddy==nil) {
        _btn_addBuddy.enabled = false;
        _btn_messege.enabled = false;
    }
    else{
        _btn_addBuddy.enabled = true;
        _btn_messege.enabled = true;
    }
    
    
    if (!_isSchoolMembers && (_color == RED_COLOR_IN_ADDBUDDYFROMSCHOOLVC)){
        _btn_messege.hidden = YES;
        _btn_addBuddy.center = _btn_messege.center;
    }
}


- (IBAction)addBuddyAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add this user as a friend",nil) message:NSLocalizedString(@"self introduction",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"发送",nil), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 2011;
    [alert show];
    [alert release];
}



- (IBAction)sendMessegeAction:(id)sender {
    if (self.buddy){
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:self.buddy withFirstChat:NO];
        if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[OMMessageVC class]]){
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
    }
    
}

- (void)didAddFriend:(NSNotification *)notification
{
    NSDictionary *infodict = [notification userInfo];
    NSError *err = [infodict objectForKey:@"error"];
    if (err && err.code != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to send request", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Request is sent",nil) message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        __block UIAlertView *bAlert = alert;
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [bAlert dismissWithClickedButtonIndex:0 animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
        _btn_addBuddy.enabled = NO;
    }
}

#pragma mark - 
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2011){
        switch (buttonIndex) {
            case 1:{
                if (self.buddy){
                    UITextField *tf = [alertView textFieldAtIndex:0];
                    [WowTalkWebServerIF addBuddy:self.buddy.userID withMsg:tf.text withCallback:@selector(didAddFriend:) withObserver:self];
                }
            }break;
            default:
                break;
        }
    }
}


@end
