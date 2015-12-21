//
//  StuSettingHomeworkVC.m
//  dev01
//
//  Created by Huan on 15/8/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  学生提交作业

#import "StuSettingHomeworkVC.h"
#import "YBImgePickerView.h"
#import "YBImagePickerViewController.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "WTFile.h"
#import "NewhomeWorkModel.h"
#import "OMNetWork_MyClass.h"
#import "Lesson.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MediaProcessing.h"
#import "MediaUploader.h"
#import "OMMessageHelper.h"
#import "Lesson.h"
#import "OMClass.h"
#import "SchoolMember.h"
#import "OMDateBase_MyClass.h"
#import "WTUserDefaults.h"

@interface StuSettingHomeworkVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,YBImagePickerViewControllerDelegate,YBImgePickerViewDelegate,OMAlertViewForNetDelegate>


/** 照片选择*/
@property (retain, nonatomic) YBImgePickerView * imagePickerView;


/** 作业内容的textView*/
@property (retain, nonatomic) UITextView * contentTextView;

/** 选中照片数组*/
@property (retain, nonatomic) NSMutableArray * selectedPhotos;

@property (retain, nonatomic) ALAssetsLibrary* assetLib;

@property (retain, nonatomic) Moment * moment;

@property (assign, nonatomic) int upload_Step;

@property (retain, nonatomic) Buddy * buddy;

@property (retain, nonatomic) Homework_Moment * result_homework_moment;
/** 学校昵称*/
@property (copy, nonatomic) NSString * schoolName;
/** 导航栏按钮可否点击*/
@property (assign, nonatomic) BOOL canClick;
@end

@implementation StuSettingHomeworkVC

- (void)dealloc{
    
    self.classmodel = nil;
    
    self.homeworkModel = nil;
    
    self.selectedPhotos = nil;
    
    self.lessonModel = nil;
    
    self.imagePickerView = nil;
    
    self.contentTextView = nil;
    
    self.buddy = nil;
    
    self.result_homework_moment = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提交作业";
    
    self.imagePickerView.delegate = self;
    
    self.navigation_back_button_title=@"取消";
    
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.imagePickerView.y = 74;
    
    self.canClick = NO;
}

#pragma mark 导航栏右边点击事件
- (void)affirmSend{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"确认提交作业吗？" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定",nil), nil] autorelease];
    alertView.tag = 200;
    [alertView show];
}


#pragma mark setHomework - 上传作业

- (void)setHomework{
    self.omAlertViewForNet = [OMAlertViewForNet OMAlertViewForNet];
    self.omAlertViewForNet.title = @"正在提交作业";
    self.omAlertViewForNet.delegate = self;
    self.omAlertViewForNet.duration = 1.0;
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
    [self.omAlertViewForNet show];
    
    //获取moment_id
    [WowTalkWebServerIF addMomentToUploadParentsOpinion:self.contentTextView.text isPublic:NO allowReview:TRUE Latitude:@"0" Longitutde:@"0" withPlace:NULL withMomentType:@"5" withSharerange:nil withCallback:@selector(didSaveMomentInServer:) withObserver:self];
    
}

#pragma mark set - get 方法

- (YBImgePickerView *)imagePickerView{
    if (!_imagePickerView) {
        YBImgePickerView *imagePickerView = [[YBImgePickerView imagePickerView] retain];
        imagePickerView.width = self.view.width;
        imagePickerView.height = 150;
        imagePickerView.x = 0;
        imagePickerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:imagePickerView];
        _imagePickerView = imagePickerView;
    }
    return _imagePickerView;
}

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.x = 0;
        _contentTextView.width = self.view.width;
        _contentTextView.height = 150;
        _contentTextView.delegate = self;
        [self.view addSubview:_contentTextView];
    }
    return _contentTextView;
}

- (NSMutableArray *)selectedPhotos{
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    }
    return _selectedPhotos;
}

- (ALAssetsLibrary *)assetLib{
    if (!_assetLib) {
        _assetLib = [[ALAssetsLibrary alloc] init];
    }
    return _assetLib;
}

- (NSString *)schoolName{
    if (!_schoolName) {
        SchoolMember *schoolMem = [OMDateBase_MyClass fetchClassMemberByClass_id:self.lessonModel.class_id andMember_id:[WTUserDefaults getUid]];
        _schoolName = [schoolMem.alias copy];
    }
    return _schoolName;
}


-(void)setUpload_Step:(int)upload_Step{
    _upload_Step = upload_Step;
    
    if (_upload_Step == 2){
        self.result_homework_moment.multimedias = self.moment.multimedias;
        
        self.omAlertViewForNet.title = @"提交成功";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        self.omAlertViewForNet.duration = 1.0;
        
        
        self.buddy = [Database buddyWithUserID:self.homeworkModel.teacher_id];
        if (self.buddy) {
            NSString *message_text = [NSString stringWithFormat:@"%@课%@班的%@学生，已经交作业了，请批阅",self.lessonModel.title,self.classmodel.groupNameOriginal,self.schoolName];
            
            [OMMessageHelper sendTextMessage:message_text withToBuddy:self.buddy];
        }
        else{
            [WowTalkWebServerIF getBuddyWithUID:self.homeworkModel.teacher_id withCallback:@selector(didGetBuddyWithUID:) withObserver:self];
        }
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



#pragma mark - UploadHomeworkViewDelegate 获取imagePickerView对象  位置信息 与  选中照片的数组

- (void)imagePickerView:(YBImgePickerView *)imagePickerView changeFrame:(CGRect) frame{
    self.imagePickerView.frame = frame;
    self.contentTextView.y = CGRectGetMaxY(frame) + 10;
    self.selectedPhotos = imagePickerView.selected_image_array;
}

#pragma mark - YBImagePickerViewControllerDelegate

- (void)YBImagePickerViewController:(YBImagePickerViewController *)imagePickerVC selectedPhotoArray:(NSArray *)selected_photo_array{
    
    NSMutableArray *selected_image_array = [[NSMutableArray alloc]initWithArray:selected_photo_array];
    
    self.imagePickerView.selected_image_array = selected_image_array;
    
    if (selected_image_array.count || self.contentTextView.text.length) {
        self.canClick = YES;
    }else{
        self.canClick = NO;
    }
    
}
#pragma mark didSaveMomentInServer  是否上传成功moment

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
            self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
            self.omAlertViewForNet.title = @"提交成功";
            self.omAlertViewForNet.duration = 1.5;
            return;
        }
        
    }
    
}

#pragma mark didUploadhomework 是否提交作业成功
- (void)didUploadhomework:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.result_homework_moment = [notif userInfo][@"fileName"];
        self.upload_Step += 1;
        self.omAlertViewForNet.title = @"提交作业成功";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
    }else{
        self.omAlertViewForNet.title = @"提交失败";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
        self.omAlertViewForNet.duration = 1.5;
    }
}
- (void)didGetBuddyWithUID:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.buddy = [Database buddyWithUserID:self.homeworkModel.teacher_id];
        NSString *message_text = [NSString stringWithFormat:@"%@课%@班的%@学生，已经交作业了，请批阅",self.lessonModel.title,self.classmodel.groupNameOriginal,self.schoolName];
        [OMMessageHelper sendTextMessage:message_text withToBuddy:self.buddy];
    }
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length) {
        self.canClick = YES;
    }else{
        self.canClick = NO;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.canClick = NO;
        [self setHomework];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
