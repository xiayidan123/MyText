//
//  OMNewVideoMomentVC
//  wowtalkbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "OMNewVideoMomentVC.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"

#import "UIPlaceHolderTextView.h"
#import "GalleryViewController.h"
#import "MomentPrivacyViewController.h"

#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Constants.h"
#import <UIKit/UIImagePickerController.h>




static const NSUInteger BufferSize = 1024*1024;

@implementation ALAsset (Export)

- (BOOL) exportDataToURL: (NSURL*) fileURL error: (NSError**) error
{
    [[NSFileManager defaultManager] createFileAtPath:[fileURL path] contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:fileURL error:error];
    if (!handle) {
        return NO;
    }
    
    ALAssetRepresentation *rep = [self defaultRepresentation];
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    
    do {
        @try {
            bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:error];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        } @catch (NSException *exception) {
            free(buffer);
            return NO;
        }
    } while (bytesRead > 0);
    
    free(buffer);
    return YES;
}

@end






@interface OMNewVideoMomentVC ()
{
    BOOL hasVideoInfo;
    BOOL hasLocationInfo;
    
    BOOL isGettingLocation;
    
    BOOL keyboardIsShown;
    
    BOOL dismissFromPicker;
    
    BOOL isTakingVideo;
    
    int seconds;
    int totalseconds;
    BOOL isPlaying;
    
    
    CGFloat latitude;
    CGFloat longitude;
    
    UITapGestureRecognizer* tap;
    UISwipeGestureRecognizer* swiper;
    
    BOOL didUploadOriginlFile;
    BOOL didUploadThumbnail;
}

@property (nonatomic,retain) Moment* new_moment;

@property (nonatomic,retain) WTFile* myFile;


@property (nonatomic,retain) NSMutableArray* selectedGroups;
@property (nonatomic,assign) ALAssetsLibrary* assetLib;


//array for storage
@property (nonatomic,retain) NSMutableArray* arr_medias;


@end

#define TAG_TEXTVIEW 98
#define TAG_PHOTO_SCROLLVIEW  99


#define TAG_LOCATION_VIEW   105
#define TAG_LOCATION_DESC   106
#define TAG_LOCATION_BUTTON 107
#define TAG_LOCATION_ICON   108
#define TAG_LOCATION_DELETE 109

#define TAG_BLOCK_VIEW      110
#define TAG_TABLE_RESTRICTION 111

#define TAG_DELETE_LOCATION_BTN 112






@implementation OMNewVideoMomentVC

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
    if ( isGettingLocation || isPlaying) {
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
    
    if (dismissFromPicker) {
        dismissFromPicker = FALSE;
        [self buildVideoArea];
    }
    
    UITableView* tb = (UITableView*)[self.view viewWithTag:TAG_TABLE_RESTRICTION];
    [tb reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    if (self.selectedVideos == nil) {
        self.selectedVideos = [[[NSMutableArray alloc] init] autorelease];
    }
    else
        [self.selectedVideos removeAllObjects];
    
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
    title = NSLocalizedString(@"Video", nil);
    
    
    
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
    
    
    UIBarButtonItem *rightBarButton = [PublicFunctions getCustomNavButtonWithText:NSLocalizedString(@"Done", nil) withTextColor:[UIColor whiteColor]  target:self selection:@selector(generateNewVideoMoment)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}


-(void)goBack
{
    if ([self.delegate respondsToSelector:@selector(didAddNewMoment)]){
        [self.delegate didAddNewMoment];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)generateNewVideoMoment{
    
    [self dismissKeyboard];
    
    if (self.selectedVideos!=Nil && [self.selectedVideos count] >0) {
        hasVideoInfo = TRUE;
    }
    else
        hasVideoInfo = FALSE;
    
    UIPlaceHolderTextView* textview = (UIPlaceHolderTextView*)[self.view viewWithTag:TAG_TEXTVIEW];
//    UILabel* locationdesc = (UILabel*)[self.view viewWithTag:TAG_LOCATION_DESC];
    
    if (textview.text==nil || [NSString isEmptyString: textview.text] ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"The moment is empty, please write something", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    else if (!hasVideoInfo) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"视频不能为空", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
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
        [self step1];
    }
}

-(void)disableOperations{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    UIView* blockview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blockview.tag = TAG_BLOCK_VIEW;
    blockview.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.sv_container addSubview:blockview];
    self.navigationItem.rightBarButtonItem.enabled = false;
    self.navigationItem.leftBarButtonItem.enabled = false;
}

-(void)enableOperations{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIView* blockview = [self.view viewWithTag:TAG_BLOCK_VIEW];
    [blockview removeFromSuperview];
//    self.navigationItem.rightBarButtonItem.enabled = TRUE;
    self.navigationItem.leftBarButtonItem.enabled = TRUE;
}







#pragma mark - network callback
/*
 -(void)didSaveMomentInServer:(NSNotification*)notif
 {
 [self enableOperations];
 [self goBack];
 
 
 NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
 self.arr_medias = [[[NSMutableArray alloc] init] autorelease];
 
 if (error.code == NO_ERROR) {
 self.new_moment = (Moment*)[[notif userInfo] valueForKey:@"moment"];
 if (hasVideoInfo) {
 __block NSMutableArray* files = [[NSMutableArray alloc] init];
 for (NSURL* url in self.selectedVideos) {
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
 @autoreleasepool {
 NSArray* array = [MediaProcessing saveVideoFromLibraryToLocal:url];
 if (array) {
 WTFile* file = [[WTFile alloc] init];
 file.thumbnailid = [array objectAtIndex:1];
 file.fileid = [array objectAtIndex:0];
 file.ext = @"mp4";
 [files addObject:file];
 [file release];
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
 [Database storeQueuedMediaFile:file.fileid withExt:file.ext forMoment:self.new_moment.moment_id isThumbnail:FALSE];
 [Database storeQueuedMediaFile:file.thumbnailid withExt:file.ext forMoment:self.new_moment.moment_id isThumbnail:TRUE];
 
 }
 
 [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_NEW_MOMENT object:self.new_moment.moment_id];
 [[MediaUploader sharedUploader] upload];
 
 [self enableOperations];
 [self goBack];
 
 return;
 
 });
 });
 }
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
 
 */




//step1: save video file from asset library to local

-(void)step1
{
    
    for (NSURL* videourl in self.selectedVideos) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        
        CFUUIDRef newUniqueId;
        CFStringRef newUniqueIdString;
        NSString* relativefilepath;
        NSString* filepath;
        NSString* relativetthumbpath;
        NSString* thumbnailpath;
        
        int timeStamp = (int)[[NSDate date] timeIntervalSince1970] ;
        
        // original path;
        do {
            newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
            newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
            relativefilepath = [NSString stringWithFormat:@"%@_%d_%@",[WTUserDefaults getUid],timeStamp,(NSString*)newUniqueIdString];
            filepath = [[documentsPath stringByAppendingPathComponent:[SDK_MOMENT_MEDIA_DIR stringByAppendingPathComponent:relativefilepath]] stringByAppendingPathExtension:@"mp4"];
            CFRelease(newUniqueId);
            CFRelease(newUniqueIdString);
        } while ([NSFileManager mediafileExistedAtPath:filepath]);
        
        // thumbnail path;
        do {
            newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
            newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
            relativetthumbpath = [NSString stringWithFormat:@"%@_%d_%@",[WTUserDefaults getUid],timeStamp,(NSString*)newUniqueIdString];
            thumbnailpath = [[documentsPath stringByAppendingPathComponent:[SDK_MOMENT_MEDIA_DIR stringByAppendingPathComponent:relativetthumbpath]] stringByAppendingPathExtension:@"jpg"];
            CFRelease(newUniqueId);
            CFRelease(newUniqueIdString);
            
        } while ([NSFileManager mediafileExistedAtPath:thumbnailpath]);
        
        
        MPMoviePlayerController *mpplayer = [[[MPMoviePlayerController alloc] initWithContentURL:videourl] autorelease];
        
        mpplayer.shouldAutoplay = NO;
        
        UIImage *firstframe = [mpplayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame] ;
        
        CGSize targetSizeThumbnail = [firstframe calculateTheScaledSize:CGSizeMake(firstframe.size.width, firstframe.size.height) withMaxSize:CGSizeMake(200, 200)];
        
        UIImage* thumbnailImage = [firstframe resizeToSize:targetSizeThumbnail];
        
        
        NSData * data2 = [NSData dataWithData:UIImageJPEGRepresentation(thumbnailImage, 1.0f)];  //1.0f = 100% quality
        
        [data2 writeToFile:[NSFileManager absolutePathForFileInDocumentFolder:thumbnailpath] atomically:YES];
        
        
        //        if ([NSFileManager mediafileExistedAtPath:[NSFileManager absolutePathForFileInDocumentFolder:thumbnailpath]]){
        //            if(PRINT_LOG)NSLog(@"thumnail writed to local");
        //
        //        }
        //
        //        if ([NSFileManager hasFileAtPath:[NSFileManager absolutePathForFileInDocumentFolder:thumbnailpath]]){
        //            if(PRINT_LOG)NSLog(@"thumnail writed to local");
        //
        //        }
        
        
        NSURL* fileurl = [NSURL fileURLWithPath:filepath];
        [self.assetLib assetForURL:videourl resultBlock:^(ALAsset *asset) {
            NSError* err = [[NSError alloc] init];
            
            [asset exportDataToURL:fileurl error:&err];
            
            if ([NSFileManager mediafileExistedAtPath:[NSFileManager absolutePathForFileInDocumentFolder:filepath]]){
                if(PRINT_LOG)NSLog(@"file writed to local");
                
                self.myFile= [[[WTFile alloc] init] autorelease];
                self.myFile.thumbnailid = relativetthumbpath;
                self.myFile.fileid =[NSString stringWithFormat:@"%@",relativefilepath] ;
                self.myFile.ext = @"mp4";
                
                [self step2];
            }
            
        }failureBlock:^(NSError *error) {
            NSLog(@"Error: %@",[error localizedDescription]);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"文件保存出错，请稍候重试", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles: nil];
            [alert show];
            [alert release];
            [self enableOperations];
            
        }];
        
        
        
    }
    
}
//step2: upload video file and thumbnail to server
-(void)step2
{
    if(self.myFile){
        [WowTalkWebServerIF uploadMomentMedia:self.myFile withCallback:@selector(didUploadMomentVideo:) withObserver:self withExt:YES];
        
        [WowTalkWebServerIF uploadMomentMediaThumbnail:self.myFile withCallback:@selector(didUploadMomentVideo:) withObserver:self];
        
    }
    
}






-(void)didUploadMomentVideo:(NSNotification*)notif
{
    if(notif==nil) return;
    
    if([notif.name isEqualToString:WT_UPLOAD_MOMENT_MEDIA_ORIGINAL]){
        didUploadOriginlFile = YES;
    }
    if([notif.name isEqualToString:WT_UPLOAD_MOMENT_MEDIA_THUMBNAIL]){
        didUploadThumbnail = YES;
    }
    
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR ) {
        
        if(didUploadThumbnail && didUploadOriginlFile){
            // generate a moment in server.
            UIPlaceHolderTextView* textview = (UIPlaceHolderTextView*)[self.view viewWithTag:TAG_TEXTVIEW];
            UILabel* locationdesc = (UILabel*)[self.view viewWithTag:TAG_LOCATION_DESC];
            
            NSString *momentTextContent = [textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            [WowTalkWebServerIF addMoment:momentTextContent isPublic:TRUE allowReview:TRUE Latitude:hasLocationInfo?[NSString stringWithFormat:@"%f",latitude]:@"0" Longitutde:hasLocationInfo?[NSString stringWithFormat:@"%f",longitude]:@"0" withPlace:hasLocationInfo?locationdesc.text:NULL withMomentType:[NSString stringWithFormat:@"%zi", self.type] withSharerange:nil withCallback:@selector(didSaveMomentInServer:) withObserver:self];
        }
        
        
        
    }
    else{
//        [self didFailedInSaveMoment];
    }
    
}





-(void)didSaveMomentInServer:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    
    if (error.code == NO_ERROR) {
        self.new_moment = (Moment*)[[notif userInfo] valueForKey:@"moment"];
        self.myFile.fileid = [NSString stringWithFormat:@"%@.mp4",self.myFile.fileid];
        [WowTalkWebServerIF uploadMomentMultimedia:self.myFile ForMoment:self.new_moment.moment_id withCallback:@selector(didUpdateMomentThumbInfoInServer:) withObserver:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_NEW_MOMENT object:self.new_moment.moment_id];
        
    }
    else{
//        [self didFailedInSaveMoment];
    }
    
    
}


-(void)didUpdateMomentThumbInfoInServer:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    
    if (error.code == NO_ERROR) {
        [self enableOperations];
        [self goBack];
        
        
    }
    else{
//        [self didFailedInSaveMoment];
    }
    
    
}


//-(void)didFailedInSaveMoment{
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your network is slow, please try it later", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles: nil];
//    [alert show];
//    [alert release];
//    [self enableOperations];
//    
//}











#pragma mark- ui component
-(void)buildUIComponents{
    [self.view setBackgroundColor:[Colors wowtalkbiz_grayColorOne]];
    
    [self buildInputTextView];
    //    [self buildRestrictionArea];
    [self buildVideoArea];
    [self buildLocationArea];
    
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

-(void)buildVideoArea{
    
    UIScrollView* sv_photo = (UIScrollView*)[self.view viewWithTag:TAG_PHOTO_SCROLLVIEW];
    if (sv_photo== nil) {
        //        sv_photo = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 224, 300, 84)];
        sv_photo = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 165, 300, 84)];
        sv_photo.tag = TAG_PHOTO_SCROLLVIEW;
        sv_photo.contentSize = CGSizeMake(300, 84);
        [self.sv_container addSubview:sv_photo];
        [sv_photo release];
    }
    
    for (UIView* subview in [sv_photo subviews]) {
        [subview removeFromSuperview];
    }
    
    for (int i = 0; i < [self.selectedVideos count]; i++) {
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 72*i, 10, 64, 64)];
        
        
        [sv_photo addSubview:imageview];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(momentVideoClicked:)];
        tapRecognizer.delegate = self;
        tapRecognizer.cancelsTouchesInView =NO;
        imageview.userInteractionEnabled=YES;
        imageview.tag=i;
        [imageview addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        [imageview release];
        
        [self.assetLib assetForURL:[self.selectedVideos objectAtIndex:i] resultBlock:^(ALAsset *asset) {
            UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageview.image = image;
            });
        }failureBlock:^(NSError *error) {
            
        }];
    }
    
    if ([self.selectedVideos count] == 0) {
        sv_photo.backgroundColor = [UIColor whiteColor];
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 64, 64)];
        imageview.image = [UIImage imageNamed:@"timeline_add_photo.png"];
        
        UIButton* button = [[UIButton alloc] initWithFrame:imageview.frame];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(addVideo) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel* lbl_desc = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 210, 84)];
        lbl_desc.backgroundColor = [UIColor clearColor];
        lbl_desc.font = [UIFont systemFontOfSize:17];
        lbl_desc.textColor = [Colors wowtalkbiz_Text_grayColorTwo];
        lbl_desc.text = NSLocalizedString(@"Add video", nil);
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
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10+72*[self.selectedVideos count], 10, 64, 64)];
        imageview.image = [UIImage imageNamed:@"timeline_add_photo.png"];
        
        UIButton* button = [[UIButton alloc] initWithFrame:imageview.frame];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(addVideo) forControlEvents:UIControlEventTouchUpInside];
        
        [sv_photo addSubview:imageview];
        [sv_photo addSubview:button];
        
        [imageview release];
        [button release];
    }
    
    [sv_photo setContentSize:CGSizeMake(10+72*([self.selectedVideos count]+1), 84)];
    sv_photo.showsHorizontalScrollIndicator = TRUE;
    sv_photo.showsVerticalScrollIndicator = FALSE;
}

-(void)momentVideoClicked:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"photo clicked %zi",recognizer.view.tag);
    [self viewActualVideoWithTag:recognizer.view.tag];
}


-(void)buildLocationArea{
    
    
    
    //    UIView* locationview = [[UIView alloc] initWithFrame:CGRectMake(10, 318, 300, 36)];
    UIView* locationview = [[UIView alloc] initWithFrame:CGRectMake(10, 259, 300, 36)];
    
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
    return 0;
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

-(void)viewActualVideoWithTag:(NSInteger)tag
{
    if([self.selectedVideos count]<1){
        return;
    }
    
    [self watchTheMovie];
}


-(void)watchTheMovie
{
    
    
    @try
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        NSString* urlAddress = [self.selectedVideos objectAtIndex:0];
        NSString *newUrl = [[NSString alloc] initWithFormat:@"%@",urlAddress];
        NSURL* theURL = [NSURL URLWithString:newUrl];
        
        if(!theURL)return;
        MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:theURL];
        [moviePlayerViewController.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        [moviePlayerViewController.moviePlayer setShouldAutoplay:YES];
        [moviePlayerViewController.moviePlayer setFullscreen:NO animated:YES];
        [moviePlayerViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [moviePlayerViewController.moviePlayer setScalingMode:MPMovieScalingModeNone];
        //[moviePlayerViewController.moviePlayer setUseApplicationAudioSession:NO];
        // Register to receive a notification when the movie has finished playing.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinished:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:moviePlayerViewController];
        
        // Register to receive a notification when the movie has finished playing.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinished:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayerViewController];
        
        [self.navigationController presentViewController:moviePlayerViewController animated:YES completion:nil];
        moviePlayerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [moviePlayerViewController release];
        [pool release];
    }
    @catch (NSException *exception) {
        NSLog(@"watchTheMovie failed:%@",exception.description);
    }
    
    
    
}







-(void)addVideo
{
    if(self.selectedVideos!=nil && [self.selectedVideos count]>=1){
        return;
    }
    
    
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:Nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Select from album", nil),NSLocalizedString(@"Take a video", nil), nil];
    
    [sheet showInView:self.view];
    [sheet release];
}





-(void)toggleLocation
{
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
        [self.selectedVideos removeObject:url];
    }
    [self buildVideoArea];
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
    isTakingVideo = FALSE;
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = NO;
    imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = 1 ;
    imagePickerController.filterType = QBImagePickerFilterTypeAllVideos;
    
    if ([self.selectedVideos count] > 0) {
        __block NSMutableArray* assets = [[NSMutableArray alloc] init];
        
        __block int i = 0;
        
        for (NSURL* url in self.selectedVideos) {
            [self.assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
                i++ ;
                [assets addObject:asset];
                if (i == [self.selectedVideos count]) {
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
        [picker setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeMovie]];
        [picker setDelegate:self];
        
        dismissFromPicker = TRUE;
        isTakingVideo = TRUE;
        
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }
    else
        return;
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if (isTakingVideo) {
        isTakingVideo = FALSE;
        NSString *mediaType = info[UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
        {
            // Media is an image
            NSURL *videoPathURL = info[UIImagePickerControllerMediaURL];
            NSLog(@"videoPathURL=%@",videoPathURL);
            
            [self.assetLib writeVideoAtPathToSavedPhotosAlbum:(NSURL *)videoPathURL
                                              completionBlock:^(NSURL *assetURL, NSError *error) {
                                                  [self.assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                                      NSLog(@"assetURL=%@",assetURL);
                                                      
                                                      [self.selectedVideos addObject:assetURL];
                                                      [self dismissViewControllerAnimated:YES completion:NULL];
                                                      
                                                  } failureBlock:^(NSError *error) {
                                                      [self dismissViewControllerAnimated:YES completion:NULL];
                                                  }];
                                                  
                                              }];
        }
        
    }
    else{
        [self.selectedVideos removeAllObjects];
        [self.selectedVideos addObject:[info objectForKey:UIImagePickerControllerReferenceURL]];
        NSLog(@"url=%@",[info objectForKey:UIImagePickerControllerReferenceURL]);
        
        
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