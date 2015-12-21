//
//  PersonalInfoVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "PublicFunctions.h"
#import "WTUserDefaults.h"
#import "SetCellFrameModel.h"

#import "SetBaseCell.h"

#import "SetUserInforHeadCell.h"

#import "ChangeNickNameVC.h"

#import "GenderVC.h"

#import "ChangeStatusViewController.h"

#import "OMBaseDatePickerCell.h"
#import "OMBaseCellFrameModel.h"
#import "WowTalkWebServerIF.h"

#import "WTHeader.h"


@interface PersonalInfoVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChangeNickNameVCDelegate,GenderVCDelegate,ChangeStatusViewControllerDelegate,OMBaseDatePickerCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView *infor_tableView;


@property (retain, nonatomic) NSMutableArray *itemsArray;

@end

@implementation PersonalInfoVC

- (void)dealloc {
    [_itemsArray release];
    [_infor_tableView release],_infor_tableView.dataSource = nil,_infor_tableView.delegate = nil,_infor_tableView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self uiConfig];
    
}


- (void)prepareData{
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    NSArray *titleArray = @[@[NSLocalizedString(@"头像",nil)],
                            @[NSLocalizedString(@"用户类型",nil)
                              ,NSLocalizedString(@"昵称",nil)
                              ,NSLocalizedString(@"性别",nil)
                              ,NSLocalizedString(@"生日",nil)
                              ,NSLocalizedString(@"个性签名",nil)]];
    NSString *headImage = @"";
    
    NSString *userType = [WTUserDefaults getUsertype];
    if ([userType isEqualToString:@"1"]){
        userType = @"学生";
    }else if ([userType isEqualToString:@"2"]){
        userType = @"老师";
    }else if ([userType isEqualToString:@"0"]){
        userType = @"公众账号";
    }else{
        userType = @"";
    }
    NSString *nickName = [WTUserDefaults getNickname];
    if (nickName == nil)nickName = @"";
    NSInteger genderIndteger = [WTUserDefaults getGender];
    NSString *gender = nil;
    if (genderIndteger == 0){
        gender = @"男";
    }else if (genderIndteger == 1){
        gender = @"女";
    }else if(genderIndteger == 2){
        gender = @"保密";
    }else{
        gender = @"";
    }
    NSString *birthday = [WTUserDefaults getBirthday];
    if (birthday == nil)birthday = @"";
    NSString *status = [WTUserDefaults getStatus];
    if (status == nil)status = @"";
    

    NSArray *contentArray = @[@[headImage],@[userType,nickName,gender,birthday,status]];
    
    NSInteger count = titleArray.count;
    for (int i=0; i<count; i++){
        NSInteger jcount = [titleArray[i] count];
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        for (int j=0; j<jcount; j++ ){
            if (j == 3){
                OMBaseCellFrameModel *model = [[OMBaseCellFrameModel alloc] init];
                model.isOpen = NO;
                model.canEdit = YES;
                OMBaseCellModel *cellModel = [[OMBaseCellModel alloc]init];
                cellModel.title = @"生日";
                NSString *birthday = [WTUserDefaults getBirthday];
                if (birthday.length == 0 || [birthday isEqualToString:@"0000-00-00"]){
                    cellModel.content = @"2005-6-15";
                }else{
                    cellModel.content = birthday ;
                }
                cellModel.type = OMBaseCellModelTypeDatePicker;
                model.cellModel = cellModel;
                [cellModel release];
                [sectionArray addObject:model];
                [model release];
                
            }else{
                SetCellFrameModel *frameModel = [[SetCellFrameModel alloc]init];
                frameModel.cellHeight = (i==0&&j==0 ? 90 : 44);
                frameModel.title = titleArray[i][j];
                frameModel.content = contentArray[i][j];
                frameModel.canEnter = (i==1&&j==0) ? NO :YES;
                [sectionArray addObject:frameModel];
                [frameModel release];
            }
        }
        [itemsArray addObject:sectionArray];
        [sectionArray release];
    }
    self.itemsArray = itemsArray;
    [itemsArray release];
    
}


- (void)uiConfig{
    [self configNav];
    
    self.infor_tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    
}



-(void)configNav{
    self.title = NSLocalizedString(@"My profile",nil);
}

-(void)reloadTableView{
    [self prepareData];
    [self.infor_tableView reloadData];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        SetUserInforHeadCell *cell = [SetUserInforHeadCell cellWithTableView:tableView];
        cell.frameModel = self.itemsArray[indexPath.section][indexPath.row];
        return cell;
        
    }else{
        if (indexPath.row == 3){
            OMBaseDatePickerCell *cell = [OMBaseDatePickerCell cellWithTableView:tableView];
            cell.isSettingVCInit = YES;
            cell.delegate = self;
            cell.cellFrameModel = self.itemsArray[indexPath.section][indexPath.row];
            cell.content_color = [UIColor grayColor];
            return cell;
        }else{
            SetBaseCell *cell = [SetBaseCell cellWithTableView:tableView];
            cell.frameModel = self.itemsArray[indexPath.section][indexPath.row];
            return cell;
        }
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemsArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OMBaseCellFrameModel *model = self.itemsArray[indexPath.section][indexPath.row];
    
    if (indexPath.section == 1 && indexPath.row == 3 ){
        if (model.isOpen == YES){
            return 200;
        }else{
            return 44;
        }
    }
    return model.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                UIActionSheet *avatarSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take a photo",nil),NSLocalizedString(@"从手机相册选择",nil), nil];
                avatarSheet.tag = 2000;
                [avatarSheet showInView:self.view];
                [avatarSheet release];
            }break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                
            }break;
            case 1:{
                ChangeNickNameVC *changeNickNameVC = [[ChangeNickNameVC alloc]initWithNibName:@"ChangeNickNameVC" bundle:nil];
                changeNickNameVC.delegate = self;
                [self.navigationController pushViewController:changeNickNameVC animated:YES];
                [changeNickNameVC release];
            }break;
            case 2:{
                GenderVC *genderVC = [[GenderVC alloc]initWithNibName:@"GenderVC" bundle:nil];
                genderVC.delegate = self;
                [self.navigationController pushViewController:genderVC animated:YES];
                [genderVC release];
            }break;
            case 3:{
                
            }break;
            case 4:{
                ChangeStatusViewController *csvc = [[ChangeStatusViewController alloc] init];
                csvc.delegate = self;
                [self.navigationController pushViewController:csvc animated:YES];
                [csvc release];
            }break;
            default:
                break;
        }
    }
}


#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex])return;
    
    if (actionSheet.tag == 2000) {
        switch (buttonIndex) {
            case 0:
                [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
                
            default:
                return;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        pickerVC.allowsEditing = YES;
        
        [pickerVC setSourceType:sourceType];
        [self presentViewController:pickerVC animated:YES completion:nil];
        [pickerVC release];
        
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    UIImage *thumbnail = [AvatarHelper getThumbnailFromImage:image];
    UIImage *avatar = [AvatarHelper getPhotoFromImage:image];
    
    
    NSString *thumbpath = [NSFileManager absolutePathForFileInDocumentFolder: [NSFileManager relativePathToDocumentFolderForFile:@"mythumbnail" WithSubFolder:SDK_AVATAR_THUMB_DIR]];
    
    BOOL isSucc = [UIImagePNGRepresentation(thumbnail) writeToFile:thumbpath atomically:YES];
    
    if (isSucc){
        [WowTalkWebServerIF uploadMyThumbnail:thumbpath withCallback:@selector(didUploadThumbnailAvatar:) withObserver:self];
    }
    
    
    NSString *photopath = [NSFileManager absolutePathForFileInDocumentFolder: [NSFileManager relativePathToDocumentFolderForFile:@"myphoto" WithSubFolder:SDK_AVATAR_IMAGE_DIR]];
    
    isSucc = [UIImagePNGRepresentation(avatar) writeToFile:photopath atomically:YES];
    if (isSucc){
        [WowTalkWebServerIF uploadMyPhoto:photopath withCallback:@selector(didUploadPhoto:) withObserver:self];
    }
}



#pragma mark - ChangeNickNameVCDelegate

-(void)changeNickNameVC:(ChangeNickNameVC *)changeNickNameVC didChangeNickName:(NSString *)newNickName{
    [self prepareData];
    [self.infor_tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(personalInfoVC:didChangeNickName:)]){
        [self.delegate personalInfoVC:self didChangeNickName:newNickName];
    }
}


#pragma  mark - GenderVCDelegate
-(void)genderVC:(GenderVC *)genderVC didChangeGender:(NSString *)genderType{
    [self prepareData];
    [self.infor_tableView reloadData];
}



#pragma mark - ChangeStatusViewControllerDelegate

-(void)changeStatusViewController:(ChangeStatusViewController *)changeStatusVC didChangeStatus:(NSString *)status{
    [self prepareData];
    [self.infor_tableView reloadData];
}

#pragma mark - OMBaseDatePickerCellDelegate

- (void)baseDatePickerCell:(OMBaseDatePickerCell *)baseDatePickerCell hiddenWithModel:(OMBaseCellFrameModel *)cellFrameModel{
    [self.infor_tableView reloadData];
}

- (void)baseDatePickerCell:(OMBaseDatePickerCell *)baseDatePickerCell changeDateWithModel:(OMBaseCellFrameModel *)cellFrameModel{
    [WowTalkWebServerIF updateMyProfileWithNickName:nil withStatus:nil withBirthday:cellFrameModel.cellModel.content withSex:nil withArea:nil withCallback:@selector(birthdayChanged:) withObserver:self];
}


#pragma mark - NetWork CallBack


- (void)birthdayChanged:(NSNotification *)notification
{
    NSError *err = [[notification userInfo] valueForKey:WT_ERROR];
    
    if (err.code== NO_ERROR) {
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to change birthday",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        [self prepareData];
        [self.infor_tableView reloadData];
        
    }
}


-(void)didUploadThumbnailAvatar:(NSNotification *)notification
{
    NSError* error = [[notification userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self reloadTableView];
        
        if ([self.delegate respondsToSelector:@selector(personalInfoVC:didChangeHeadImageIsThumb:)]){
            [self.delegate personalInfoVC:self didChangeHeadImageIsThumb:YES];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to upload avatar" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}

-(void)didUploadPhoto:(NSNotification *)notification
{
    NSError *err = [[notification userInfo] valueForKey:WT_ERROR];
    
    if (err.code== NO_ERROR) {
        [WowTalkWebServerIF getMyProfileWithCallback:@selector(reloadTableView) withObserver:self];
        if ([self.delegate respondsToSelector:@selector(personalInfoVC:didChangeHeadImageIsThumb:)]){
            [self.delegate personalInfoVC:self didChangeHeadImageIsThumb:NO];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to upload avatar", nil)  message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}















@end
