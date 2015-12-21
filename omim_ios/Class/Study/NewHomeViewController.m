//
//  NewHomeViewController.m
//  dev01
//
//  Created by Huan on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NewHomeViewController.h"
#import "UINavigationItem+SpaceHandler.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "HOMEButtonCell.h"
#import "ActivityListViewController.h"
#import "TimelineContainerVC.h"
#import "SchoolViewController.h"
#import "ParentChatRoomVC.h"
#import "WTUserDefaults.h"
#import "CameraListVC.h"
#import "MyclassAndHomeworkVC.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "EmailStatus.h"
#import "NewAccountSettingVC.h"
#import "ADViewCollectionViewCell.h"
#import "OnlineHomeworkVC.h"
#import "OMSettingVC.h"
#import "AddCourseController.h"
#import "SendTo.h"
#import "AvatarHelper.h"
#import "DAViewController.h"
#import "MyClassViewController.h"
#import "UIImage+Resize.h"
#import "LHImagePickerController.h"
#import "SignInViewController.h"
#import "LeaveViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ClassBulletinVC.h"
#import "ChooseClassAndLessonVC.h"

#import "OMFMomentListVC.h"

#import "OMNetWork_MyClass.h"



#import "OMNetWork_Moment_Manager.h"

#import "YBImagePickerViewController.h"


// test
#import "BindingTelephoneViewController.h"
#import "OMContactListViewController.h"
#import "OMUserSetting.h"


@interface NewHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,AddCourseControllerDelegate>




@property (retain, nonatomic) IBOutlet UICollectionView *mainView_collectionView;
@property (retain, nonatomic) NSArray *ImageNameArr;
@property (retain, nonatomic) NSArray *titltNameArr;
@property (retain, nonatomic) IBOutlet UICollectionView *ADCollectionView;
@property (retain, nonatomic) NSArray *ADs;
@property (retain, nonatomic) NSTimer *ADTimer;
@property (assign, nonatomic) NSInteger ADCount;
@property (retain, nonatomic) IBOutlet UIPageControl *PageControl;
@property (retain, nonatomic) UIImage *HomeworkPhoto;
@property (retain, nonatomic) UIImage *HomeworkThumnailPhoto;
/**0默认 1拍照答疑 2在线作业 */
@property (assign, nonatomic) int flags;
@property (assign, nonatomic) BOOL isTakingPhoto;
@property (retain, nonatomic) NSMutableArray *selectedPhotos;
//访问所有图片
@property (retain, nonatomic) ALAssetsLibrary* assetLib;
@property (assign, nonatomic) BOOL dismissFromPicker;
@property (assign, nonatomic) BOOL isOn;

@property (assign, nonatomic) BOOL alreadyShow;
@end

@implementation NewHomeViewController
- (void)dealloc {
    [_mainView_collectionView release];
    [_mainScrollView release];
    [_bottomView release];
    [_ADCollectionView release];
    [_PageControl release];
    [_ImageNameArr release];
    [_titltNameArr release];
    [_ADs release];
    [_ADTimer release];
    [_HomeworkPhoto release];
    [_HomeworkThumnailPhoto release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09f green:0.64f blue:0.89f alpha:1.00f];
    self.alreadyShow = NO;
    
#if 0
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"aaa" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(aaa) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
#endif
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.alreadyShow = YES;
}



- (void)aaa{
//    [OMNetWork_Moment_Manager uploadMoment:nil];
    
//    BindingTelephoneViewController *vc = [[BindingTelephoneViewController alloc]initWithNibName:@"BindingTelephoneViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//    [vc release];
    
    OMUserSetting *userSetting = [OMUserSetting getUserSetting];
    
    
    userSetting.domain = @"时间拾荒者";
    
    [userSetting storeUserSetting];
    
    userSetting = [OMUserSetting getUserSetting];
    
    
    OMContactListViewController *vc = [[OMContactListViewController alloc]initWithNibName:@"OMContactListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
    
//    YBImagePickerViewController *picker = [[YBImagePickerViewController alloc]init];
//    picker.max_count = 9;
//    picker.delegate = self;
//    [self presentViewController:picker animated:YES completion:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //检查是否绑定邮箱号：若没有绑定则提醒绑定
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WowTalkWebServerIF GetBindEmailStatusWithCallback:@selector(bindingEmail:) withObserver:self];
    });
    
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self fillData];
    [self loadLeftItem];
    [self uiConfig];
}

//- (void)configNavigation{
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
//    
//    
//    self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    
//    
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tabbar_home_set"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSettingVC)] autorelease];
//    
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:NAV_ADD_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)] autorelease];
//    
//}

/**
 *  找活动、班级圈、好友圈button
 */
- (void)loadLeftItem
{
    self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 44);
    [button setImage:[UIImage imageNamed:@"tabbar_home_set"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"tabbar_home_set_press"] forState:UIControlStateSelected];
    //    [button setTitle:@"设置" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tabbar_home_set"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSettingVC)] autorelease];

    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:NAV_ADD_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)] autorelease];
    
}
#pragma mark---
#pragma mark---跳转到设置页面
- (void)pushSettingVC{
    if (!self.alreadyShow)return;
    OMSettingVC *settingVC = [[OMSettingVC alloc]initWithNibName:@"OMSettingVC" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
    [settingVC release];
}

#pragma mark---
#pragma mark---跳转到添加页面
- (void)addCourse{
    AddCourseController *addcourse = [[AddCourseController alloc]init];
    addcourse.isInvitationCodeInHomeVC = YES;
    addcourse.delegate = self;
    [self.navigationController pushViewController:addcourse animated:YES];
    [addcourse release];
}

- (void)fillData
{
    self.PageControl.numberOfPages = self.ADs.count;
    [self timeOn];
    _ImageNameArr = [[NSArray alloc] init];
    _titltNameArr = [[NSArray alloc] init];
    _ImageNameArr = @[@"icon_home_classnotice",
                      @"icon_home_register",
                      @"icon_home_classlive",
                      @"icon_home_answerquestion",
                      @"icon_home_homework",
                      @"icon_home_chatroom"];
    _titltNameArr = @[@"班级通知",@"签到请假",@"直播课堂",@"拍照答疑",@"在线交作业",@"家长聊天室"];
    self.ADs = @[@"home_banner2",@"home_banner1"];
    self.PageControl.numberOfPages = self.ADs.count;
}

//海报滚动定时器
- (void)timeOn
{
    self.ADTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changeADContent) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.ADTimer forMode:NSRunLoopCommonModes];
}

- (void)changeADContent
{
    //1）获取当前正在展示的位置
    NSIndexPath *currentIndexPath=[[self.ADCollectionView indexPathsForVisibleItems]lastObject];
    //2）计算出下一个需要展示的位置
    NSInteger nextItem=currentIndexPath.item+1;
    NSInteger nextSection=currentIndexPath.section;
    if (nextItem == self.ADs.count * 1000) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath=[NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    //3）通过动画滚动到下一个位置
    [self.ADCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self timerOff];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    scrollView.showsVerticalScrollIndicator = NO;
    self.PageControl.currentPage = ((int)(self.ADCollectionView.contentOffset.x / self.ADCollectionView.bounds.size.width))%2;
}
//当用户停止拖拽的时候，添加一个定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self timeOn];
}
- (void)timerOff
{
    [self.ADTimer invalidate];
    self.ADTimer = nil;
}

- (void)uiConfig{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    self.mainView_collectionView.collectionViewLayout = flowLayout;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 20, 0, 20);
    self.mainView_collectionView.backgroundColor = [UIColor whiteColor];
//    [self.mainView_collectionView registerClass:[HOMEButtonCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.mainView_collectionView registerNib:[UINib nibWithNibName:@"HOMEButtonCell" bundle:nil] forCellWithReuseIdentifier:@"HOMEBtnCell"];
    flowLayout.itemSize = CGSizeMake(80, 90);
    
    [self.ADCollectionView registerNib:[UINib nibWithNibName:@"ADViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ADCell"];
    UICollectionViewFlowLayout *ADflowLayout = (UICollectionViewFlowLayout *)self.ADCollectionView.collectionViewLayout;
    ADflowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, 90);
//    [self.ADCollectionView addSubview:self.PageControl];
//    [self.ADCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:500 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)configNavi
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *barItem = [PublicFunctions getCustomNavButtonOnLeftSide:NO
                                                                      target:self
                                                                       image:[UIImage imageNamed:NAV_ADD_IMAGE]
                                                                    selector:@selector(addCourse)];
    [self.navigationItem addRightBarButtonItem:barItem];
}

#pragma mark collectionView 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1009) {
        return self.ADs.count * 1000;
    }
    else
    {
        return 6;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView.tag == 1009) {
        return 1;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1009) {
        static NSString *ID = @"ADCell";
        ADViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.ADIcon_imgV.image = [UIImage imageNamed:_ADs[indexPath.row % self.ADs.count]];
        return cell;
    }
    else
    {
        static NSString *identify = @"HOMEBtnCell";
        HOMEButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.icon_ImageView.image = [UIImage imageNamed:_ImageNameArr[indexPath.row]];
        cell.title_Lab.text = _titltNameArr[indexPath.row];
        if (indexPath.row != 0) {
            [cell.TipCount_Lab setHidden:YES];
            cell.tipBg_imgV.hidden = YES;
            
            if (indexPath.row == 1) {
                [cell.TipCount_Lab setHidden:YES];
                cell.tipBg_imgV.hidden = YES;
            }
        }
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1009) {
        
    }
    else{
        switch (indexPath.row) {
            case 0:
                //班级通知
            {
                ClassBulletinVC *classBulletinVC = [[ClassBulletinVC alloc]initWithNibName:@"ClassBulletinVC" bundle:nil];
                [self.navigationController pushViewController:classBulletinVC animated:YES];
                [classBulletinVC release];
            }
                
                break;
            case 1:{
                //签到请假
                /**
                 *  判断是老师还是学生：userType == 2 则是老师
                 */
                if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
                    LeaveViewController *leaveVC = [[[LeaveViewController alloc] initWithNibName:@"LeaveViewController" bundle:nil] autorelease];
                    [self.navigationController pushViewController:leaveVC animated:YES];
                }
                else{
                    SignInViewController *signInVC = [[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil] autorelease];
                    [self.navigationController pushViewController:signInVC animated:YES];
                }
                
            }break;
            case 2:
                //直播课堂
                if ([[WTUserDefaults getUsertype] isEqual:@"1"]) {
                    //学生  摄像头列表页
                    MyclassAndHomeworkVC *myclassVC = [[MyclassAndHomeworkVC alloc] initWithNibName:@"MyclassAndHomeworkVC" bundle:nil];
                    myclassVC.isMyclass = YES;
                    [self.navigationController pushViewController:myclassVC animated:YES];
                    [myclassVC release];
                }
                else
                {
                    //老师
                    MyclassAndHomeworkVC *myclassVC = [[MyclassAndHomeworkVC alloc] initWithNibName:@"MyclassAndHomeworkVC" bundle:nil];
                    myclassVC.isMyclass = YES;
                    [self.navigationController pushViewController:myclassVC animated:YES];
                    [myclassVC release];
                }
                break;
            case 3:
                //拍照答疑
            {
                
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"take a picture", nil),NSLocalizedString(@"photo album", nil),nil];
                [actionSheet showInView:self.view];
                self.flags = 1;
                
            }
                
                break;
            case 4:
                //在线交作业
            {
                ChooseClassAndLessonVC *chooseClassVC = [[[ChooseClassAndLessonVC alloc] init] autorelease];
                [self.navigationController pushViewController:chooseClassVC animated:YES];
//                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"take a picture", nil),NSLocalizedString(@"photo album", nil),nil];
//                [actionSheet showInView:self.view];
//                self.flags = 2;
            }
                break;
            case 5:{
                //家长聊天室
                ParentChatRoomVC *schoolVC = [[ParentChatRoomVC alloc] init];
                [self.navigationController pushViewController:schoolVC animated:YES];
                [schoolVC release];
            }
                break;
            default:
                break;
        }
    }
    
    
}

#pragma mark UIActionSheetDelegate
/**
 *  拍照答疑actionsheet
 *
 *  @param buttonIndex 0：拍照；1：相册
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.flags == 1) {
        if (buttonIndex == 0) {
            NSString *mediaType = AVMediaTypeVideo;
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                self.isOn = NO;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请在【设置-隐私-相机】中允许访问相机。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
                [alertView show];
                [alertView release];
                return;
            }
            else{
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
                NSLog(@"模拟器中无法打开照相机,请在真机中使用");
                
            }
        }
        else if (buttonIndex == 1)
        {
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
                
            }
            else{
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

//打开系统相册
-(void)openAlbum{
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

//打开相机方法
-(void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [picker setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeImage]];
        [picker setDelegate:self];
        
        _dismissFromPicker = TRUE;
        _isTakingPhoto = TRUE;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
        return;
}


- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    self.flags = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
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






- (IBAction)findActivity:(id)sender {
    //找活动
    ActivityListViewController *activityVC = [[ActivityListViewController alloc] init];
    [self.navigationController pushViewController:activityVC animated:YES];
    [activityVC release];
}

- (IBAction)classGroup:(id)sender {
    //班级圈
    TimelineContainerVC *timeLineVC = [[TimelineContainerVC alloc] init];
    [self.navigationController pushViewController:timeLineVC animated:YES];
    [timeLineVC release];
}

- (IBAction)friendGroup:(id)sender {
    //好友圈
    TimelineContainerVC *timeLineVC = [[TimelineContainerVC alloc] init];
    [self.navigationController pushViewController:timeLineVC animated:YES];
    [timeLineVC release];
}

- (void)bindingEmail:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        EmailStatus *emailStaus = [[notif userInfo] valueForKey:@"fileName"];
        if (![emailStaus.verified isEqualToString:@"1"]) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"请绑定邮箱,用于找回密码" delegate:self cancelButtonTitle:NSLocalizedString(@"以后再说", nil) otherButtonTitles:NSLocalizedString(@"去绑定",nil), nil];
            [alerView show];
        }
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

#pragma mark - AddCourseControllerDelegate

- (void)refreshSchoolTree{
    [OMNetWork_MyClass getClassListWithCallBack:@selector(didGetClassList:) withObserver:nil];
    [WowTalkWebServerIF getSchoolMembersWithCallBack:nil withObserver:nil];
}



@end
