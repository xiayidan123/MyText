//
//  HomeInMyClassViewController.m
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "HomeInMyClassViewController.h"
#import "WowTalkWebServerIF.h"
#import "OMNetWork_MyClass.h"
#import "MyclassinformationCell.h"
#import "MyClassFunctionCell.h"
#import "LessonCell.h"
#import "OMTableViewHeadView.h"
#import "NewClassDetailVC.h"
#import "OMClass.h"
#import "ClassMemberListVC.h"
#import "ClassBulletinVC.h"
#import "WTUserDefaults.h"
#import "EditClassInformationTableVC.h"
#import "LessonListVC.h"
#import "OMDateBase_MyClass.h"
#import "PublicFunctions.h"
#import "LHImagePickerController.h"
#import "NewAccountSettingVC.h"
#import "OnlineHomeworkVC.h"
#import "UIImage+Resize.h"
#import "Constants.h"
#import "ChatCellConfiguration.h"
#import "DAViewController.h"
#import "LeaveViewController.h"
#import "SignInViewController.h"
#import "TimelineContainerVC.h"
#import <AVFoundation/AVFoundation.h>
#import "Lesson.h"
#import "LessonDetailModel.h"
#import "ChooseClassAndLessonVC.h"
#import "LivingCameraListVC.h"

@interface HomeInMyClassViewController ()<UITableViewDataSource,UITableViewDelegate,MyClassFunctionCellDelegate,UIActionSheetDelegate,EditClassInformationTableVCDelegate,LessonListVCDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) CGSize maxThumbnailSize;
@property (retain, nonatomic) NSMutableArray *lesson_array;
@property (retain, nonatomic) UIImage *HomeworkPhoto;
@property (retain, nonatomic) UIImage *HomeworkThumnailPhoto;
@property (nonatomic,assign) BOOL needCropping;
/**0默认 1拍照答疑 2在线作业 */
@property (assign, nonatomic) BOOL isOn;
@property (assign, nonatomic) int flags;
@property (assign, nonatomic) BOOL isTakingPhoto;
@property (retain, nonatomic) NSMutableArray *selectedPhotos;
@property (retain, nonatomic) ALAssetsLibrary* assetLib;
@property (assign, nonatomic) BOOL dismissFromPicker;
@end

@implementation HomeInMyClassViewController
- (void)dealloc {
    self.HomeworkPhoto = nil;
    self.HomeworkThumnailPhoto = nil;
    self.classModel = nil;
    self.lesson_array = nil;
    self.tableView = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"我的教室";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self uiConfig];
}

- (void)prepareData
{
    [WowTalkWebServerIF getSchoolMembersWithCallBack:nil withObserver:nil];
}

- (void)uiConfig
{
    [self configNavi];
    
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}
- (void)configNavi
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
    self.view.layer.masksToBounds = YES;
    
    self.title = @"我的教室";
    
    if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)] autorelease];
    }else {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"视频直播" style:UIBarButtonItemStylePlain target:self action:@selector(liveAction)] autorelease];
    }
}

- (void)moreAction{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"编辑班级信息",nil),NSLocalizedString(@"编辑课表",nil) ,nil];
    [as showInView:self.view];
    [as release];
}

- (void)liveAction{
    
    
    Lesson *living_lesson =  [OMDateBase_MyClass getLivingLessonWithClass_id:self.classModel.groupID withNowTime:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
    
    if (nil == living_lesson){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@暂时没有直播的课程",self.classModel.groupNameOriginal] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    
    [OMNetWork_MyClass getLessonDetailWithLessonID:living_lesson.lesson_id withCallBack:@selector(didGetLessonDetail:) withObserver:self];
}


- (void)didGetLessonDetail:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        LessonDetailModel *model = [[[notif userInfo] valueForKey:@"fileName"] firstObject];
        if (model != nil){
            NSArray *camera_array = model.cameraArray;
            
            if(camera_array.count == 0 || camera_array == nil){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@暂时没有直播的课程",self.classModel.groupNameOriginal] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                [alertView release];
                return;
            }
            
            LivingCameraListVC *livingCameraListVC = [[LivingCameraListVC alloc]initWithNibName:@"LivingCameraListVC" bundle:nil];
            livingCameraListVC.camera_array = camera_array;
            [self.navigationController pushViewController:livingCameraListVC animated:YES];
            [livingCameraListVC release];
        }
    }
}


-(void)setClassModel:(OMClass *)classModel{
    [_classModel release],_classModel = nil;
    _classModel = [classModel retain];
    
    [OMNetWork_MyClass getLessoListWithClassID:_classModel WithCallBack:@selector(didGetLessonList:) withObserver:self];
}

- (void)didGetLessonList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        self.lesson_array = [OMDateBase_MyClass fetchLessonWithClassID:self.classModel.groupID];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.section == 0 && indexPath.row == 0){
            MyclassinformationCell *cell = [MyclassinformationCell cellWithTableView:tableView];
            cell.classModel = self.classModel;
            //            cell.classModel = [self.class_array firstObject];
            return cell;
        }else if (indexPath.section == 1 && indexPath.row == 0){
            MyClassFunctionCell *cell = [MyClassFunctionCell cellWithTableView:tableView];
            cell.delegate = self;
            return cell;
        }else if (indexPath.section == 2){
            LessonCell *cell = [LessonCell cellWithTableView:tableView];
            
            cell.lesson = self.lesson_array[indexPath.row];
            
            return cell;
        }
    static NSString *cellID = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.section == 0 && indexPath.row == 0){
            return 110;
        }else if (indexPath.section == 1){
            return 175;
        }
        return 44;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (section == 2){
            return self.lesson_array.count;
        }
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 0;
        }break;
        case 1:{
            return 20;
        }break;
        case 2:{
            return 30;
        }break;
            
        default:
            break;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2){
        OMTableViewHeadView *headView = [OMTableViewHeadView omTableViewHeadViewWithTitle:@"课表:"];
        return headView;
    }else {
        return nil;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 3;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.section == 2){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NewClassDetailVC *classDetailVC = [[NewClassDetailVC alloc] initWithNibName:@"NewClassDetailVC" bundle:nil];
            classDetailVC.lessonModel = self.lesson_array[indexPath.row];
            classDetailVC.classModel = self.classModel;
            [self.navigationController pushViewController:classDetailVC animated:YES];
            [classDetailVC release];
            
            self.title = self.classModel.groupNameOriginal;
        }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.flags == 0) {
        if (buttonIndex==0) {
            EditClassInformationTableVC *editClassInfomationVC = [[EditClassInformationTableVC alloc]initWithNibName:@"EditClassInformationTableVC" bundle:nil]; 
            editClassInfomationVC.classModel = self.classModel;
            editClassInfomationVC.lessonArray = self.lesson_array;
            editClassInfomationVC.delegate = self;
            [self.navigationController pushViewController:editClassInfomationVC animated:YES];
            [editClassInfomationVC release];
        }else if (buttonIndex == 1){
            if ([self.classModel.start_day length] == 0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"请先编辑班级信息",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认",nil), nil];
                [alert show];
                [alert release];
                return;
            }
            LessonListVC *lessonListVC = [[LessonListVC alloc]initWithNibName:@"LessonListVC" bundle:nil];
            lessonListVC.lessonArray = self.lesson_array;
            lessonListVC.classModel = self.classModel;
            lessonListVC.delegate = self;
            [self.navigationController pushViewController:lessonListVC animated:YES];
            [lessonListVC release];
            
        }
    }
    else if (self.flags == 1)
    {
        if (buttonIndex == 0) {
            NSString *mediaType = AVMediaTypeVideo;
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                self.isOn = NO;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请在【设置-隐私-相机】中允许访问相机。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
                [alertView show];
                [alertView release];
                return;
                
            }else{
                self.isOn = YES;
            }
            
            
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //设置拍照后的图片可被编辑
                picker.allowsEditing = NO;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:nil];
                [picker release];
            }else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            }
        }else if (buttonIndex == 1){
            [self openAlbum];
        }
    }
    else if (self.flags == 2)
    {

        if (buttonIndex == 0) {
            NSString *mediaType = AVMediaTypeVideo;
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                self.isOn = NO;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请在【设置-隐私-相机】中允许访问相机。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
                [alertView show];
                [alertView release];
                return;
                
            }else{
                self.isOn = YES;
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请拍下作业，发送给老师", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
            [alertView show];
            
        }
        else if (buttonIndex == 1)
        {
            [self openAlbum];
        }
    }
}

- (void)openAlbum
{
    _isTakingPhoto = FALSE;
    LHImagePickerController *imagePickerController = [[LHImagePickerController alloc] init];
    //    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = 1;
    
    if ([_selectedPhotos count] > 0) {
        __block NSMutableArray* assets = [[NSMutableArray alloc] init];
        
        __block int i = 0;
        
        for (NSURL* url in _selectedPhotos) {
            [_assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
                i++ ;
                [assets addObject:asset];
                if (i == [_selectedPhotos count]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imagePickerController.TotalSelectedArrays = [[NSMutableOrderedSet alloc] initWithArray:assets];
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
                        
                        [self presentViewController:navigationController animated:YES completion:NULL];
                        
                        _dismissFromPicker = TRUE;
                    });
                }
                
            } failureBlock:^(NSError *error) {
            }];
        }
    }
    
    else{
        [self.navigationController pushViewController:imagePickerController animated:YES];
        imagePickerController.flags = self.flags;
        _dismissFromPicker = TRUE;
    }
}

#pragma mark  alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.flags == 2) {
        if (buttonIndex == 0 && self.isOn) {
        
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                
                picker.delegate = self;
                //设置拍照后的图片可被编辑
                picker.allowsEditing = NO;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:nil];
                [picker release];
            }else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
                
            }
        }
    }
    if (buttonIndex == 1) {
        NewAccountSettingVC *newAcc = [[NewAccountSettingVC alloc] init];
        [self.navigationController pushViewController:newAcc animated:YES];
        [newAcc release];
    }
}
#pragma mark imagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //格式化缩略图大小
    self.maxThumbnailSize = CGSizeMake(MULTIMEDIACELL_THUMBNAIL_MAX_X, MULTIMEDIACELL_THUMBNAIL_MAX_Y);
    //如果是 来自照相机的image，那么先保存
    UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageWriteToSavedPhotosAlbum(original_image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   nil);
    //获得编辑过的图片
    self.HomeworkPhoto = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (self.flags == 2) {//在线作业
        //获得缩略图
        UIImage *image = self.HomeworkPhoto;
        CGSize targetSize;
        CGSize targetSizeThumbnail;
        if (self.needCropping) {
            if (image.size.height>image.size.width)
            {
                targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.width) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
            }
            else
            {
                targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.height, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
            }
            
            self.HomeworkPhoto = [image resizeToSqaureSize:targetSize];
            
            targetSizeThumbnail = [self.HomeworkPhoto calculateTheScaledSize:CGSizeMake(self.HomeworkPhoto.size.width, self.HomeworkPhoto.size.height) withMaxSize: self.maxThumbnailSize];
            
            self.HomeworkThumnailPhoto = [image resizeToSqaureSize:targetSizeThumbnail];
            
        }
        else
        {
            targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
            
            self.HomeworkPhoto = [image resizeToSize:targetSize];
            
            targetSizeThumbnail = [self.HomeworkPhoto calculateTheScaledSize:CGSizeMake(self.HomeworkPhoto.size.width, self.HomeworkPhoto.size.height) withMaxSize: self.maxThumbnailSize];
            
            self.HomeworkThumnailPhoto = [image resizeToSize:targetSizeThumbnail];
            
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            //            [picker release];
            
        }
        
    }
    if (self.flags == 1) {//拍照答疑
        //        UIImage *pitToWrite = [AvatarHelper getPhotoFromImage:self.HomeworkPhoto];
        DAViewController *myDaVC = [[[DAViewController alloc]init] autorelease];
        myDaVC.myImage=self.HomeworkPhoto;
        
        myDaVC.maxThumbnailSize = CGSizeMake(MULTIMEDIACELL_THUMBNAIL_MAX_X, MULTIMEDIACELL_THUMBNAIL_MAX_Y);
        
        //        myDaVC.dirName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self._userName];
        
        [self.navigationController pushViewController:myDaVC animated:YES];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {//保存出错
        
    }else
    {//保存成功
        if (self.flags == 1) {
            
        }
        else if(self.flags == 2)
        {
            OnlineHomeworkVC *homeworkVC = [[OnlineHomeworkVC alloc] init];
            homeworkVC.homeworkThumnailIMG = self.HomeworkThumnailPhoto;
            homeworkVC.homeworkIMG = self.HomeworkPhoto;
            [self.navigationController pushViewController:homeworkVC animated:YES];
            [homeworkVC release];
        }
        
    }
    self.flags = 0;
}


#pragma mark - EditClassInformationTableVCDelegate
-(void)editClassInformationTableVC:(EditClassInformationTableVC *)editClassInformationTableVC didEditedWithClassModel:(ClassModel *)classModel{
    [self.tableView reloadData];
}

#pragma mark - LessonListVCDelegate

- (void)lessonListVC:(LessonListVC *)lessonListVC didDeleteLessonWithLessonModel:(Lesson *)lessonModel{
    self.lesson_array = [OMDateBase_MyClass fetchLessonWithClassID:self.classModel.groupID];
    [self.tableView reloadData];
}

- (void)lessonListVC:(LessonListVC *)lessonListVC didAddLessonWithLessonModel:(Lesson *)lessonModel{
    self.lesson_array = [OMDateBase_MyClass fetchLessonWithClassID:self.classModel.groupID];
    [self.tableView reloadData];
}

- (void)lessonListVC:(LessonListVC *)lessonListVC didModifyLessonWithLessonModel:(Lesson *)lessonModel{
    self.lesson_array = [OMDateBase_MyClass fetchLessonWithClassID:self.classModel.groupID];
    [self.tableView reloadData];
}


#pragma mark - MyClassFunctionCellDelegate
/**
 *  师生名单
 */
- (void)clickMemberListButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell{
    ClassMemberListVC *classMemberListVC = [[ClassMemberListVC alloc]initWithNibName:@"ClassMemberListVC" bundle:nil];
    classMemberListVC.classModel = self.classModel;
    [self.navigationController pushViewController:classMemberListVC animated:YES];
    [classMemberListVC release];
}


/**
 *  班级通知
 */
- (void)clickClassNotificationButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell{
    ClassBulletinVC *classBulletinVC = [[ClassBulletinVC alloc]initWithNibName:@"ClassBulletinVC" bundle:nil];
    classBulletinVC.classModel = self.classModel;
    [self.navigationController pushViewController:classBulletinVC animated:YES];
    [classBulletinVC release];
}

/**
 *  请假申请
 */
- (void)clickLeaveApplyButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell{
    if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
        LeaveViewController *leaveVC = [[[LeaveViewController alloc] initWithNibName:@"LeaveViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:leaveVC animated:YES];
    }
    else{
        SignInViewController *signInVC = [[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:signInVC animated:YES];
    }
}

/**
 *  申请补课
 */
- (void)clickMakeUpLessonsButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"很快回来...." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


/**
 *  拍照答疑
 */
- (void)clickTakePhotoForQuestionsButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"take a picture", nil),NSLocalizedString(@"photo album", nil),nil];
    [actionSheet showInView:self.view];
    self.flags = 1;
    [actionSheet release];
}


/**
 *  在线作业
 */
- (void)clickHomeWorkOnLineButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"take a picture", nil),NSLocalizedString(@"photo album", nil),nil];
//    [actionSheet showInView:self.view];
//    self.flags = 2;
//    [actionSheet release];
    ChooseClassAndLessonVC *chooseClassVC = [[[ChooseClassAndLessonVC alloc] init] autorelease];
    chooseClassVC.OMClass = self.classModel;
    [self.navigationController pushViewController:chooseClassVC animated:YES];
}

/**
 *  班级圈
 */
- (void)clickclassCircleActionButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell{
 
    TimelineContainerVC *timeLineVC = [[TimelineContainerVC alloc] init];
    [self.navigationController pushViewController:timeLineVC animated:YES];
    [timeLineVC release];
    
    
}



@end
