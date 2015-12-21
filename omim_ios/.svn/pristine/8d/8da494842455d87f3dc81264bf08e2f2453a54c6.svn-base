//
//  CreateGroupViewController.m
//  omim
//
//  Created by coca on 2013/04/24.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "CreateGroupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"

#import "GroupInfoBuddyCell.h"
#import "GroupMember.h"

#import "ContactPickerViewController.h"

#import "ContactInfoViewController.h"

#import "CustomActionSheet.h"

#import "ViewDetailedLocationVC.h"
#import "CustomAnnotation.h"

#import "ChangeGroupNameViewController.h"
#import "NonUserContactViewController.h"
#import "UIPlaceHolderTextView.h"
#import "ChoosePlaceViewController.h"

#define TAG_AVATAR    1
#define TAG_LABEL   2
#define TAG_INPUTFIELD 3
#define TAG_FRAME      4
#define TAG_SHOULD_GO_BACK 100;


@interface CreateGroupViewController ()<ContactPickerViewControllerDelegate,ChangeGroupNameDelegate>
{
    BOOL ableToDelete;
    BOOL ableToAdd;
    BOOL keyboardIsShown;
    
    UIImagePickerController* picker;
    BOOL hasUploadedAvatar;
    BOOL hasUploadedThumbnail;
    
    BOOL hasAddedMembers;
    BOOL hasUpdateThumbnailTimestamp;
    BOOL hasMemberToAdd;
    BOOL hasNewThumbnail;
    BOOL hasSomeErr;
    BOOL didDeleteMember;
    
    BOOL groupTpyeActionSheetIsShow;
    
    UIPlaceHolderTextView* tf_input;
    UITapGestureRecognizer* tap;
    
    
    CGFloat oldOffset_height;
    BOOL isCreatingGroup;
}
@property (nonatomic,retain) NSString* groupid;
@property (nonatomic,assign) MemberGridView* gridview;
@property (nonatomic,retain) NSMutableArray* memberlist;
@property (nonatomic,retain) NSString* imagepath;
@property (nonatomic,retain) NSString* groupname;
@property (nonatomic,retain) NSString* place;

@property (nonatomic,retain) NSString* introduction;
@property (nonatomic, retain) UIBarButtonItem *rightButton;

@property  NSString* type;
@property (nonatomic) NSInteger location;

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end

@implementation CreateGroupViewController
@synthesize tb_group = _tb_group;
@synthesize group = _group;
@synthesize inDeleteMode = _inDeleteMode;
@synthesize gridview = _gridview;
@synthesize memberlist = _memberlist;
@synthesize groupid  = _groupid;
@synthesize rightButton = _rightButton;




#pragma mark -
#pragma mark - GridViewDelegate

-(void)becomeDeleteMode:(MemberGridView *)requstor
{
    self.inDeleteMode = TRUE;
    [self.tb_group reloadData];
    [self.tb_group scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewRowAnimationTop animated:YES];
}

-(void)didDeleteMember:(GroupMember *)member inGridView:(MemberGridView *)requestor
{
    [self.memberlist removeObject:member];
    [self.tb_group reloadData];
    didDeleteMember = YES;
    // [self.tb_detail scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)becomeAddMode:(MemberGridView *)requestor
{
   // NSLog(@"try to add members");
    
    ContactPickerViewController* cpvc = [[ContactPickerViewController alloc] init];
    cpvc.isManageGroupMember = TRUE;
    cpvc.exsitingBuddys = self.memberlist;
    cpvc.delegate = self;
    [self.navigationController pushViewController:cpvc animated:YES];
    [cpvc release];
}

-(void)didSelectMember:(GroupMember *)member inGridView:(MemberGridView *)requestor
{
    if ([member.buddy_flag isEqualToString:@"2"]) {
        
        NonUserContactViewController* nucvc = [[NonUserContactViewController alloc] init];
        nucvc.buddy =[Database buddyWithUserID:member.userID];
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
        
        if (didDeleteMember == YES) {
            didDeleteMember = NO;
            return;
        }else{
            
             [self.navigationController pushViewController:civc animated:YES];
        }
        
       // [self.navigationController pushViewController:civc animated:YES];
        [civc release];
    }
}

-(void)dismissDeleteMode:(id)sender
{
    self.inDeleteMode = FALSE;
    [self.tb_group reloadData];
    
}

#pragma mark -contactpickerdelegate;
-(void)didChooseGroupMembers:(NSArray *)members withRequestor:(ContactPickerViewController *)requestor
{
    NSArray* selectedgroupmembers = [GroupMember normalGroupMembersFromBuddys:members];
    
    [self.memberlist addObjectsFromArray:selectedgroupmembers];
    [self.tb_group reloadData];
}


#pragma mark - scrollview delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self dismissKeyboard];
}


#pragma mark -
#pragma mark - table view delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 || section == 1) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"introcell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"introcell"] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel* deslabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 7, 205, 30)];
            deslabel.tag = TAG_LABEL;
            deslabel.font = [UIFont systemFontOfSize:FONT_SIZE_17];
            deslabel.numberOfLines = 0;
            deslabel.textColor = [UIColor blackColor];
            deslabel.textAlignment = NSTextAlignmentRight;
            deslabel.adjustsFontSizeToFitWidth = NO;
            deslabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            deslabel.backgroundColor = [UIColor clearColor];
            
            UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(220, 5, 50, 50)];
            imageview.tag = TAG_AVATAR;
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 5.0f;
            
            UIImageView* imageframe = [[UIImageView alloc] initWithFrame:imageview.frame];
            imageframe.tag = TAG_FRAME;
        //    [imageframe setImage:[UIImage imageNamed:AVATAR_MASK_FRAME]];
            
            
            [cell.contentView addSubview:deslabel];
            [deslabel release];
            [cell.contentView addSubview:imageview];
            cell.detailTextLabel.text = @"";
            [imageview release];
            
            [cell.contentView addSubview:imageframe];
            
            [imageframe release];
            
        }
        
        UIImageView* imageview = (UIImageView*)[cell.contentView viewWithTag:TAG_AVATAR];
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:TAG_LABEL];
        
        UIImageView* imageframe = (UIImageView*)[cell.contentView viewWithTag:TAG_FRAME];
        
        imageframe.hidden = true;
        label.hidden = false;
        imageview.hidden = TRUE;
        
        if (section == 0 && row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Group name", nil);
            label.text = self.groupname;
        }
        else if (section == 0 && row == 1){
            imageview.hidden = false;
            label.hidden = TRUE;
            imageframe.hidden = FALSE;
            cell.textLabel.text = NSLocalizedString(@ "Group avatar", nil);
            UIImage* image = [[UIImage alloc] initWithContentsOfFile:self.imagepath]; // image path has to be absolute;
            if (image) {
                [imageview setImage:image];
                [image release];
            }
            else
                [imageview setImage:[UIImage imageNamed:DEFAULT_GROUP_AVATAR]];
        }
        else if (section == 1){
            if (row == 0) {
//                cell.textLabel.text = NSLocalizedString(@"Location", nil);
//                label.text = self.place;
                cell.textLabel.text = NSLocalizedString(@"Group type", nil);
                if (self.type == nil) {
                    self.type = @"class";
                }
                label.text = [UserGroup groupType:self.type];
            }
            //redmine 160
//            else if (row == 1){
//                cell.textLabel.text = NSLocalizedString(@"Group type", nil);
//                if (self.type == nil) {
//                    self.type = @"class";
//                }
//                label.text = [UserGroup groupType:self.type];
//            }
        }
        
        CGFloat width = [UILabel labelWidth:cell.textLabel.text FontType:17 withInMaxWidth:300];
        label.frame = CGRectMake(width + 20, 7, 255 - width, 30);
        
        return cell;
    }
    
    else if (section == 2){
        
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
        label.text = [NSString stringWithFormat:NSLocalizedString(@"Members(%d)", nil), [self.memberlist count]];
        [label setFrame:CGRectMake(10, 10, 300, 30)];
        label. textAlignment = NSTextAlignmentLeft;
            
        if (_gridview && [_gridview superview]!=nil) {
            [_gridview removeFromSuperview];
        }
        
        _gridview = [[MemberGridView alloc] initWithFrame:CGRectMake(10, 40, 58*5, 2 * 79) withMembers:self.memberlist showingAllMembers:TRUE ableToAdd:TRUE ableToDelete:true isCreator:TRUE isManager:NO isDeleteMode:self.inDeleteMode];
        _gridview.ableToDelete = YES;
        _gridview.scrollEnabled = FALSE;
        _gridview.caller = self;
        
        [cell addSubview:_gridview];
        [_gridview release];
        
        return cell;
        
    }
    else if (section == 3){
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InputCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"InputCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:tf_input];
        }
        return cell;
    }
    return nil;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return 1;
    }
    else if (section == 2){
        return 1;
    }
    else if (section == 3){
        return 1;
    }
    else
        return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) return 44;
        else if (row == 1) return 60;
    }
    else if (section == 1){
        return 44;
    }
    else if (section == 2){
        return 40 + [MemberGridView heightForViewWithMembers:[self.memberlist count] showingAll:YES ableToAdd:YES ableToDelete:YES isDeleteMode:self.inDeleteMode];
    }
    else if (section == 3){
        return 100;
    }
    else {
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            ChangeGroupNameViewController* cgnvc = [[ChangeGroupNameViewController alloc] init];
            cgnvc.delegate = self;
            cgnvc.oldGroupName = self.groupname;
            
            [self.navigationController pushViewController:cgnvc animated:TRUE];
        }
        else if (indexPath.row == 1) {
            UIActionSheet *avatarSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel" , nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take a photo", nil),NSLocalizedString(@"Open album",nil), nil];
            [avatarSheet showInView:self.view];
            [avatarSheet release];
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
//            ViewDetailedLocationVC* vdl = [[[ViewDetailedLocationVC alloc] initWithNibName:@"ViewDetailedLocationVC" bundle:nil] autorelease];
//            
//            vdl.mode = PICK_TO_SET_GROUP_POSITION;
//            vdl.delegate = self;
//            
//            [self.navigationController pushViewController:vdl animated:YES];
            if (groupTpyeActionSheetIsShow)return;
            
            if (self.type == nil) {
                self.type =@"class";
            }
            
            CustomActionSheet* actionsheet = [[CustomActionSheet alloc] initGroupPickerWithInitialChoice:self.type delegate:self];
            [actionsheet showInView:self.view];
            [actionsheet release];
            groupTpyeActionSheetIsShow = YES;
        }
        if (indexPath.row == 1) {
            if (self.type == nil) {
                self.type =@"class";
            }
            
            CustomActionSheet* actionsheet = [[CustomActionSheet alloc] initGroupPickerWithInitialChoice:self.type delegate:self];
            [actionsheet showInView:self.view];
        }
    }
    if (indexPath.section != 2) {
        self.inDeleteMode = FALSE;
        [self.tb_group reloadData];
    }
}

#pragma mark - Choose Place Delegate
- (void)didChoosePlace:(NSString *)place
{
    [self.navigationController popViewControllerAnimated:YES];
    self.place = place;
    [self.tb_group reloadData];
}

#pragma mark - actionsheet delegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    if (actionSheet.tag == 101) {
        if (buttonIndex == 0) {
            self.place = NSLocalizedString(@"location.all", nil);
        } else if (buttonIndex == 1) {
            ChoosePlaceViewController *chooseVC = [[ChoosePlaceViewController alloc] init];
            chooseVC.delegate = self;
            [self.navigationController pushViewController:chooseVC animated:YES];
            [chooseVC release];
        } else if (buttonIndex == 2) {
            self.place = NSLocalizedString(@"location.secret", nil);
        }
        [self.tb_group reloadData];
    } else {
        picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        picker.allowsEditing = YES;
        
        //TODO: not good way to wrap all the function here. currently we use it for temp.
        switch (buttonIndex) {
            case 0:
                [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            case 5:
                self.type = [(CustomActionSheet*)actionSheet chosenType];
                [self.tb_group reloadData];
                
            default:
                break;
        }
        [picker release];
    }
    if ([actionSheet isKindOfClass:[CustomActionSheet class]]){
        groupTpyeActionSheetIsShow = NO;
    }
    
}


#pragma mark - 
#pragma mark -- uipickercontroller

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [picker setSourceType:sourceType];
        
        picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *)
                                       kUTTypeImage, nil] autorelease];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}


#pragma mark - UIPickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];//退出照相机
    
    UIImage *thumbnail = [AvatarHelper getThumbnailFromImage:image];
    UIImage *avatar = [AvatarHelper getPhotoFromImage:image];
    

    NSString* thumbpath = [NSFileManager relativePathToDocumentFolderForFile:@"gthumbnail" WithSubFolder:GROUP_AVATAR_THUMBNAIL_FOLDER];
    

  [UIImagePNGRepresentation(thumbnail) writeToFile:[NSFileManager absolutePathForFileInDocumentFolder:thumbpath] atomically:YES];

    NSString* photostr =  [NSFileManager relativePathToDocumentFolderForFile:@"gphoto" WithSubFolder:GROUP_AVATAR_FOLDER];
    NSString* photopath = [NSFileManager absolutePathForFileInDocumentFolder:photostr];
    
    [UIImagePNGRepresentation(avatar) writeToFile:photopath atomically:YES];
    
    self.imagepath = [NSFileManager absolutePathForFileInDocumentFolder:thumbpath];
    [self.tb_group reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    /*添加代码，处理选中图像又取消的情况*/
    [self dismissViewControllerAnimated:YES completion:nil];//退出照相机
}

#pragma mark - map delegate
-(void)getDataFromMap:(ViewDetailedLocationVC *)requestor
{
    
    self.place = requestor.annotation.shortTitle;
    self.latitude = requestor.annotation.coordinate.latitude;
    self.longitude = requestor.annotation.coordinate.longitude;
    
    [self.tb_group reloadData];
}


#pragma mark - change info delegate
-(void)didChangeGroupNameTo:(NSString *)name withRequestor:(ChangeGroupNameViewController *)requestor
{
    self.groupname = name;
    [self.tb_group reloadData];
}


#pragma mark - callback


-(void)modifyAvatarThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        self.imagepath =   [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:self.groupid WithSubFolder:GROUP_AVATAR_THUMBNAIL_FOLDER]];
        
        [self.tb_group reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        NSString* oldphoto = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:@"gphoto" WithSubFolder:GROUP_AVATAR_FOLDER ]];
        
        NSString* lastpathcomponent = self.groupid;
        NSString* newpath = [[oldphoto stringByDeletingLastPathComponent] stringByAppendingPathComponent:lastpathcomponent];
        [[NSFileManager defaultManager] moveItemAtPath:oldphoto toPath:newpath error:nil];
        
        [WowTalkWebServerIF uploadGroupAvatar:newpath forGroup:self.groupid withCallback:@selector(modifyAvatargraph:) withObserver:self];
    }
    else{
        [self fCheckWhetherShouldGoBack];

    }
}
-(void)modifyAvatargraph:(NSNotification *)notification
{
    NSError* error = [[notification userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [WowTalkWebServerIF updateThumbnailTimestamp:self.groupid withCallback:@selector(didUpdateTimestamp:) withObserver:self];
    }
    else{
        [self fCheckWhetherShouldGoBack];

    }
}
-(void)didUpdateTimestamp:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {  
        hasUpdateThumbnailTimestamp = TRUE;
        
    }
    else{
        hasUpdateThumbnailTimestamp = NO;
    }
    
    
    
    [WowTalkWebServerIF getUserGroupDetail:self.groupid isCreator:YES withCallback:@selector(didGetGroupDetail:) withObserver:self];

}


//dismiss the keyboard
-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}



-(void)createGroup
{
    [self.view endEditing:YES];
    self.introduction = tf_input.text;
    
    if ([NSString isEmptyString:[self.groupname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Group name can't be empty", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    if (isCreatingGroup) {
        return;
    }
    [WTHelper WTLog:@"create the group"];
    isCreatingGroup=true;
    [WowTalkWebServerIF createGroup:self.groupname withStatus:self.introduction withPlacename:self.place withLongitude:self.longitude withLatitude:self.latitude withBreifIntroduction:self.introduction withGroupType:self.type withCallback:@selector(didCreateUserGroup:) withObserver:self];
    
}

-(void)didAddMembers:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        hasAddedMembers = TRUE;
    } else {
         hasAddedMembers =false;
    }
    
    [self fCheckWhetherShouldGoBack];



}

-(void)didCreateUserGroup:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString* groupid = [[notif userInfo] valueForKey:WT_GROUP_ID];
        self.groupid = groupid;
        [WowTalkWebServerIF getUserGroupDetail:self.groupid isCreator:YES withCallback:@selector(didGetGroupDetail:) withObserver:self];
        NSString* oldThumbnail =  [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:@"gthumbnail" WithSubFolder:GROUP_AVATAR_THUMBNAIL_FOLDER]];
        NSString* lastpathcomponent = self.groupid;
        NSString* newthumbpath = [[oldThumbnail stringByDeletingLastPathComponent] stringByAppendingPathComponent:lastpathcomponent];
        [[NSFileManager defaultManager] moveItemAtPath:oldThumbnail toPath:newthumbpath error:nil];
     
        if ([NSFileManager hasFileAtPath:newthumbpath]) {
            hasNewThumbnail = YES;
            [WowTalkWebServerIF  uploadGroupAvatarThumbnail:newthumbpath forGroup:self.groupid withCallback:@selector(modifyAvatarThumbnail:) withObserver:self];
        }
        else{
            hasNewThumbnail = NO;
        }
        
        
        if(self.memberlist && [self.memberlist count]>1){
            hasMemberToAdd = YES;
            [WowTalkWebServerIF groupChat_AddMembers:self.groupid withMembers:self.memberlist withCallback:@selector(didAddMembers:) withObserver:self];

        }
        else{
            hasMemberToAdd = NO;
        }
       
        if (!hasNewThumbnail && !hasMemberToAdd) {
            [self fCheckWhetherShouldGoBack];

        }

        
 
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Create group failed!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];

        [alert show];
        [alert release];
        
        isCreatingGroup=false;

    }
    
    
}
-(void)didGetGroupDetail:(NSNotification*)notif
{

    [self fCheckWhetherShouldGoBack];
    
}


-(void)fCheckWhetherShouldGoBack{
    
    NSString* message = NSLocalizedString(@"Create group success!", nil);
    
    
    /*if ((hasMemberToAdd && !hasAddedMembers) || (hasNewThumbnail &&  !hasUpdateThumbnailTimestamp)) {
        message = [NSString stringWithFormat:@"%@%@",message,NSLocalizedString(@"(However some information of the group is lost due to network problem.Please try again later.)", nil)];
    }
   */
    
    if ((hasMemberToAdd && !hasAddedMembers) || (hasNewThumbnail &&  !hasUpdateThumbnailTimestamp)){
        return;
    }

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    alert.tag = TAG_SHOULD_GO_BACK;
    [alert show];
    [alert release];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];

}






#pragma mark - View lifecycle
-(void)configNav
{
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  NSLocalizedString(@"Create a group", nil);
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
    
    UIBarButtonItem *rightBarButton = [PublicFunctions getCustomNavDoneButtonWithTarget:self selector:@selector(createGroup)];
    [self.navigationItem addRightBarButtonItem:rightBarButton];
    self.rightButton = _rightButton;
    [rightBarButton release];
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)generateInitialData
{
    self.imagepath = nil;
    self.groupname = @"";
    self.type = @"class";
    self.place = nil;
    
    self.memberlist = [[[NSMutableArray alloc] init] autorelease];
   
    GroupMember* member = [[GroupMember alloc] init];
    member.nickName = [WTUserDefaults getNickname];
    
    if ([NSString isEmptyString:member.nickName]) {
        member.nickName = [WTUserDefaults getWTID];
    }
    member.isCreator = TRUE;
    member.userID = [WTUserDefaults getUid];
    
    [self.memberlist addObject:member];
    [member release];
    

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNav];
    
    [self generateInitialData]; 
    
    self.tb_group.scrollEnabled = TRUE;
    [self.tb_group setBackgroundView:nil];
    self.tb_group.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self.tb_group setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    tf_input = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 5, 270, 80)];
    tf_input.placeholder = NSLocalizedString(@"Please write group introduction", nil);
    [tf_input setTextColor:[UIColor blackColor]];
    [tf_input setBackgroundColor:[UIColor clearColor]];
    tf_input.font = [UIFont systemFontOfSize:15];
    tf_input.delegate = self;
    
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self setAutomaticallyAdjustsScrollViewInsets:FALSE];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self.tb_group setFrame:CGRectMake(0, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];

    }
    
    isCreatingGroup=false;

}


-(void)viewWillAppear:(BOOL)animated
{
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

#pragma mark - keyboard notification- not blocking the textfield.
-(void) keyboardWillShow:(NSNotification *)n
{
    
    if (keyboardIsShown == NO)
    {
        oldOffset_height = self.tb_group.contentOffset.y;
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        tap.delegate = self;
        [self.tb_group addGestureRecognizer:tap];
        tap.cancelsTouchesInView = TRUE;
        [tap release];
        
        keyboardIsShown = YES;
        
        NSDictionary* keyboardInfo = [n userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        
        int height = keyboardFrameBeginRect.size.height;
    
        [self.tb_group setContentOffset:CGPointMake(0, height+60) animated:TRUE];
    }
}

- (void)keyboardWillHide:(NSNotification *)n
{
    [self.tb_group setContentOffset:CGPointMake(0, oldOffset_height) animated:TRUE];
    keyboardIsShown = NO;
}

-(void)dismissKeyboard
{
  
    if (keyboardIsShown&& [self.tb_group.gestureRecognizers containsObject:tap]) {
         [self.tb_group removeGestureRecognizer:tap];
    }
   
      [tf_input resignFirstResponder];
}



@end
