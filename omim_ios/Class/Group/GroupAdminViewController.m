//
//  GroupAdminViewController.m
//  omim
//
//  Created by coca on 2013/05/01.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "GroupAdminViewController.h"
#import "WTHeader.h"
#import "ContactPreviewCell.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "CustomButton.h"

#import "ContactInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ApplyViewController.h"

@interface GroupAdminViewController ()

@property int workingrow;
@end
#define TAG_LABEL 7

#define TAG_CELL_ACCEPT_BUTTON                      1
#define TAG_CELL_REFUSE_BUTTON                      2
#define TAG_CELL_ACCEPT_BUTTON_LABLE                3
#define TAG_CELL_REFUSE_BUTTON_LABLE                4
#define TAG_AVATAR                                  5
#define TAG_NAME                                    6

@implementation GroupAdminViewController

#pragma mark - callback

-(void)didRemoveManager:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        GroupMember* member = [self.arr_members objectAtIndex:self.workingrow];
        member.isManager = FALSE;
        [self.tb_members reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.workingrow inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)didSetManager:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        GroupMember* member = [self.arr_members objectAtIndex:self.workingrow];
        member.isManager = TRUE;
        [self.tb_members reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.workingrow inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)getThumbnail:(NSNotification*)notif
{
    
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if(error.code == NO_ERROR) {
        [self.tb_members reloadData];
    }
    
}

-(void)didHandleGroupApplicationRequest:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [WowTalkWebServerIF getPendingMembers:self.groupid withCallback:@selector(didFetchPendingMembers:) withObserver:self];
    }
}

#pragma mark -button method

-(void)acceptGroupApplication:(id)sender
{
    CustomButton* btn = (CustomButton*)sender;
    PendingRequest* request = [self.arr_requests objectAtIndex:btn.row];
    [WowTalkWebServerIF acceptJoinApplicationFor:self.groupid FromUser:request.buddyid  withCallback:@selector(didHandleGroupApplicationRequest:) withObserver:self];
}

-(void)refuseGroupApplication:(id)sender
{
    CustomButton* btn = (CustomButton*)sender;
    PendingRequest* request = [self.arr_requests objectAtIndex:btn.row];
    [WowTalkWebServerIF rejectCandidate:request.buddyid toJoinGroup:self.groupid withCallback:@selector(didHandleGroupApplicationRequest:) withObserver:self];
}

-(void)removeManager:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int row = btn.tag;
    self.workingrow = row;
    GroupMember* member = [self.arr_members objectAtIndex:row];
    [WowTalkWebServerIF setLevel:@"9" forUser:member.userID forGroup:self.groupid withCallback:@selector(didRemoveManager:) withObserver:self];
}

-(void)setManager:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int row = btn.tag;
    self.workingrow = row;
    GroupMember* member = [self.arr_members objectAtIndex:row];
    [WowTalkWebServerIF setLevel:@"1" forUser:member.userID forGroup:self.groupid withCallback:@selector(didSetManager:) withObserver:self];
}

#pragma mark -
#pragma mark - table view delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        NSString* identifier = @"requestcell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier] autorelease];
            
            int width1 = [UILabel labelWidth:NSLocalizedString(@"Accecpt", nil) FontType:16 withInMaxWidth:60];
            
            int width2 = [UILabel labelWidth:NSLocalizedString(@"Reject", nil) FontType:16 withInMaxWidth:60];
            
            int width = width1> width2 ? width1:width2;
            width = width>50?width:50;
            
            CustomButton* btn_accpet = [[CustomButton alloc] init];
            [btn_accpet setFrame:CGRectMake(300-2*width, 6, width, 32)];
            [btn_accpet setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
            btn_accpet.tag = TAG_CELL_ACCEPT_BUTTON;
            [cell.contentView addSubview:btn_accpet];
            [btn_accpet release];
            
            UILabel* lbl_desc = [[UILabel alloc] initWithFrame:btn_accpet.frame];
            lbl_desc.tag = TAG_CELL_ACCEPT_BUTTON_LABLE;
            lbl_desc.backgroundColor = [UIColor clearColor];
            lbl_desc.textColor = [UIColor whiteColor];
            lbl_desc.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
            lbl_desc.textAlignment = NSTextAlignmentCenter;
            [lbl_desc setText:NSLocalizedString(@"Accecpt", nil)];
            [cell.contentView addSubview:lbl_desc];
            
            [lbl_desc release];
            
            CustomButton* btn_refuse = [[CustomButton alloc] init];
            [btn_refuse setFrame:CGRectMake(310-width, 6, width, 32)];
            [btn_refuse setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
            btn_refuse.tag = TAG_CELL_REFUSE_BUTTON;
            [cell.contentView addSubview:btn_refuse];
            [btn_refuse release];
            
            UILabel* lbl_refuse = [[UILabel alloc] initWithFrame:btn_refuse.frame];
            lbl_refuse.tag = TAG_CELL_REFUSE_BUTTON_LABLE;
            lbl_refuse.backgroundColor = [UIColor clearColor];
            lbl_refuse.textColor = [UIColor whiteColor];
            lbl_refuse.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
            lbl_refuse.textAlignment = NSTextAlignmentCenter;
            
            [lbl_refuse setText:NSLocalizedString(@"Reject", nil)];
            [cell.contentView addSubview:lbl_refuse];
            [lbl_refuse release];
            
            
            UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 5.0f;
            
            imageview.tag = TAG_AVATAR;
            [cell.contentView addSubview:imageview];
            [imageview release];
            
            UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 5.0f, 155, 40)];
            
            name.backgroundColor = [UIColor clearColor];
            name.textColor = [UIColor blackColor];
            name.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_15];
            name.textAlignment = NSTextAlignmentLeft;
            name.numberOfLines = 3;
            name.minimumScaleFactor = 7;
            name.adjustsFontSizeToFitWidth = TRUE;
            
            name.tag = TAG_NAME;
            [cell.contentView addSubview:name];
            [name release];
            
            UIImageView* divider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
            [divider setImage:[UIImage imageNamed:@"divider_320.png"]];
            [cell.contentView addSubview:divider];
            [divider release];
            
        }
        
        UILabel* name = ( UILabel*)[[cell contentView] viewWithTag:TAG_NAME];
        UIImageView* imageview = (UIImageView* )[cell.contentView viewWithTag:TAG_AVATAR];
        CustomButton* btn_accept = (CustomButton*)[cell.contentView viewWithTag:TAG_CELL_ACCEPT_BUTTON];
        CustomButton* btn_refuse = (CustomButton*)[cell.contentView viewWithTag:TAG_CELL_REFUSE_BUTTON];
        
        btn_refuse.row = indexPath.row;
        btn_refuse.section = indexPath.section;
        
        btn_accept.row = indexPath.row;
        btn_accept.section = indexPath.section;
        
        PendingRequest* request = [self.arr_requests objectAtIndex:indexPath.row];
        
        name.text = request.nickname;
        NSData* data = [AvatarHelper getThumbnailForUser:request.buddyid];
        if (data){
            [imageview setImage: [UIImage imageWithData:data]];
        }
        else{
            [imageview setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        
            [WowTalkWebServerIF getThumbnailForUserID:request.buddyid withCallback:@selector(getThumbnail:) withObserver:self];
        }
    
        
        [btn_accept addTarget:self action:@selector(acceptGroupApplication:) forControlEvents:UIControlEventTouchUpInside];
        [btn_refuse addTarget:self action:@selector(refuseGroupApplication:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }
    else if(indexPath.section == 1) {
        
        ContactPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTableCell"];
        
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactPreviewCell" owner:self options:nil] lastObject];
            cell.btn_admin = [[[UIButton alloc] initWithFrame:CGRectMake(300, 9, 50, 32)] autorelease];
            UILabel* lbl = [[UILabel alloc] initWithFrame:cell.btn_admin.frame] ;
            lbl.backgroundColor = [UIColor clearColor];
            lbl.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_15];
            lbl.textColor = [UIColor whiteColor];
        //    lbl.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        //    lbl.shadowOffset = CGSizeMake(0, 1);
            lbl.tag = TAG_LABEL;
            lbl.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:cell.btn_admin];
            [cell.contentView addSubview:lbl];
            [lbl release];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.btn_admin.hidden = TRUE;
        
        UILabel* label = (UILabel*)[cell viewWithTag:TAG_LABEL];
        label.hidden = TRUE;

        cell.btn_admin.tag = indexPath.row;
        cell.btn_admin.hidden = FALSE;
        label.hidden = FALSE;
        
        GroupMember* buddy = [self.arr_members objectAtIndex:indexPath.row];
        
        NSString* str1 =  NSLocalizedString(@"normal member", nil);
        NSString* str2 = NSLocalizedString(@"Adminstrator", nil);
        
        int width1 = [UILabel labelWidth:str1 FontType:16 withInMaxWidth:100];
        int width2 = [UILabel labelWidth:str2 FontType:16 withInMaxWidth:100];
        int width = width1> width2? width1:width2;
        
        width = width>60? width:60;
        
        NSString* str;
        if (buddy.isManager) {
            str = NSLocalizedString(@"normal member", nil);
            [cell.btn_admin setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_GRAY_BUTTON]  forState:UIControlStateNormal];
            [cell.btn_admin addTarget:self action:@selector(removeManager:) forControlEvents:UIControlEventTouchUpInside];
            label.textColor = [Colors grayColorSeven];
        }
        else{
            str = NSLocalizedString(@"Adminstrator", nil);
            [cell.btn_admin setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
            [cell.btn_admin addTarget:self action:@selector(setManager:) forControlEvents:UIControlEventTouchUpInside];
            if ([label isKindOfClass:[UIButton class]]){
                [(UIButton *)label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                label.textColor = [UIColor whiteColor];
            }
            
        }
        
        [cell.btn_admin setFrame:CGRectMake(320-width-10, 9, width, 32)];
        
        [label setFrame:cell.btn_admin.frame];
        if ([label isKindOfClass:[UIButton class]]){
            [(UIButton *)label setTitle:str forState:UIControlStateNormal];
            ((UIButton *)label).titleLabel.font = [UIFont systemFontOfSize:14];
        }else{
            label.text = str;
            label.font = [UIFont systemFontOfSize:14];
        }
        
        
        cell.buddy = buddy;
        [cell loadView];
        
        [cell.signatureLabel setFrame:CGRectMake(cell.signatureLabel.frame.origin.x, cell.signatureLabel.frame.origin.y, cell.btn_admin.frame.origin.x - 10 - cell.signatureLabel.frame.origin.x, cell.signatureLabel.frame.size.height)];
        
        return cell;
    }
    
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.arr_requests count];
    }
    else if (section == 1){
        return [self.arr_members count];
    }
    return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isManager) {
        return 1;
    }
    else if (self.isCreator){
        return 2;
    }
    else return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CONTACT_TABLEVIEWCELL_HEIGHT;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ApplyViewController* avc = [[ApplyViewController alloc] init];
        PendingRequest* request = [self.arr_requests objectAtIndex:indexPath.row];
        UserGroup* group = [Database getFixedGroupByID:self.groupid];
        avc.isApplyForGroup = TRUE;
        avc.buddyid = request.buddyid;
        avc.groupid = self.groupid;
        avc.name = group.groupNameLocal;
        avc.name = request.nickname;
        avc.helloword = request.msg;
        [self.navigationController pushViewController:avc animated:YES];
        [avc release];
        
    }
    else{
        Buddy* buddy = [self.arr_members objectAtIndex:indexPath.row];
        ContactInfoViewController *contactInfoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
        
        contactInfoViewController.buddy = buddy;
        if (buddy.isFriend) {
            contactInfoViewController.contact_type = CONTACT_FRIEND;
        }
        else{
            contactInfoViewController.contact_type = CONTACT_STRANGER;
        }
        
        [self.navigationController pushViewController:contactInfoViewController animated:YES];
        [contactInfoViewController release];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tb_members) {
        return CONTACT_TABLEVIEWCELL_SECTION_HEIGHT;
    }
    
    else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tb_members) {
        
        NSString *sectionTitle;
        if (section == 0) {
            sectionTitle = NSLocalizedString(@"Join Application", nil);
        }
        else
            sectionTitle = NSLocalizedString(@"Member authority", nil);
        
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
    else {
        return nil;
    }
}


#pragma mark - call back
-(void)didFetchPendingMembers:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        //     NSArray* result = [[notif userInfo] valueForKey:WT_PENDING_REQUEST];
        self.arr_requests =  [[notif userInfo] valueForKey:WT_PENDING_REQUEST];
        [self.tb_members reloadData];
    }
}

#pragma mark -- navigation bar
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNav
{
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  NSLocalizedString(@"Member management",nil);
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
    
    if (self.arr_members == nil) {
        self.arr_members = [Database getAllMembersButMeInFixedGroup:self.groupid]; // better to get one from server.
    }
    
    for (int i = 0; i<[self.arr_members count];i ++ ) {
        
        GroupMember* member = [self.arr_members objectAtIndex:i];
        if (member.isCreator) {
            [self.arr_members removeObject:member];
            continue;
        }
    }
    
    if (self.arr_requests == nil) {
        self.arr_requests = [[[NSMutableArray alloc] init] autorelease];
    }
    
    
    [self.tb_members setBackgroundView:nil];
    self.tb_members.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self.tb_members setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tb_members reloadData];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:false];
        [self setAutomaticallyAdjustsScrollViewInsets:false];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [WowTalkWebServerIF getPendingMembers:self.groupid withCallback:@selector(didFetchPendingMembers:) withObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end