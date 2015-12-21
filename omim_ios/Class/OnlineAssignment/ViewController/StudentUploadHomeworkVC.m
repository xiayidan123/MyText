//
//  StudentUploadHomeworkVC.m
//  dev01
//
//  Created by Huan on 15/6/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  学生提交作业

#import "StudentUploadHomeworkVC.h"
#import "AddPhotoView.h"
#import "ExplainView.h"
#import "Moment.h"
#import "ShowHomeworkView.h"
#import "YBImagePickerViewController.h"
#import "OMNetWork_MyClass.h"
#import "NewhomeWorkModel.h"
#import "WowTalkWebServerIF.h"
#import "WTFile.h"
#import "MediaProcessing.h"
#import "MediaUploader.h"
#import "AppDelegate.h"
#import "OMMessageVC.h"
#import "WTUserDefaults.h"
#import "OMClass.h"
#import "Lesson.h"
#import "SchoolMember.h"
#import "OMDateBase_MyClass.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "OMMessageHelper.h"

#define interval 20
#define addPhotoViewHeight 130
#define addPhotoViewWidth self.view.bounds.size.width
#define addPhotoViewY interval
#define addPhotoViewX 0
#define showhomeworkViewHeight 180
@interface StudentUploadHomeworkVC ()<AddPhotoViewDelegate,ExplainViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YBImagePickerViewControllerDelegate,UIAlertViewDelegate>

/** 添加照片的View*/
@property (retain, nonatomic) AddPhotoView *addPhotoView;
/** 补充说明的View*/
@property (retain, nonatomic) ExplainView * explain_textView;

@property (assign, nonatomic) BOOL takePicPermission;
/** 补充说明内容*/
@property (copy, nonatomic) NSString * explain_content;
@property (retain, nonatomic) Moment * moment;
/** 选择的照片*/
@property (retain, nonatomic) NSMutableArray *selectedPhotos;

@property (retain, nonatomic) ALAssetsLibrary *assetLib;

@property (assign, nonatomic) BOOL isTakingPhoto;

@property (assign, nonatomic) BOOL dismissFromPicker;

@property (retain, nonatomic)  ShowHomeworkView *showhomeworkView;

@property (assign, nonatomic) int upload_Step;//

@property (retain, nonatomic) Homework_Moment * result_homework_moment;

@property (copy, nonatomic) NSString * messageContent;

@property (retain, nonatomic) Buddy * buddy;

@property (copy, nonatomic) NSString * schoolName;
/** 导航栏右侧按钮可否点击*/
@property (assign, nonatomic) BOOL canClick;
@end

@implementation StudentUploadHomeworkVC

-(void)dealloc{
    self.buddy = nil;
    self.messageContent = nil;
    self.addPhotoView = nil;
    self.explain_textView = nil;
    self.explain_content = nil;
    self.moment = nil;
    self.selectedPhotos = nil;
    self.assetLib = nil;
    self.showhomeworkView = nil;
    self.result_homework_moment = nil;
    self.homeworkModel = nil;
    [super dealloc];
}


- (NSMutableArray *)selectedPhotos{
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    }
    return _selectedPhotos;
}
- (NSString *)schoolName{
    if (!_schoolName) {
        SchoolMember *schoolMem = [OMDateBase_MyClass fetchClassMemberByClass_id:self.lessonmodel.class_id andMember_id:[WTUserDefaults getUid]];
        _schoolName = [schoolMem.alias copy];
    }
    return _schoolName;
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
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"确认提交作业吗？" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定",nil), nil] autorelease];
    alertView.tag = 200;
    [alertView show];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
    
    [self uiConfig];
}

- (void)configNavigation{
    self.title = NSLocalizedString(@"提交作业", nil);
}

- (void)uiConfig{
    
    /** 添加导航栏右侧按钮*/
    self.canClick = NO;
    
    /** 添加照片的View*/
    
    [self loadAddPhotoView];
    
    
    /** 补充说明的View*/
    [self loadExplainView];
    
    //    [self loadSupplment];
}


- (void)send{
    [WowTalkWebServerIF addMomentToUploadParentsOpinion:self.explain_content isPublic:NO allowReview:TRUE Latitude:@"0" Longitutde:@"0" withPlace:NULL withMomentType:@"5" withSharerange:nil withCallback:@selector(didSaveMomentInServer:) withObserver:self];
    
    self.omAlertViewForNet.title = @"正在提交";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertViewForNet showInView:self.view];
    
//    [OMNetWork_MyClass addHomeworkResultWithHomeworkID:self.homeworkModel.homework_moment.homework_id WithMomentID:self.homeworkModel.homework_moment.moment_id withCallBack:@selector(didUploadhomework:) withObserver:self];
}

- (void)loadAddPhotoView{
    _addPhotoView = [[AddPhotoView alloc] initWithFrame:CGRectMake(addPhotoViewX, addPhotoViewY, addPhotoViewWidth, addPhotoViewHeight)] ;
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

- (void)loadExplainView{
    _explain_textView = [[ExplainView alloc] initWithFrame:CGRectMake(addPhotoViewX, CGRectGetMaxY(self.addPhotoView.frame) + interval, addPhotoViewWidth, addPhotoViewHeight)];
    _explain_textView.delegate = self;
    [self.view addSubview:_explain_textView];
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
#pragma mark ExplainViewDelegate

- (void)getExplainText:(UITextView *)textView{
    if (textView.text.length || self.addPhotoView.photos.count != 0) {
        self.explain_content = textView.text;
        self.canClick = YES;
    }else{
        self.canClick = NO;
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

- (void)didUploadhomework:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.result_homework_moment = [notif userInfo][@"fileName"];
        self.upload_Step  = self.upload_Step + 1;
    }else{
        self.omAlertViewForNet.title = @"提交失败";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
}

#pragma mark - OMAlertViewForNetDelegate
- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSaveMomentInServer:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    NSMutableArray *arr_medias = [[NSMutableArray alloc] init];
    self.moment = (Moment*)[[notif userInfo] valueForKey:@"moment"];
    if (error.code == NO_ERROR) {
        [OMNetWork_MyClass addHomeworkResultWithHomeworkID:self.homeworkModel.homework_moment.homework_id WithMomentID:self.moment.moment_id withCallBack:@selector(didUploadhomework:) withObserver:self];
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
                                    self.upload_Step = self.upload_Step + 1;
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
            self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
            self.omAlertViewForNet.title = @"提交成功";
            return;
        }
        
    }
}


- (void)didGetBuddyWithUID:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.buddy = [Database buddyWithUserID:self.homeworkModel.teacher_id];
        NSString *message_text = [NSString stringWithFormat:@"%@课%@班的%@学生，已经交作业了，请批阅",self.lessonmodel.title,self.classmodel.groupNameOriginal,self.schoolName];
        
        [OMMessageHelper sendTextMessage:message_text withToBuddy:self.buddy];
    }
}

- (ALAssetsLibrary *)assetLib{
    if (_assetLib == nil){
        _assetLib = [[ALAssetsLibrary alloc]init];
    }
    return _assetLib;
}

-(void)setUpload_Step:(int)upload_Step{
    _upload_Step = upload_Step;
    
    if (_upload_Step == 2){
        self.result_homework_moment.multimedias = self.moment.multimedias;
        if ([self.delegate respondsToSelector:@selector(studentUploadHomeworkVC:didUploadHomeworkWithHomework_model:andHomework_moment:)]){
            [self.delegate studentUploadHomeworkVC:self didUploadHomeworkWithHomework_model:self.homeworkModel andHomework_moment:self.result_homework_moment ];
        }
        
        
        self.omAlertViewForNet.title = @"提交成功";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        
        
        
        self.buddy = [Database buddyWithUserID:self.homeworkModel.teacher_id];
        if (self.buddy) {
            NSString *message_text = [NSString stringWithFormat:@"%@课%@班的%@学生，已经交作业了，请批阅",self.lessonmodel.title,self.classmodel.groupNameOriginal,self.schoolName];
            
            [OMMessageHelper sendTextMessage:message_text withToBuddy:self.buddy];
        }
        else{
            [WowTalkWebServerIF getBuddyWithUID:self.homeworkModel.teacher_id withCallback:@selector(didGetBuddyWithUID:) withObserver:self];
        }
    }
    
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200 && buttonIndex == 1) {
        [self send];
    }
}

@end
