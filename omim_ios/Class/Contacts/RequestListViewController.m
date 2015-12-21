//
//  RequestListViewController.m
//  omim
//
//  Created by elvis on 2013/05/07.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "RequestListViewController.h"
#import "PublicFunctions.h"
#import "WTHeader.h"
#import "Constants.h"
#import "CustomButton.h"
#import <QuartzCore/QuartzCore.h>
#import "ApplyViewController.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "AddContactViewController.h"
#import "Buddy.h"
#import "MsgComposerVC.h"
#import "MessagesVC.h"
#import "RequestListCell.h"
#import "OMMessageVC.h"
@implementation RequestListViewController

#define TAG_CELL_ACCEPT_BUTTON                      1
#define TAG_CELL_REFUSE_BUTTON                      2
#define TAG_CELL_ACCEPT_BUTTON_LABLE                3
#define TAG_CELL_REFUSE_BUTTON_LABLE                4
#define TAG_AVATAR                                  5
#define TAG_NAME                                    6
#define TAG_MSG_LAB                                 7
{
    MsgComposerVC *_message;
    Buddy *_buddy;
    NSInteger selectRow;
}

-(void)dealloc
{
    [_buddy_id release],_buddy_id = nil;
    [_message release],_message = nil;
    [_tb_request release],_tb_request.delegate = nil,_tb_request.dataSource = nil,_tb_request = nil;
    [super dealloc];
}
#pragma mark - table view controller
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* identifier = @"requestcell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier] autorelease];
        
        int width1 = [UILabel labelWidth:NSLocalizedString(@"Accecpt", nil) FontType:16 withInMaxWidth:60];
        
        int width2 = [UILabel labelWidth:NSLocalizedString(@"Reject", nil) FontType:16 withInMaxWidth:60];
        
        int width = width1> width2 ? width1:width2;
        width = width>50?width:50;
        
        CustomButton* btn_accpet = [[CustomButton alloc] init];
        [btn_accpet setFrame:CGRectMake(300-2*width, 7, width, 36)];
        [btn_accpet setBackgroundImage:[PublicFunctions strecthableImage:SMALL_BLUE_BUTTON] forState:UIControlStateNormal];
        [btn_accpet setBackgroundImage:[PublicFunctions strecthableImage:SMALL_BLUE_BUTTON_P] forState:UIControlStateHighlighted];
        btn_accpet.tag = TAG_CELL_ACCEPT_BUTTON;
        [cell.contentView addSubview:btn_accpet];
        [btn_accpet release];
        
        
        UILabel* lbl_desc = [[UILabel alloc] initWithFrame:btn_accpet.frame];
        lbl_desc.tag = TAG_CELL_ACCEPT_BUTTON_LABLE;
        lbl_desc.backgroundColor = [UIColor clearColor];
        lbl_desc.textColor = [UIColor whiteColor];
        lbl_desc.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        lbl_desc.textAlignment = NSTextAlignmentCenter;
        lbl_desc.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        lbl_desc.shadowOffset = CGSizeMake(0, 1);
        [lbl_desc setText:NSLocalizedString(@"Accecpt", nil)];
        
        
        [cell.contentView addSubview:lbl_desc];
        
        [lbl_desc release];
        
        CustomButton* btn_refuse = [[CustomButton alloc] init];
        [btn_refuse setFrame:CGRectMake(310-width, 7, width, 36)];
        [btn_refuse setBackgroundImage:[PublicFunctions strecthableImage:SMALL_BLUE_BUTTON] forState:UIControlStateNormal];
        [btn_refuse setBackgroundImage:[PublicFunctions strecthableImage:SMALL_BLUE_BUTTON_P] forState:UIControlStateHighlighted];
        btn_refuse.tag = TAG_CELL_REFUSE_BUTTON;
        [cell.contentView addSubview:btn_refuse];
        [btn_refuse release];
        
        UILabel* lbl_refuse = [[UILabel alloc] initWithFrame:btn_refuse.frame];
        lbl_refuse.tag = TAG_CELL_REFUSE_BUTTON_LABLE;
        lbl_refuse.backgroundColor = [UIColor clearColor];
        lbl_refuse.textColor = [UIColor whiteColor];
        lbl_refuse.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        lbl_refuse.textAlignment = NSTextAlignmentCenter;
        lbl_refuse.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        lbl_refuse.shadowOffset = CGSizeMake(0, 1);
        
        [lbl_refuse setText:NSLocalizedString(@"Reject", nil)];
        [cell.contentView addSubview:lbl_refuse];
        [lbl_refuse release];
        
        
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 5.0f;
        
        imageview.tag = TAG_AVATAR;
        [cell.contentView addSubview:imageview];
        [imageview release];
        
        UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 5.0f, 135, 20)];
        
        name.backgroundColor = [UIColor clearColor];
        name.textColor = [UIColor blackColor];
        name.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_15];
        name.textAlignment = NSTextAlignmentLeft;
        name.numberOfLines = 3;
        name.minimumScaleFactor = 9;
        name.adjustsFontSizeToFitWidth = TRUE;
        name.lineBreakMode = NSLineBreakByTruncatingTail;
        
        name.tag = TAG_NAME;
        [cell.contentView addSubview:name];
        [name release];
        
        UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 25, 130, 20)];
        msgLab.tag = TAG_MSG_LAB;
        msgLab.textColor = [UIColor blackColor];
        name.font = [UIFont systemFontOfSize:12];
        msgLab.textAlignment = NSTextAlignmentLeft;
        msgLab.numberOfLines = 3;
        msgLab.adjustsFontSizeToFitWidth = TRUE;
        [cell.contentView addSubview:msgLab];
        
        UIImageView* divider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
        [divider setImage:[UIImage imageNamed:@"divider_320.png"]];
        [cell.contentView addSubview:divider];
        [divider release];
        
    }
    
    UILabel* name = ( UILabel*)[[cell contentView] viewWithTag:TAG_NAME];
    UIImageView* imageview = (UIImageView* )[cell.contentView viewWithTag:TAG_AVATAR];
    CustomButton* btn_accept = (CustomButton*)[cell.contentView viewWithTag:TAG_CELL_ACCEPT_BUTTON];
    CustomButton* btn_refuse = (CustomButton*)[cell.contentView viewWithTag:TAG_CELL_REFUSE_BUTTON];
    
    UILabel *msgLab = (UILabel *)[[cell contentView] viewWithTag:TAG_MSG_LAB];
    
    
    btn_refuse.row = indexPath.row;
    btn_refuse.section = indexPath.section;
    
    btn_accept.row = indexPath.row;
    btn_accept.section = indexPath.section;
    
    PendingRequest* request = nil;
    
    if (indexPath.section == 0) {
        if ([self.arr_buddyrequests count] >0) {
            request = [self.arr_buddyrequests objectAtIndex:indexPath.row];
            name.text = request.nickname;
            msgLab.text = request.msg;
            NSData* data = [AvatarHelper getThumbnailForUser:request.buddyid];
            if (data){
                [imageview setImage:[UIImage imageWithData:data]];
            }
            else{
                [imageview setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
                [WowTalkWebServerIF getThumbnailForUserID:request.buddyid withCallback:@selector(didGetThumbnail:) withObserver:self];
            }
            
            [btn_accept addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
            [btn_refuse addTarget:self action:@selector(refuseFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            if (indexPath.row < [self.arr_groupinvitation count]) {
                request = [self.arr_groupinvitation objectAtIndex:indexPath.row];
                name.text = [NSString stringWithFormat:@"%@ %@",request.groupname,NSLocalizedString(@"invite you to join", nil)];
                NSData* data = [AvatarHelper getThumbnailForGroup:request.groupid];
                if (data){
                    [imageview setImage: [UIImage imageWithData:data]];
                }
                else{
                    [imageview setImage:[UIImage imageNamed:DEFAULT_GROUP_AVATAR]];
                    [WowTalkWebServerIF getGroupAvatarThumbnail:request.groupid withCallback:@selector(didGetThumbnail:) withObserver:self];
                }
                [btn_accept addTarget:self action:@selector(acceptJoinTheGroup:) forControlEvents:UIControlEventTouchUpInside];
                [btn_refuse addTarget:self action:@selector(refuseJoinTheGroup:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                request = [self.arr_grouprequests objectAtIndex:indexPath.row];
                
                name.text = [NSString stringWithFormat:NSLocalizedString(@"%@ Apply to join group %@", nil),request.nickname,  request.groupname];
                NSData* data = [AvatarHelper getThumbnailForUser:request.buddyid];
                if (data){
                    [imageview setImage: [UIImage imageWithData:data]];
                }
                else{
                    [imageview setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
                    [WowTalkWebServerIF getThumbnailForUserID:request.buddyid withCallback:@selector(didGetThumbnail:) withObserver:self];
                }
                [btn_accept addTarget:self action:@selector(acceptGroupApplication:) forControlEvents:UIControlEventTouchUpInside];
                [btn_refuse addTarget:self action:@selector(refuseGroupApplication:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
      
    }
    else{
        if (indexPath.row < [self.arr_groupinvitation count]) {
            request = [self.arr_groupinvitation objectAtIndex:indexPath.row];
            name.text = [NSString stringWithFormat:@"%@ %@",request.groupname,NSLocalizedString(@"invite you to join", nil)];
            NSData* data = [AvatarHelper getThumbnailForGroup:request.groupid];
            if (data){
                [imageview setImage: [UIImage imageWithData:data]];
            }
            else{
                [imageview setImage:[UIImage imageNamed:DEFAULT_GROUP_AVATAR]];
                [WowTalkWebServerIF getGroupAvatarThumbnail:request.groupid withCallback:@selector(didGetThumbnail:) withObserver:self];
            }
            [btn_accept addTarget:self action:@selector(acceptJoinTheGroup:) forControlEvents:UIControlEventTouchUpInside];
            [btn_refuse addTarget:self action:@selector(refuseJoinTheGroup:) forControlEvents:UIControlEventTouchUpInside];

        }
        else{
            request = [self.arr_grouprequests objectAtIndex:indexPath.row];
            
            name.text = [NSString stringWithFormat:@"%@ %@ %@",request.nickname, NSLocalizedString(@"申请加入群", nil), request.groupname];
            NSData* data = [AvatarHelper getThumbnailForUser:request.buddyid];
            if (data){
                [imageview setImage: [UIImage imageWithData:data]];
            }
            else{
                [imageview setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
                [WowTalkWebServerIF getThumbnailForUserID:request.buddyid withCallback:@selector(didGetThumbnail:) withObserver:self];
            }
            [btn_accept addTarget:self action:@selector(acceptGroupApplication:) forControlEvents:UIControlEventTouchUpInside];
            [btn_refuse addTarget:self action:@selector(refuseGroupApplication:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
    /*
    static NSString *cellid = @"requestcell";
    RequestListCell *cello = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cello) {
        cello = [[[NSBundle mainBundle] loadNibNamed:@"RequestListCell" owner:self options:nil] firstObject];
        
    }
    cello.Accept.row = indexPath.row;
    cello.Accept.section = indexPath.section;
    
    cello.Reject.row = indexPath.row;
    cello.Reject.section = indexPath.section;
    PendingRequest *request1 = nil;
    if (indexPath.section == 0) {
        if ([self.arr_buddyrequests count] >0) {
            request1 = [self.arr_buddyrequests objectAtIndex:indexPath.row];
            cello.nameLab.text = request1.nickname;
            cello.RequestMsg.text = request1.msg;
            NSData* data = [AvatarHelper getThumbnailForUser:request1.buddyid];
            if (data){
                [cello.headImg setImage:[UIImage imageWithData:data]];
            }
            else{
                [cello.headImg setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
                [WowTalkWebServerIF getThumbnailForUserID:request1.buddyid withCallback:@selector(didGetThumbnail:) withObserver:self];
            }
            
            [cello.Accept addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
            [cello.Reject addTarget:self action:@selector(refuseFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    */
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tb_request deselectRowAtIndexPath:indexPath animated:YES];
    
    PendingRequest* request = nil;
    
    ApplyViewController* avc = [[ApplyViewController alloc] init];
    avc.delegate = self;
    if (indexPath.section == 0) {
        if ([self.arr_buddyrequests count] >0) {
            request = [self.arr_buddyrequests objectAtIndex:indexPath.row];
            avc.isApplyForAddFriend = TRUE;
            avc.buddyid = request.buddyid;
            avc.name = request.nickname;
            avc.helloword = request.msg;
            
            if (![Database buddyWithUserID:request.buddyid]) {
                [WowTalkWebServerIF getBuddyWithUID:request.buddyid withCallback:nil withObserver:nil];
            }
            
        }
        else{
            if (indexPath.row < [self.arr_groupinvitation count]) {
                request = [self.arr_groupinvitation objectAtIndex:indexPath.row];
                avc.isGroupInvitation = TRUE;
                avc.groupid = request.groupid;
                avc.name = request.groupname;
                avc.helloword = request.msg;
            }
            else{
                request = [self.arr_grouprequests objectAtIndex:indexPath.row];
                avc.isApplyForGroup = TRUE;
                avc.groupid = request.groupid;
                avc.name = request.nickname;
                avc.helloword = request.msg;
                avc.buddyid = request.buddyid;
                if (![Database buddyWithUserID:request.buddyid]) {
                    [WowTalkWebServerIF getBuddyWithUID:request.buddyid withCallback:nil withObserver:nil];
                }
            
            }
        }
        
    }
    else{
        if (indexPath.row < [self.arr_groupinvitation count]) {
            request = [self.arr_groupinvitation objectAtIndex:indexPath.row];
            avc.isGroupInvitation = TRUE;
            avc.groupid = request.groupid;
            avc.name = request.groupname;
            avc.helloword = request.msg;
        }
        else{
            request = [self.arr_grouprequests objectAtIndex:indexPath.row];
            avc.isApplyForGroup = TRUE;
            avc.groupid = request.groupid;
            avc.name = request.nickname;
            avc.helloword = request.msg;
            avc.buddyid = request.buddyid;
            if (![Database buddyWithUserID:request.buddyid]) {
                [WowTalkWebServerIF getBuddyWithUID:request.buddyid withCallback:nil withObserver:nil];
            }
        }
    }
    
    [self.navigationController pushViewController:avc animated:TRUE];
    [avc release];
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CONTACT_TABLEVIEWCELL_HEIGHT;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle  = nil;
    if ([self.arr_buddyrequests count]> 0) {
        if (section == 0) {
            sectionTitle = NSLocalizedString(@"Friend request", nil);
        }
        else{
            sectionTitle = NSLocalizedString(@"Join Application / Invitation", nil);
        }
    }
    else{
        sectionTitle = NSLocalizedString(@"Join Application / Invitation", nil);
    }
        UILabel *nameLabel = [[[UILabel alloc] init] autorelease];
        nameLabel.frame = CGRectMake(TABLE_HEADER_LABEL_X_OFFSET, TABLE_HEADER_LABEL_Y_OFFSET, TABLE_HEADER_LABEL_WIDTH, TABLE_HEADER_LABEL_HEIGHT);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = POPLISTVIEW_TABLEVIEW_CELL_TEXT_COLOR;
        nameLabel.font = [UIFont fontWithName:TABLE_HEADER_LABEL_FONT_NAME size:TABLE_HEADER_LABEL_FONT_SIZE];
        nameLabel.text = sectionTitle;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, TABLE_HEADER_IMAGEVIEW_HEIGHT)];
        imageView.image = [UIImage imageNamed:CONTACT_TABLEVIEW_SECTION_IMAGE];
        
        [imageView addSubview:nameLabel];
        return [imageView autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CONTACT_TABLEVIEWCELL_SECTION_HEIGHT;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = 0;
    if ([self.arr_buddyrequests count]> 0) {
        count ++;
    }
    if ([self.arr_grouprequests count]> 0 || [self.arr_groupinvitation count]> 0) {
        count ++;
    }
    return count;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.arr_buddyrequests count] > 0) {
        if (section == 0) {
          return [self.arr_buddyrequests count];  
        }
        else{
            return [self.arr_grouprequests count] + [self.arr_groupinvitation count];
        }
    }
    else
        return [self.arr_grouprequests count] + [self.arr_groupinvitation count];
    
}

#pragma mark - button method

-(void)acceptGroupApplication:(id)sender
{
    CustomButton* btn = (CustomButton*)sender;
    PendingRequest* request = [self.arr_grouprequests objectAtIndex:btn.row];
    [WowTalkWebServerIF acceptJoinApplicationFor:request.groupid FromUser:request.buddyid  withCallback:@selector(didHandleGroupApplicationRequest:) withObserver:self];
}

-(void)refuseGroupApplication:(id)sender
{
    CustomButton* btn = (CustomButton*)sender;
    PendingRequest* request = [self.arr_grouprequests objectAtIndex:btn.row];
    [WowTalkWebServerIF rejectCandidate:request.buddyid toJoinGroup:request.groupid withCallback:@selector(didHandleGroupApplicationRequest:) withObserver:self];
}

-(void)acceptJoinTheGroup:(id)sender
{
    
}

-(void)refuseJoinTheGroup:(id)sender
{
    
}

-(void)acceptFriendRequest:(id)sender
{
   
    CustomButton* btn = (CustomButton*)sender;
    selectRow = btn.row;
    PendingRequest* request = [self.arr_buddyrequests objectAtIndex:btn.row];
    [WowTalkWebServerIF addBuddy:request.buddyid withMsg:nil withCallback:@selector(didAddBuddy:) withObserver:self];
    
}
-(void)refuseFriendRequest:(id)sender
{
    CustomButton* btn = (CustomButton*)sender;
    PendingRequest* request = [self.arr_buddyrequests objectAtIndex:btn.row];
    
    [WowTalkWebServerIF rejectFriendRequest:request.buddyid withCallback:@selector(didRejectFriendRequest:) withObserver:self];
    
}

#pragma mark - callback
- (void)didGetThumbnail:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.tb_request reloadData];
    }
}

- (void)didGetPendingRequest:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSDictionary *requestdic = (NSDictionary *)[[notif userInfo] valueForKey:WT_PENDING_REQUEST];
        self.arr_buddyrequests = [requestdic objectForKey:@"buddyrequest"];
        self.arr_grouprequests = [requestdic objectForKey:@"joingrouprequest"];
        self.arr_groupinvitation = [requestdic objectForKey:@"inviterequest"];
        [self.tb_request reloadData];
        
    }
}

- (void)didHandleGroupApplicationRequest:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [WowTalkWebServerIF getAllPendingRequest:@selector(didGetPendingRequest:) withObserver:self];
    }
}

- (void)didAddBuddy:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        PendingRequest* request = [self.arr_buddyrequests objectAtIndex:selectRow];
        _buddy = [Database buddyWithUserID:request.buddyid];
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:_buddy withFirstChat:YES];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [WowTalkWebServerIF getAllPendingRequest:@selector(didGetPendingRequest:) withObserver:self];
    }
}
-(void)didRejectFriendRequest:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [WowTalkWebServerIF getAllPendingRequest:@selector(didGetPendingRequest:) withObserver:self];
    }
}

#pragma mark - view handle
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goAddFriend
{
    AddContactViewController *addViewController = [[AddContactViewController alloc] init];
    addViewController.enableGroupCreation = YES;
    [self.navigationController pushViewController:addViewController animated:YES];
    [addViewController release];
}

-(void)configNav
{
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  NSLocalizedString(@"Request list",nil);
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
    UIBarButtonItem *rightButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_ADD_IMAGE] selector:@selector(goAddFriend)];
    [self.navigationItem addRightBarButtonItem:rightButton];
    [rightButton release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNav];
 
    if (self.arr_groupinvitation == nil) {
           self.arr_groupinvitation = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if (self.arr_grouprequests == nil) {
            self.arr_grouprequests = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if (self.arr_buddyrequests == nil) {
        self.arr_buddyrequests = [[[NSMutableArray alloc] init] autorelease];
    }
    
    [self.tb_request setBackgroundView:nil];
    self.tb_request.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self.tb_request setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tb_request setFrame:CGRectMake(0, 0, self.tb_request.frame.size.width, [UISize screenHeight] - 20 - 44)];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [WowTalkWebServerIF getAllPendingRequest:@selector(didGetPendingRequest:) withObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    if (_isAccecpt && (_buddy_id != nil)){
        Buddy *buddy = [Database buddyWithUserID:_buddy_id];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:buddy withFirstChat:YES];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
        if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[OMMessageVC class]]){
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
//        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabbarVC selectTabAtIndex:TAB_MESSAGE];
        _isAccecpt = NO;
        _buddy_id = nil;
    }
}



@end
