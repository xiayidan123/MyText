//
//  SettingHomeworkVC.m
//  dev01
//
//  Created by Huan on 15/5/15.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  布置作业


#import "SettingHomeworkVC.h"
#import "ParentsOpinionDetailView.h"
#import "UploadParentsOpinionView.h"
#import "AddPhotoView.h"
#import "ExplainView.h"
#import "NewhomeWorkModel.h"
#import "OMNetWork_MyClass.h"
#import "OMDateBase_MyClass.h"
#import "Lesson.h"
#import "WowTalkWebServerIF.h"
#import "Moment.h"
#import "MediaProcessing.h"
#import "WTFile.h"
#import "MediaUploader.h"
#import "WTHelper.h"
#import "YBPhotoListViewController.h"
#import "YBImagePickerViewController.h"
#import "YBPhotoModel.h"
#import "WTUserDefaults.h"
#import "ShowHomeworkView.h"
#import "StudentUploadHomeworkVC.h"
#import "OMAlertViewForNet.h"
#import "HomeworkDetailVC.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define interval 20
#define addPhotoViewHeight 130
#define addPhotoViewWidth self.view.bounds.size.width
#define addPhotoViewY 64 + interval
#define addPhotoViewX 0
#define showhomeworkViewHeight 180
@interface SettingHomeworkVC ()<AddPhotoViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ExplainViewDelegate,QBImagePickerControllerDelegate,YBImagePickerViewControllerDelegate,ShowHomeworkViewDelegate,SettingHomeworkVCDelegate,UIAlertViewDelegate,UIAlertViewDelegate,OMAlertViewForNetDelegate,StudentUploadHomeworkVCDelegate,HomeworkDetailVCDelegate>

/** 添加照片的View*/
@property (retain, nonatomic) AddPhotoView *addPhotoView;
/** 补充说明的View*/
@property (retain, nonatomic) ExplainView * explain_textView;
/** 拍照权限是否开启*/
@property (assign, nonatomic) BOOL takePicPermission;
/** 补充说明内容*/
@property (copy, nonatomic) NSString * explain_content;
/** 作业model*/
//@property (retain, nonatomic) NewhomeWorkModel * homeWorkModel;

@property (retain, nonatomic) Moment * moment;
/** 选择的照片*/
@property (retain, nonatomic) NSMutableArray *selectedPhotos;

@property (retain, nonatomic) ALAssetsLibrary *assetLib;

@property (assign, nonatomic) BOOL isTakingPhoto;

@property (assign, nonatomic) BOOL dismissFromPicker;

@property (retain, nonatomic)  ShowHomeworkView *showhomeworkView ;

@property (retain, nonatomic) NSMutableArray * file_array;

@property (retain, nonatomic) OMAlertViewForNet * OMalertView;
/** 导航栏右侧按钮可否点击*/
@property (assign, nonatomic) BOOL canClick;

@property (assign, nonatomic) int canSelectNum;

@property (assign, nonatomic) BOOL isTeacher;

@end

@implementation SettingHomeworkVC

-(void)dealloc{
    self.classModel = nil;
    self.lessonModel = nil;
    self.homeworkModel = nil;
    self.addPhotoView = nil;
    self.explain_textView = nil;
    self.explain_content = nil;
    self.moment = nil;
    self.selectedPhotos = nil;
    self.assetLib = nil;
    self.showhomeworkView = nil;
    self.file_array = nil;
    self.OMalertView.delegate = nil;
    self.OMalertView = nil;
    
    [super dealloc];
}



- (void)viewWillAppear:(BOOL)animated{
    [self.showhomeworkView.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
    
    [self loadData];
}

- (void)configNavigation{
    if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
        self.title = NSLocalizedString(@"布置作业", nil);
    }else{
        self.title = NSLocalizedString(@"作业", nil);
    }
    if (!self.isTeacher) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"提交作业" style:UIBarButtonItemStylePlain target:self action:@selector(uploadHomework)] autorelease];
    }
}

- (void)uploadHomework{
    if (self.homeworkModel.results_moments.count == 0){
        if (self.homeworkModel.homework_moment.homework_id) {
            //提交作业页面
            StudentUploadHomeworkVC *setHomeVC = [[[StudentUploadHomeworkVC alloc] init] autorelease];
            setHomeVC.delegate = self;
            //            setHomeVC.lessonModel = self.lessonModel;
            setHomeVC.lessonmodel = self.lessonModel;
            setHomeVC.classmodel = self.classModel;
            setHomeVC.homeworkModel = self.homeworkModel;
            [self.navigationController pushViewController:setHomeVC animated:YES];
        }else{
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"老师还未布置作业" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil] autorelease];
            [alertView show];
        }
        
    }else{
        HomeworkDetailVC *homeworkDetailVC = [[HomeworkDetailVC alloc]initWithNibName:@"HomeworkDetailVC" bundle:nil];
        homeworkDetailVC.delegate = self;
        homeworkDetailVC.lesson_id = self.lessonModel.lesson_id;
        NSString *uid = [WTUserDefaults getUid];
        
        homeworkDetailVC.classmodel = self.classModel;
        homeworkDetailVC.lessonmodel = self.lessonModel;
        homeworkDetailVC.student = [OMDateBase_MyClass fetchClassMemberByClass_id:self.lessonModel.class_id andMember_id:uid];
        [self.navigationController pushViewController:homeworkDetailVC animated:YES];
        [homeworkDetailVC release];
    }
}

- (void)uiConfig{
    
    /** 添加导航栏右侧按钮*/
    self.canClick = NO;
    /** 添加照片的View*/

    [self loadAddPhotoView];
    
    
    /** 补充说明的View*/
    
    self.explain_textView.old_text = self.homeworkModel.homework_moment.text;
    
//    [self loadSupplment];
}


//已经布置过作业  获取homeworkmodel  布局ui

- (void)uiPreView{
    if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
        self.showhomeworkView = [[[NSBundle mainBundle] loadNibNamed:@"ShowHomeworkView" owner:nil options:nil] firstObject];
        self.showhomeworkView.homeworkModel = self.homeworkModel;
        self.showhomeworkView.delegate = self;
        self.showhomeworkView.frame = CGRectMake(addPhotoViewX, addPhotoViewY - 64, addPhotoViewWidth, showhomeworkViewHeight);
        [self.view addSubview:self.showhomeworkView];
    }
    else{
        self.showhomeworkView = [[[NSBundle mainBundle] loadNibNamed:@"ShowHomeworkView" owner:nil options:nil] firstObject];
        self.showhomeworkView.homeworkModel = self.homeworkModel;
        self.showhomeworkView.delegate = self;
        self.showhomeworkView.frame = CGRectMake(addPhotoViewX, addPhotoViewY - 64, addPhotoViewWidth, showhomeworkViewHeight + 64);
        [self.view addSubview:self.showhomeworkView];
    }
    
    
    NSLog(@"%@",NSStringFromCGRect(self.showhomeworkView.frame));
}


/** 添加照片View*/

- (void)loadAddPhotoView
{
    self.addPhotoView.isSettingHomework = self.isSettingHomework;
    if (self.isSettingHomework) {
        self.addPhotoView.homeWorkModel = self.homeworkModel;
    }
}


- (void)loadData{
    //获取当前有没有布置作业
//    [OMNetWork_MyClass getHomeWorkWithLessonID:self.lessonModel.lesson_id withCallBack:@selector(didGetHomework:) withObserver:self];
    
    if (self.isEditing)return;
    
    if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
        [OMNetWork_MyClass getLessonHomeWorkWithLessonID:self.lessonModel.lesson_id withCallBack:@selector(didGetHomework:) withObserver:self];
    }else{
        [self uiPreView];
    }
    
    
}

- (void)send{
    self.OMalertView = [OMAlertViewForNet OMAlertViewForNet];
    self.OMalertView.title = @"正在提交作业";
    self.OMalertView.delegate = self;
    self.OMalertView.duration = 1.0;
    self.OMalertView.type = OMAlertViewForNetStatus_Loading;
    [self.OMalertView show];
    //获取moment_id
    if (self.explain_content.length == 0) {
        //如果是修改作业进这里
        self.explain_content = self.homeworkModel.homework_moment.text;
    }
    [WowTalkWebServerIF addMomentToUploadParentsOpinion:self.explain_content isPublic:NO allowReview:TRUE Latitude:@"0" Longitutde:@"0" withPlace:NULL withMomentType:@"5" withSharerange:nil withCallback:@selector(didSaveMomentInServer:) withObserver:self];
}



#pragma mark - AddPhotoViewDelegate
- (void)didSelectedAddPhoto{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"take a picture", nil),NSLocalizedString(@"photo album", nil),nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}
- (void)cannotAddphoto{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"只能添加6张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
    [alertView show];
}
#pragma mark- UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100 && buttonIndex == 1){
        [OMNetWork_MyClass deleteHomeworkWithHomeWorkID:self.homeworkModel.homework_moment.homework_id withCallBack:@selector(didDeleteHomework:) withObserver:self];
    }else if (alertView.tag == 400 && buttonIndex == 1){
        [self modifyHomework];
    }else if (alertView.tag == 200 && buttonIndex == 1){
        [self send];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            self.takePicPermission = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请在【设置-隐私-相机】中允许访问相机。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
            [alertView show];
            [alertView release];
            return;
        }
        else{
            self.takePicPermission = YES;
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
    }
    else if (buttonIndex == 1)
    {
        [self openAlbum];
    }
    
}



- (void)openAlbum{
    YBImagePickerViewController *picker = [[YBImagePickerViewController alloc]init];
    picker.max_count = 6;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark ExplainViewDelegate

- (void)getExplainText:(UITextView *)textView{
    if (textView.text.length || self.selectedPhotos.count) {
        self.explain_content = textView.text;
        self.canClick = YES;
    }else{
        self.canClick = NO;
    }
    
}

#pragma mark didgethomework

- (void)didGetHomework:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.homeworkModel = [notif userInfo][@"fileName"];
        if (self.isSettingHomework) {//有作业模型代表已经布置作业
            [self uiPreView];
        }else{//没有布置作业
            [self uiConfig];
        }
    }
}


- (void)didSaveMomentInServer:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    NSMutableArray *arr_medias = [[NSMutableArray alloc] init];
    if (error.code == NO_ERROR) {
        self.moment = (Moment*)[[notif userInfo] valueForKey:@"moment"];
        if (self.isEditing){
            [OMNetWork_MyClass modifyLessonHomeWorkWithHomeworkID:self.homeworkModel.homework_moment.homework_id WithMomentID:self.moment.moment_id withCallBack:@selector(didmodifyHomework:) withObserver:self];
        }else{
            if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
                [OMNetWork_MyClass AddLessonHomeWorkWithLessonID:self.lessonModel.lesson_id WithMomentID:self.moment.moment_id withCallBack:@selector(didSettingHomework:) withObserver:self];
            }else{
                [OMNetWork_MyClass addHomeworkResultWithHomeworkID:self.homeworkModel.homework_moment.homework_id WithMomentID:self.moment.moment_id withCallBack:@selector(didSettingHomework:) withObserver:self];
            }
        }
        
        // take care of images
        if (self.selectedPhotos.count > 0) {
            __block NSMutableArray* files = [[NSMutableArray alloc] init];
            //            __block int i = 0;
            __block NSMutableArray* fetchedAssetArray = [[NSMutableArray alloc] init];
            for (YBPhotoModel *model in self.selectedPhotos) {
                NSURL *url = nil;
                if (model.image_obj){
                    WTFile *file = model.image_obj;
                    file.momentid = self.moment.moment_id;
                    [fetchedAssetArray addObject:file];
                }else if (model.url){
                    url = model.url;
                }
                
                if (fetchedAssetArray.count == [self.selectedPhotos count]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        for (id obj in fetchedAssetArray) {
                            @autoreleasepool {
                                
                                if ([obj isKindOfClass:[WTFile class]]){
                                    [files addObject:obj];
                                }else{
                                    ALAsset *aAsset = obj;
                                    NSLog(@"process asset %@",aAsset);
                                    NSArray* array = [MediaProcessing savePhotoFromLibraryToLocal:aAsset];
                                    if (array) {
                                        NSLog(@"process asset ok");
                                        WTFile* file = [[WTFile alloc] init];
                                        file.thumbnailid = [array objectAtIndex:1];
                                        file.fileid = [array objectAtIndex:0];
                                        file.ext = @"jpg";
                                        [files addObject:file];
                                        [file release];
                                    }
                                }
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"final process on main thread");
                            [arr_medias addObjectsFromArray:files];
                            self.moment.multimedias = arr_medias;
                            [Database storeMoment:self.moment];
                            [files release];
                            // save the upload work in background
                            for (WTFile* file in arr_medias) {
                                if ([file.ext isEqualToString:@"aac"]) {
                                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.moment.moment_id isThumbnail:FALSE];
                                }
                                else{
                                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.moment.moment_id isThumbnail:FALSE];
                                    [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:self.moment.moment_id isThumbnail:TRUE];
                                };
                            }
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_NEW_MOMENT object:self.moment.moment_id];
                            [[MediaUploader sharedUploader] upload];
                            
                            //                                [self backAction];
                            
                            return;
                            
                        });
                    });
                    
                }

                
                if (url != nil){
                    [self.assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
                        [fetchedAssetArray addObject:asset];
                        NSLog(@"fetched asset array %zi/%zi",fetchedAssetArray.count,[self.selectedPhotos count]);
                        
                        if (fetchedAssetArray.count == [self.selectedPhotos count]) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                for (id obj in fetchedAssetArray) {
                                    @autoreleasepool {
                                        
                                        if ([obj isKindOfClass:[WTFile class]]){
                                            [files addObject:obj];
                                        }else{
                                            ALAsset *aAsset = obj;
                                            NSLog(@"process asset %@",aAsset);
                                            NSArray* array = [MediaProcessing savePhotoFromLibraryToLocal:aAsset];
                                            if (array) {
                                                NSLog(@"process asset ok");
                                                WTFile* file = [[WTFile alloc] init];
                                                file.thumbnailid = [array objectAtIndex:1];
                                                file.fileid = [array objectAtIndex:0];
                                                file.ext = @"jpg";
                                                [files addObject:file];
                                                [file release];
                                            }
                                        }
                                    }
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSLog(@"final process on main thread");
                                    [arr_medias addObjectsFromArray:files];
                                    self.moment.multimedias = arr_medias;
                                    [Database storeMoment:self.moment];
                                    [files release];
                                    // save the upload work in background
                                    for (WTFile* file in arr_medias) {
                                        if ([file.ext isEqualToString:@"aac"]) {
                                            [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.moment.moment_id isThumbnail:FALSE];
                                        }
                                        else{
                                            [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.moment.moment_id isThumbnail:FALSE];
                                            [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:self.moment.moment_id isThumbnail:TRUE];
                                        };
                                    }
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_NEW_MOMENT object:self.moment.moment_id];
                                    [[MediaUploader sharedUploader] upload];
                                    
                                    //                                [self backAction];
                                    
                                    self.OMalertView.title = @"提交作业成功";
                                    self.OMalertView.type = OMAlertViewForNetStatus_Done;
                                    return;
                                    
                                });
                            });
                        }
                        
                    } failureBlock:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //TODO: localization string here
                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@ "The image file is broken, please select it again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                            [alert show];
                            [alert release];
                            //                        [self backAction];
                            return;
                        });
                    }];
                }
            }
        }
        else{
            self.moment.multimedias = arr_medias;
            [Database storeMoment:self.moment];
            
            // save the upload work in background
            for (WTFile* file in arr_medias) {
                if ([file.ext isEqualToString:@"aac"]) {
                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.moment.moment_id isThumbnail:FALSE];
                }
                else{
                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.moment.moment_id isThumbnail:FALSE];
                    [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:self.moment.moment_id isThumbnail:TRUE];
                };
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_NEW_MOMENT object:self.moment.moment_id];
            
            [[MediaUploader sharedUploader] upload];
            //            [self backAction];
            self.OMalertView.title = @"提交作业成功";
            self.OMalertView.type = OMAlertViewForNetStatus_Done;
            return;
        }
        
    }
}

- (void)didSettingHomework:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.OMalertView.title = @"提交作业成功";
        self.OMalertView.type = OMAlertViewForNetStatus_Done;
    }
}



#pragma mark - YBImagePickerViewControllerDelegate

- (void)YBImagePickerViewController:(YBImagePickerViewController *)imagePickerVC selectedPhotoArray:(NSArray *)selected_photo_array{
    NSMutableArray *photos = [[NSMutableArray alloc]initWithArray:self.addPhotoView.photos];
    [photos addObjectsFromArray:selected_photo_array];
    self.addPhotoView.photos = photos;
    if (photos.count || self.explain_content.length) {
        self.canClick = YES;
    }else{
        self.canClick = NO;
    }
    [photos release];
    NSInteger count = selected_photo_array.count;
    for (int i = 0; i < count; i++) {
        YBPhotoModel *ybPhotoModel = selected_photo_array[i];
        [self.selectedPhotos addObject:ybPhotoModel];
    }
}


- (ALAssetsLibrary *)assetLib{
    if (_assetLib == nil){
        _assetLib = [[ALAssetsLibrary alloc]init];
    }
    
    return _assetLib;
}

- (void)delete{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除该作业" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alertView.tag = 100;
    [alertView show];
    [alertView release];
    
}

- (void)didDeleteHomework:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ShowHomeworkViewDelegate

- (void)didClickEditButtonWithShowHomeworkView:(ShowHomeworkView *)showHomeworkView{
    SettingHomeworkVC *editHomeworkVC = [[SettingHomeworkVC alloc]initWithNibName:@"SettingHomeworkVC" bundle:nil];
    editHomeworkVC.isSettingHomework = NO;
    editHomeworkVC.delegate = self;
    editHomeworkVC.classModel = self.classModel;
    editHomeworkVC.lessonModel = self.lessonModel;
    editHomeworkVC.homeworkModel = self.homeworkModel;
    editHomeworkVC.isEditing = YES;
    [self.navigationController pushViewController:editHomeworkVC animated:YES];
    [editHomeworkVC release];
}


//- (void)getDescriptionViewHeight:(float)height{
//    self.showhomeworkView.frame = CGRectMake(addPhotoViewX, addPhotoViewY - 64, addPhotoViewWidth, height);
//    [self.view addSubview:self.showhomeworkView];
//}

-(void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    
    if (_isEditing){
        
        self.addPhotoView.homeWorkModel = self.homeworkModel;
        
        self.explain_textView.old_text = self.homeworkModel.homework_moment.text;
        
        NSArray *files = self.homeworkModel.homework_moment.multimedias;
        
        for (int i=0; i<files.count; i++){
            WTFile *file = files[i];
            YBPhotoModel *photo_model = [[YBPhotoModel alloc]init];
            photo_model.image_obj = file;
            [self.selectedPhotos addObject:photo_model];
            [photo_model release];
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(affirmModify)];
    }
}

- (void)affirmModify{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"确认修改作业吗？" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定",nil), nil] autorelease];
    alertView.tag = 400;
    [alertView show];
}

#pragma mark - SettingHomeworkVCDelegate

- (void)SettingHomeworkVC:(SettingHomeworkVC *)settingHomeworkVC didModifyHomework:(NewhomeWorkModel *)homeworkModel{
    self.homeworkModel = homeworkModel;
    
    self.showhomeworkView.homeworkModel = self.homeworkModel;
}

- (void)modifyHomework{
    self.omAlertViewForNet.duration = 1.0;
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    self.omAlertViewForNet.title = @"正在修改作业";
    [self.omAlertViewForNet showInView:self.view];
    [WowTalkWebServerIF addMomentToUploadParentsOpinion:self.explain_content?self.explain_content:self.explain_textView.old_text isPublic:NO allowReview:TRUE Latitude:@"0" Longitutde:@"0" withPlace:NULL withMomentType:@"5" withSharerange:nil withCallback:@selector(didSaveMomentInServer:) withObserver:self];
    
    
}

- (void)didmodifyHomework:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        NewhomeWorkModel *homework_model = [[notif userInfo] objectForKey:@"fileName"];
        
        homework_model.homework_moment.multimedias = self.moment.multimedias;
        
        if ([self.delegate respondsToSelector:@selector(SettingHomeworkVC:didModifyHomework:)]){
            [self.delegate SettingHomeworkVC:self didModifyHomework:homework_model];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Set and Get

-(AddPhotoView *)addPhotoView{
    if (_addPhotoView == nil){
        _addPhotoView = [[AddPhotoView alloc] initWithFrame:CGRectMake(addPhotoViewX, addPhotoViewY - 64, addPhotoViewWidth, addPhotoViewHeight)] ;
        _addPhotoView.delegate = self;
        [self.view addSubview:_addPhotoView];
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, addPhotoViewWidth, 0.5)];
        topLineView.backgroundColor = [UIColor lightGrayColor];
        [_addPhotoView addSubview:topLineView];
        
        UIView *bottomeLineView = [[UIView alloc] initWithFrame:CGRectMake(0, addPhotoViewHeight, addPhotoViewWidth, 0.5)];
        bottomeLineView.backgroundColor = [UIColor lightGrayColor];
        [_addPhotoView addSubview:bottomeLineView];
        [topLineView release];
        [bottomeLineView release];
    }
    return _addPhotoView;
}


-(ExplainView *)explain_textView{
    if(_explain_textView == nil){
        _explain_textView = [[ExplainView alloc] initWithFrame:CGRectMake(addPhotoViewX, CGRectGetMaxY(self.addPhotoView.frame) + interval, addPhotoViewWidth, addPhotoViewHeight)];
        _explain_textView.delegate = self;
        [self.view addSubview:_explain_textView];
    }
    
    return _explain_textView;
}

- (NSMutableArray *)selectedPhotos{
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    }
    return _selectedPhotos;
}

- (BOOL)isTeacher{
    if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setCanClick:(BOOL)canClick{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(affirmSend)];
    if (canClick) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)affirmSend{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"确认提交吗？" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil] autorelease];
    alertView.tag = 200;
    [alertView show];
}
#pragma mark - OMAlertViewForNetDelegate
- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet;
{
    [self.navigationController popViewControllerAnimated:YES];
}






#pragma mark ----- QBImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        // Media is an image
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        [self.assetLib writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation*)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
            [self.assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                YBPhotoModel *ybPhoto = [[YBPhotoModel alloc] init];
                ybPhoto.url = assetURL;
                [self.selectedPhotos addObject:ybPhoto];
                self.addPhotoView.photos = self.selectedPhotos;
                if (self.selectedPhotos) {
                    self.canClick = YES;
                }else{
                    self.canClick = NO;
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } failureBlock:^(NSError *error) {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }];
        }];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - StudentUploadHomeworkVCDelegate
- (void)studentUploadHomeworkVC:(StudentUploadHomeworkVC *)studentUploadHomeworkVC didUploadHomeworkWithHomework_model:(NewhomeWorkModel *)homework_model{
//    [self.tableView reloadData];
}
@end
