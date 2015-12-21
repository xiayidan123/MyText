//
//  BizNewMomentViewController.m
//  wowtalkbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "BizNewMomentViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"

#import "UIPlaceHolderTextView.h"
#import "GalleryViewController.h"
#import "MomentPrivacyViewController.h"
#import "WarningView.h"
#import "AppDelegate.h"


@interface BizNewMomentViewController ()<UIAlertViewDelegate>
{
    BOOL hasImageInfo;
    BOOL hasRecordInfo;
    BOOL hasLocationInfo;
    BOOL isRecording;
    
    BOOL isGettingLocation;
    
    BOOL keyboardIsShown;
    
    BOOL dismissFromPicker;
    
    BOOL isTakingPhoto;
    
    int seconds;
    int totalseconds;
    BOOL isPlaying;
    
    
    CGFloat latitude;
    CGFloat longitude;
    
    UITapGestureRecognizer* tap;
    UISwipeGestureRecognizer* swiper;
}

@property (nonatomic,retain) Moment* new_moment;

//recorder
@property (nonatomic,retain) AVAudioPlayer* recordPlayer;
@property (nonatomic,retain) AVAudioRecorder *recorder;
@property (nonatomic,retain) NSMutableDictionary *recordSetting;
@property (nonatomic,retain) NSTimer* timer;

@property (nonatomic,retain) NSMutableArray* selectedGroups;
@property (nonatomic,assign) ALAssetsLibrary* assetLib;


//array for storage
@property (nonatomic,retain) NSMutableArray* arr_medias;


@end

#define TAG_TEXTVIEW 98
#define TAG_PHOTO_SCROLLVIEW  99

#define TAG_RECORD_VIEW    100
#define TAG_RECORD_DESC    101
#define TAG_RECORD_BUTTON   102
#define TAG_RECORD_ICON     103
#define TAG_RECORD_DELETE   104

#define TAG_LOCATION_VIEW   105
#define TAG_LOCATION_DESC   106
#define TAG_LOCATION_BUTTON 107
#define TAG_LOCATION_ICON   108
#define TAG_LOCATION_DELETE 109

#define TAG_BLOCK_VIEW      110
#define TAG_TABLE_RESTRICTION 111

#define TAG_DELETE_LOCATION_BTN 112


#define MAX_RECORD_DURATION  120.0




@implementation BizNewMomentViewController

#pragma mark - view lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)updateRightButtonStatus
{
    if (isRecording || isGettingLocation || isPlaying) {
        self.navigationItem.rightBarButtonItem.enabled = false;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = true;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.contentSizeGap = 80;
    }
    else{
        self.contentSizeGap = 20;
        
    }

    
    [self.view setBackgroundColor:[Colors wowtalkbiz_background_gray]];
    
    [self configNav];
    
    [self buildData];
    [self buildUIComponents];
    
    
   // [self.sv_container setFrame:CGRectMake(self.sv_container.frame.origin.x, self.sv_container.frame.origin.y, self.sv_container.frame.size.width, [UISize screenHeight] - 20 - 44)];


}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnterBackgroundHandle)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    if (dismissFromPicker) {
        dismissFromPicker = FALSE;
        [self buildPhotoArea];
    }
    
    UITableView* tb = (UITableView*)[self.view viewWithTag:TAG_TABLE_RESTRICTION];
    [tb reloadData];
}

-(void)appEnterBackgroundHandle
{
    if (isRecording) {
        [self stopRecording];
        [self deleteRecord:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- data handle
-(void)buildData{
    if (self.selectedPhotos == nil) {
        self.selectedPhotos = [[[NSMutableArray alloc] init] autorelease];
    }
    else
        [self.selectedPhotos removeAllObjects];
    
    if (self.selectedGroups == nil) {
        self.selectedGroups = [[[NSMutableArray alloc] init] autorelease];
    }
    else
        [self.selectedGroups removeAllObjects];
    
    
    if (!self.assetLib) {
        self.assetLib = [PublicFunctions defaultAssetsLibrary];
    }
}

#pragma mark -- navigation bar
-(void)configNav
{
    NSString* title = nil;
    if (self.type == 0) {
        title = NSLocalizedString(@"Notice", nil);
    }
    else if (self.type == 1){
        title = NSLocalizedString(@"Q&A", nil);
    }
    else if (self.type == 2){
        title = NSLocalizedString(@"Study", nil);
    }
    else if (self.type == 5){
        title = NSLocalizedString(@"Life", nil);
    }

    else if (self.type == 6){
        title = NSLocalizedString(@"Video", nil);
    }

    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = title;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    

    UIBarButtonItem *rightBarButton = [PublicFunctions getCustomNavButtonWithText:NSLocalizedString(@"完成", nil) withTextColor:[UIColor whiteColor]  target:self selection:@selector(generateNewMoment)];

    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}


-(void)goBack
{
    if (isPlaying) {
        [self stopPlaying]; // stop the record
    }
    if ([self.delegate respondsToSelector:@selector(didAddNewMoment)]){
        [self.delegate didAddNewMoment];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)generateNewMoment{
    
    [self dismissKeyboard];

    
    if (self.selectedPhotos!=Nil && [self.selectedPhotos count] >0) {
        hasImageInfo = TRUE;
        
    }
    else
        hasImageInfo = FALSE;
    
    UIPlaceHolderTextView* textview = (UIPlaceHolderTextView*)[self.view viewWithTag:TAG_TEXTVIEW];
    UILabel* locationdesc = (UILabel*)[self.view viewWithTag:TAG_LOCATION_DESC];
    
    if (textview.text==nil ||  ([NSString isEmptyString: textview.text] && !hasRecordInfo && !hasLocationInfo && !hasImageInfo) ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"The moment is empty, please write something", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    else if ([textview.text length]>600){
        NSLog(@"text size=%zi",[textview.text length]);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"New moment can only contain no more than 600 words.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    else{
        [self disableOperations];
        if (isPlaying) {
            [self stopPlaying]; // stop the record
        }
        // generate a moment in server.
        NSString *momentTextContent = [textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
       /* NSArray* groupd_id_array = [Department departmentidFromDepartmentArray:self.selectedGroups];
        [WowTalkWebServerIF addMoment:momentTextContent isPublic:TRUE allowReview:TRUE Latitude:hasLocationInfo?[NSString stringWithFormat:@"%f",latitude]:@"0" Longitutde:hasLocationInfo?[NSString stringWithFormat:@"%f",longitude]:@"0" withPlace:hasLocationInfo?locationdesc.text:NULL withMomentType:[NSString stringWithFormat:@"%d", self.type] withSharerange:groupd_id_array withCallback:@selector(didSaveMomentInServer:) withObserver:self];*/
        
        
        NSLog(@"%@ %@ ",hasLocationInfo ? @"yes":@"no",locationdesc.text);
        
        [WowTalkWebServerIF addMoment:momentTextContent isPublic:TRUE allowReview:TRUE Latitude:hasLocationInfo?[NSString stringWithFormat:@"%f",latitude]:@"0" Longitutde:hasLocationInfo?[NSString stringWithFormat:@"%f",longitude]:@"0" withPlace:hasLocationInfo?locationdesc.text:NULL withMomentType:[NSString stringWithFormat:@"%zi", self.type] withSharerange:nil withCallback:@selector(didSaveMomentInServer:) withObserver:self];
    }
}

-(void)disableOperations{
    UIView* blockview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blockview.tag = TAG_BLOCK_VIEW;
    blockview.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.sv_container addSubview:blockview];
    self.navigationItem.rightBarButtonItem.enabled = false;
    self.navigationItem.leftBarButtonItem.enabled = false;
}

-(void)enableOperations{
    UIView* blockview = [self.view viewWithTag:TAG_BLOCK_VIEW];
    [blockview removeFromSuperview];
    self.navigationItem.rightBarButtonItem.enabled = TRUE;
    self.navigationItem.leftBarButtonItem.enabled = TRUE;
}

#pragma mark - network callback
-(void)didSaveMomentInServer:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    self.arr_medias = [[[NSMutableArray alloc] init] autorelease];
    
    if (error.code == NO_ERROR) {
        self.new_moment = (Moment*)[[notif userInfo] valueForKey:@"moment"];
        // first take care of recorder
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
        // take care of images
        if (hasImageInfo) {
            __block NSMutableArray* files = [[NSMutableArray alloc] init];
//            __block int i = 0;
            __block NSMutableArray* fetchedAssetArray = [[NSMutableArray alloc] init];
            for (NSURL* url in self.selectedPhotos) {
                [self.assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
                    [fetchedAssetArray addObject:asset];
                    NSLog(@"fetched asset array %zi/%zi",fetchedAssetArray.count,[self.selectedPhotos count]);
                    
                    if (fetchedAssetArray.count == [self.selectedPhotos count]) {
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
                                [self.arr_medias addObjectsFromArray:files];
                                self.new_moment.multimedias = self.arr_medias;
                                [Database storeMoment:self.new_moment];
                                [files release];
                                // save the upload work in background
                                for (WTFile* file in self.arr_medias) {
                                    if ([file.ext isEqualToString:@"aac"]) {
                                        [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.new_moment.moment_id isThumbnail:FALSE];
                                    }
                                    else{
                                        [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.new_moment.moment_id isThumbnail:FALSE];
                                        [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:self.new_moment.moment_id isThumbnail:TRUE];
                                    };
                                }
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_NEW_MOMENT object:self.new_moment.moment_id];
                                [[MediaUploader sharedUploader] upload];
                                
                                [self enableOperations];
                                [self goBack];
                                
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
                        [self enableOperations];
                        return;
                    });
                }];
            }
        }
        else{
            self.new_moment.multimedias = self.arr_medias;
            [Database storeMoment:self.new_moment];
            
            // save the upload work in background
            for (WTFile* file in self.arr_medias) {
                if ([file.ext isEqualToString:@"aac"]) {
                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.new_moment.moment_id isThumbnail:FALSE];
                }
                else{
                    [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.new_moment.moment_id isThumbnail:FALSE];
                    [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:self.new_moment.moment_id isThumbnail:TRUE];
                };
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_NEW_MOMENT object:self.new_moment.moment_id];
            
            [[MediaUploader sharedUploader] upload];
            [self enableOperations];
            [self goBack];
            
            return;
        }
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your network is slow, please try it later", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles: nil];
        [alert show];
        [alert release];
        [self enableOperations];
        return;
    }
    
    
}


#pragma mark- ui component
-(void)buildUIComponents{
    [self.view setBackgroundColor:[Colors wowtalkbiz_grayColorOne]];
    
    [self buildInputTextView];
//    [self buildRestrictionArea];
    [self buildPhotoArea];
    [self buildRecordArea];
    [self buildLocaitionArea];
    
    UIView* locationview = (UIView*)[self.view viewWithTag:TAG_LOCATION_VIEW];
    [self.sv_container setContentSize:CGSizeMake(320, locationview.frame.origin.y + locationview.frame.size.height+ self.contentSizeGap)];
    [self.sv_container setShowsVerticalScrollIndicator:FALSE];
    
}

-(void)buildInputTextView{
    UIPlaceHolderTextView* textview = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 140)];
    textview.placeholder = NSLocalizedString(@"Write something", nil);
    
       
    textview.backgroundColor = [UIColor whiteColor];
    textview.tag = TAG_TEXTVIEW;
//    textview.delegate = self;
    textview.font = [UIFont systemFontOfSize:17];
//    [textview setReturnKeyType:UIReturnKeyDone];
    [self.sv_container addSubview:textview];
    [textview release];
}

-(void)buildRestrictionArea{
    UITableView* tb_restriction = [[UITableView alloc] initWithFrame:CGRectMake(10, 165, 300, 44) style:UITableViewStylePlain];
    tb_restriction.tag = TAG_TABLE_RESTRICTION;
    tb_restriction.dataSource = self;
    tb_restriction.delegate = self;
    tb_restriction.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.sv_container addSubview:tb_restriction];
    tb_restriction.scrollEnabled = FALSE;
    [tb_restriction release];
}

-(void)buildPhotoArea{
    
    UIScrollView* sv_photo = (UIScrollView*)[self.view viewWithTag:TAG_PHOTO_SCROLLVIEW];
    if (sv_photo== nil) {
        sv_photo = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 224 - 44, 300, 84)];
        sv_photo.tag = TAG_PHOTO_SCROLLVIEW;
        sv_photo.contentSize = CGSizeMake(300, 84);
        
        [self.sv_container addSubview:sv_photo];
        [sv_photo release];
    }
    
    for (UIView* subview in [sv_photo subviews]) {
        [subview removeFromSuperview];
    }
    
    for (int i = 0; i < [self.selectedPhotos count]; i++) {
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 72*i, 10, 64, 64)];
        
//        UIButton* button = [[UIButton alloc] initWithFrame:imageview.frame];
//        button.tag = i;
//        [button addTarget:self action:@selector(viewLargePhoto:) forControlEvents:UIControlEventTouchUpInside];
        
        [sv_photo addSubview:imageview];
//        [sv_photo addSubview:button];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(momentPhotoClicked:)];
        tapRecognizer.delegate = self;
        tapRecognizer.cancelsTouchesInView =NO;
        imageview.userInteractionEnabled=YES;
        imageview.tag=i;
        [imageview addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        [imageview release];
//        [button release];
        
        [self.assetLib assetForURL:[self.selectedPhotos objectAtIndex:i] resultBlock:^(ALAsset *asset) {
            UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageview.image = image;
            });
        }failureBlock:^(NSError *error) {
            
        }];
    }
    
    if ([self.selectedPhotos count] == 0) {
        sv_photo.backgroundColor = [UIColor whiteColor];
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
        sv_photo.backgroundColor = [UIColor whiteColor];
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10+72*[self.selectedPhotos count], 10, 64, 64)];
        imageview.image = [UIImage imageNamed:@"timeline_add_photo.png"];
        
        UIButton* button = [[UIButton alloc] initWithFrame:imageview.frame];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        [sv_photo addSubview:imageview];
        [sv_photo addSubview:button];
        
        [imageview release];
        [button release];
    }
    
    [sv_photo setContentSize:CGSizeMake(10+72*([self.selectedPhotos count]+1), 84)];
    sv_photo.showsHorizontalScrollIndicator = TRUE;
    sv_photo.showsVerticalScrollIndicator = FALSE;
}

-(void)momentPhotoClicked:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"photo clicked %zi",recognizer.view.tag);
    [self viewActualPhotoWithTag:recognizer.view.tag];
}

-(void)buildRecordArea{
    UIView* recordview = [[UIView alloc] initWithFrame:CGRectMake(10, 323 - 44, 300, 36)];
    recordview.tag = TAG_RECORD_VIEW;
    recordview.backgroundColor = [UIColor whiteColor];
    
    UIImageView* iv_mic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 16)];
    iv_mic.tag = TAG_RECORD_ICON;
    [iv_mic setImage:[UIImage imageNamed:@"timeline_record.png"]];
    [recordview addSubview:iv_mic];
    [iv_mic release];
    
    NSString* str = NSLocalizedString(@"Press to record", nil);
    CGFloat width = [UILabel labelWidth:str FontType:17 withInMaxWidth:220];
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, width, 36)];
    lbl.tag = TAG_RECORD_DESC;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = str;
    lbl.font = [UIFont systemFontOfSize:15];
    lbl.textColor = [Colors wowtalkbiz_inactive_text_gray];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.minimumScaleFactor = 7;
    lbl.adjustsFontSizeToFitWidth = TRUE;
    [recordview addSubview:lbl];
    [lbl release];
    
    recordview.frame = CGRectMake(recordview.frame.origin.x, recordview.frame.origin.y, 35+width+5, recordview.frame.size.height);
    
    UIButton* btn_press = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, recordview.frame.size.width, recordview.frame.size.height)];
    [btn_press addTarget:self action:@selector(toggleRecordButton) forControlEvents:UIControlEventTouchUpInside];
    [btn_press setBackgroundColor:[UIColor clearColor]];
    btn_press.tag = TAG_RECORD_BUTTON;
    [recordview addSubview:btn_press];
    [btn_press release];
    
    [self.sv_container addSubview:recordview];
    [recordview release];
}

-(void)buildLocaitionArea{

    
    
    UIView* locationview = [[UIView alloc] initWithFrame:CGRectMake(10, 374 - 44, 300, 36)];
    locationview.tag = TAG_LOCATION_VIEW;
    locationview.backgroundColor = [UIColor whiteColor];
    
    UIImageView* iv_location = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 16)];
    iv_location.tag = TAG_LOCATION_ICON;
    [iv_location setImage:[UIImage imageNamed:@"timeline_location.png"]];
    [locationview addSubview:iv_location];
    [iv_location release];
    
    NSString* str = NSLocalizedString(@"Show current location", nil);
    CGFloat width = [UILabel labelWidth:str FontType:17 withInMaxWidth:220];
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, width, 36)];
    lbl.tag = TAG_LOCATION_DESC;
    lbl.text = str;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:15];
    lbl.textColor = [Colors wowtalkbiz_inactive_text_gray];
    lbl.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    lbl.minimumScaleFactor = 7;
    lbl.adjustsFontSizeToFitWidth = TRUE;
    [locationview addSubview:lbl];
    [lbl release];
    
    locationview.frame = CGRectMake(locationview.frame.origin.x, locationview.frame.origin.y, 35+width+5, locationview.frame.size.height);
    
    UIButton* btn_press = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, locationview.frame.size.width, locationview.frame.size.height)];
    btn_press.tag = TAG_LOCATION_BUTTON;
    [btn_press addTarget:self action:@selector(toggleLocation) forControlEvents:UIControlEventTouchUpInside];
    [btn_press setBackgroundColor:[UIColor clearColor]];
    [locationview addSubview:btn_press];
    [btn_press release];
    
    //if(self.type!=0)locationview.hidden=TRUE;

    [self.sv_container addSubview:locationview];
    [locationview release];
}


#pragma mark table of restriction
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;//coca
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    MomentPrivacyViewController* mpvc = [[MomentPrivacyViewController alloc] init];
    mpvc.selectedDepartments = self.selectedGroups;
    [self.navigationController pushViewController:mpvc animated:TRUE];
    [mpvc release];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == Nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = NSLocalizedString(@"Who can see this?", nil);
        
 
    }
    
    if (self.selectedGroups&& [self.selectedGroups count] > 0) {
            cell.detailTextLabel.text = NSLocalizedString(@"Limited", nil);
        }
        else
            cell.detailTextLabel.text = NSLocalizedString(@"Public(Everyone can see)", nil);
    
    
    return cell;
}


#pragma mark - keyboard
-(void) keyboardWillShow:(NSNotification *)n{
    if (keyboardIsShown == NO){
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        tap.delegate = self;
        [self.view addGestureRecognizer:tap];
        [tap release];
        
        swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        swiper.delegate = self;
        swiper.direction = UISwipeGestureRecognizerDirectionDown;
        
        [self.view addGestureRecognizer:swiper];
        [swiper release];
        
        keyboardIsShown = YES;

        CGRect keyboardFrame = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        int kbSizeH = keyboardFrame.size.height;
        [self.sv_container setFrame:CGRectMake(self.sv_container.frame.origin.x,self.sv_container.frame.origin.y,self.sv_container.frame.size.width,self.sv_container.frame.size.height - kbSizeH)];

    }
}

- (void)keyboardWillHide:(NSNotification *)n{
    keyboardIsShown = NO;
    CGRect keyboardFrame = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    int kbSizeH = keyboardFrame.size.height;
    [self.sv_container setFrame:CGRectMake(self.sv_container.frame.origin.x, self.sv_container.frame.origin.y, self.sv_container.frame.size.width, self.sv_container.frame.size.height + kbSizeH)];

}

-(void)dismissKeyboard{
    UIPlaceHolderTextView* textview = (UIPlaceHolderTextView*)[self.view viewWithTag:TAG_TEXTVIEW];
    [textview resignFirstResponder];
    
    if (tap!=nil &&[self.view.gestureRecognizers containsObject:tap]) {
        [self.view removeGestureRecognizer:tap];
        tap = nil;
    }
    
    if (swiper != nil && [self.view.gestureRecognizers containsObject:swiper] ) {
          [self.view removeGestureRecognizer:swiper];
        swiper = nil;
    }
    
  
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text hasSuffix:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - MomentPrivacyViewController delegate
/*
-(void)didSetShareRange:(MomentPrivacyViewController *)requestor
{
    if (requestor.selectedDepartments&& [requestor.selectedDepartments count] >0) {
        self.selectedGroups = requestor.selectedDepartments;
    }
    else{
        self.selectedGroups = nil;
    }
    
}
*/
#pragma mark - button action

-(void)viewLargePhoto:(id)sender
{
    [self viewActualPhotoWithTag:[(UIButton *)sender tag]];
}

-(void)viewActualPhotoWithTag:(NSInteger)tag
{
    GalleryViewController* gcv= [[GalleryViewController alloc] init];
    
    gcv.arr_assets = self.selectedPhotos;
    gcv.isViewAssests = TRUE;
    gcv.isEnableDelete = TRUE;
    gcv.delegate = self;
    gcv.startpos = tag;
    
    [self.navigationController pushViewController:gcv animated:YES];
    [gcv release];
}

-(void)addPhoto
{
    if(self.selectedPhotos!=nil && [self.selectedPhotos count]>=MAX_IMAGE_COUNT_FOR_MOMENT){
        return;
    }
    
    [self.view.window findAndResignFirstResponder];
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:Nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Select from album", nil),NSLocalizedString(@"Take a photo", nil), nil];
    [sheet showInView:self.view];
    [sheet release];
}

-(void)beginRecording{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err)
        return;
    
    [audioSession setActive:YES error:&err];
    
    if(err)
        return;
    
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
    if(audioData){
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    err = nil;
    
    self.recorder = [[[ AVAudioRecorder alloc] initWithURL:url settings:self.recordSetting error:&err] autorelease];
    if(!self.recorder){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Warning",nil)
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:NSLocalizedString(@"OK",nil)
                         otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    //prepare to record
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Warning",nil)
                                   message: NSLocalizedString(@"Audio input hardware not available",nil)
                                  delegate: nil
                         cancelButtonTitle:NSLocalizedString(@"OK",nil)
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release];
        return;
    }
    
    // start recording
    [self.recorder recordForDuration:(NSTimeInterval) MAX_RECORD_DURATION];
    seconds= 0;
    totalseconds= 0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTimeDisplay:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    isRecording = TRUE;
    [self updateRightButtonStatus];
}
-(void)stopRecording
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if(self.recorder.currentTime > 0) {
        totalseconds = self.recorder.currentTime;
    } else {
        totalseconds=seconds;
    }
    NSLog(@"total seconds %d",totalseconds);
    isRecording = FALSE;
    [self updateRightButtonStatus];
    [self.recorder stop];
    
    hasRecordInfo = TRUE;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"av did finish");
    
    /*cocatest:to check the recorded file duration*/
    /*AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:self.recorder.url options:nil];
    CMTime audioDuration = audioAsset.duration;
    double duration = CMTimeGetSeconds(audioDuration);
    */
    
    if (isRecording) {
        [self toggleRecordButton];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"av encode error");
    if (isRecording) {
        [self toggleRecordButton];
    }
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    NSLog(@"av begin interruption");
    if (isRecording) {
        [self toggleRecordButton];
    }
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    NSLog(@"av end interruption with options");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags
{
    NSLog(@"av end interruption with flags");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder
{
    NSLog(@"av end interruption");
}

-(void)changeTimeDisplay:(NSTimer*)timer
{
    /* have to stop the timer here since recordforduration:120 will not stop at the specified time 120, it will work 2-3 more secs to make sure the 120secs of record is verified*/
    if(self.recorder.currentTime > 0) {
        seconds=self.recorder.currentTime;
    }    
    [self setRecordDesc:seconds];
    
    
    if(seconds>=MAX_RECORD_DURATION){
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    
}
-(void)setRecordDesc:(int)secs
{
    int min = secs /60 ;
    int leftseconds = secs %60;
    
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
    
    UILabel* recorddesc = (UILabel*)[self.view viewWithTag:TAG_RECORD_DESC];
    UIView* recordview = (UIView*)[self.view viewWithTag:TAG_RECORD_VIEW];
    UIButton* btn = (UIButton*)[self.view viewWithTag:TAG_RECORD_BUTTON];
    
    recorddesc.text = [NSString stringWithFormat:@"%@:%@ %@",minstr,secstr,NSLocalizedString(@" Tap to finish recording", nil)];
    CGFloat width = [UILabel labelWidth:recorddesc.text FontType:17 withInMaxWidth:220];
    [recorddesc setFrame:CGRectMake(35, 0, width, 35)];
    
    recordview.frame = CGRectMake(recordview.frame.origin.x, recordview.frame.origin.y, 35+width+5, recordview.frame.size.height);
    [btn setFrame:CGRectMake(0, 0, recordview.frame.size.width, recordview.frame.size.height)];
}


-(void)deleteRecord:(id)sender{
    if (isPlaying) {
        [self stopPlaying];  // actually it is stoping the playing
    }
    
    NSURL* url = [NSURL fileURLWithPath:[NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:@"temprecorder" WithSubFolder:SDK_MOMENT_MEDIA_DIR withExtention:AAC]]];
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:nil];
    
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:nil];
    }
    
    UIView* recordview = (UIView*)[self.view viewWithTag:TAG_RECORD_VIEW];
    UILabel* recorddesc = (UILabel*)[self.view viewWithTag:TAG_RECORD_DESC];
    UIButton* btn = (UIButton*)[self.view viewWithTag:TAG_RECORD_BUTTON];
    UIImageView* icon = (UIImageView*)[self.view viewWithTag:TAG_RECORD_ICON];
    
    NSString* str = NSLocalizedString(@"Press to record", nil);
    CGFloat width = [UILabel labelWidth:str FontType:17 withInMaxWidth:220];
    [recorddesc setFrame:CGRectMake(35, 0, width, 36)];
    recorddesc.text = str;
    
    [icon setImage:[UIImage imageNamed:@"timeline_record.png"]];
    
    recordview.frame = CGRectMake(recordview.frame.origin.x, recordview.frame.origin.y, 35+width+5, recordview.frame.size.height);
    [btn setFrame:CGRectMake(0, 0, recordview.frame.size.width, recordview.frame.size.height)];
    
    recordview.backgroundColor = [UIColor whiteColor];
    recorddesc.textColor = [Colors wowtalkbiz_inactive_text_gray];
    
    hasRecordInfo = FALSE;
    
    [sender removeFromSuperview];
    
}

-(void)stopPlaying{
    isPlaying = FALSE;
    [self updateRightButtonStatus];
    [self.recordPlayer stop];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    // show the total seconds
    [self setPlayTime:totalseconds];
}

-(void)startPlaying{
    isPlaying = TRUE;
    [self updateRightButtonStatus];
    NSURL* url = [NSURL fileURLWithPath:[NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:@"temprecorder" WithSubFolder:SDK_MOMENT_MEDIA_DIR withExtention:AAC]]];
    
    NSError* err;
    self.recordPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err] autorelease];
    
    if (self.recordPlayer == nil) {
        [WTHelper WTLogError:err];
   //     NSLog(@"%@",err.localizedDescription);
    }
    
    [self.recordPlayer setNumberOfLoops:0];
    self.recordPlayer.delegate = self;
    [self.recordPlayer prepareToPlay];
    [self.recordPlayer play];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    seconds= 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changePlayTime:) userInfo:nil repeats:YES];
    [self.timer fire];
    
}

-(void)changePlayTime:(NSTimer*)timer
{
    seconds=self.recordPlayer.currentTime;
    if (seconds > totalseconds) {
        seconds=totalseconds;
    }
    [self setPlayTime:seconds];
}

-(void)setPlayTime:(int)secs{
    
    int min = secs /60 ;
    int leftseconds = secs %60;
    
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
    
    UILabel* recorddesc = (UILabel*)[self.view viewWithTag:TAG_RECORD_DESC];
    recorddesc.text = [NSString stringWithFormat:@"%@:%@",minstr,secstr];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    isPlaying = FALSE;
    [self updateRightButtonStatus];
    [self.recordPlayer stop];
    
    [self setPlayTime:totalseconds];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    UIImageView* icon = (UIImageView*)[self.view viewWithTag:TAG_RECORD_ICON];
    [icon setImage:[UIImage imageNamed:@"timeline_play.png"]];
    
}


-(void)toggleRecordButton{
    
    UIView* recordview = (UIView*)[self.view viewWithTag:TAG_RECORD_VIEW];
    UILabel* recorddesc = (UILabel*)[self.view viewWithTag:TAG_RECORD_DESC];
    UIButton* btn = (UIButton*)[self.view viewWithTag:TAG_RECORD_BUTTON];
    UIImageView* icon = (UIImageView*)[self.view viewWithTag:TAG_RECORD_ICON];
    
    if(hasRecordInfo){
        if (isPlaying) {
            [self stopPlaying];
            [icon setImage:[UIImage imageNamed:@"timeline_play.png"]];
        }
        else{
            [self startPlaying];
            [icon setImage:[UIImage imageNamed:@"timeline_stop.png"]];
        }
        
    }
    else{
        if (isRecording) {
            [self stopRecording];
            
            
            int min = totalseconds /60 ;
            int leftseconds = totalseconds %60;
            
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
            
            [icon setImage:[UIImage imageNamed:@"timeline_play.png"]];
            
            recorddesc.text = [NSString stringWithFormat:@"%@:%@",minstr,secstr];
            CGFloat width = [UILabel labelWidth:recorddesc.text FontType:17 withInMaxWidth:220];
            [recorddesc setFrame:CGRectMake(35, 0, width, 35)];
            
            recordview.frame = CGRectMake(recordview.frame.origin.x, recordview.frame.origin.y, 35+width+5, recordview.frame.size.height);
            [btn setFrame:CGRectMake(0, 0, recordview.frame.size.width, recordview.frame.size.height)];
            
            UIButton* btn_delete = [[UIButton alloc] initWithFrame:CGRectMake(recordview.frame.origin.x + recordview.frame.size.width + 10, recordview.frame.origin.y, recordview.frame.size.height,recordview.frame.size.height)];
            btn_delete.backgroundColor = [UIColor whiteColor];
            [btn_delete setImage:[UIImage imageNamed:@"timeline_close.png"] forState:UIControlStateNormal];
            [btn_delete addTarget:self action:@selector(deleteRecord:) forControlEvents:UIControlEventTouchUpInside];
            [self.sv_container addSubview:btn_delete];
            
            if (totalseconds < 2) {
                [self deleteRecord:btn_delete];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Message is too short, please record it again", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                
                [alert show];
                [alert release];
            }
            
            [btn_delete release];
        }
        else{
            recordview.backgroundColor = [UIColor whiteColor];
            recorddesc.textColor = [UIColor blackColor];
            [icon setImage:[UIImage imageNamed:@"timeline_record_a.png"]];
            [self beginRecording];
        }
    }
}


-(void)toggleLocation
{
    if(![CLLocationManager locationServicesEnabled]
        || (!(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)))){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"请允许调用位置信息,方可使用此功能!\n您可以在\"设置->隐私->定位\"中启用",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"设置",nil), nil];
        alertView.tag = 2123;
        [alertView show];
        [alertView release];
        
        return;
    }
    
    if (isGettingLocation || hasLocationInfo) {
        [[LocationHelper defaultLocaltionHelper] stopTraceLocation];
        [self deleteLocation:[self.sv_container viewWithTag:TAG_DELETE_LOCATION_BTN]];
        return;
    }

    
    [LocationHelper defaultLocaltionHelper].delegate = self;
    [[LocationHelper defaultLocaltionHelper] startTraceLocation];
    isGettingLocation = TRUE;
    [self updateRightButtonStatus];
    
    UIView* locationview = (UIView*)[self.view viewWithTag:TAG_LOCATION_VIEW];
    UILabel* locationdesc = (UILabel*)[self.view viewWithTag:TAG_LOCATION_DESC];
    UIButton* btn = (UIButton*)[self.view viewWithTag:TAG_LOCATION_BUTTON];
    
    NSString* str = NSLocalizedString(@"is Getting current location", nil);
    CGFloat width = [UILabel labelWidth:str FontType:17 withInMaxWidth:220];
    [locationdesc setFrame:CGRectMake(35, 0, width, 36)];
    locationdesc.text = str;
    
    locationview.frame = CGRectMake(locationview.frame.origin.x, locationview.frame.origin.y, 35+width+5, locationview.frame.size.height);
    [btn setFrame:CGRectMake(0, 0, locationview.frame.size.width, locationview.frame.size.height)];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 2123) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}


-(void)deleteLocation:(id)sender
{
    hasLocationInfo = FALSE;
    isGettingLocation = FALSE;
    [self updateRightButtonStatus];
    
    UIView* locationview = (UIView*)[self.view viewWithTag:TAG_LOCATION_VIEW];
    UILabel* locationdesc = (UILabel*)[self.view viewWithTag:TAG_LOCATION_DESC];
    UIButton* btn = (UIButton*)[self.view viewWithTag:TAG_LOCATION_BUTTON];
    UIImageView* icon = (UIImageView*)[self.view viewWithTag:TAG_LOCATION_ICON];
    [icon setImage:[UIImage imageNamed:@"timeline_location.png"]];
    
    NSString* str = NSLocalizedString(@"Show current location", nil);
    CGFloat width = [UILabel labelWidth:str FontType:17 withInMaxWidth:220];
    [locationdesc setFrame:CGRectMake(35, 0, width, 36)];
    locationdesc.text = str;
    
    locationview.frame = CGRectMake(locationview.frame.origin.x, locationview.frame.origin.y, 35+width+5, locationview.frame.size.height);
    [btn setFrame:CGRectMake(0, 0, locationview.frame.size.width, locationview.frame.size.height)];
    
    locationview.backgroundColor = [UIColor whiteColor];
    locationdesc.textColor = [Colors wowtalkbiz_inactive_text_gray];
    
    // todo : change icon.
    
    [sender removeFromSuperview];
}


#pragma mark  location helper delegate

-(void)getCurrentLocationData:(LocationHelper *)request withResult:(BOOL)success
{
    if (!isGettingLocation) {
        return;
    }
    isGettingLocation = false;
    [self updateRightButtonStatus];
    if (!success) {
        UIView* locationview = (UIView*)[self.view viewWithTag:TAG_LOCATION_VIEW];
        UILabel* locationdesc = (UILabel*)[self.view viewWithTag:TAG_LOCATION_DESC];
        UIButton* btn = (UIButton*)[self.view viewWithTag:TAG_LOCATION_BUTTON];
        
        NSString* str = NSLocalizedString(@"Current location is not available", nil);
        CGFloat width = [UILabel labelWidth:str FontType:17 withInMaxWidth:220];
        locationdesc.text = str;
        [locationdesc setFrame:CGRectMake(35, 0, width, 36)];
        
        locationview.frame = CGRectMake(locationview.frame.origin.x, locationview.frame.origin.y, 35+width+5, locationview.frame.size.height);
        [btn setFrame:CGRectMake(0, 0, locationview.frame.size.width, locationview.frame.size.height)];
        
        latitude = -1;
        longitude = -1;
    }
    else{
        hasLocationInfo = TRUE;
        
        UIView* locationview = (UIView*)[self.view viewWithTag:TAG_LOCATION_VIEW];
        UILabel* locationdesc = (UILabel*)[self.view viewWithTag:TAG_LOCATION_DESC];
        UIButton* btn = (UIButton*)[self.view viewWithTag:TAG_LOCATION_BUTTON];
        UIImageView* icon = (UIImageView*)[self.view viewWithTag:TAG_LOCATION_ICON];
        
        [icon setImage:[UIImage imageNamed:@"timeline_location_a.png"]];
        
        locationview.backgroundColor = [UIColor whiteColor];
        locationdesc.textColor = [UIColor blackColor];
        
        NSString* str = request.locationName;
        
        CGFloat width = [UILabel labelWidth:str FontType:17 withInMaxWidth:220];
        [locationdesc setFrame:CGRectMake(35, 0, width, 36)];
        locationdesc.text = str;
        
        locationview.frame = CGRectMake(locationview.frame.origin.x, locationview.frame.origin.y, 35+width+5, locationview.frame.size.height);
        [btn setFrame:CGRectMake(0, 0, locationview.frame.size.width, locationview.frame.size.height)];
        
        latitude = request.currentLocation.coordinate.latitude;
        longitude = request.currentLocation.coordinate.longitude;
        
        
        // add the delete button
        UIButton* btn_delete = [[UIButton alloc] initWithFrame:CGRectMake(locationview.frame.origin.x + locationview.frame.size.width + 10, locationview.frame.origin.y, locationview.frame.size.height,locationview.frame.size.height)];
        btn_delete.backgroundColor = [UIColor whiteColor];
        [btn_delete setImage:[UIImage imageNamed:@"timeline_close.png"] forState:UIControlStateNormal];
        [btn_delete addTarget:self action:@selector(deleteLocation:) forControlEvents:UIControlEventTouchUpInside];
        btn_delete.tag=TAG_DELETE_LOCATION_BTN;
        [self.sv_container addSubview:btn_delete];
        [btn_delete release];
        
    }
    
}



#pragma mark -- gallery view controller delegate
-(void)didDeletePhotosInGallery:(NSMutableArray *)arr_deleted
{
    for (NSURL* url in arr_deleted) {
        [self.selectedPhotos removeObject:url];
    }
    [self buildPhotoArea];
}

#pragma mark -- action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openAlbum];
    }
    else if (buttonIndex == 1){
        [self openCamera];
    }
}


#pragma mark -- photo related
-(void)openAlbum{
    isTakingPhoto = FALSE;
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

-(void)checkPhotoAssetValid:(NSURL *)assetURL
{
    [self.assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
        if (nil == image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.selectedPhotos removeObject:assetURL];
                [self buildPhotoArea];
                [[WarningView viewWithString:NSLocalizedString(@"operation_failed", nil)] showAlert:nil];
            });
        }
    }failureBlock:^(NSError *error) {
        
    }];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if (isTakingPhoto) {
        isTakingPhoto = FALSE;
        NSString *mediaType = info[UIImagePickerControllerMediaType];

        if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
        {
            // Media is an image
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            [self.assetLib writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation*)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                [self.assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    [self.selectedPhotos addObject:assetURL];
                    [self checkPhotoAssetValid:assetURL];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                } failureBlock:^(NSError *error) {
                    [self dismissViewControllerAnimated:YES completion:NULL];
                }];
            }];
            
        }
        
    }
    else{
        
        if(imagePickerController.allowsMultipleSelection) {
            [self.selectedPhotos removeAllObjects];
            for (ALAsset* asset in info ) {
                NSURL* url = [[asset defaultRepresentation] url];
//                BOOL isFound = FALSE;
//                for (NSURL* oldurl in self.selectedPhotos) {
//                    if ([url isEquivalent:oldurl]) {
//                        isFound = TRUE;
//                    }
//                }
//                if (!isFound) {
//                    [self.selectedPhotos addObject:url];
//                }
                [self.selectedPhotos addObject:url];
                [self checkPhotoAssetValid:url];
            }
        }
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
