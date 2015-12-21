//
//  PrivacyViewController.m
//  omim
//
//  Created by elvis on 2013/05/29.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "PrivacyViewController.h"
#import "WTHeader.h"
#import "Constants.h"
#import "PublicFunctions.h"

@interface PrivacyViewController ()

@end

#define TAG_ALLOW_ADD                   1
#define TAG_NEED_VERIFICATION           2
#define TAG_LIST_IN_NEARBY              3


@implementation PrivacyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];
    
    [self.tb_privacy setBackgroundView:nil];
    [self.tb_privacy setScrollEnabled:NO];
    [self.tb_privacy setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    
    [WowTalkWebServerIF getPrivacySettingWithCallback:@selector(didGetPrivacy:) withObserver:self];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
           self.tb_privacy.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tb_privacy.bounds.size.width, 15.0f)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNav
{
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(goBack)];
       [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  NSLocalizedString(@"Privacy",nil);
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
}

#pragma mark -- callback
-(void)didGetPrivacy:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.tb_privacy reloadData];
    }
}

-(void)didUpdatePrivacy:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.tb_privacy reloadData];
    }
}

-(void)toggleSwitch:(id)sender
{
    UISwitch* swither = (UISwitch*)sender;
    switch (swither.tag) {
        case TAG_ALLOW_ADD:
            
            if ([WTUserDefaults getAllowPeopleAddMe] == 0) {
                [WTUserDefaults setAllowPeopleAddMe:1];
                [WowTalkWebServerIF setPrivacy_peopleCanAddMe:1 unknowPeopleCanCallMe:-1 unknowPeopleCanMessageMe:-1 shouldShowMsgDetailInPush:-1 ListMeNearBy:-1 withCallback:@selector(didUpdatePrivacy:) withObserver:self];
            }
            else if ([WTUserDefaults getAllowPeopleAddMe] > 0){
                  [WTUserDefaults setAllowPeopleAddMe:0];
                [WowTalkWebServerIF setPrivacy_peopleCanAddMe:0 unknowPeopleCanCallMe:-1 unknowPeopleCanMessageMe:-1 shouldShowMsgDetailInPush:-1 ListMeNearBy:-1 withCallback:@selector(didUpdatePrivacy:) withObserver:self];
            }
            
            break;
        case TAG_NEED_VERIFICATION:
            if ([WTUserDefaults getAllowPeopleAddMe] == 1){
                 [WTUserDefaults setAllowPeopleAddMe:2];
                [WowTalkWebServerIF setPrivacy_peopleCanAddMe:2 unknowPeopleCanCallMe:-1 unknowPeopleCanMessageMe:-1 shouldShowMsgDetailInPush:-1 ListMeNearBy:-1 withCallback:@selector(didUpdatePrivacy:) withObserver:self];
            }
            else{
                  [WTUserDefaults setAllowPeopleAddMe:1];
                 [WowTalkWebServerIF setPrivacy_peopleCanAddMe:1 unknowPeopleCanCallMe:-1 unknowPeopleCanMessageMe:-1 shouldShowMsgDetailInPush:-1 ListMeNearBy:-1 withCallback:@selector(didUpdatePrivacy:) withObserver:self];
            }
            
            
            break;
        case TAG_LIST_IN_NEARBY:
            
            if ([WTUserDefaults getListMeInNearbyResult]){
                [WTUserDefaults setListMeInNearbyResult:FALSE];
                [WowTalkWebServerIF setPrivacy_peopleCanAddMe:-1 unknowPeopleCanCallMe:-1 unknowPeopleCanMessageMe:-1 shouldShowMsgDetailInPush:-1 ListMeNearBy:0 withCallback:@selector(didUpdatePrivacy:) withObserver:self];
            }
            else{
                   [WTUserDefaults setListMeInNearbyResult:TRUE];
                [WowTalkWebServerIF setPrivacy_peopleCanAddMe:-1 unknowPeopleCanCallMe:-1 unknowPeopleCanMessageMe:-1 shouldShowMsgDetailInPush:-1 ListMeNearBy:1 withCallback:@selector(didUpdatePrivacy:) withObserver:self];
            }
            
            
            break;
        default:
            break;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PrivacyCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PrivacyCell"] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    for (UIView* subview in [cell.contentView subviews]) {
        if ([subview isKindOfClass:[UISwitch class]]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    CGFloat offsetx = 220;
    if (IS_IOS7) {
        offsetx = 250;
    }
    
    UISwitch* switcher = [[[UISwitch alloc] initWithFrame:CGRectMake(offsetx, 7, 50, 30)] autorelease];
    
    [switcher addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:switcher];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            switcher.tag = TAG_ALLOW_ADD;
            
            cell.textLabel.text = NSLocalizedString(@"Others can add me", nil);
            if ([WTUserDefaults getAllowPeopleAddMe] == 0) {
                [switcher setOn:FALSE animated:NO];
            }
            else
                [switcher setOn:TRUE animated:NO];
        }
        else if (indexPath.row == 1){
            switcher.tag = TAG_NEED_VERIFICATION;
            if ([WTUserDefaults getAllowPeopleAddMe] == 1) {
                [switcher setOn:TRUE animated:NO];
            }
            else if ([WTUserDefaults getAllowPeopleAddMe] == 2){
                [switcher setOn:FALSE animated:NO];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Authetication is needed", nil);
        }
    }
    
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            switcher.tag = TAG_LIST_IN_NEARBY;
            if ([WTUserDefaults getListMeInNearbyResult]) {
                [switcher setOn:TRUE animated:NO];
            }
            else
                [switcher setOn:FALSE animated:NO];
            
            cell.textLabel.text = NSLocalizedString(@"users nearby can find me", nil);
        }
    }
    
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([WTUserDefaults getAllowPeopleAddMe] == 0) {
            return 1;
        }
        else
            return 2;
    }
    
    else if (section == 1){
        return 1;
    }
    else return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


@end
