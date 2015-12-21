//
//  TempChatRoomInfoViewController.m
//  omim
//
//  Created by elvis on 2013/05/23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "TempChatRoomInfoViewController.h"
#import "WTHeader.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "ChangeTempGroupNameViewController.h"
#import "CustomNavigationBar.h"
#import "ContactListViewController.h"
#import "ContactInfoViewController.h"
#import "AddBuddyFromSchoolVC.h"

#define TAG_BUTTON  1
#define TAG_LABEL   2

@interface TempChatRoomInfoViewController ()
{
    BOOL showingAllMembers;
    BOOL ableToDelete;
    BOOL ableToAdd;
    BOOL inDeleteMode;
    UILabel* messageLabel;
    BOOL noNeedToRefresh;
}

- (void)exitAction;

@property (nonatomic,retain) MemberGridView* gridview;
@property (nonatomic,retain) UIImageView* imageview;
@property (nonatomic,retain) UIButton* btn_chat;
@property (nonatomic,retain) NSArray* selectedMembers;
@property (nonatomic,retain) GroupMember* toBeDeletedMember;
@property (nonatomic,retain) UIButton* btn_action;

@end

@implementation TempChatRoomInfoViewController
@synthesize groupid;


-(void)dealloc{
    [super dealloc];
}

#pragma mark - callback function

-(void)didGetMemberList:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self loadGroupInfo];
    }
}

-(void)didGetGroupInfo:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self loadGroupInfo];
    }
}

-(void)didLeaveGroup:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [Database deleteChatMessageWithUser:self.groupid];
        [Database deleteGroupChatRoomWithID:self.groupid];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void)didAddMembers:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.group.memberList addObjectsFromArray:self.selectedMembers];
        [self.mytableView reloadData];
    }
    noNeedToRefresh = NO;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)configNav
{
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Tmp Chatroom info",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
       [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configNav];
    
    self.mytableView.scrollEnabled = YES;
    [self.mytableView setBackgroundView:nil];
    self.mytableView.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self.mytableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.mytableView.separatorColor = [UIColor whiteColor];
    showingAllMembers = NO;
    ableToDelete = YES;
    ableToAdd = YES;
    inDeleteMode = NO;
    
    NSArray *members = [Database getAllMembersInFixedGroup:self.groupid];
    for (GroupMember *buddy in members) {
        if (buddy.isCreator) {
            if (![buddy.userID isEqualToString:[WTUserDefaults getUid]]) {
                ableToDelete = NO;
            }
            break;
        }
    }
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        //[self.mytableView setFrame:CGRectMake(0, 0, self.mytableView.frame.size.width, [UISize screenHeight] - 20 - 44)];
        [self.mytableView setSeparatorInset:UIEdgeInsetsZero];
        self.mytableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.mytableView.bounds.size.width, 15.0f)] autorelease];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [WowTalkWebServerIF groupChat_GetGroupDetail:self.groupid withCallback:@selector(didGetGroupInfo:) withObserver:self];
    
    if (!noNeedToRefresh) {
        [WowTalkWebServerIF groupChat_GetGroupMembers:self.groupid withCallback:@selector(didGetMemberList:) withObserver:self];
        
        [self loadGroupInfo];
    }
    
}

-(void)loadGroupInfo
{
    // tempgroup will not include me.
    
    NSMutableArray* array = [Database fetchAllBuddysInGroupChatRoom:self.groupid];
    
    /*  //add myself.
  Buddy* buddy = [[Buddy alloc] initWithUID:[WTUserDefaults getUid] andPhoneNumber:[WTUserDefaults getPhoneNumber] andNickname:[WTUserDefaults getNickname] andStatus:[WTUserDefaults getStatus] andDeviceNumber:nil andAppVer:nil andUserType:@"1" andBuddyFlag:@"1" andIsBlocked:NO andSex:nil andPhotoUploadTimeStamp:nil andWowTalkID:[WTUserDefaults getWowTalkID] andLastLongitude:nil andLastLatitude:nil andLastLoginTimestamp:nil withAddFriendRule:1];
    [array addObject:buddy];
    [buddy release];
  */
    self.group = [Database getGroupChatRoomByGroupid:self.groupid];
    
    self.group.memberList = array;
    
    if (![NSString isEmptyString:self.group.groupNameOriginal]) {
        self.title = self.group.groupNameOriginal;
    }
    
    [self.mytableView reloadData];
}


- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - memebergridview delegate
-(void)becomeAddMode:(MemberGridView *)requestor
{
    ContactPickerViewController* bpvc = [[ContactPickerViewController alloc] init];
    bpvc.isManageGroupMember = YES;
    bpvc.exsitingBuddys = self.group.memberList;
    bpvc.delegate = self;
    
    [self.navigationController pushViewController:bpvc animated:YES];
    [bpvc release];

}

- (void)becomeDeleteMode:(MemberGridView *)requstor
{
    inDeleteMode = YES;
    [self.mytableView reloadData];
}

-(void)didSelectMember:(GroupMember *)member inGridView:(MemberGridView *)requestor
{
    if (inDeleteMode) {
        if (![member.userID isEqualToString:[WTUserDefaults getUid]]) {
            [Database deleteMember:member.userID InGroup:self.groupid];
            [WowTalkWebServerIF removeMemeber:[NSArray arrayWithObject:member] fromGroup:self.groupid withCallback:nil withObserver:nil];
            for (Buddy *buddy in self.group.memberList) {
                if ([buddy.userID isEqualToString:member.userID]) {
                    [self.group.memberList removeObject:buddy];
                    break;
                }
            }
        }
        inDeleteMode = NO;
        [self.mytableView reloadData];
    } else {
        if ([member.userID isEqualToString:[WTUserDefaults getUid]]) {
            return;
        }
        else {
//#warning by yangbin
            Buddy *buddy = [Buddy buddyFromGroupMember:member];
            if ([Database schoolMemberAlreadyAddBuddy:buddy.userID] && (![[WTUserDefaults getUid] isEqualToString:buddy.userID]) ){
                ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
                infoViewController.buddy = buddy;
                infoViewController.contact_type = CONTACT_FRIEND;
                [self.navigationController pushViewController:infoViewController animated:YES];
                [infoViewController release];
            }else{
                AddBuddyFromSchoolVC *addBuddyFromSchool = [[AddBuddyFromSchoolVC alloc]init];
                addBuddyFromSchool.color = RED_COLOR_IN_ADDBUDDYFROMSCHOOLVC;
                PersonModel *person = [[PersonModel alloc]init];
                person.uid = buddy.userID;
                person.nickName = buddy.nickName;
                person.upload_photo_timestamp =  [NSString stringWithFormat:@"%zi",buddy.photoUploadedTimeStamp];
                person.user_type =[NSString stringWithFormat:@"%zi",buddy.userType];
                person.sex = [NSString stringWithFormat:@"%zi",buddy.sexFlag] ;
                person.alias = buddy.alias;
                addBuddyFromSchool.person = person;
                [person release];
                [self.navigationController pushViewController:addBuddyFromSchool animated:YES];
                [addBuddyFromSchool release];
            }
        }
    }
}


-(void)dismissDeleteMode:(id)sender
{
    inDeleteMode = NO;
    [self.mytableView reloadData];
    
}

#pragma mark -bizcontactpickerdelegate;

-(void)didSelectContacts:(NSArray *)members withRequestor:(ContactPickerViewController *)requestor
{
    self.selectedMembers = members;
    noNeedToRefresh = TRUE;
    [WowTalkWebServerIF groupChat_AddMembers:self.group.groupID withMembers:self.selectedMembers withCallback:@selector(didAddMembers:) withObserver:self];
}

#pragma mark -contactpickerdelegate;
-(void)didChooseGroupMembers:(NSArray *)members withRequestor:(ContactPickerViewController *)requestor
{
    self.selectedMembers = members;
    noNeedToRefresh = TRUE;
    [WowTalkWebServerIF groupChat_AddMembers:self.group.groupID withMembers:self.selectedMembers withCallback:@selector(didAddMembers:) withObserver:self];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if ([self.group.memberList count] < 8){
                return 1;
            }
            return 2;
            break;
            
        default:
            break;
    }
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return ableToDelete ? 1 : 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"FriendCell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel* deslabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
        deslabel.tag = TAG_LABEL;
        deslabel.font = [UIFont systemFontOfSize:FONT_SIZE_17];
        deslabel.numberOfLines = 0;
        deslabel.textColor = [UIColor blackColor];
        deslabel.textAlignment = NSTextAlignmentCenter;
        deslabel.adjustsFontSizeToFitWidth = NO;
        deslabel.lineBreakMode = NO;
        deslabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:deslabel];
        [deslabel release];

        [cell.contentView.layer setCornerRadius:4.0];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:TAG_LABEL];
    label.text = @"";
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;

        if (indexPath.row == 1) {
            if (showingAllMembers) {
                label.text = NSLocalizedString(@"Hide", nil);
            }
            else{
                label.text = NSLocalizedString(@"See all members", nil);
            }
            
            [label setFrame:CGRectMake(0, 0, 300, 44)];
            label. textAlignment = NSTextAlignmentCenter;
            UIView* view = [cell.contentView viewWithTag:100];
            if (view == nil) {
                UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 1)];
                view.tag = 100;
                [view setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
                [cell.contentView addSubview:view];
                [view release];
            }
        }
        else if (indexPath.row == 0){
            label.text = [NSString stringWithFormat:NSLocalizedString(@"Members(%d)", nil), [self.group.memberList count]+1];
            [label setFrame:CGRectMake(10, 10, 300, 30)];
            label. textAlignment = NSTextAlignmentLeft;
            
            if (_gridview && [_gridview superview]!=nil) {
                [_gridview removeFromSuperview];
            }
            NSMutableArray *newGroupMemberList = [[NSMutableArray alloc]init];
            Buddy *myBuddy = [Database buddyWithUserID:[WTUserDefaults getUid]];
            [newGroupMemberList addObject:myBuddy];
            [newGroupMemberList addObjectsFromArray:self.group.memberList];
            [_gridview release],_gridview = nil;
            _gridview = [[MemberGridView alloc] initWithFrame:CGRectMake(10, 40, 58*5, 2 * 79) withTempGroupMembers:newGroupMemberList showingAllMembers:showingAllMembers isDeleteMode:inDeleteMode];
            [newGroupMemberList release];
            
            _gridview.scrollEnabled = FALSE;
            _gridview.ableToDelete = ableToDelete;
            _gridview.inDeleteMode = inDeleteMode;
            _gridview.caller = self;
            
            [cell addSubview:_gridview];
            [_gridview release];
        }
    }
    else if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.row == 0) {
            label.text = NSLocalizedString(@"Change chatroom's name", nil);
            [label setFrame:CGRectMake(10, 0, 290, 44)];
            label. textAlignment = NSTextAlignmentLeft;
        }
        else if (indexPath.row == 1) {
            label.text = NSLocalizedString(@"Chat History", nil);
            [label setFrame:CGRectMake(10, 0, 290, 44)];
            label.textAlignment = NSTextAlignmentLeft;
        }
        
    }
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 66;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView* footview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)] autorelease];
        
        self.btn_action = [[[UIButton alloc] initWithFrame:CGRectMake(10, 22, 300, 44)] autorelease];
        
        [self.btn_action  setBackgroundImage:[PublicFunctions strecthableImage:LARGE_RED_BUTTON] forState:UIControlStateNormal];
        [self.btn_action  addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = nil;
        if (ableToDelete) {
            title = NSLocalizedString(@"contacts_temp_group_delete_and_exit", nil);
        } else {
            title = NSLocalizedString(@"quit_multiplayer_session", nil);
        }
        [self.btn_action  setTitle:title forState:UIControlStateNormal];
        
        //TODO:use undername if i am owner
        
        
        
        [footview addSubview:self.btn_action];
        
        return footview;
    }
    return nil;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 44;
        }
        else
            return 40 + [MemberGridView  heightForViewWithTempGroupMembers:[self.group.memberList count] + 1
                                                                showingAll:showingAllMembers
                                                                 ableToAdd:ableToAdd
                                                              ableToDelete:ableToDelete
                                                                deleteMode:inDeleteMode];
    }
    else{
        return 44;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            if (showingAllMembers) {
                showingAllMembers = NO;
            }
            else{
                showingAllMembers = YES;
            }
            [self.mytableView reloadData];
            [self.mytableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }else{
            inDeleteMode = NO;
            [self.mytableView reloadData];
            [self.mytableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ChangeTempGroupNameViewController* ctgnvc = [[ChangeTempGroupNameViewController alloc] init];
            ctgnvc.chatroom = self.group;
            [self.navigationController pushViewController:ctgnvc animated:YES];
            [ctgnvc release];
        }
        else if (indexPath.row == 1) {
            
        }
    }
}


- (void)exitAction
{
    NSString *alertString = nil;
    if (ableToDelete){
        alertString = NSLocalizedString(@"删除并退出后，将不再接收此群聊信息",nil);
    }else{
        alertString = NSLocalizedString(@"退出后，将不再接收此群聊信息",nil);
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",nil) message:alertString delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    alertView.tag = 200;
    [alertView show];
    [alertView release];
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200 && buttonIndex == 1){
        if (ableToDelete) {
            [WowTalkWebServerIF dismissGroup:self.groupid withCallback:@selector(didLeaveGroup:) withObserver:self];
        } else {
            [WowTalkWebServerIF groupChat_LeaveGroup:self.groupid withCallback:@selector(didLeaveGroup:) withObserver:self];
        }
    }
}


@end
