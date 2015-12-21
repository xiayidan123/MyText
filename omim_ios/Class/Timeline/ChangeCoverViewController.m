//
//  ChangeCoverViewController.m
//  suzhou
//
//  Created by xu xiao feng on 14-4-9.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ChangeCoverViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "UISize.h"
#import "CoverImage.h"
#import "Database.h"
#import "WTUserDefaults.h"
#import "WowTalkWebServerIF.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "WTError.h"
#import "MediaProcessing.h"
#import "SettingCell.h"
//#import "SelectDefaultCoverViewController.h"

//#define TABLE_SECTION_HEADER_HEIGHT 25
#define TABLE_ROW_HEIGHT 44
//#define TABLE_SEPRATOR_HEIGHT 3

#define TABLE_ROW_CELL_TITLE_TAG 1
#define TABLE_ROW_CELL_BG_TAG 2

#define TABLE_ROW_INIT_OFFSET 20

@interface ChangeCoverViewController ()
@property (nonatomic,retain) CoverImage* coverimage;
@property (nonatomic,retain) UIView* handleStatusView;
@end

@implementation ChangeCoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [self.view setAutoresizesSubviews:FALSE];
    [self.view setAutoresizingMask:UIViewAutoresizingNone];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [UISize screenHeight]  - 44 - 20)];
    
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [Colors wowtalkbiz_background_gray];
    
    [self configNav];
    [self getCoverImageInfo];
    
    self.handleStatusView=[self getUploadingView];
}

-(void)getCoverImageInfo
{
    self.coverimage = [Database getCoverImageByUid:[WTUserDefaults getUid]];
    if (self.coverimage == nil) {
        self.coverimage = [[[CoverImage alloc] init] autorelease];
        self.coverimage.coverNotSet=true;
    }
}


- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNav
{
    NSString* title =  NSLocalizedString(@"Change Cover", nil);
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = title;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *backButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:backButton];
    [backButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    if (0 == indexPath.section && 1 == indexPath.row) {
        rowHeight=TABLE_SEPRATOR_HEIGHT;//seprator
    } else {
        rowHeight=TABLE_ROW_HEIGHT;//normal row
    }
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_SECTION_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //empty header view,just occupy space
    UILabel *label=[[[UILabel alloc] init] autorelease];
    label.frame=CGRectMake(0, 0, 320, TABLE_SECTION_HEADER_HEIGHT);
    label.backgroundColor=[UIColor clearColor];
    return label;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdForContent = @"ChangeCoverCell";
    static NSString *CellIdForSep = @"SepCell";
    
    UITableViewCell *cell;
    
    if (0 == indexPath.section && 1 == indexPath.row) {
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdForSep];
    } else {
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdForContent];
    }
    
    if (cell == nil)
    {
        if (0 == indexPath.section && 1 == indexPath.row) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdForSep] autorelease];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            UIButton *btnBkg=[[[UIButton alloc] init] autorelease];
            btnBkg.frame=CGRectMake(0, 0, 320, TABLE_SEPRATOR_HEIGHT);
            btnBkg.backgroundColor=[UIColor whiteColor];
            //        [btnBkg addTarget:self action:@selector(emptyAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnBkg];
            
            UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(TABLE_ROW_INIT_OFFSET, 0, 320-TABLE_ROW_INIT_OFFSET, TABLE_SEPRATOR_HEIGHT)];
            [imgView setImage:[UIImage imageNamed:DIVIDER_IMAGE_320]];
            [cell.contentView addSubview:imgView];
        } else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdForContent] autorelease];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            //white bkg
            UILabel *labelBkg=[[[UILabel alloc] init] autorelease];
            labelBkg.frame=CGRectMake(0, 0, 320, TABLE_ROW_HEIGHT);
            labelBkg.backgroundColor=[UIColor whiteColor];
            labelBkg.tag=TABLE_ROW_CELL_BG_TAG;
            //        [btnBkg addTarget:self action:@selector(emptyAction) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:labelBkg];
            
            UILabel *labelTxt=[[[UILabel alloc] init] autorelease];
            labelTxt.backgroundColor = [UIColor clearColor];
            labelTxt.tag = TABLE_ROW_CELL_TITLE_TAG;
            labelTxt.font = [UIFont systemFontOfSize:16];
            labelTxt.minimumScaleFactor = 7;
            labelTxt.adjustsFontSizeToFitWidth = TRUE;
            if (indexPath.section==2)
            {
                labelTxt.textAlignment=NSTextAlignmentCenter;
            }
            else
            {
                labelTxt.textAlignment = NSTextAlignmentLeft;

            }
            labelTxt.frame=CGRectMake(TABLE_ROW_INIT_OFFSET, 0, 320-TABLE_ROW_INIT_OFFSET, TABLE_ROW_HEIGHT);
            
            [cell.contentView addSubview:labelTxt];
        }
    }
    
    if (0 == indexPath.section && 1 == indexPath.row) {
    } else {
        //set text
        UILabel *label=(UILabel *)[cell.contentView viewWithTag:TABLE_ROW_CELL_TITLE_TAG];
        if (0 == indexPath.section) {
            if (0 == indexPath.row) {
                label.text =NSLocalizedString(@"Select cover from album", nil);
            } else if (2 == indexPath.row) {
                label.text =NSLocalizedString(@"Take a photo for cover",nil);
            }
        } else if (1 == indexPath.section) {
            label.text =NSLocalizedString(@"Selected Photos",nil);
        } else if (2 == indexPath.section) {
            label.text =NSLocalizedString(@"Remove cover",nil);
        }
        
        
        //set status
        UILabel *labelBkg=(UILabel *)[cell.contentView viewWithTag:TABLE_ROW_CELL_BG_TAG];
        if (2 == indexPath.section) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            if (nil == self.coverimage || self.coverimage.coverNotSet) {
                labelBkg.backgroundColor=[UIColor clearColor];
                label.textColor=[UIColor blackColor];
            } else {
                labelBkg.backgroundColor=[UIColor redColor];
                label.textColor=[UIColor whiteColor];
            }
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            labelBkg.backgroundColor=[UIColor whiteColor];
        }
    }
    
    return cell;
}

//-(void)emptyAction
//{
//    return;
//}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            [self openAlbum];
        } else if (2 == indexPath.row) {
            [self openCamera];
        }
    } else if (1 == indexPath.section)
    {
        [self selectDefaultPhoto];
    } else if (2 == indexPath.section)
    {
        [self removeCover];
    }
}


//actions
-(void)selectDefaultPhoto
{
   /* SelectDefaultCoverViewController* imageSelecter = [[[SelectDefaultCoverViewController alloc] init] autorelease];
    imageSelecter.delegate = self;
    
    [self.navigationController pushViewController:imageSelecter animated:YES];*/
}

-(void)didGetCoverFromDefaultAlbum:(NSString *)photoName
{
    //NSLog(@"set photo to %@",photoName);
    [self doUploadCoverToServer:[UIImage imageNamed:photoName]];
}

-(void)openAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        UIImagePickerController* imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        imagePicker.delegate = self;
        imagePicker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *)
                                   kUTTypeImage, nil] autorelease];
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
}

-(void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagepicker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *)
                                   kUTTypeImage, nil] autorelease];
        
        imagepicker.delegate = self;
        
        imagepicker.showsCameraControls = TRUE;
        
        [self presentViewController:imagepicker animated:YES completion:nil];
    }
}

-(void) removeCover{
    if (nil == self.coverimage || self.coverimage.coverNotSet) {
        return;
    }
    self.coverimage.ext = @"png";
    self.coverimage.uid = [WTUserDefaults getUid];
    if (self.coverimage.file_id) {
        self.coverimage.previousfile_id = self.coverimage.file_id;
    }
    
    [WowTalkWebServerIF removeCoverImage:self.coverimage withCallback:@selector(CoverImageStatusChanged) withObserver:self];
}

-(void)CoverImageStatusChanged{
    [self getCoverImageInfo];
    [self.tableView reloadData];
    
    //send notice
//    [[NSNotificationCenter defaultCenter] postNotificationName:TIMELINE_COVER_IMAGE_CHANGED object:self];
    
    [_delegate changeCover];
    
}

- (UIView *) getUploadingView
{
    UIButton *btn=[[[UIButton alloc] init] autorelease];
    btn.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7];
//    labelTxt.font = [UIFont systemFontOfSize:25];
//    labelTxt.minimumFontSize = 7;
//    labelTxt.adjustsFontSizeToFitWidth = TRUE;
//    labelTxt.textAlignment = NSTextAlignmentCenter;
    
    CGRect tScreenBounds = [[UIScreen mainScreen] bounds];
    btn.frame=CGRectMake(0, 0, tScreenBounds.size.width, tScreenBounds.size.height-49);
    
    return btn;
}

-(void)doUploadCoverToServer:(UIImage *)image
{
    self.coverimage.ext = @"png";
    self.coverimage.uid = [WTUserDefaults getUid];
    if (self.coverimage.file_id) {
        self.coverimage.previousfile_id = self.coverimage.file_id;
    }
    
    @autoreleasepool {
        self.coverimage.file_id = [MediaProcessing saveCoverImageToLocal:image];
    }
    
    self.coverimage.timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];  // we set a timestamp here.
    
    [WowTalkWebServerIF uploadCoverToServer:self.coverimage withCallback:@selector(didUploadCover:) withObserver:self];
    
    [self.view addSubview:self.handleStatusView];
    
}
//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo
//{
//    //image为选中图片
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        [self doUploadCoverToServer:image];
//        self.coverimage.ext = @"png";
//        self.coverimage.uid = [WTUserDefaults getUid];
//        if (self.coverimage.file_id) {
//            self.coverimage.previousfile_id = self.coverimage.file_id;
//        }
//        
//        self.coverimage.file_id = [MediaProcessing saveCoverImageToLocal:image];
//        self.coverimage.timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];  // we set a timestamp here.
//        
//        [WowTalkWebServerIF uploadCoverToServer:self.coverimage withCallback:@selector(didUploadCover:) withObserver:self];
//        
//        [self.view addSubview:self.handleStatusView];
    }
    //[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popoverPresentationController];
    //  [picker release];
    
}

-(void)didUploadCover:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [WowTalkWebServerIF uploadCoverImage:self.coverimage withCallback:@selector(didUpdateCoverImageData:) withObserver:self];
    } else {
        [self.handleStatusView removeFromSuperview];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didUpdateCoverImageData:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [Database storeCoverImage:self.coverimage];
        [self CoverImageStatusChanged];
    }
    
    [self.handleStatusView removeFromSuperview];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
