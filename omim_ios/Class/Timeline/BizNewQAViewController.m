//
//  BizNewQAViewController.m
//  wowtalkbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "BizNewQAViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"
#import "WarningView.h"
#import "UIPlaceHolderTextView.h"
#import "GalleryViewController.h"
#import "MomentPrivacyViewController.h"
#import "UITextView+Size.h"
#import "AppDelegate.h"

#import "NSDateFormatterGregorianCalendar.h"
@interface BizNewQAViewController ()
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
    
    BOOL isWithDeadline;
    BOOL allowMultiselection;
    
    
    CGFloat latitude;
    CGFloat longitude;
    
    UITapGestureRecognizer* tap;
    UISwipeGestureRecognizer* swiper;
    
    int numberOfOptions;
    
    CGFloat totalHeightForOptionTable;
    
    UIDatePicker* datepicker;
    
    BOOL isChangeDeadline;
    int keyboardHeight;
}
//recorder
@property (nonatomic,retain) AVAudioPlayer* recordPlayer;
@property (nonatomic,retain) AVAudioRecorder *recorder;
@property (nonatomic,retain) NSMutableDictionary *recordSetting;
@property (nonatomic,retain) NSTimer* timer;

@property (nonatomic,retain) NSMutableArray* selectedGroups;
@property (nonatomic,assign) ALAssetsLibrary* assetLib;


@property (nonatomic,retain) NSMutableArray* arr_options;

@property (nonatomic,retain) NSString*datestring;

@property (nonatomic,retain) NSDate*selectedDate;
@property (nonatomic,retain) NSMutableArray* arr_medias;
@property (nonatomic,retain) Moment* new_moment;

@end

#define TAG_TABLE_OPTION        95
#define TAG_TABLE_RESTRICTION   96
#define TAG_TABLE_SELECTION     97

#define TAG_TEXTVIEW            98
#define TAG_PHOTO_SCROLLVIEW    99

#define TAG_RECORD_VIEW         100
#define TAG_RECORD_DESC         101
#define TAG_RECORD_BUTTON       102
#define TAG_RECORD_ICON         103
#define TAG_RECORD_DELETE       104

#define TAG_LOCATION_VIEW       105
#define TAG_LOCATION_DESC       106
#define TAG_LOCATION_BUTTON     107
#define TAG_LOCATION_ICON       108
#define TAG_LOCATION_DELETE     109

#define TAG_SWITCHER            110

#define TAG_ADD_OPTION_BUTTON       111

#define TAG_TABLE_TIME_SELECTION    112
#define TAG_DATEPICKER              113
#define TAG_DATE_LABEL              114

#define TAG_DELETE_RECORD           115
#define TAG_DELETE_LOCATION         116

#define TAG_BLOCK_VIEW              117
#define TAG_SWITCHER_DEADLINE       118
#define MAX_RECORD_DURATION  120.0
@implementation BizNewQAViewController

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
    if (isRecording || isPlaying) {
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
        self.contentSizeGap = 80;

    }
    
    [self.view setBackgroundColor:[Colors wowtalkbiz_background_gray]];
    
    [self configNav];
    
    [self buildData];
    [self buildUIComponents];
    
  //  [self.sv_container setFrame:CGRectMake(0, 0, self.sv_container.frame.size.width, [UISize screenHeight] - 20 - 44)];
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
    
    if (!self.arr_options) {
        self.arr_options = [[NSMutableArray alloc] init];
        numberOfOptions = 2;
        
        Option* op1 = [[Option alloc] init];
        op1.desc = @"";
        op1.option_id = 0;
        
        [self.arr_options addObject:op1];
        [op1 release];
        
        Option* op2 = [[Option alloc] init];
        op2.desc = @"";
        op2.option_id = 1;
        [self.arr_options addObject:op2];
        [op2 release];
    }
}

#pragma mark -- navigation bar
-(void)configNav
{
    NSString* title =  NSLocalizedString(@"Survey", nil);
    
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
    

    UIBarButtonItem *rightBarButton = [PublicFunctions getCustomNavButtonWithText:NSLocalizedString(@"Finish", nil) withTextColor:[UIColor whiteColor]  target:self selection:@selector(generateNewMoment)];
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
    
    int count = 0;
    for (Option* option in self.arr_options) {
        if (![NSString isEmptyString:option.desc]) {
            count ++;
        }
        if (count > 1) {
            break;
        }
    }
    
    if (count <2) {
        UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:Nil message:NSLocalizedString(@"At least two options are required", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertview show];
        [alertview release];
        return;
    }
    
    
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
        
        NSString *deadline = nil;
        if (!isWithDeadline || self.selectedDate == nil) {
            deadline = [[NSNumber numberWithInt:UNLIMIT_DEADLINE_VOTE_VALUE] stringValue];
        }
        else{
            deadline = [NSString stringWithFormat:@"%f", [PublicFunctions timeIntervalTillEndOfDateSince1970:self.selectedDate]+[[WTUserDefaults getTimeOffset] intValue]];
        }
        
        // generate a moment in server.
      //   NSArray* groupd_id_array = [Department departmentidFromDepartmentArray:self.selectedGroups];
        NSString *momentTextContent = [textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      /*  [WowTalkWebServerIF addSurveyMoment:momentTextContent isPublic:TRUE allowReview:TRUE Latitude:hasLocationInfo?[NSString stringWithFormat:@"%f",latitude]:@"0" Longitutde:hasLocationInfo?[NSString stringWithFormat:@"%f",longitude]:@"0" withPlace:hasLocationInfo?locationdesc.text:NULL withDeadline:deadline isMultiSelection:allowMultiselection withOptions:self.arr_options withSharerange:groupd_id_array  withCallback:@selector(didSaveMomentInServer:) withObserver:self];*/
          [WowTalkWebServerIF addSurveyMoment:momentTextContent isPublic:TRUE allowReview:TRUE Latitude:hasLocationInfo?[NSString stringWithFormat:@"%f",latitude]:@"0" Longitutde:hasLocationInfo?[NSString stringWithFormat:@"%f",longitude]:@"0" withPlace:hasLocationInfo?locationdesc.text:NULL withDeadline:deadline isMultiSelection:allowMultiselection withOptions:self.arr_options withSharerange:nil  withCallback:@selector(didSaveMomentInServer:) withObserver:self];
    }
}

-(void)disableOperations{
    UIView* blockview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blockview.tag = TAG_BLOCK_VIEW;
    blockview.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.view addSubview:blockview];
    self.navigationItem.rightBarButtonItem.enabled = false;
    self.navigationItem.leftBarButtonItem.enabled = false;
}

-(void)enableOperations{
    UIView* blockview = [self.view viewWithTag:TAG_BLOCK_VIEW];
    [blockview removeFromSuperview];
    self.navigationItem.rightBarButtonItem.enabled = TRUE;
    self.navigationItem.leftBarButtonItem.enabled = TRUE;
}
#pragma mark -- call back
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
    [self.sv_container setBackgroundColor:[Colors wowtalkbiz_grayColorOne]];
    [self buildInputTextView];
    [self buildOptionArea];
    [self buildAddOptionArea];
    [self buildTimeSelectionArea];
    [self buildSelectionOptionArea];
    [self buildRestrictionArea];
    [self buildPhotoArea];
    [self buildRecordArea];
    [self buildLocaitionArea];
    
    
    UIView* locationview = (UIView*)[self.view viewWithTag:TAG_LOCATION_VIEW];
    [self.sv_container setContentSize:CGSizeMake([UISize screenWidth], locationview.frame.origin.y + locationview.frame.size.height+self.contentSizeGap)];
    [self.sv_container setShowsVerticalScrollIndicator:FALSE];
    [self layout];
}

-(void)buildInputTextView{
    UIPlaceHolderTextView* textview = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
    textview.placeholder = [NSLocalizedString(@"Moment survey hint", nil) stringByAppendingString:NSLocalizedString(@"Moment content text max length 600", nil)];
    textview.backgroundColor = [UIColor whiteColor];
    textview.tag = TAG_TEXTVIEW;
//    textview.delegate = self;
    textview.font = [UIFont systemFontOfSize:17];
//    [textview setReturnKeyType:UIReturnKeyDone];
    [self.sv_container addSubview:textview];
    [textview release];
}


-(void)buildOptionArea{
    
    UITableView* tb_options = [[UITableView alloc] initWithFrame:CGRectMake(10, 125, 300, 88) style:UITableViewStylePlain];
    tb_options.dataSource = self;
    tb_options.delegate = self;
    tb_options.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tb_options.tag = TAG_TABLE_OPTION;
    [tb_options setEditing:TRUE];
    [self.sv_container addSubview:tb_options];
    tb_options.scrollEnabled = FALSE;
    
    [tb_options release];
}


-(void)buildAddOptionArea{
    
    UIButton* btn_add = [[UIButton alloc] initWithFrame:CGRectMake(10, 228, 300, 44)];
    [btn_add setBackgroundColor:[Colors wowtalkbiz_blue]];
    [btn_add addTarget:self action:@selector(addOption) forControlEvents:UIControlEventTouchUpInside];
    [btn_add setTitle:NSLocalizedString(@"Add an option", Nil) forState:UIControlStateNormal];
    btn_add.tag = TAG_ADD_OPTION_BUTTON;
    [self.sv_container addSubview:btn_add];
    [btn_add release];
}

-(void)buildTimeSelectionArea
{
    UITableView* tb_time = [[UITableView alloc] initWithFrame:CGRectMake(10, 287, 300, 44) style:UITableViewStylePlain];
    tb_time.dataSource = self;
    tb_time.delegate = self;
    tb_time.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb_time.tag = TAG_TABLE_TIME_SELECTION;
    [self.sv_container addSubview:tb_time];
    tb_time.scrollEnabled = FALSE;
    [tb_time release];
    
//    NSDateFormatter* format = [[NSDateFormatter alloc] initWithGregorianCalendar];
//    [format setDateFormat:@"yyyy/MM/dd"];
//    NSDate* now = [NSDate date];
//    self.datestring = [format stringFromDate:now];
//    [format release];
    self.datestring=nil;
    
}

-(void)buildSelectionOptionArea
{
    UITableView* tb_selectionOption = [[UITableView alloc] initWithFrame:CGRectMake(10, 346, 300, 44) style:UITableViewStylePlain];
    tb_selectionOption.dataSource = self;
    tb_selectionOption.delegate = self;
    tb_selectionOption.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb_selectionOption.tag = TAG_TABLE_SELECTION;
    [self.sv_container addSubview:tb_selectionOption];
    tb_selectionOption.scrollEnabled = FALSE;
    [tb_selectionOption release];
}

-(void)buildRestrictionArea{
    UITableView* tb_restriction = [[UITableView alloc] initWithFrame:CGRectMake(10, 405, 300, 0) style:UITableViewStylePlain];
    tb_restriction.dataSource = self;
    tb_restriction.delegate = self;
    tb_restriction.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb_restriction.tag = TAG_TABLE_RESTRICTION;
    [self.sv_container addSubview:tb_restriction];
    tb_restriction.scrollEnabled = FALSE;
    [tb_restriction release];
}

-(void)buildPhotoArea{
    
    UIScrollView* sv_photo = (UIScrollView*)[self.view viewWithTag:TAG_PHOTO_SCROLLVIEW];
    if (sv_photo== nil) {
        sv_photo = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 464, 300, 84)];
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
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(momentPhotoClicked:)];
        tapRecognizer.delegate = self;
        tapRecognizer.cancelsTouchesInView =NO;
        imageview.userInteractionEnabled=YES;
        imageview.tag=i;
        [imageview addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
//        [sv_photo addSubview:button];
        
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
        sv_photo.backgroundColor =[UIColor whiteColor];
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
    UIView* recordview = [[UIView alloc] initWithFrame:CGRectMake(10, 563, 300, 36)];
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
    
    UIView* locationview = [[UIView alloc] initWithFrame:CGRectMake(10, 614, 300, 36)];
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
    
    locationview.hidden=TRUE;
    
    [self.sv_container addSubview:locationview];
    [locationview release];
    
    
}


-(void)layout{
    
    UITableView* tb_options = (UITableView*)[self.sv_container viewWithTag:TAG_TABLE_OPTION];
    UIButton* btn_addoption = (UIButton*)[self.sv_container viewWithTag:TAG_ADD_OPTION_BUTTON];
    UITableView* tb_timeselection = (UITableView*)[self.sv_container viewWithTag:TAG_TABLE_TIME_SELECTION];
    UITableView* tb_selectionoption = (UITableView*)[self.sv_container viewWithTag:TAG_TABLE_SELECTION];
    UITableView* tb_restriction = (UITableView*)[self.sv_container viewWithTag:TAG_TABLE_RESTRICTION];
    UIScrollView* sv_photos = (UIScrollView*)[self.sv_container viewWithTag:TAG_PHOTO_SCROLLVIEW];
    UIView* recordview = (UIView*)[self.sv_container viewWithTag:TAG_RECORD_VIEW];
    UIView* locationview = (UIView*)[self.sv_container viewWithTag:TAG_LOCATION_VIEW];
    
    UIButton* btn_delete_record = (UIButton*)[self.sv_container viewWithTag:TAG_DELETE_RECORD];
    UIButton* btn_delete_location = (UIButton*)[self.sv_container viewWithTag:TAG_DELETE_LOCATION];
    
    totalHeightForOptionTable = 0;
    for (Option* option in self.arr_options) {
//        CGFloat height = [UILabel labelHeight:[option desc] FontType:18 withInMaxWidth:260] + 20;
        CGFloat height = [UITextView txtHeight:[option desc] fontSize:18 andWidth:260]+20;
        height = height<44? 44:height;
        totalHeightForOptionTable += height;
    }
    
    [tb_options setFrame:CGRectMake(tb_options.frame.origin.x,tb_options.frame.origin.y, tb_options.frame.size.width, totalHeightForOptionTable)];
    
    [btn_addoption setFrame:CGRectMake(btn_addoption.frame.origin.x, tb_options.frame.size.height+tb_options.frame.origin.y+15, btn_addoption.frame.size.width, btn_addoption.frame.size.height)];
    int heightForDeadline=44;
    if (isWithDeadline) {
        heightForDeadline += 44;
    }
    [tb_timeselection setFrame:CGRectMake(tb_timeselection.frame.origin.x, btn_addoption.frame.size.height+btn_addoption.frame.origin.y+15, tb_timeselection.frame.size.width, heightForDeadline)];
    
    [tb_selectionoption setFrame:CGRectMake(tb_selectionoption.frame.origin.x, tb_timeselection.frame.size.height+tb_timeselection.frame.origin.y+15, tb_selectionoption.frame.size.width, tb_selectionoption.frame.size.height)];
    [tb_restriction setFrame:CGRectMake(tb_restriction.frame.origin.x, tb_selectionoption.frame.size.height+tb_selectionoption.frame.origin.y+15, tb_restriction.frame.size.width, tb_restriction.frame.size.height)];
    [sv_photos setFrame:CGRectMake(sv_photos.frame.origin.x, tb_restriction.frame.size.height+tb_restriction.frame.origin.y+15, sv_photos.frame.size.width, sv_photos.frame.size.height)];
    [recordview setFrame:CGRectMake(recordview.frame.origin.x, sv_photos.frame.size.height+sv_photos.frame.origin.y+15, recordview.frame.size.width, recordview.frame.size.height)];
    [btn_delete_record setFrame:CGRectMake(recordview.frame.origin.x + recordview.frame.size.width + 10, recordview.frame.origin.y, recordview.frame.size.height,recordview.frame.size.height)];
    
    [locationview setFrame:CGRectMake(locationview.frame.origin.x, recordview.frame.size.height+recordview.frame.origin.y+15, locationview.frame.size.width, locationview.frame.size.height)];
    
    [btn_delete_location setFrame:CGRectMake(locationview.frame.origin.x + locationview.frame.size.width + 10, locationview.frame.origin.y, locationview.frame.size.height,locationview.frame.size.height)];
    
    [self.sv_container setContentSize:CGSizeMake([UISize screenWidth], locationview.frame.origin.y+locationview.frame.size.height+self.contentSizeGap)];
}


#pragma mark table of restriction
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    if (tableView.tag == TAG_TABLE_TIME_SELECTION) {
        if (1 == indexPath.row) {
            if (isChangeDeadline) {
                return;
            }
            
            isChangeDeadline = TRUE;
            CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:nil isDatePicker:TRUE delegate:self];
            
            NSString *initDateStr=nil;
            if (nil == self.datestring) {
                NSDateFormatter* format = [[NSDateFormatter alloc] initWithGregorianCalendar];
                [format setDateFormat:@"yyyy/MM/dd"];
                NSDate* now = [NSDate date];
                initDateStr = [format stringFromDate:now];
                [format release];
            } else {
                initDateStr=self.datestring;
            }
            sheet.initialDate = initDateStr;
            [sheet showInView:self.view];
        }
    }
    else if (tableView.tag == TAG_TABLE_RESTRICTION){
    /*
        MomentPrivacyViewController* mpvc = [[MomentPrivacyViewController alloc] init];
        mpvc.selectedDepartments = self.selectedGroups;
        [self.navigationController pushViewController:mpvc animated:TRUE];
        [mpvc release];*///coca
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TAG_TABLE_OPTION) {
//        CGFloat height = [UILabel labelHeight:[[self.arr_options objectAtIndex:indexPath.row] desc] FontType:18 withInMaxWidth:260] + 20;
        CGFloat height = [UITextView txtHeight:[[self.arr_options objectAtIndex:indexPath.row] desc] fontSize:18 andWidth:260]+20;
        return  height<44? 44:height;
    }
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == TAG_TABLE_OPTION) {
        return [self.arr_options count];
    } else if (TAG_TABLE_TIME_SELECTION == tableView.tag) {
        if (isWithDeadline) {
            return 2;
        }
    }
    return 1;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TAG_TABLE_OPTION) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TAG_TABLE_OPTION)  {
        if ([self.arr_options count] == 1) {
            UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:Nil message:NSLocalizedString(@"Option is required", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alertview show];
            [alertview release];
            return;
        }
        else{
            [self.arr_options removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
            [self layout];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == TAG_TABLE_OPTION) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"optioncell"];
        if (cell == Nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optioncell"] autorelease];
            UITextView* tv = [[UITextView alloc] initWithFrame:CGRectMake(5, 7, 260, 30)];
            tv.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:tv];
            tv.scrollEnabled = FALSE;
            tv.delegate = self;
            [tv release];
        }
        
        UITextView* textview;
        for (UIView* tv in [cell.contentView subviews]) {
            if ([tv isKindOfClass:[UITextView class]]) {
                textview = (UITextView*)tv;
                break;
            }
        }
        
        textview.tag = indexPath.row;
        textview.text = [[self.arr_options objectAtIndex:indexPath.row] desc];
        textview.font = [UIFont systemFontOfSize:18];
        
//        CGFloat textheight = [UILabel labelHeight:[[self.arr_options objectAtIndex:indexPath.row] desc] FontType:18 withInMaxWidth:260];
        CGFloat textheight = [UITextView txtHeight:[[self.arr_options objectAtIndex:indexPath.row] desc] fontSize:18 andWidth:260];
        CGFloat height = textheight + 20;
        if(height<44) height = 44;
        
        if (textheight < 30) {
            textheight = 30;
        }
        
        [textview setFrame:CGRectMake(5, (height -textheight)/2, 260, textheight)];
        
        if (IS_IOS7) {
            // due to ios 7 bug, we have to put the delete button in the front.
            for (UIView *subview in cell.subviews) {
                for (UIView *subview2 in subview.subviews) {
                    if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
                        [subview bringSubviewToFront:subview2];
                    }
                }
            }
        }
        
        
        [cell.contentView setFrame:CGRectMake(38, 0, 262, height)];
        
        return cell;
    }
    else if(tableView.tag == TAG_TABLE_RESTRICTION){
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
    else if (tableView.tag == TAG_TABLE_TIME_SELECTION){
        NSString *reuseIdentifier=nil;
        if (0 == indexPath.row) {
            reuseIdentifier=@"timecell_control";
        } else {
            reuseIdentifier=@"timecell";
        }
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == Nil) {
            if (0 == indexPath.row) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.textLabel.text = NSLocalizedString(@"deadline enabled?", nil);
                UISwitch* switcher;
                if (IS_IOS7) {
                    switcher = [[UISwitch alloc] initWithFrame:CGRectMake(230, 6, 60, 34)];
                }
                else
                    switcher = [[UISwitch alloc] initWithFrame:CGRectMake(210, 6, 60, 34)];
                
                switcher.tag = TAG_SWITCHER_DEADLINE;
                [switcher addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview: switcher];
                [switcher release];
            } else {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                cell.textLabel.text = NSLocalizedString(@"Deadline", nil);
                
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 140, 44)];
                label.tag = TAG_DATE_LABEL;
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentRight;
                label.numberOfLines = 1;
                label.minimumScaleFactor = 7;
                label.adjustsFontSizeToFitWidth = TRUE;
                
                [cell.contentView addSubview:label];
                [label release];
            }
            
        }
        
        if (0 == indexPath.row) {
            UISwitch * switcher = (UISwitch*)[[cell contentView] viewWithTag:TAG_SWITCHER_DEADLINE];
            
            if (isWithDeadline) {
                [switcher setOn:TRUE];
            }
            else
                [switcher setOn:FALSE];
        } else {
            UILabel* label = (UILabel*)[cell.contentView viewWithTag:TAG_DATE_LABEL];
            if (nil == self.datestring) {
                label.text = NSLocalizedString(@"survey_deadline_no_limit", nil);
            } else {
                label.text = self.datestring;
            }
        }
        
        
        return cell;
    }
    else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"selectioncell"];
        if (cell == Nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectioncell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = NSLocalizedString(@"Multiselection", nil);
            UISwitch* switcher;
            if (IS_IOS7) {
                switcher = [[UISwitch alloc] initWithFrame:CGRectMake(230, 6, 60, 34)];
            }
            else
                switcher = [[UISwitch alloc] initWithFrame:CGRectMake(210, 6, 60, 34)];
            
            switcher.tag = TAG_SWITCHER;
            [switcher addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview: switcher];
            [switcher release];
        }
        UISwitch * switcher = (UISwitch*)[[cell contentView] viewWithTag:TAG_SWITCHER];
        
        if (allowMultiselection) {
            [switcher setOn:TRUE];
        }
        else
            [switcher setOn:FALSE];
        
        
        return cell;
    }
}


#pragma mark - keyboard
-(void) keyboardWillShow:(NSNotification *)n{
    if (keyboardIsShown == NO){
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        tap.delegate = self;
        [self.sv_container addGestureRecognizer:tap];
        [tap release];
        
        swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        swiper.delegate = self;
        swiper.direction = UISwipeGestureRecognizerDirectionDown;
        
        [self.sv_container addGestureRecognizer:swiper];
        [swiper release];
        
        keyboardIsShown = YES;
        
        CGRect keyboardFrame = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        int kbSizeH = keyboardFrame.size.height;
        [self.sv_container setFrame:CGRectMake(0,0,self.sv_container.frame.size.width,self.sv_container.frame.size.height - kbSizeH)];
        keyboardHeight=kbSizeH;
    }
}

- (void)keyboardWillHide:(NSNotification *)n{
    keyboardIsShown = NO;
    CGRect keyboardFrame = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    int kbSizeH = keyboardFrame.size.height;
    [self.sv_container setFrame:CGRectMake(0, 0, self.sv_container.frame.size.width, self.sv_container.frame.size.height + kbSizeH)];
    
    [self dismissKeyboard];
    keyboardHeight=0;
}

-(void)dismissKeyboard{
    
    [self.view findAndResignFirstResponder];
    if (tap != nil && [self.sv_container.gestureRecognizers containsObject:tap]) {
        [self.sv_container removeGestureRecognizer:tap];
        tap = nil;
    }
    if (swiper != nil && [self.sv_container.gestureRecognizers containsObject:swiper]) {
        [self.sv_container removeGestureRecognizer:swiper];
        swiper =nil;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text hasSuffix:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - button action
-(void)addOption
{
    [self.view findAndResignFirstResponder];
    
    Option* option = [[Option alloc] init];
    option.option_id = [[self.arr_options lastObject] option_id] + 1;
    option.desc = @"";
    
    [self.arr_options addObject:option];
    [option release];
    
    UITableView* table = (UITableView*)[self.view viewWithTag:TAG_TABLE_OPTION];
    [table reloadData];
    [self layout];
}


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
            btn_delete.tag = TAG_DELETE_RECORD;
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
    if (isGettingLocation || hasLocationInfo) {
        return;
    }
    
    [LocationHelper defaultLocaltionHelper].delegate = self;
    [[LocationHelper defaultLocaltionHelper] startTraceLocation];
    isGettingLocation = TRUE;

    
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


-(void)deleteLocation:(id)sender
{
    hasLocationInfo = FALSE;
    isGettingLocation = FALSE;
    
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self makeTextViewVisibleWithKeyboard:textView];
}

-(void)makeTextViewVisibleWithKeyboard:(UITextView *)textView
{
    CGRect convertRect =  [textView convertRect:textView.frame toView:nil];
    //        NSLog(@"convertRect [%f-%f,%f-%f]",convertRect.origin.x,convertRect.origin.y,convertRect.size.width,convertRect.size.height);
    //        NSLog(@"window height=%f,v+k=%f",[UISize screenHeight],convertRect.origin.y+convertRect.size.height+keyboardHeight);
    CGFloat matchHeight=convertRect.origin.y+convertRect.size.height+keyboardHeight;
    if (keyboardIsShown &&  matchHeight > [UISize screenHeight]) {
        NSLog(@"textView may not visible behind keyboard %f-%f",matchHeight,[UISize screenHeight]);
        CGFloat offsetUp=matchHeight-[UISize screenHeight];
        CGPoint originOffset=self.sv_container.contentOffset;
        originOffset.y += offsetUp;
        [self.sv_container setContentOffset:originOffset animated:YES];
    }
}

#pragma mark textfiledview;
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == TAG_TEXTVIEW) {
        
    }
    else{
        Option* option = [self.arr_options objectAtIndex:textView.tag];
        option.desc = textView.text;
        
        UITableView* tb_options = (UITableView*)[self.sv_container viewWithTag:TAG_TABLE_OPTION];
        
        [tb_options beginUpdates];
        
        UITableViewCell* cell = [tb_options cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag inSection:0]];
//        CGFloat textheight = [UILabel labelHeight:[[self.arr_options objectAtIndex:textView.tag] desc] FontType:18 withInMaxWidth:260];
        CGFloat textheight = [UITextView txtHeight:[[self.arr_options objectAtIndex:textView.tag] desc] fontSize:18 andWidth:260];
        CGFloat height = textheight + 20;
        if(height<44) height = 44;
        
        if (textheight < 30) {
            textheight = 30;
        }
        
        [textView setFrame:CGRectMake(5, (height-textheight)/2, 260, textheight)];
        [cell.contentView setFrame:CGRectMake(38, 0, 262, height)];
        
        [tb_options endUpdates];
        
        [self layout];
        
        [self makeTextViewVisibleWithKeyboard:textView];
    }
    
}
#pragma mark - MomentPrivacyViewController delegate

-(void)didSetShareRange:(MomentPrivacyViewController *)requestor
{
    if (requestor.selectedDepartments&& [requestor.selectedDepartments count] >0) {
        self.selectedGroups = requestor.selectedDepartments;
    }
    else{
        self.selectedGroups = nil;
    }
    
}

#pragma mark switch method
-(void)flip:(UISwitch*)switcher
{
    if (TAG_SWITCHER_DEADLINE == switcher.tag) {
        isWithDeadline = !isWithDeadline;
        UITableView* tb_timeselection = (UITableView*)[self.sv_container viewWithTag:TAG_TABLE_TIME_SELECTION];
        [tb_timeselection reloadData];
        [self layout];
    } else if(TAG_SWITCHER == switcher.tag) {
        [self.view findAndResignFirstResponder];
        
        allowMultiselection = !allowMultiselection;
        [switcher setOn:allowMultiselection animated:TRUE];
    }
    
}


#pragma mark  location helper delegate

-(void)getCurrentLocationData:(LocationHelper *)request withResult:(BOOL)success
{
    isGettingLocation = false;
    
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
        [self.sv_container addSubview:btn_delete];
        btn_delete.tag = TAG_DELETE_LOCATION;
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
    if (isChangeDeadline) {
        isChangeDeadline = FALSE;
        if (buttonIndex == [actionSheet cancelButtonIndex]) {
            return;
        }
        CustomActionSheet *sheet = (CustomActionSheet *)actionSheet;
        NSDateFormatter* format = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [format setDateFormat:@"yyyy/MM/dd"];
        
        UITableView* tb_timeselection = (UITableView*)[self.sv_container viewWithTag:TAG_TABLE_TIME_SELECTION];
        switch (buttonIndex) {
            case 4:{
                NSDate *today = [NSDate date];
                NSComparisonResult result;
                //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
                today = [format dateFromString:[format stringFromDate:today]];
                NSDate *selecedDate = [format dateFromString:[format stringFromDate:sheet.datePicker.date]];
                result = [today compare:selecedDate]; // comparing two dates
                
                if(result==NSOrderedAscending){
                    NSLog(@"today is less");
                }else if(result==NSOrderedDescending){
                    // alert
                    NSLog(@"newDate is less");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"deadlineError",nil ) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                    return;
                    
                }else{
                    NSLog(@"Both dates are same");
                }
                
                self.datestring = [format stringFromDate:sheet.datePicker.date];
                self.selectedDate = sheet.datePicker.date;
                [format release];
                [tb_timeselection reloadData];
                
                break;
            }
            default:
                break;
        }
    }
    else{
        if (buttonIndex == 0) {
            [self openAlbum];
        }
        else if (buttonIndex == 1){
            [self openCamera];
        }
        else if (buttonIndex == 4){
            
        }
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
                //  [WTHelper WTLog:@"can't read the asset"];
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
                    [self checkPhotoAssetValid:url];
                }
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
