//
//  NewMomentViewController.m
//  omim
//
//  Created by Li  Beck on 14-3-13.
//  Implemented by Elvis Shu
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "NewMomentViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PublicFunctions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Constants.h"

#import "WTHeader.h"

#import "UIPlaceHolderTextView.h"

#import "GalleryViewController.h"
#import "AppDelegate.h"


#define KEY_BAORD_HEIGHT 216.0
#define COLUMN_NO        4
#define CELL_SIZE_WHITH  70
#define CELL_SIZE_HEIGHT 70

@interface NewMomentViewController ()
{
    BOOL locationInfoShown;
    BOOL isPhotoMode;
    BOOL isRecordMode;
    BOOL isRecording;
    BOOL isPlaying;
    
    BOOL hasRecordInfo;
    BOOL hasImageInfo;
    int seconds;
    int totalseconds;
    
    BOOL isKeyboardShown;
    
    BOOL dismissFromPicker;
    
    double latitude;
    double longitude;
    
    int indexOfImageQueue;
    BOOL failToUploadVoice;
    
    int indexOfMediaReportQueue;
    
    
    BOOL isTakingPhoto;
    
    
    BOOL reCreateMode;
    
    BOOL createMomentFailed;
    BOOL reportMediaFailed;
    
    
    BOOL comeFromLargePhoto;
    
}

@property (nonatomic,retain) Moment* now_moment;

@property (nonatomic,retain) NSMutableArray* arr_medias;

@property (nonatomic,retain) ALAsset* lastAsset;

@property (nonatomic,retain) NSTimer* timer;

@property (nonatomic,assign) ALAssetsLibrary* assetLib;

@end

@implementation NewMomentViewController

#pragma mark - navigation bar config
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didSaveMomentInServer:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.now_moment = (Moment*)[[notif userInfo] valueForKey:@"moment"];
        
        if (hasRecordInfo) {
            NSString* filepath = [MediaProcessing saveVoiceClipToLocal];
            if (filepath) {
                WTFile* file = [[WTFile alloc] init];
                file.fileid = filepath;
                file.ext = @"aac";
                file.duration = totalseconds;
                [self.arr_medias addObject:file];
                [file release];
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@ "The record file is broken, please record it again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                [alert show];
                [alert release];
                [self enableOperations];
                return;
            }
        }
        
        if (hasImageInfo) {
            __block NSMutableArray* files = [[NSMutableArray alloc] init];
            __block int i = 0;
            for (NSURL* url in self.selectedPhotos) {
                [self.assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
                    i ++ ;
                    NSArray* array = [MediaProcessing savePhotoFromLibraryToLocal:asset];
                    if (array) {
                        WTFile* file = [[WTFile alloc] init];
                        file.thumbnailid = [array objectAtIndex:1];
                        file.fileid = [array objectAtIndex:0];
                        file.ext = @"jpg";
                        [files addObject:file];
                        [file release];
                    }
                    // all the images are saved locally.
                    if (i == [self.selectedPhotos count]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.arr_medias addObjectsFromArray:files];
                            [files release];
                            self.now_moment.multimedias = self.arr_medias;
                            [Database storeMoment:self.now_moment];
                            
                             // save the upload work in background
                            for (WTFile* file in self.arr_medias) {
                                if ([file.ext isEqualToString:@"aac"]) {
                                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.now_moment.moment_id isThumbnail:FALSE];
                                }
                                else{
                                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.now_moment.moment_id isThumbnail:FALSE];
                                    [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:self.now_moment.moment_id isThumbnail:TRUE];
                                };
                            }

                            [AppDelegate sharedAppDelegate].needToAddNewMoment = TRUE;

                            [[AppDelegate sharedAppDelegate].moments addObject: self.now_moment.moment_id];
                            

                            [[MediaUploader sharedUploader] upload];
                            
                            [self goBack];
                            
                            return;
                            
                        });
                    }
                } failureBlock:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //TODO: localization string here
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@ "The image file is broken, please select it again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                        [alert show];
                        [alert release];
                        [self enableOperations];
                        return;
                    });
                }];
            }
        }
        else{
             self.now_moment.multimedias = self.arr_medias;
             [Database storeMoment:self.now_moment];
    
            // save the upload work in background
            for (WTFile* file in self.arr_medias) {
                if ([file.ext isEqualToString:@"aac"]) {
                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.now_moment.moment_id isThumbnail:FALSE];
                }
                else{
                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.now_moment.moment_id isThumbnail:FALSE];
                    [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:self.now_moment.moment_id isThumbnail:TRUE];
                }; 
            }
            
            [AppDelegate sharedAppDelegate].needToAddNewMoment = TRUE;
            [[AppDelegate sharedAppDelegate].moments addObject: self.now_moment.moment_id];
            
            [[MediaUploader sharedUploader] upload];
            [self goBack];
            
            return;
        }
    }
    else{
        NSLog(@"create text moment failed");
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your network is slow, please try it later", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles: nil];
        [alert show];
        [alert release];
        [self enableOperations];
    }
}

-(void)generateNewMoment
{
    if ([NSString isEmptyString: self.textView.text]&& !hasRecordInfo && !hasImageInfo && !locationInfoShown ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"The moment is empty, please write something", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    else{
        
        [self disableOperations];
        
        if (isPlaying) {
            [self playRecord]; // stop the record
        }
        
        // generate a moment in server.
//        [WowTalkWebServerIF addMoment:self.textView.text isPublic:TRUE allowReview:TRUE Latitude:locationInfoShown?[NSString stringWithFormat:@"%f",latitude]:@"0" Longitutde:locationInfoShown?[NSString stringWithFormat:@"%f",longitude]:@"0" withPlace:self.lbl_location.text withCallback:@selector(didSaveMomentInServer:) withObserver:self];
        
    }
}


-(void)enableOperations
{
    self.btn_addLocation.enabled = TRUE;
            self.btn_addPhoto.enabled = TRUE;
            self.btn_addVoice.enabled = TRUE;
            self.btn_album.enabled= TRUE;
            self.btn_camera.enabled = TRUE;
            self.btn_delete.enabled = TRUE;
            self.btn_play.enabled = TRUE;
            self.btn_record.enabled = TRUE;
            
    [self.navigationItem enableLeftBarButtonItem];
    [self.navigationItem enableRightBarButtonItem];

            self.textView.editable = true;
}

-(void)disableOperations
{
    self.btn_addLocation.enabled = FALSE;
    self.btn_addPhoto.enabled = FALSE;
    self.btn_addVoice.enabled = FALSE;
    self.btn_album.enabled= FALSE;
    self.btn_camera.enabled = FALSE;
    self.btn_delete.enabled = FALSE;
    self.btn_play.enabled = FALSE;
    self.btn_record.enabled = FALSE;
    
    [self.navigationItem disableLeftBarButtonItem];
    [self.navigationItem disableRightBarButtonItem];
    
    self.textView.editable = FALSE;
}


- (void)configNav
{
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"New moment",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;

    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
       [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
//    UIBarButtonItem *rightBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_CONFIRM_IMAGE] selector:@selector(generateNewMoment)];
    UIBarButtonItem *rightBarButton = [PublicFunctions getCustomNavDoneButtonWithTarget:self selector:@selector(generateNewMoment)];
       [self.navigationItem addRightBarButtonItem:rightBarButton];
    [rightBarButton release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark view lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.selectedPhotos = nil;
    self.arr_medias = nil;
    [super dealloc];
}

// changes : set the height of photo and record view to 214

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.uv_bg_below setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    
    [self.uv_photo setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    [self.uv_record setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    
    
    [self configNav];
    
    [self.uv_additems setFrame:CGRectMake(0, [UISize screenHeightNotIncludingStatusBarAndNavBar] - 214 - 40, 320, 40)];
    [self.textView setFrame:CGRectMake(10, 10, 300, self.uv_additems.frame.origin.y-40)];
    
    [self.uv_photo setFrame:CGRectMake(0, [UISize screenHeightNotIncludingStatusBarAndNavBar] - 214, 320, 214)];
    
    [self.uv_record setFrame:CGRectMake(0, [UISize screenHeightNotIncludingStatusBarAndNavBar] - 214, 320, 214)];
    
    [self.uv_bg_below setFrame:CGRectMake(0, self.uv_additems.frame.origin.y+self.uv_additems.frame.size.height, 320, [UISize screenHeight] - (self.uv_additems.frame.origin.y+self.uv_additems.frame.size.height))];
    
    [self.location_container setFrame:CGRectMake(0, self.uv_additems.frame.origin.y - 30, 320, 30)];

    
    self.textView.placeholder = NSLocalizedString(@"Write your moment!", nil);
    
    [self.btn_addLocation addTarget:self action:@selector(toggleLocationInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_addPhoto addTarget:self action:@selector(becomePhotoMode) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_addVoice addTarget:self action:@selector(becomeVoiceMode) forControlEvents:UIControlEventTouchUpInside];
    
    // image related
    [self.iv_image setFrame:CGRectMake(75, 30, 170, 110)];
    [self.iv_image setImage:[UIImage imageNamed:@"write_noimage.png"]];
    
    [self.btn_camera setFrame:CGRectMake(20, 160, 130, 44)];
    [self.btn_album setFrame:CGRectMake(170, 160, 130, 44)];
    
    [self.btn_camera setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_GRAY_BUTTON] forState:UIControlStateNormal];
    [self.btn_album setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_GRAY_BUTTON] forState:UIControlStateNormal];
    
    [self.btn_camera setTitle:NSLocalizedString(@"Take a photo", nil) forState:UIControlStateNormal];
    [self.btn_album setTitle:NSLocalizedString(@"Album", nil) forState:UIControlStateNormal];
    
    [self.btn_album setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn_camera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.btn_album addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_camera addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    
    [self.lbl_count setFrame:CGRectMake(10, 20, 310, 30)];
    [self.lbl_count setBackgroundColor:[UIColor clearColor]];
    [self.lbl_count setFont:[UIFont systemFontOfSize:17]];
    [self.lbl_count setTextColor:[UIColor grayColor]];
    [self.lbl_count setTextAlignment:NSTextAlignmentLeft];
    
    [self refreshCountLabel];
    
    [self.sv_images setFrame:CGRectMake(0, 50, 320, 100)];
    [self.sv_images setBackgroundColor:[UIColor clearColor]];
    [self.sv_images setHidden:TRUE];
    [self.sv_images setShowsHorizontalScrollIndicator:FALSE];
    
    //record
    [self.iv_mic setFrame:CGRectMake(75, 30, 170, 110)];
    [self.iv_mic setImage:[UIImage imageNamed:@"write_mic_bg.png"]];
    [self.btn_record setFrame:CGRectMake(70, 160, 180, 44)];
    [self.btn_record addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn_record setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_GRAY_BUTTON] forState:UIControlStateNormal];
    [self.btn_record setTitle:NSLocalizedString(@"Start recording", nil) forState:UIControlStateNormal];
    
    [self.btn_record setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.lbl_des setFrame:CGRectMake(70, 20, 180, 40)];
    
    [self.lbl_des setTextAlignment:NSTextAlignmentCenter];
    [self.lbl_des setFont:[UIFont systemFontOfSize:20]];
    
    [self.lbl_timer setFrame:CGRectMake(60, 60, 200, 80)];
    [self.lbl_timer setTextAlignment:NSTextAlignmentCenter];
    [self.lbl_timer setFont:[UIFont systemFontOfSize:70]];
    [self.lbl_timer setText:NSLocalizedString(@"00:00", nil)];
    
    [self.lbl_timer setHidden: TRUE];
    [self.lbl_des setHidden:TRUE];
    
    [self.btn_play setFrame:CGRectMake(20, 160, 130, 44)];
    [self.btn_delete setFrame:CGRectMake(170, 160, 130, 44)];
    
    [self.btn_play setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
    [self.btn_delete setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_GRAY_BUTTON] forState:UIControlStateNormal];
    
    [self.btn_play setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
    [self.btn_delete setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    
    [self.btn_delete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn_play setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btn_delete addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_play addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn_delete setHidden:TRUE];
    [self.btn_play setHidden:TRUE];
    
    // location info
    [self.lbl_location setBackgroundColor:[UIColor clearColor]];
    self.lbl_location.numberOfLines = 2;
    self.lbl_location.font = [UIFont systemFontOfSize:9];
    
    [self.location_container setHidden:TRUE];
   
    if (self.selectedPhotos == nil) {
        self.selectedPhotos = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if (self.arr_medias == nil) {
         self.arr_medias = [[[NSMutableArray alloc] init] autorelease];  
    }
  
    self.btn_addLocation.enabled = TRUE;
    self.btn_addPhoto.enabled = TRUE;
    self.btn_addVoice.enabled = TRUE;
    self.btn_album.enabled= TRUE;
    self.btn_camera.enabled = TRUE;
    self.btn_delete.enabled = TRUE;
    self.btn_play.enabled = TRUE;
    self.btn_record.enabled = TRUE;
    
    [self.navigationItem enableRightBarButtonItem];
    [self.navigationItem enableLeftBarButtonItem];
    
    self.textView.editable = YES;
    
    if (!self.assetLib) {
        self.assetLib = [PublicFunctions defaultAssetsLibrary];
       //  NSLog(@"lib in load: %@", self.assetLib);
    }
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}


-(void)viewDidDisappear:(BOOL)animated{
    if (isPlaying) {
        [self playRecord]; // stop the record
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    isTakingPhoto = FALSE;
    
    if (dismissFromPicker) {
        dismissFromPicker = FALSE;
        [self initImageScollView];
        [self refreshCountLabel];
        
    }
    else if (comeFromLargePhoto){
        comeFromLargePhoto = FALSE;
    }
    else
        [self.textView becomeFirstResponder];
}


-(void)initImageScollView
{
    if ([self.selectedPhotos count] == 0) {
        [self.sv_images setHidden:TRUE];
        [self.iv_image setHidden:FALSE];
        hasImageInfo = FALSE;
        return;
    }
    
    [self.sv_images setHidden:FALSE];
    [self.iv_image setHidden:TRUE];
    hasImageInfo = TRUE;
    
    for (UIView* subview in [self.sv_images subviews]) {
        [subview removeFromSuperview];
    }
    
    for (int i = 0; i< [self.selectedPhotos count]; i++) {
        
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 95*i, 10, 75, 75)];
        
        
        
        UIButton* button = [[UIButton alloc] initWithFrame:imageview.frame];
        button.tag = i;
        [button addTarget:self action:@selector(viewLargePhoto:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton* btn_delete = [[UIButton alloc] initWithFrame:CGRectMake(71 + 95*i, 5, 29, 29)];
        btn_delete.tag = 100 + i;
        [btn_delete addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [btn_delete setBackgroundImage:[UIImage imageNamed:@"write_btn_delete.png"] forState:UIControlStateNormal];
        
        [self.sv_images addSubview:imageview];
        [self.sv_images addSubview:button];
        [self.sv_images addSubview:btn_delete];
        
        [imageview release];
        [button release];
        [btn_delete release];
        
        [self.assetLib assetForURL:[self.selectedPhotos objectAtIndex:i] resultBlock:^(ALAsset *asset) {
            UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageview.image = image;
            }
                           );
            
            
        } failureBlock:^(NSError *error) {
            
        }];
        
        // ALAsset* asset = [self.selectedPhotos objectAtIndex:i];
        
    }
    [self.sv_images setContentSize:CGSizeMake(40+95*[self.selectedPhotos count], 100)];
}

#pragma mark button method

-(void)viewLargePhoto:(id)sender
{
    GalleryViewController* gcv= [[GalleryViewController alloc] init];
    
    gcv.arr_assets = self.selectedPhotos;
    gcv.isViewAssests = TRUE;
    gcv.startpos = [(UIButton*)sender tag];
  
    comeFromLargePhoto = TRUE;
    
    [self.navigationController pushViewController:gcv animated:YES];
    [gcv release];
}

-(void)deletePhoto:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    [self.selectedPhotos removeObjectAtIndex:btn.tag-100];
    
    [self initImageScollView];
    
    [self refreshCountLabel];
}

-(void)openAlbum
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9 ;
    
    if ([self.selectedPhotos count] > 0) {
        __block NSMutableArray* assets = [[NSMutableArray alloc] init];
        
        __block int i = 0;
        
        for (NSURL* url in self.selectedPhotos) {
            [self.assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
                i++ ;
                [assets addObject:asset];
                if (i == [self.selectedPhotos count]) {
                    
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

-(void)openCamera
{
    if ([self.selectedPhotos count] >= 9) {
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [picker setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeImage]];
        [picker setDelegate:self];
        
        dismissFromPicker = TRUE;
        isTakingPhoto = TRUE;
        
//        [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }
    else
        return;
}

-(void)record
{
    if (isRecording) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        [self.btn_record setTitle:NSLocalizedString(@"Start recording", nil) forState:UIControlStateNormal];
        
        [self.lbl_des setText:NSLocalizedString(@"Finish recording", nil)];
        [self.btn_record setHidden:TRUE];
        
        [self.btn_delete setHidden:FALSE];
        [self.btn_play setHidden:FALSE];
        
        totalseconds = seconds;
        
        isRecording = FALSE;
        [self.recorder stop];
        if (totalseconds > 1) {
            hasRecordInfo = TRUE;
        }
        else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString( @"The recording time is too short, please record it again",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        [self refreshIcons];
        
    }
    else{
        [self.btn_record setTitle:NSLocalizedString(@"Finish recording", nil) forState:UIControlStateNormal];
        
        [self.lbl_des setText:NSLocalizedString(@"Recording", nil)];
        
        
        if (self.recordPlayer != nil && self.recordPlayer.isPlaying)
        {
            [self.recordPlayer stop];
        }
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
        
        if(err){
            return;
        }
        
        [audioSession setActive:YES error:&err];
        
        if(err){
            return;
        }
        
        self.recordSetting = [[[NSMutableDictionary alloc] init] autorelease];
        
        // We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
        [self.recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        
        // We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
        [self.recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
        
        // We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
        [self.recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        
        NSURL *url = [NSURL fileURLWithPath:[NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:@"temprecorder" WithSubFolder:SDK_MOMENT_MEDIA_DIR withExtention:AAC]]];
        
        err = nil;
        
        NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
        
        if(audioData)
        {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:[url path] error:&err];
        }
        
        err = nil;
        
        self.recorder = [[[ AVAudioRecorder alloc] initWithURL:url settings:self.recordSetting error:&err] autorelease];
        
        if(!self.recorder){
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: [err localizedDescription]
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        //prepare to record
        [self.recorder setDelegate:self];
        
        [self.recorder prepareToRecord];
        
        self.recorder.meteringEnabled = YES;
        
//        BOOL audioHWAvailable = audioSession.inputIsAvailable;
        BOOL audioHWAvailable = audioSession.inputAvailable;
        
        if (! audioHWAvailable) {
            UIAlertView *cantRecordAlert =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: @"Audio input hardware not available"
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [cantRecordAlert show];
            [cantRecordAlert release];
            return;
        }
        
        // start recording
        [self.recorder recordForDuration:(NSTimeInterval) 120];
        //  [self.recorder record];
        
        seconds = 0;
        totalseconds = 0;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeDisplay:) userInfo:nil repeats:YES];
        
        [self.timer fire];
        
        [self.lbl_timer setHidden:FALSE];
        [self.lbl_des setHidden:FALSE];
        [self.iv_mic setHidden:TRUE];
        
        isRecording = TRUE;
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    isPlaying = FALSE;
    [self.recordPlayer stop];
    [self.btn_play setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
    [self.lbl_des setText:NSLocalizedString(@"Finish recording", nil)];
    [self setTimeLabel:totalseconds];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

-(void)changeTimeDisplay:(NSTimer*)timer
{
    seconds ++;
    [self setTimeLabel:seconds];
    
}

-(void)deleteRecord
{
    if (isPlaying) {
        [self playRecord];  // actually it is stoping the playing
    }
    NSURL* url = [NSURL fileURLWithPath:[NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:@"temprecorder" WithSubFolder:SDK_MOMENT_MEDIA_DIR withExtention:AAC]]];
    
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:nil];
    
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:nil];
    }
    
    hasRecordInfo = FALSE;
    
    [self.btn_record setHidden:FALSE];
    [self.btn_play setHidden:TRUE];
    [self.btn_delete setHidden:TRUE];
    [self.iv_mic setHidden:FALSE];
    [self.lbl_des setHidden:TRUE];
    [self.lbl_timer setHidden:TRUE];
    
    [self refreshIcons];
}

-(void)playRecord
{
    if (isPlaying) {
        
        isPlaying = FALSE;
        [self.recordPlayer stop];
        [self.btn_play setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
        [self.lbl_des setText:NSLocalizedString(@"Finish recording", nil)];
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        // show the total seconds
        [self setTimeLabel:totalseconds];
        
    }
    else{
        isPlaying = TRUE;
        NSURL* url = [NSURL fileURLWithPath:[NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:@"temprecorder" WithSubFolder:SDK_MOMENT_MEDIA_DIR withExtention:AAC]]];
        
        NSError* err;
        self.recordPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err] autorelease];
        
        if (self.recordPlayer == nil) {
            [WTHelper WTLogError:err];
            NSLog(@"%@",err.localizedDescription);
        }
        
        [self.recordPlayer setNumberOfLoops:0];
        self.recordPlayer.delegate = self;
        [self.recordPlayer prepareToPlay];
        [self.recordPlayer play];
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        seconds = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeDisplay:) userInfo:nil repeats:YES];
        [self.timer fire];
        
        [self.btn_play setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
        [self.lbl_des setText:NSLocalizedString(@"Replaying", nil)];
    }
    
}

-(void)toggleLocationInfo
{
    if (locationInfoShown) {
        [self.location_container setHidden:TRUE];
        locationInfoShown = FALSE;
        [self.btn_addLocation setImage:[UIImage imageNamed:@"write_icon_location.png"] forState:UIControlStateNormal];
    }
    else{
        [LocationHelper defaultLocaltionHelper].delegate = self;
        [[LocationHelper defaultLocaltionHelper] startTraceLocation];
        [self.location_container setHidden:TRUE];
        locationInfoShown = TRUE;
        [self.btn_addLocation setImage:[UIImage imageNamed:@"write_icon_location_a.png"] forState:UIControlStateNormal];
    }
}



-(void)becomePhotoMode
{
    if (!isPhotoMode) {
        [self.textView resignFirstResponder];
        [self.uv_photo setHidden:FALSE];
        [self.uv_record setHidden:TRUE];
        isPhotoMode = TRUE;
        isRecordMode = FALSE;
        
    }
    
    if (isKeyboardShown) {
        [self.textView resignFirstResponder];
    }
    
    [self refreshIcons];
}

-(void)becomeVoiceMode
{
    if (!isRecordMode) {
        
        [self.textView resignFirstResponder];
        
        [self.uv_record setHidden:FALSE];
        [self.uv_photo setHidden:TRUE];
        
        isRecordMode = TRUE;
        isPhotoMode = FALSE;
    }
    if (isKeyboardShown) {
        [self.textView resignFirstResponder];
    }
    
    [self refreshIcons];
}


-(void)refreshCountLabel
{
    if ([self.selectedPhotos count] == 0)  {
        [self.lbl_count setHidden:TRUE];
    }
    else
        [self.lbl_count setHidden:FALSE];
    
    [self.lbl_count setText:[NSString stringWithFormat:@"%@(%zi/9)",NSLocalizedString(@"upload photos", nil),[self.selectedPhotos count]]];
    [self refreshIcons];
    
}

-(void)refreshIcons
{
    if ([self.selectedPhotos count] != 0) {
        [self.btn_addPhoto setImage:[UIImage imageNamed:@"write_icon_camera_a.png"] forState:UIControlStateNormal];
    }
    else{
        [self.btn_addPhoto setImage:[UIImage imageNamed:@"write_icon_camera.png"] forState:UIControlStateNormal];
    }
    
    
    if (hasRecordInfo) {
        [self.btn_addVoice setImage:[UIImage imageNamed:@"write_icon_mic_a.png"] forState:UIControlStateNormal];
    }
    else
        [self.btn_addVoice setImage:[UIImage imageNamed:@"write_icon_mic.png"] forState:UIControlStateNormal];
    
    
    
}


-(void)setTimeLabel:(int)passingseconds
{
    int min = passingseconds /60 ;
    int leftseconds = passingseconds %60;
    
    NSString* minstr = nil;
    if (min<10) {
        
        minstr = [NSString stringWithFormat:@"%d%d",0,min];
    }
    else{
        minstr = [NSString stringWithFormat:@"%d",min];
    }
    
    NSString* secstr = nil;
    if (leftseconds<10) {
        secstr = [NSString stringWithFormat:@"%d%d",0,leftseconds];
    }
    else
        secstr = [NSString stringWithFormat:@"%d",leftseconds];
    
    self.lbl_timer.text = [NSString stringWithFormat:@"%@:%@",minstr,secstr];
    
}

#pragma mark  location helper delegate

-(void)getCurrentLocationData:(LocationHelper *)request withResult:(BOOL)success
{
    if (!success) {
        [self.lbl_location setText:NSLocalizedString(@"Current location is not available", nil)];
        latitude = -1;
        longitude = -1;
    }
    else{
        [self.lbl_location setText:request.locationName];
        latitude = request.currentLocation.coordinate.latitude;
        longitude = request.currentLocation.coordinate.longitude;
    }
    
    
    [self.location_container setHidden:FALSE];
}


#pragma - mark keyboard delegate

- (void) keyboardWillShow:(NSNotification *)notification{
    
    isKeyboardShown = TRUE;
    self.uv_photo.hidden = YES;
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat height = keyboardSize.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.uv_additems setFrame:CGRectMake(0, [UISize screenHeightNotIncludingStatusBarAndNavBar] - height - 40, 320, 40)];
    }];
    
    [self.textView setFrame:CGRectMake(10, 10, 300, self.uv_additems.frame.origin.y-40)];
    
//    [self.uv_photo setFrame:CGRectMake(0, self.uv_additems.frame.origin.y+self.uv_additems.frame.size.height, 320, [UISize screenHeight] - (self.uv_additems.frame.origin.y+self.uv_additems.frame.size.height))];
    
//    [self.uv_record setFrame:CGRectMake(0, self.uv_additems.frame.origin.y+self.uv_additems.frame.size.height, 320, [UISize screenHeight] - (self.uv_additems.frame.origin.y+self.  uv_additems.frame.size.height))];
    
    [self.uv_bg_below setFrame:CGRectMake(0, self.uv_additems.frame.origin.y+self.uv_additems.frame.size.height, 320, [UISize screenHeight] - (self.uv_additems.frame.origin.y+self.uv_additems.frame.size.height))];
    
    [self.location_container setFrame:CGRectMake(0, self.uv_additems.frame.origin.y - 30, 320, 30)];
}

-(void) keyboardWillHide:(NSNotification *)notification{
    
    isKeyboardShown = FALSE;
    self.uv_photo.hidden = NO;
    
    
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
//    CGFloat height = keyboardSize.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.uv_additems setFrame:CGRectMake(0, [UISize screenHeightNotIncludingStatusBarAndNavBar] - 254, 320, 40)];
    }];
    
    [self.textView setFrame:CGRectMake(10, 10, 300, self.uv_additems.frame.origin.y-40)];
    [self.uv_bg_below setFrame:CGRectMake(0, self.uv_additems.frame.origin.y + self.uv_additems.frame.size.height, 320, [UISize screenHeight] - (self.uv_additems.frame.origin.y+self.uv_additems.frame.size.height))];
    
    [self.location_container setFrame:CGRectMake(0, self.uv_additems.frame.origin.y - 30, 320, 30)];
    
}


#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if (isTakingPhoto) {
        NSString *mediaType = info[UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
        {
            // Media is an image
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            
            [self.assetLib writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation*)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                [self.assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    
                    [self.selectedPhotos addObject:assetURL];
                    // [self.selectedPhotos addObject:asset];
//                    [self dismissModalViewControllerAnimated:YES];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                } failureBlock:^(NSError *error) {
                    
                    [self dismissViewControllerAnimated:YES completion:NULL];
                }];
            }];
            
        }
        
    }
    else{
        
        NSLog(@"did finish selection");
        if(imagePickerController.allowsMultipleSelection) {
            
            for (ALAsset* asset in info ) {
                NSURL* url = [[asset defaultRepresentation] url];
                BOOL isFound = FALSE;
                for (NSURL* oldurl in self.selectedPhotos) {
                    if ([url isEquivalent:oldurl]) {
                        isFound = TRUE;
                    }
                }
                if (!isFound) {
                  [self.selectedPhotos addObject:url];  
                }
            }
            
            //   self.selectedPhotos = [NSMutableArray arrayWithArray:info];
            //            [self initImageScollView];
            
        }
        //      [self refreshCountLabel];
        [self dismissViewControllerAnimated:YES completion:NULL];
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


@end