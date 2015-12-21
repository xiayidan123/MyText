//
//  OfficialAccountViewController.m
//  omim
//
//  Created by coca on 2013/04/17.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "OfficialAccountViewController.h"

#import "WTHeader.h"

#import "PublicFunctions.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "MessagesVC.h"
#import "OMBuddySpaceViewController.h"
#import "WarningView.h"


@interface OfficialAccountViewController ()<UIAlertViewDelegate>
@property (nonatomic,retain) UIImageView* imageview;

@property (nonatomic,retain) UIButton* btn_follow;
@property (nonatomic,retain) UIButton* btn_chat;
@property (nonatomic,retain) UIButton* btn_unfollow;
@property (nonatomic,retain) UIButton* btn_history;

@property (nonatomic, retain) UIBarButtonItem *rightBarButton;

@end

@implementation OfficialAccountViewController
#define TAG_SWITCHER    1
#define TAG_LABEL   2

@synthesize rightBarButton = _rightBarButton;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IntroCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* deslabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 220, 10)];
            deslabel.tag = TAG_LABEL;
            deslabel.font = [UIFont systemFontOfSize:FONT_SIZE_17];
            deslabel.numberOfLines = 0;
            deslabel.textColor = [UIColor blackColor];
            deslabel.textAlignment = NSTextAlignmentRight;
            deslabel.adjustsFontSizeToFitWidth = NO;
            deslabel.lineBreakMode = NO;
            deslabel.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:deslabel];
            [deslabel release];
        }
        cell.detailTextLabel.text = @"";
        cell.textLabel.text = NSLocalizedString(@"Introduction", nil);
        
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:TAG_LABEL];
        
        int height = [UILabel labelHeight:self.account.status FontType:FONT_SIZE_17 withInMaxWidth:220] > 44? [UILabel labelHeight:self.account.status FontType:FONT_SIZE_17 withInMaxWidth:220]  : 44;
        [label setFrame:CGRectMake(70, 0, 220, height)];
        
        label.text = self.account.status;

       
        return cell;
    }
    else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SettingCell"] autorelease];
            UISwitch* switcher = [[[UISwitch alloc] init] autorelease];
            switcher.tag = TAG_SWITCHER;
            CGRect switcherFrame = switcher.frame;
            switcher.frame = CGRectMake(200.0, 7.0, switcherFrame.size.width, 30.0);
            [switcher addTarget:self action:@selector(toggleSwitch) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:switcher];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UISwitch* cellswitch = (UISwitch*)[cell.contentView viewWithTag:TAG_SWITCHER];
        cellswitch.frame = CGRectMake(290.0 - cellswitch.frame.size.width, 7.0, cellswitch.frame.size.width, 30.0);
        if (self.account.isBlocked) {
            [cellswitch setOn:FALSE animated:NO];
        }
        else{
            [cellswitch setOn:TRUE animated:NO];
        }
        cell.textLabel.text = NSLocalizedString(@"Receive messages", nil);
        cellswitch.enabled =NO;
        return cell;
    }

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView* headerview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 118)] autorelease];
        
        UIImageView* bg = [[UIImageView alloc] initWithFrame:headerview.frame];
        [bg setImage:[UIImage imageNamed:@"contact_info_bg.png"]];
        [headerview addSubview:bg];
        [bg release];
        
        self.imageview = [[[UIImageView alloc]initWithFrame:
                           CGRectMake(PERSON_INFO_X_14, PERSON_INFO_Y_14, PERSON_INFO_MSG_BUTTON_WIDTH, PERSON_INFO_MSG_BUTTON_HEIGHT)] autorelease];
        
        self.imageview.layer.masksToBounds =YES;
        self.imageview.layer.cornerRadius = self.imageview.frame.size.height/2;
        
        NSData *data = [AvatarHelper getThumbnailForUser:self.account.userID];
        if (data)
            self.imageview.image = [UIImage imageWithData:data];
        else
        {
            self.imageview.image = [UIImage imageNamed:DEFAULT_OFFICIAL_AVARAR];
        }
        
        if (self.account.needToDownloadThumbnail)
        {
            [WowTalkWebServerIF getThumbnailForUserID:self.account.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
        }
        
        [headerview addSubview:self.imageview];
        
        UILabel *nameLabel= [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, PERSON_INFO_Y_10,PERSON_INFO_WIDTH_160, PERSON_INFO_HEIGHT_20)];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_17];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.shadowColor = [UIColor blackColor];
        nameLabel.shadowOffset = CGSizeMake(1, 1);
        nameLabel.text = self.account.nickName;
        [headerview addSubview:nameLabel];
        [nameLabel release];
        
        // set the wowtalk id label
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, 40.0, 200.0, PERSON_INFO_HEIGHT_20)];
        idLabel.adjustsFontSizeToFitWidth = YES;
        idLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        idLabel.backgroundColor = [UIColor clearColor];
        idLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
        idLabel.font = [UIFont boldSystemFontOfSize:15.0];
        idLabel.shadowColor = [UIColor blackColor];
        idLabel.shadowOffset = CGSizeMake(1.0, 1.0);

        idLabel.text = [NSLocalizedString(@"WowTalk ID", nil) stringByAppendingString:self.account.wowtalkID];

        [headerview addSubview:idLabel];
        [idLabel release];
        
        self.btn_follow = [[[UIButton alloc] initWithFrame:CGRectMake(118, 74, 90, 37)] autorelease];
        [self.btn_follow setBackgroundImage:[UIImage imageNamed:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
        [self.btn_follow setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];

        [self.btn_follow addTarget:self action:@selector(followOfficalAccount) forControlEvents:UIControlEventTouchUpInside];
        
//        self.btn_chat = [[[UIButton alloc] initWithFrame:CGRectMake(118, 74, 90, 37)] autorelease];
//        [self.btn_chat setBackgroundImage:[UIImage imageNamed:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
//        [self.btn_chat addTarget:self action:@selector(chatWithOfficalAccount) forControlEvents:UIControlEventTouchUpInside];
        
        self.btn_history = [[[UIButton alloc] initWithFrame:CGRectMake(216, 74, 90, 37)] autorelease];
        [self.btn_history setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
        [self.btn_history addTarget:self action:@selector(CheckHistoryMessage) forControlEvents:UIControlEventTouchUpInside];
        
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:self.btn_chat.frame];
//        messageLabel.adjustsFontSizeToFitWidth = NO;
//        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        messageLabel.backgroundColor = [UIColor clearColor];
//        messageLabel.textColor = [UIColor whiteColor];
//        messageLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.text = NSLocalizedString(@"Message", nil);
//        messageLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
//        messageLabel.shadowOffset = CGSizeMake(0, 1);
        
        UILabel *historyLabel = [[UILabel alloc] initWithFrame:self.btn_history.frame];
        historyLabel.adjustsFontSizeToFitWidth = NO;
        historyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        historyLabel.backgroundColor = [UIColor clearColor];
        historyLabel.textColor = [UIColor whiteColor];
        historyLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        historyLabel.textAlignment = NSTextAlignmentCenter;
        historyLabel.text = NSLocalizedString(@"History", nil);
        historyLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        historyLabel.shadowOffset = CGSizeMake(0, 1);
        
        UILabel *followlabel = [[UILabel alloc] initWithFrame:self.btn_follow.frame];
        followlabel.adjustsFontSizeToFitWidth = NO;
        followlabel.lineBreakMode = NSLineBreakByTruncatingTail;
        followlabel.backgroundColor = [UIColor clearColor];
        followlabel.textColor = [UIColor whiteColor];
        followlabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        followlabel.textAlignment = NSTextAlignmentCenter;
        followlabel.text = NSLocalizedString(@"Follow", nil);
        followlabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        followlabel.shadowOffset = CGSizeMake(0, 1);
        
        if (self.account.isFriend) {
            
//            [headerview addSubview:self.btn_chat];
//            [headerview addSubview:messageLabel];
            
            [historyLabel release];
//            [messageLabel release];
        }
        else{
            [headerview addSubview:self.btn_follow];
            [headerview addSubview:followlabel];
            [followlabel release];
        }
        
        
       /* UIImageView* iv_avatarframe = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 104, 104)];
        [iv_avatarframe setImage:[UIImage imageNamed:@"avatar_mask_90.png"]];
        [headerview addSubview:iv_avatarframe];
        [iv_avatarframe release];
        */
        UIImageView* iv_divide = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
        [iv_divide setImage:[UIImage imageNamed:@"table_divider_black.png"]];
        [headerview addSubview:iv_divide];
        [iv_divide release];
        
        
        return headerview;
        
    }
    else return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        if (self.noShowGoToMoment) {
            return 0;
        }        
    }
    return 66;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.noShowGoToMoment) {
            return nil;
        }
        UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)] autorelease];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 11, 300, 44)];
        [button setBackgroundImage:[PublicFunctions strecthableImage:LARGE_BLUE_BUTTON] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"Check moments", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(viewBuddySpace:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [footerView addSubview:button];
        [button release];
        return footerView;
    } else if (section == 1) {
        UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)] autorelease];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 11, 300, 44)];
        [button setBackgroundImage:[PublicFunctions strecthableImage:BTN_LARGE_RED_IMAGE] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"unfollow", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(unfollowOfficalAccount) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [footerView addSubview:button];
        [button release];
        return footerView;
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 129;
    } else {
        return 10;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.account.isFriend) {
        return 2;
    } else {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [UILabel labelHeight:self.account.status FontType:FONT_SIZE_17 withInMaxWidth:220] > 44? [UILabel labelHeight:self.account.status FontType:FONT_SIZE_17 withInMaxWidth:220]  : 44;
    }
    else {
        return 44;
    }
}


#pragma mark -- button function

-(void)chatWithOfficalAccount
{
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:self.account withFirstChat:NO];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];

}

-(void)CheckHistoryMessage
{
    [WTHelper WTLog:@"check history message"];
}

-(void)followOfficalAccount
{
    [WowTalkWebServerIF addBuddy:self.account.userID withMsg:nil withCallback:@selector(didFollowAccount:) withObserver:self];
    [WTHelper WTLog:@"Follow this account"];
    
}

-(void)unfollowOfficalAccount
{
    
    NSString *tipsStr = [NSString stringWithFormat:@"不再关注\"%@\"后将不再收到其下发的消息",self.account.nickName];
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips",nil) message:tipsStr delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"sure", nil), nil];
    [alerView show];
    [alerView release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [WTHelper WTLog:@"unfollow this account"];
        [WowTalkWebServerIF removeBuddy:self.account.userID withCallback:@selector(didUnfollowAccount:) withObserver:self];
    }else{
        
    }
}
-(void)toggleSwitch
{
    if (self.account.isBlocked) {
         [WowTalkWebServerIF unlockBuddy:self.account.userID withCallback:@selector(didUnlockAccount:) withObserver:self];
    }
    else{
         [WowTalkWebServerIF blockBuddy:self.account.userID withCallback:@selector(didBlockAccount:) withObserver:self];
    }
}

- (void)viewBuddySpace:(UIButton *)button
{
    OMBuddySpaceViewController *spaceViewController = [[OMBuddySpaceViewController alloc] init];
    spaceViewController.buddyid = self.account.userID;
    [self.navigationController pushViewController:spaceViewController animated:YES];
    [spaceViewController release];
}

#pragma mark - notification callback
-(void)didFollowAccount:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    
    if (error.code == NO_ERROR) {
        self.account = [Database buddyWithUserID:self.account.userID];
        self.account.isFriend = YES;
        [self.tb_offcialaccount reloadData];
        UIBarButtonItem *moreButtonItem = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_MORE_IMAGE] selector:@selector(showActionSheet)];
        [self.navigationItem addRightBarButtonItem:moreButtonItem];
        [moreButtonItem release];
    }
}

-(void)didUnfollowAccount:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    
    if (error.code == NO_ERROR) {
        
        [Database deleteChatMessageWithUser:self.account.userID];
        
        [[WarningView sharedViewWithString:NSLocalizedString(@"unfollow_public_account_note",nil)] showAlert:error];
        
        [self goBack];
    }
}

- (void)getBuddyThumbnail:(NSNotification *)notification
{
    NSData *data = [AvatarHelper getThumbnailForUser:self.account.userID];
    if (data)
        self.imageview.image = [UIImage imageWithData:data];
}

-(void)didBlockAccount:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    
    if (error.code == NO_ERROR) {
        self.account = [Database buddyWithUserID:self.account.userID];
        [self.tb_offcialaccount reloadData];
    }
}

-(void)didUnlockAccount:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    
    if (error.code == NO_ERROR) {
        self.account = [Database buddyWithUserID:self.account.userID];
        [self.tb_offcialaccount reloadData];
    }
}


#pragma mark -- navigation bar
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"close", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"unfollow", nil)
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)configNav
{    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Details",nil);
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
    if (self.account.isFriend) {
//        UIBarButtonItem *moreButtonItem = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_MORE_IMAGE] selector:@selector(showActionSheet)];
//        [self.navigationItem addRightBarButtonItem:moreButtonItem];
//        [moreButtonItem release];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self unfollowOfficalAccount];
    }
}

#pragma mark -- View Lifecycle
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
    self.tb_offcialaccount.scrollEnabled = FALSE;
    [self.tb_offcialaccount setBackgroundView:nil];
     self.tb_offcialaccount.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self.tb_offcialaccount setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.btn_chat = nil;
    self.btn_unfollow = nil;
    self.btn_history = nil;
    self.btn_follow = nil;
    
    [super dealloc];
}

@end
