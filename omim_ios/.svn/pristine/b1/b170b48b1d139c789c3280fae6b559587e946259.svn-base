//
//  GroupInfoViewController.m
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "GroupInfoBuddyCell.h"
#import "ContactPickerViewController.h"
#import "ContactInfoViewController.h"
#import "GroupContactViewController.h"
#import "WTHeader.h"
#import "NonUserContactViewController.h"

#import <QuartzCore/QuartzCore.h>

#define TAG_BUTTON  1
#define TAG_LABEL   2

@interface GroupInfoViewController ()
{
    BOOL showingAllMembers;
    BOOL ableToDelete;
    BOOL ableToAdd;
    UILabel* messageLabel;
    
    BOOL noNeedToRefresh;
}
- (void)exitAction;

@property (nonatomic,assign) MemberGridView* gridview;
@property (nonatomic,retain) UIImageView* imageview;
@property (nonatomic,retain) UIButton* btn_chat;
@property (nonatomic,retain) NSArray* selectedMembers;
@property (nonatomic,retain) GroupMember* toBeDeletedMember;
@property (nonatomic,retain) UIButton* btn_action;

@end

@implementation GroupInfoViewController

@synthesize groupid;

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
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void)didDismissGroup:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self goBack];
    }
}

-(void)didAddMembers:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.group.memberList addObjectsFromArray:self.selectedMembers];
        [self.mytableView reloadData];
    }
    noNeedToRefresh = FALSE;
}

-(void)didRemoveMember:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.group.memberList removeObject:self.toBeDeletedMember];
        [self.mytableView reloadData];
    }
    
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
    self.group = [Database getFixedGroupByID:self.groupid];
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  self.group.groupNameLocal;
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
    
    self.mytableView.scrollEnabled = TRUE;
    [self.mytableView setBackgroundView:nil];
    self.mytableView.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self.mytableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    

    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:false];
        [self setAutomaticallyAdjustsScrollViewInsets:false];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self.mytableView setFrame:CGRectMake(0, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [WowTalkWebServerIF groupChat_GetGroupDetail:self.groupid withCallback:@selector(didGetGroupInfo:) withObserver:self];
    
    if (!noNeedToRefresh) {
         [WowTalkWebServerIF groupChat_GetGroupMembers:self.groupid withCallback:@selector(didGetMemberList:) withObserver:self];
        [self loadGroupInfo];
    }
   
}

-(void)authorize
{
    NSString* uid = [WTUserDefaults getUid];
    for (GroupMember* member in self.group.memberList) {
        if ([member.userID isEqualToString:uid]) {
            self.isCreator = member.isCreator;
            self.isManager = member.isManager;
            self.isStanger = FALSE;
        }
    }
    
    if (!self.isStanger && !self.isCreator && !self.isManager) {
        self.isNormalMember = TRUE;
    }    
}

-(void)loadGroupInfo
{
    
    self.group = [Database getFixedGroupByID:self.groupid];
    
    self.group.memberList = [Database getAllMembersInFixedGroup:self.groupid];
    [self authorize];
    
    ableToDelete = FALSE;
    ableToAdd = FALSE;
    
    if (self.isCreator || self.isManager) {
        ableToAdd = TRUE;
        ableToDelete = TRUE;
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
-(void)becomeDeleteMode:(MemberGridView *)requstor
{
    self.inDeleteMode = TRUE;
    [self.mytableView reloadData];
    [self.mytableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:YES];
    
}

-(void)didDeleteMember:(GroupMember *)member inGridView:(MemberGridView *)requestor
{
    self.toBeDeletedMember = member;
    
    [WowTalkWebServerIF removeMemeber:[NSArray arrayWithObject:member] fromGroup:self.group.groupID withCallback:@selector(didRemoveMember:) withObserver:self];
}

-(void)becomeAddMode:(MemberGridView *)requestor
{
    ContactPickerViewController* cpvc = [[ContactPickerViewController alloc] init];
    cpvc.delegate = self;
    cpvc.isManageGroupMember = TRUE;
    cpvc.exsitingBuddys = self.group.memberList;
    [self.navigationController pushViewController:cpvc animated:YES];
    [cpvc release];
}

-(void)didSelectMember:(GroupMember *)member inGridView:(MemberGridView *)requestor
{
    if ([member.buddy_flag isEqualToString:@"2"]) {
        
        NonUserContactViewController* nucvc = [[NonUserContactViewController alloc] init];
        nucvc.buddy = [Database buddyWithUserID:member.userID];
        [self.navigationController pushViewController:nucvc animated:TRUE];
        [nucvc release];
        
    }
    else{
        
        //   NSLog(@"select a member");
        ContactInfoViewController* civc = [[ContactInfoViewController alloc] init];
        civc.buddy = [Database buddyWithUserID:member.userID];
        if ([member.buddy_flag isEqualToString:@"1"]) {
            civc.contact_type = CONTACT_FRIEND;
        }
        else
            civc.contact_type = CONTACT_STRANGER;
        
        
        [self.navigationController pushViewController:civc animated:YES];
        [civc release];
    }
    
}

-(void)dismissDeleteMode:(id)sender
{
    self.inDeleteMode = FALSE;
    [self.mytableView reloadData];
    
}

#pragma mark -contactpickerdelegate;
-(void)didChooseGroupMembers:(NSArray *)members withRequestor:(ContactPickerViewController *)requestor
{
    self.selectedMembers = [GroupMember normalGroupMembersFromBuddys:members];
    noNeedToRefresh = TRUE;
    
    [WowTalkWebServerIF groupChat_AddMembers:self.group.groupID withMembers:self.selectedMembers withCallback:@selector(didAddMembers:) withObserver:self];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.group.memberList == nil) {
        return 0;
    }
    if (self.inDeleteMode) {
        return 1;
    }

    
    if (self.isCreator || self.isManager) {
        if ([self.group.memberList count] +2 < 11 ) {
            return 1;
        }
        else return 2;
    }
    else{
        if ([self.group.memberList count] < 11 ) {
            return 1;
        }
        else return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"FriendCell"] autorelease];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
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
    }
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:TAG_LABEL];
    label.text = @"";
    
    if (indexPath.row == 1) {
        if (showingAllMembers) {
            label.text = NSLocalizedString(@"Hide", nil);
        }
        else{
            label.text = NSLocalizedString(@"See all members", nil);
        }
        
        [label setFrame:CGRectMake(0, 0, 300, 44)];
        label. textAlignment = NSTextAlignmentCenter;
    }
    else if (indexPath.row == 0){
        label.text = [NSString stringWithFormat:NSLocalizedString(@"Members(%d)", nil), [self.group.memberList count]];
        [label setFrame:CGRectMake(10, 10, 300, 30)];
        label. textAlignment = NSTextAlignmentLeft;
        
        if (_gridview && [_gridview superview]!=nil) {
            [_gridview removeFromSuperview];
        }
        
        _gridview = [[MemberGridView alloc] initWithFrame:CGRectMake(10, 40, 58*5, 2 * 79) withMembers:self.group.memberList showingAllMembers:showingAllMembers ableToAdd:ableToAdd ableToDelete:ableToDelete isCreator:self.isCreator isManager:self.isManager isDeleteMode:self.inDeleteMode];
        _gridview.scrollEnabled = FALSE;
        _gridview.caller = self;
        
        [cell addSubview:_gridview];
        [_gridview release];
        
    }
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 66;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView* footview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)] autorelease];
    
    self.btn_action = [[[UIButton alloc] initWithFrame:CGRectMake(10, 22, 300, 44)] autorelease];

    [self.btn_action  setBackgroundImage: [PublicFunctions strecthableImage:LARGE_BLUE_BUTTON] forState:UIControlStateNormal];
    [self.btn_action  addTarget:self action:@selector(viewTheGroupDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_action  setTitle:NSLocalizedString(@"Check group detail", nil) forState:UIControlStateNormal];
    
    
    [footview addSubview:self.btn_action];
    
    return footview;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 1) {
        return 44;
    }
    else
        return 40 + [MemberGridView heightForViewWithMembers:[self.group.memberList count] showingAll:showingAllMembers ableToAdd:ableToAdd ableToDelete:ableToDelete isDeleteMode:self.inDeleteMode];
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if (showingAllMembers) {
            showingAllMembers = FALSE;
        }
        else{
            showingAllMembers = TRUE;
        }
        
        [self.mytableView reloadData];
        [self.mytableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (void)exitAction
{
    [WowTalkWebServerIF groupChat_LeaveGroup:self.groupid withCallback:@selector(didLeaveGroup:) withObserver:self];
}

-(void)viewTheGroupDetail
{
    GroupContactViewController* gcvc = [[GroupContactViewController alloc] init];
    gcvc.groupid = self.groupid;
    gcvc.isStanger = FALSE;
    [self.navigationController pushViewController:gcvc animated:YES];
    [gcvc release];
    
}





@end
