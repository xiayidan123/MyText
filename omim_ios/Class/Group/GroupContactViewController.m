//
//  GroupContactViewController.m
//  omim
//
//  Created by coca on 2013/04/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "GroupContactViewController.h"

#import "WTHeader.h"
#import "PublicFunctions.h"
#import "Constants.h"

#import "GroupInfoBuddyCell.h"

#import "ContactPickerViewController.h"
#import "EditGroupInfoViewController.h"
#import "ContactInfoViewController.h"
#import "GroupAdminViewController.h"
#import "GroupAdminVC.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"
#import "MessagesVC.h"
#import "NonUserContactViewController.h"
#import "OMMessageVC.h"
#import "GalleryViewController.h"

#define TAG_SWITCHER    1
#define TAG_LABEL   2
#define TEST_TEXT           @"我们是屌丝，我们是屌丝，拉拉拉拉拉拉拉"

@interface GroupContactViewController ()<GroupAdminVCDelegate>
{
    BOOL showingAllMembers;
    BOOL ableToDelete;
    BOOL ableToAdd;
    UILabel* messageLabel;
    
    UIBarButtonItem* btn_admin;
    BOOL isIOS7ApplyInfoDialogShown;
    UIView *IOS7ApplyAlertView;
    CGRect IOS7ApplyAlertViewFrameOriginal;
}

@property (nonatomic,assign) MemberGridView* gridview;
@property (nonatomic,retain) UIImageView* imageview;
@property (nonatomic,retain) UIButton* btn_chat;
@property (nonatomic,retain) NSArray* selectedMembers;
@property (nonatomic,retain) GroupMember* toBeDeletedMember;


@end


@implementation GroupContactViewController

@synthesize isCreator = _isCreator;
@synthesize isManager = _isManager;
@synthesize isNormalMember = _isNormalMember;


#pragma mark - table delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"InfoCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* deslabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 220, 17)];
            deslabel.tag = TAG_LABEL;
            deslabel.font = [UIFont systemFontOfSize:FONT_SIZE_17];
            deslabel.numberOfLines = 0;
            deslabel.textColor = [UIColor blackColor];
            deslabel.textAlignment = NSTextAlignmentLeft;
            deslabel.adjustsFontSizeToFitWidth = NO;
            deslabel.lineBreakMode = NO;
            deslabel.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:deslabel];
            [deslabel release];
        }
        
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:TAG_LABEL];
        
        if (indexPath.row == 0) {
//            cell.detailTextLabel.text = @"";
//            cell.textLabel.text = NSLocalizedString(@"Location", nil);
//            label.text = self.group.createdPlace;
            cell.detailTextLabel.text = @"";
            cell.textLabel.text = NSLocalizedString(@"Group type", nil);
            label.text = [UserGroup groupType:self.group.groupType];
        }
        else if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"";
            cell.textLabel.text = NSLocalizedString(@"Group type", nil);
            label.text = [UserGroup groupType:self.group.groupType];
        }
        
        int width = [UILabel labelWidth:cell.textLabel.text FontType:17 withInMaxWidth:300 ]> 70? [UILabel labelWidth:cell.textLabel.text FontType:17 withInMaxWidth:300 ]: 70;
        
        [label setFrame:CGRectMake(width+ 20, 10, 220, 24)];
        return cell;
    }
    else if (indexPath.section == 1){
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"InfoCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* deslabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 220, 40)];
            deslabel.tag = TAG_LABEL;
            deslabel.font = [UIFont systemFontOfSize:FONT_SIZE_17];
            deslabel.numberOfLines = 0;
            deslabel.textColor = [UIColor blackColor];
            deslabel.textAlignment = NSTextAlignmentLeft;
            deslabel.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:deslabel];
            [deslabel release];
        }
        
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:TAG_LABEL];
        cell.detailTextLabel.text = @"";
        cell.textLabel.text = NSLocalizedString(@"Group Introduction", nil);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        label.text = self.group.introduction;
        
       
        int widthLabel=[UILabel labelWidth:cell.textLabel.text FontType:17 withInMaxWidth:300 ] + 10;
        int width = widthLabel > 70? widthLabel: 70;
        
        int widthHeight=[UILabel labelHeight:self.group.introduction FontType:18.0 withInMaxWidth:290 - width] + 30;
        int height =  widthHeight > 50? widthHeight  : 50;
        
        [label setFrame:CGRectMake(width, 0, 220, height)];
        
        return cell;
    }
    else if (indexPath.section == 2){
        
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
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView* headerview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 118)] autorelease];
        
        UIImageView* bg = [[UIImageView alloc] initWithFrame:headerview.frame];
        [bg setImage:[UIImage imageNamed:CONTACT_INFO_BG]];
        [headerview addSubview:bg];
        [bg release];
       
        self.imageview = [[[UIImageView alloc] initWithFrame:CGRectMake(PERSON_INFO_X_14, PERSON_INFO_Y_14, PERSON_INFO_MSG_BUTTON_WIDTH, PERSON_INFO_MSG_BUTTON_HEIGHT)] autorelease];
        self.imageview.layer.cornerRadius = PERSON_INFO_MSG_BUTTON_WIDTH/2;
        self.imageview.layer.masksToBounds = YES;
        
        //TODO: change to group avatar;
        NSData* data = [AvatarHelper getThumbnailForGroup:self.group.groupID];
        
        if (data) {
            self.imageview.image =  [UIImage imageWithData:data];
        } else {
            self.imageview.image = [UIImage imageNamed:DEFAULT_GROUP_AVATAR];
        }
        
        [headerview addSubview:self.imageview];
        
        UIButton* btn = [[UIButton alloc] initWithFrame:self.imageview.frame];
        [btn addTarget:self action:@selector(viewAvatar) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:btn];
        [btn release];

        
        UILabel *nameLabel= [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, PERSON_INFO_Y_10,PERSON_INFO_WIDTH_160, PERSON_INFO_HEIGHT_20)];
        nameLabel.adjustsFontSizeToFitWidth = NO;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_17];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.shadowColor = [UIColor blackColor];
        nameLabel.shadowOffset = CGSizeMake(1, 1);
        nameLabel.text = self.group.groupNameLocal;
        [headerview addSubview:nameLabel];
        [nameLabel release];
        
        
        self.btn_chat = [[[UIButton alloc] initWithFrame:CGRectMake(118, 74, 60, 36)] autorelease];
        [self.btn_chat setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];

        if (self.isStanger) {
            [self.btn_chat addTarget:self action:@selector(applyForJoinGroup) forControlEvents:UIControlEventTouchUpInside];
            [self.btn_chat setTitle:NSLocalizedString(@"ConfirmApplyJoinGroup",nil) forState:UIControlStateNormal];
        }
        else{
            [self.btn_chat setImage:[UIImage imageNamed:@"profile_btn_message.png"] forState:UIControlStateNormal];
            [self.btn_chat setImage:[UIImage imageNamed:@"profile_btn_message_p.png"] forState:UIControlStateHighlighted];
            [self.btn_chat addTarget:self action:@selector(chatWithGroup) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    
        
        /*
        
        messageLabel = [[UILabel alloc] initWithFrame:self.btn_chat.frame];
        messageLabel.adjustsFontSizeToFitWidth = NO;
        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        if (self.isStanger) {
            [messageLabel setText:NSLocalizedString(@"ConfirmApplyJoinGroup", nil)];
        } else {
//            messageLabel.text = NSLocalizedString(@"Chat", nil);
            messageLabel.text = nil;
        }
        messageLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        messageLabel.shadowOffset = CGSizeMake(0, 1);
        */
        
        
        NSString *idText = NSLocalizedString(@"Group ID:", nil);
//        CGSize idLabelSize = [idText sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE_12] constrainedToSize:CGSizeMake(320, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        CGSize size=CGSizeMake(320, 1000);
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE_12];
        NSDictionary *atttibutes=@{NSFontAttributeName:font};
        CGSize idLabelSize = [idText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:atttibutes context:nil].size;
        
        
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, PERSON_INFO_Y_44, idLabelSize.width, PERSON_INFO_HEIGHT_15)];
        idLabel.adjustsFontSizeToFitWidth = NO;
        idLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        idLabel.backgroundColor = [UIColor clearColor];
        idLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
        idLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_12];
        idLabel.textAlignment = NSTextAlignmentLeft;
        idLabel.text = NSLocalizedString(@"Group ID:", nil);
        idLabel.shadowColor = [UIColor blackColor];
        idLabel.shadowOffset = CGSizeMake(1, 1);
        
        UILabel *idValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(idLabel.frame.origin.x + idLabel.frame.size.width + 6,PERSON_INFO_Y_44,PERSON_INFO_WIDTH_120,PERSON_INFO_HEIGHT_15)];
        idValueLabel.adjustsFontSizeToFitWidth = NO;
        idValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        idValueLabel.backgroundColor = [UIColor clearColor];
        idValueLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
        idValueLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_12];
        idValueLabel.textAlignment = NSTextAlignmentLeft;
        idValueLabel.text = self.group.shortid;
        idValueLabel.shadowColor = [UIColor blackColor];
        idValueLabel.shadowOffset = CGSizeMake(1, 1);
        
        [headerview addSubview:self.btn_chat];
        //[headerview addSubview:messageLabel];
        [headerview addSubview:idLabel];
        [headerview addSubview:idValueLabel];
        
        [idLabel release];
        [idValueLabel release];
        //[messageLabel release];
        
    /*    UIImageView* iv_avatarframe = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 104, 104)];
        [iv_avatarframe setImage:[UIImage imageNamed:AVATAR_MASK_FRAME]];
        [headerview addSubview:iv_avatarframe];
        [iv_avatarframe release];
      */  
        return headerview;
        
    }
    else return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 129;
    }
    else
        return 10;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 1;
    }
    else if (section == 2){
        
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
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    else if (indexPath.section == 1) {

        int widthLabel=[UILabel labelWidth:NSLocalizedString(@"Group Introduction", nil) FontType:17 withInMaxWidth:300 ] + 10;
        int width = widthLabel > 70? widthLabel: 70;
        
        int widthHeight=[UILabel labelHeight:self.group.introduction FontType:18.0 withInMaxWidth:290 - width] + 30;
        int height =  widthHeight > 50? widthHeight  : 50;
        
        return   height;
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0){

            return 40 + [MemberGridView heightForViewWithMembers:[self.group.memberList count] showingAll:showingAllMembers ableToAdd:ableToAdd ableToDelete:ableToDelete isDeleteMode:self.inDeleteMode];
        }
        return 44;
    }
    
    return 44;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click the table");
    
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            if (showingAllMembers) {
                showingAllMembers = FALSE;
            }
            else{
                showingAllMembers = TRUE;
            }
            
            [self.tb_detail reloadData];
            [self.tb_detail scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else{
        self.inDeleteMode = FALSE;
        [self.tb_detail reloadData];
    }
    
}

#pragma mark -- button function
- (void)viewAvatar
{
    // if it has no avatar, return.
    if (![AvatarHelper getThumbnailForGroup:self.group.groupID]) {
        return;
    }
    
    GalleryViewController* gvc = [[GalleryViewController alloc] init];
    gvc.isViewGroupAvatar = TRUE;
    gvc.group = self.group;
    [self.navigationController pushViewController:gvc animated:YES];
    [gvc release];
}

-(void)applyForJoinGroup
{
    
    if (IS_IOS7) {
        // Here we need to pass a full frame
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initWithParentView:self.view];
        
        // Add some custom content to the alert view
        [alertView setContainerView:[self createDemoView]];
        
        // Modify the parameters
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects: NSLocalizedString(@"Cancel", nil), NSLocalizedString(@"ConfirmApplyJoinGroup", nil), nil]];
        
        // Use a block instead of a delegate. very tricky way to do.
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            NSLog(@"Block: Button at position %d is clicked on alertView %ld.", buttonIndex, (long)[alertView tag]);
            if (buttonIndex == 1) {
                [WowTalkWebServerIF askToJoinThegroup:self.group.groupID withMessage:[(TextFieldAlertView*)alertView enteredText] withCallback:@selector(didAskedJoinTheGroup:) withObserver:self];
            }
            
            [alertView close];
            isIOS7ApplyInfoDialogShown=false;
        }];
        
        [alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [alertView show];
        isIOS7ApplyInfoDialogShown=true;
        IOS7ApplyAlertView=alertView;
        IOS7ApplyAlertViewFrameOriginal=IOS7ApplyAlertView.frame;
    }
    else{
    
    TextFieldAlertView* alertview = [[TextFieldAlertView alloc] initWithTitle:nil placeholder:NSLocalizedString(@"self introduction", nil) message:NSLocalizedString(@"Apply to join the group", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) okButtonTitle:NSLocalizedString(@"ConfirmApplyJoinGroup", nil)];
    
    [alertview show];
    [alertview release];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
       return YES;
}


- (UIView *)createDemoView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 100)];
    
    UILabel* label_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 290, 20)];
    label_title.text = NSLocalizedString(@"Apply to join the group", nil);
    label_title.textColor = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];
    label_title.font = [UIFont systemFontOfSize:18];
    label_title.backgroundColor = [UIColor clearColor];
    label_title.textAlignment = NSTextAlignmentCenter;
    
    [titleView addSubview:label_title];
    [label_title release];
    
    UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 50.f, 280.0f, 40.0)];
    [theTextField setBackgroundColor:[UIColor clearColor]];
    theTextField.borderStyle = UITextBorderStyleRoundedRect;
    theTextField.textColor = [UIColor blackColor];
    theTextField.font = [UIFont systemFontOfSize:16.0];
    theTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    theTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    theTextField.returnKeyType = UIReturnKeyDone;
    theTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    theTextField.placeholder = NSLocalizedString(@"self introduction", nil);
    theTextField.delegate = self;
//    [theTextField release];
    
    theTextField.tag = 100;
    
    [titleView addSubview:theTextField];
    [theTextField release];
    
    return titleView;
}

-(void)didAskedJoinTheGroup:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        self.btn_chat.enabled = FALSE;
        [messageLabel setText:NSLocalizedString(@"Request is sent", nil)];
        
    }
}

-(void)chatWithGroup
{
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC createGroupChatRoom:self.group.memberList withGroupID:self.group.groupID];
//    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabbarVC selectTabAtIndex:TAB_MESSAGE];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[OMMessageVC class]]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(void)CheckHistoryMessage
{
    [WTHelper WTLog:@"check history message"];
}

-(void)followOfficalAccount
{
    /*
     [WTNetworkFunction addBuddy:self.account.userID withCallback:@selector(didFollowAccount:) withObserver:self];
     [WTHelper WTLog:@"Follow this account"];
     */
    
}

-(void)unfollowOfficalAccount
{
    //  [WTNetworkFunction ]
    [WTHelper WTLog:@"unfollow this account"];
}


#pragma mark - memebergridview delegate
-(void)becomeDeleteMode:(MemberGridView *)requstor
{
    self.inDeleteMode = TRUE;
    [self.tb_detail reloadData];
    [self.tb_detail scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewRowAnimationTop animated:YES];
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
    else if(!self.inDeleteMode){
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
    [self.tb_detail reloadData];
    
}

#pragma mark -contactpickerdelegate;
-(void)didChooseGroupMembers:(NSArray *)members withRequestor:(ContactPickerViewController *)requestor
{
    self.selectedMembers = [GroupMember normalGroupMembersFromBuddys:members];
    
    [WowTalkWebServerIF groupChat_AddMembers:self.group.groupID withMembers:self.selectedMembers withCallback:@selector(didAddMembers:) withObserver:self];
    
}

#pragma mark - callback function

-(void)didGetMemberList:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
      
        [self loadGroupInfo];
      //  [btn_admin setEnabled:TRUE];  // uibarbutton have to be set like this, otherwise,it doesn't work.
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
        [Database deleteFixedGroupByID:self.groupid];
        [Database deleteChatMessageWithUser:self.groupid];
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
    
}

-(void)didDismissGroup:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [Database deleteFixedGroupByID:self.groupid];
        [Database deleteChatMessageWithUser:self.groupid];
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
}

-(void)didAddMembers:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.group.memberList addObjectsFromArray:self.selectedMembers];
        [self.tb_detail reloadData];
    }
}

-(void)didRemoveMember:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.group.memberList removeObject:self.toBeDeletedMember];
        [self.tb_detail reloadData];
    }
    
}

#pragma mark -- navigation bar
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)admin
{
    [WTHelper WTLog:@"admin the group"];
    
    if (self.isCreator) {
        
        NSString* message = (self.group.isTemporaryGroup)?NSLocalizedString(@"Dismiss the temp group", nil):NSLocalizedString(@"Dismiss the group", nil);
        
        //TODO: put the request number in 管理.
        UIActionSheet *avatarSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"close" , nil) destructiveButtonTitle:message otherButtonTitles:NSLocalizedString(@"Edit group", nil),NSLocalizedString(@"Member management",nil), nil];
        [avatarSheet showInView:self.view];
        [avatarSheet release];
    }
    
    else if (self.isManager){
        UIActionSheet *avatarSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"close" , nil) destructiveButtonTitle:NSLocalizedString(@"quit the group", nil) otherButtonTitles:NSLocalizedString(@"Edit group", nil),NSLocalizedString(@"Member management",nil), nil];
        [avatarSheet showInView:self.view];
        [avatarSheet release];
    }
    else{
        UIActionSheet *avatarSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"close" , nil) destructiveButtonTitle:NSLocalizedString(@"quit the group", nil) otherButtonTitles:nil];
        [avatarSheet showInView:self.view];
        [avatarSheet release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isStanger) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [WowTalkWebServerIF askToJoinThegroup:self.group.groupID withMessage:[(TextFieldAlertView*)alertView enteredText] withCallback:@selector(didAskedJoinTheGroup:) withObserver:self];
        }
    }
    else if (self.isCreator) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [WowTalkWebServerIF dismissGroup:self.group.groupID withCallback:@selector(didDismissGroup:) withObserver:self];
        }
    }
    else{
        if (buttonIndex != alertView.cancelButtonIndex) {
            [WowTalkWebServerIF leaveGroup:self.group.groupID withCallback:@selector(didLeaveGroup:) withObserver:self];
        }
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isManager) {
        switch (buttonIndex) {
            case 0:
                ;
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"quit this group？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];

                [alert show];
                [alert release];
                break;
            case 1:
                ;
                EditGroupInfoViewController* egivc = [[EditGroupInfoViewController alloc] init];
                egivc.group = self.group;
                [self.navigationController pushViewController:egivc animated:YES];
                [egivc release];
                break;
            case 2:
                ;
                GroupAdminVC* gavc = [[GroupAdminVC alloc]init];
                gavc.groupid = self.group.groupID;
                gavc.isCreator = self.isCreator;
                gavc.isManager = self.isManager;
                gavc.delegate = self;
                [self.navigationController pushViewController:gavc animated:YES];
                [gavc release];
                
                break;
            default:
                break;
        }
    }
    else if (self.isCreator){
        
        switch (buttonIndex) {
            case 0:
                ;
                NSString* message = (self.group.isTemporaryGroup)?NSLocalizedString(@"Dismiss the temp group?", nil):NSLocalizedString(@"Dismiss the group?", nil);
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];

                [alert show];
                [alert release];
    
                
                break;
                
            case 1:
                // NSLog(@"编辑资料");
                ;
                EditGroupInfoViewController* egivc = [[EditGroupInfoViewController alloc] init];
                egivc.group = self.group;
                [self.navigationController pushViewController:egivc animated:YES];
                [egivc release];
                break;
            case 2:
                //  NSLog(@"管理请求");
                ;
                GroupAdminVC* gavc = [[GroupAdminVC alloc]init];
                gavc.groupid = self.group.groupID;
                gavc.isCreator = self.isCreator;
                gavc.isManager = self.isManager;
                gavc.delegate = self;
                [self.navigationController pushViewController:gavc animated:YES];
                [gavc release];
                
                break;
            default:
                break;
        }
    }
    else{
     
        
        switch (buttonIndex) {
            case 0:
                ;
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"quit this group？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                [alert show];
                [alert release];
                
                break;
            default:
                break;
        }
    }
}

-(void)configNav
{
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  NSLocalizedString(@"GroupDetails",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
       [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
    
    if (!self.isStanger && ![Database isClassWithGroupID:_groupid]) {
        btn_admin= [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_SETTINGS_IMAGE] selector:@selector(admin)];
        [self.navigationItem addRightBarButtonItem:btn_admin];
        [btn_admin release];
        
    }
    
}


-(void)authorize
{
    //  self.isStanger = TRUE;
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];

    
    self.tb_detail.scrollEnabled = TRUE;
    [self.tb_detail setBackgroundView:nil];
    self.tb_detail.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self.tb_detail setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *topview = [[[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)] autorelease];
    topview.backgroundColor = [Colors blackColorUnderTable];
    
    [self.tb_detail addSubview:topview];
    
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
    }
    isIOS7ApplyInfoDialogShown=false;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!self.NoNeedToInitGroup) {
        [WowTalkWebServerIF groupChat_GetGroupMembers:self.groupid withCallback:@selector(didGetMemberList:) withObserver:self];
        [WowTalkWebServerIF getUserGroupDetail:self.groupid isCreator:FALSE withCallback:@selector(didGetGroupInfo:) withObserver:self];
    }
    
    [self loadGroupInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark keyboard notification
// this is called when the mode is changed to keyboard mode or the inputbox is clicked
-(void) keyboardWillShow:(NSNotification *)note{
    if (isIOS7ApplyInfoDialogShown) {
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        
        IOS7ApplyAlertView.frame=CGRectMake(IOS7ApplyAlertViewFrameOriginal.origin.x, IOS7ApplyAlertViewFrameOriginal.origin.y - 50,
                                      IOS7ApplyAlertViewFrameOriginal.size.width, IOS7ApplyAlertViewFrameOriginal.size.height);
        
        
        // commit animations
        [UIView commitAnimations];
    }
}

// we hide it when the textfield lost focus. Text_Mode and special mode is different.
-(void) keyboardWillHide:(NSNotification *)note{
    if (isIOS7ApplyInfoDialogShown) {
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        
        IOS7ApplyAlertView.frame=IOS7ApplyAlertViewFrameOriginal;
        
        // commit animations
        [UIView commitAnimations];
    }
}

-(void)loadGroupInfo
{
 
    
    if (!self.NoNeedToInitGroup) {
        self.group = [Database getFixedGroupByID:self.groupid];
        self.group.memberList = [Database getAllMembersInFixedGroup:self.groupid];
    }
    

    
    [self authorize];
      [self configNav];
    
    ableToDelete = FALSE;
    ableToAdd = FALSE;
    
    if (self.isCreator || self.isManager) {
        ableToAdd = TRUE;
        ableToDelete = TRUE;
    }
    [self.tb_detail reloadData];
        if ([self.group.memberList count] > 0) {
        [btn_admin setEnabled:TRUE];
    }
    else
        [btn_admin setEnabled:FALSE];
}

#pragma mark - 
#pragma mark - GroupAdminVCDelegate
- (void)didChangeManage{
    [_tb_detail reloadData];
}

@end
