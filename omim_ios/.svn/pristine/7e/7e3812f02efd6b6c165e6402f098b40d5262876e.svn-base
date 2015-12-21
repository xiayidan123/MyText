//
//  ParentsOpinionVC.m
//  dev01
//
//  Created by 杨彬 on 15-1-1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ParentsOpinionDetailVC.h"
#import "ParentsOpinionDetailView.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"
#import "FeedBackModel.h"
#import "UploadParentsOpinionView.h"
#import "Colors.h"
#import "Constants.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PictureBrowserVC.h"
#import "OMAlertViewForNet.h"

@interface ParentsOpinionDetailVC ()<UIAlertViewDelegate>
{
    ParentsOpinionDetailView *_parentsOpinionDetailView;
    UploadParentsOpinionView *_uploadParentsOpinionView;
    FeedBackModel *_feedbackModel;
    Moment *_moment;
    ALAssetsLibrary* _assetLib;
    NSMutableArray *_selectedPhotos;
    BOOL isTakingPhoto;
    BOOL dismissFromPicker;
    BOOL hasImageInfo;
    Moment *_new_moment;
}
@property (retain, nonatomic) OMAlertViewForNet * omAlertView;
@property (retain, nonatomic) OMAlertViewForNet * opnionAlert;
@end

@implementation ParentsOpinionDetailVC

-(void)dealloc{
    if (_moment){
        [_moment release];
    }
    if (_new_moment) [_new_moment release];
    self.omAlertView = nil;
    [_selectedPhotos release];
    [_feedbackModel release];
    [_studentModel release];
    [_lesson_id release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加手势控制键盘下去
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255 green:251.0/255 blue:250.0/255 alpha:1];
    
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self configNavigation];
    
    [self prepareData];
    
    [self uiConfig];
}

//手势实现方法
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
}
- (void)uiConfig{
    
    [self loadParentsOpiniomView];
    
    [self loadUploadParentsOpiniomView];
    
}


- (void)configNavigation{
    
    self.title = self.studentModel.alias;
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareData{
    _assetLib = [PublicFunctions defaultAssetsLibrary];
    _selectedPhotos = [[NSMutableArray alloc]init];
    _feedbackModel = [[FeedBackModel alloc]init];
    [self loadData];

}


- (void)loadData{
    [WowTalkWebServerIF getLessonParentFeedbackWithLessonId:_lesson_id withStudentID:_studentModel.uid withCallback:@selector(didGetParentFeedBack:) withObserver:self];


    
}

- (void)didGetParentFeedBack:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        FeedBackModel *feedbackmodel = [[Database fetchFeedBackWithLessonID:_lesson_id withStudentID:_studentModel.uid] retain];
        _feedbackModel.feedback_id = feedbackmodel.feedback_id;
        _feedbackModel.lesson_id = feedbackmodel.lesson_id;
        _feedbackModel.moment_id = feedbackmodel.moment_id;
        _feedbackModel.student_id = feedbackmodel.student_id;
        [feedbackmodel release];
        if ((!_feedbackModel  || !_feedbackModel.moment_id)){
            if ( [[WTUserDefaults getUsertype] isEqualToString:@"1"]){
                _uploadParentsOpinionView.hidden = NO;
                UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
                uploadButton.frame = CGRectMake(-100, 0, 50, 44);
                [uploadButton setTitle:NSLocalizedString(@"提交",nil) forState:UIControlStateNormal];
                [uploadButton setTintColor:[UIColor whiteColor]];
                uploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
                [uploadButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:uploadButton];
                [self.navigationItem addRightBarButtonItem:rightBarButton];
                [rightBarButton release];
    
                return;
            }else if ( [[WTUserDefaults getUsertype] isEqualToString:@"2"]){
//                self.omAlertView.title = @"加载完成";
//                self.omAlertView.type = OMAlertViewForNetStatus_Done;
//                [self.omAlertView show];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"Parents haven't submitted comment oh",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
                alert.tag = 2000;
                [alert show];
                [alert release];
                return;
            }
        }
        self.omAlertView = [OMAlertViewForNet OMAlertViewForNet];
        self.omAlertView.type = OMAlertViewForNetStatus_Loading;
        self.omAlertView.title = @"正在加载...";
        [self.omAlertView show];

        [WowTalkWebServerIF getMomentByMomentID:_feedbackModel.moment_id withCallback:@selector(didGetMoment:) withObserver:self];
    }
}

- (void)uploadAction{
    [WowTalkWebServerIF addMomentToUploadParentsOpinion:_uploadParentsOpinionView.textView_text.text isPublic:NO allowReview:TRUE Latitude:@"0" Longitutde:@"0" withPlace:NULL withMomentType:@"5" withSharerange:nil withCallback:@selector(didSaveMomentInServer:) withObserver:self];
    
}

- (void)didSaveMomentInServer:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
        NSMutableArray *arr_medias = [[NSMutableArray alloc] init];
        
        if (error.code == NO_ERROR) {
            _new_moment = [(Moment*)[[notif userInfo] valueForKey:@"moment"] retain];
            
            [WowTalkWebServerIF uploadLessonParentFeedBackWithLessonID:_lesson_id withStudentId:_studentModel.uid withMoment_id:_new_moment.moment_id WithCallBack:@selector(didUploadFeedBack:) withObserver:self];
            
            
            // take care of images
            if (_selectedPhotos.count > 0) {
                __block NSMutableArray* files = [[NSMutableArray alloc] init];
                //            __block int i = 0;
                __block NSMutableArray* fetchedAssetArray = [[NSMutableArray alloc] init];
                for (NSURL* url in _selectedPhotos) {
                    [_assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
                        [fetchedAssetArray addObject:asset];
                        NSLog(@"fetched asset array %zi/%zi",fetchedAssetArray.count,[_selectedPhotos count]);
                        
                        if (fetchedAssetArray.count == [_selectedPhotos count]) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                for (ALAsset *aAsset in fetchedAssetArray) {
                                    @autoreleasepool {
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
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSLog(@"final process on main thread");
                                    [arr_medias addObjectsFromArray:files];
                                    _new_moment.multimedias = arr_medias;
                                    [Database storeMoment:_new_moment];
                                    [files release];
                                    // save the upload work in background
                                    for (WTFile* file in arr_medias) {
                                        if ([file.ext isEqualToString:@"aac"]) {
                                            [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:_new_moment.moment_id isThumbnail:FALSE];
                                        }
                                        else{
                                            [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:_new_moment.moment_id isThumbnail:FALSE];
                                            [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:_new_moment.moment_id isThumbnail:TRUE];
                                        };
                                    }
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_NEW_MOMENT object:_new_moment.moment_id];
                                    [[MediaUploader sharedUploader] upload];
                                    
                                    [self backAction];
                                    
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
                            [self backAction];
                            return;
                        });
                    }];
                }
            }
            else{
                _new_moment.multimedias = arr_medias;
                [Database storeMoment:_new_moment];
                
                // save the upload work in background
                for (WTFile* file in arr_medias) {
                    if ([file.ext isEqualToString:@"aac"]) {
                        [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:_new_moment.moment_id isThumbnail:FALSE];
                    }
                    else{
                        [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:_new_moment.moment_id isThumbnail:FALSE];
                        [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:_new_moment.moment_id isThumbnail:TRUE];
                    };
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_NEW_MOMENT object:_new_moment.moment_id];
                
                [[MediaUploader sharedUploader] upload];
                [self backAction];
                
                return;
            }
        }
        else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your network is slow, please try it later", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        [arr_medias release];
        
    }
}

- (void)didUploadFeedBack:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.opnionAlert.title = @"意见反馈成功";
        self.opnionAlert.type = OMAlertViewForNetStatus_Done;
//        [self.opnionAlert show];
        /*发布意见后提示*/
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"家长意见" message:@"反馈成功！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alter show];
//        [alter release];
    }else{
        self.opnionAlert.title = @"意见反馈失败";
        self.opnionAlert.type = OMAlertViewForNetStatus_Failure;
//        [self.opnionAlert show];
    }
}

- (void)didGetMoment:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        _moment =  [[Database fetchMomentWithMomentID:_feedbackModel.moment_id] retain];
        _parentsOpinionDetailView.hidden = NO;
        _parentsOpinionDetailView.parentsOpinonModel = _moment;
        UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:511];
        scrollView.contentSize = CGSizeMake(0, _parentsOpinionDetailView.frame.size.height + 64);
        self.omAlertView.title = @"加载完成";
        self.omAlertView.type = OMAlertViewForNetStatus_Done;
    }else{
        self.omAlertView.title = @"加载未完成，请检查网络";
        self.omAlertView.type = OMAlertViewForNetStatus_Failure;
    }
    
}


- (void)sure{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"确认提交意见" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确认", nil), nil] autorelease];
    [alertView show];
}

- (void)loadParentsOpiniomView{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -64, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    scrollView.tag = 511;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    _parentsOpinionDetailView = [[[NSBundle mainBundle]loadNibNamed:@"ParentsOpinionDetailView" owner:self options:nil] firstObject];
    _parentsOpinionDetailView.frame = CGRectMake(0, 64, _parentsOpinionDetailView.frame.size.width, _parentsOpinionDetailView.frame.size.height);
    _parentsOpinionDetailView.delegate = self;
    _parentsOpinionDetailView.hidden = YES;
    _parentsOpinionDetailView.layer.masksToBounds = YES;
    [scrollView addSubview:_parentsOpinionDetailView];
}


- (void)loadUploadParentsOpiniomView{
    _uploadParentsOpinionView = [[[NSBundle mainBundle]loadNibNamed:@"UploadParentsOpinionView" owner:self options:nil] firstObject];
    _uploadParentsOpinionView.frame = CGRectMake(0, 0, _uploadParentsOpinionView.frame.size.width, _uploadParentsOpinionView.frame.size.height);
    _uploadParentsOpinionView.text_placeholder = @"家长意见";
    _uploadParentsOpinionView.hidden = YES;
    _uploadParentsOpinionView.layer.masksToBounds = YES;
    [self.view addSubview:_uploadParentsOpinionView];
    
    [self loadPhotoView];
}


- (void)loadPhotoView{
    
    UIScrollView* sv_photo = (UIScrollView*)[_uploadParentsOpinionView viewWithTag:510];
    if (sv_photo== nil) {
        sv_photo = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 99, _uploadParentsOpinionView.bounds.size.width - 20, 80)];
        sv_photo.tag = 510;
        sv_photo.contentSize = CGSizeMake(_uploadParentsOpinionView.bounds.size.width - 20, 0);
        [_uploadParentsOpinionView addSubview:sv_photo];
        
        [sv_photo release];
    }
    
    for (UIView* subview in [sv_photo subviews]) {
        [subview removeFromSuperview];
    }
    for (int i = 0; i < [_selectedPhotos count]; i++) {
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 72*i, 10, 64, 64)];
        
        [sv_photo addSubview:imageview];
        imageview.userInteractionEnabled=YES;
        [imageview addGestureRecognizer:[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(momentPhotoClicked:)] autorelease]];
        [imageview release];
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        dispatch_queue_t queue = dispatch_queue_create("loadphoto", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            [_assetLib assetForURL:[_selectedPhotos objectAtIndex:i] resultBlock:^(ALAsset *asset) {
                UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageview.image = image;
                    dispatch_group_leave(group);
                });
            }failureBlock:^(NSError *error) {
                
                dispatch_group_leave(group);
            }];
        });
    }
    
    if ([_selectedPhotos count] == 0) {
        sv_photo.backgroundColor = [UIColor clearColor];
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 64, 64)];
        imageview.image = [UIImage imageNamed:@"timeline_add_photo.png"];
        
        UIButton* button = [[UIButton alloc] initWithFrame:imageview.frame];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel* lbl_desc = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 210, 84)];
        lbl_desc.backgroundColor = [UIColor clearColor];
        lbl_desc.font = [UIFont systemFontOfSize:17];
        lbl_desc.textColor = [Colors wowtalkbiz_Text_grayColorTwo];
        lbl_desc.text = NSLocalizedString(@"Add photos", nil);
        lbl_desc.textAlignment = NSTextAlignmentLeft;
        
        [sv_photo addSubview:imageview];
        [sv_photo addSubview:button];
        [sv_photo addSubview:lbl_desc];
        [imageview release];
        [button release];
        [lbl_desc release];
    }
    else{
        sv_photo.backgroundColor = [UIColor clearColor];
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10+72*[_selectedPhotos count], 10, 64, 64)];
        imageview.image = [UIImage imageNamed:@"timeline_add_photo.png"];
        
        UIButton* button = [[UIButton alloc] initWithFrame:imageview.frame];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        [sv_photo addSubview:imageview];
        [sv_photo addSubview:button];
        
        [imageview release];
        [button release];
    }
    
    [sv_photo setContentSize:CGSizeMake(10+72*([_selectedPhotos count]+1), 0)];
    sv_photo.showsHorizontalScrollIndicator = TRUE;
    sv_photo.showsVerticalScrollIndicator = FALSE;
}


-(void)momentPhotoClicked:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"photo clicked %zi",recognizer.view.tag);
    [self viewActualPhotoWithTag:recognizer.view.tag];
}

#pragma mark ----- gallery view controller delegate
-(void)didDeletePhotosInGallery:(NSMutableArray *)arr_deleted
{
    for (NSURL* url in arr_deleted) {
        [_selectedPhotos removeObject:url];
    }
    [self loadPhotoView];
}


#pragma mark ----- AddPhoto
-(void)viewActualPhotoWithTag:(NSInteger)tag{
    GalleryViewController* gcv= [[GalleryViewController alloc] init];
    gcv.arr_assets = _selectedPhotos;
    gcv.isViewAssests = TRUE;
    gcv.isEnableDelete = TRUE;
    gcv.delegate = self;
    gcv.startpos = tag;
    
    [self.navigationController pushViewController:gcv animated:YES];
    [gcv release];
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self.view window] == nil)
    {
        self.view = nil;
    }
}


-(void)addPhoto
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:Nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Select from album", nil),NSLocalizedString(@"Take a photo", nil), nil];
    [sheet showInView:self.view];
    [sheet release];
}


#pragma mark ----- action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openAlbum];
    }
    else if (buttonIndex == 1){
        [self openCamera];
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000){
        [self.navigationController popViewControllerAnimated:YES];
    }else if (buttonIndex){
        self.opnionAlert = [OMAlertViewForNet OMAlertViewForNet];
        self.opnionAlert.title = @"正在提交";
        self.opnionAlert.type = OMAlertViewForNetStatus_Loading;
        [self.opnionAlert show];
        [self uploadAction];
    }
}


#pragma mark ----- photo related
-(void)openAlbum{
    isTakingPhoto = FALSE;
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9 ;
    
    if ([_selectedPhotos count] > 0) {
        __block NSMutableArray* assets = [[NSMutableArray alloc] init];
        
        __block int i = 0;
        
        for (NSURL* url in _selectedPhotos) {
            [_assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
                i++ ;
                [assets addObject:asset];
                if (i == [_selectedPhotos count]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imagePickerController.TotalSelectedArrays = [[[NSMutableOrderedSet alloc] initWithArray:assets] autorelease];
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
                        [self presentViewController:navigationController animated:YES completion:NULL];
                        [imagePickerController release];
                        [navigationController release];
                        dismissFromPicker = TRUE;
                        [assets release];
                    });
                }
                
            } failureBlock:^(NSError *error) {
                [WTHelper WTLog:@"can't read the asset"];
            }];
        }
    }
    
    else{
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
        [imagePickerController release];
        [navigationController release];
        dismissFromPicker = TRUE;
    }
}

-(void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [picker setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeImage]];
        [picker setDelegate:self];
        
        dismissFromPicker = TRUE;
        isTakingPhoto = TRUE;
        
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }
    else
        return;
}


#pragma mark ----- QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if (isTakingPhoto) {
        isTakingPhoto = FALSE;
        NSString *mediaType = info[UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
        {
            // Media is an image
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            
            [_assetLib writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation*)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                [_assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    [_selectedPhotos addObject:assetURL];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self loadPhotoView];
                    
                } failureBlock:^(NSError *error) {
                    [self dismissViewControllerAnimated:YES completion:NULL];
                    [self loadPhotoView];
                }];
            }];
        }
    }
    else{
        if(imagePickerController.allowsMultipleSelection) {
            [_selectedPhotos removeAllObjects];
            for (ALAsset* asset in info ) {
                NSURL* url = [[asset defaultRepresentation] url];
                [_selectedPhotos addObject:url];
            }
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
        [self loadPhotoView];
    }
}


- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(NSString*)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return NSLocalizedString(@"select all", nil);
}


- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return NSLocalizedString(@"Deselect all", nil);
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"%@%zi%@",NSLocalizedString(@"Photo", nil), numberOfPhotos,NSLocalizedString(@"张", nil)];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"%@%zi%@",NSLocalizedString(@"Video", nil), numberOfVideos,NSLocalizedString(@"Clips", nil)];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"%@%zi%@、%@%zi%@",NSLocalizedString(@"Photo", nil), numberOfPhotos,NSLocalizedString(@"张", nil), NSLocalizedString(@"Video", nil), numberOfVideos,NSLocalizedString(@"Clips", nil)];
}

#pragma mark ParentsOpinionDetailVCDelegate

- (void)enterParentsOpinionDetailVC:(int)SelectedIndex
{
    PictureBrowserVC *picVc = [[PictureBrowserVC alloc] init];
    picVc.PageIndex = SelectedIndex;
    picVc.moment = _moment;
    [self.navigationController pushViewController:picVc animated:YES];
    
}

@end
