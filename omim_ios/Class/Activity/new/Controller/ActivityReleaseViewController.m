//
//  ActivityReleaseViewController.m
//  dev01
//
//  Created by 杨彬 on 14-11-19.
//  Copyright (c) 2014年 wowtech. All rights reserved.

#import "ActivityReleaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PublicFunctions.h"
#import "WTHeader.h"
#import "Constants.h"
#import "UIPlaceHolderTextView.h"
#import "NSDate+ClassScheduleDate.h"

#define TAG_PHOTO_SCROLLVIEW  99
#define TAG_BLOCK_VIEW      110

@interface UploadState : NSObject

@property (nonatomic,assign)BOOL thumbnailIsOver;
@property (nonatomic,assign)BOOL originalIsOver;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,retain)WTFile *file;

@end


@implementation UploadState

-(void)dealloc{
    
    [_file release];
    [super dealloc];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _thumbnailIsOver = NO;
        _originalIsOver = NO;
        _file = [[WTFile alloc]init];
    }
    return self;
}
@end

@interface ActivityReleaseViewController ()<UIAlertViewDelegate>
{
    BOOL _startDateIsOpen;
    BOOL _endDateIsOpen;
    UIDatePicker *_startDatepicker;
    UIDatePicker *_endDatepicker;
    BOOL _isFirstResponderAndISTextField;
    CGFloat _inputViewHeight;
    CGFloat _keyboardHeight;
    BOOL isTakingPhoto;
    BOOL dismissFromPicker;
    BOOL hasImageInfo;
    BOOL _isUploading;
    NSMutableArray *_mediaUploadTaskArray;// 有几张图要上传，该数字有几个元素，记录图片上传状态
    NSInteger _event_id;
    NSInteger _numberOfUploadMedia;
    UIAlertView *_alert;
}


@property (nonatomic,retain) ActivityModel* activityModel;

@end

@implementation ActivityReleaseViewController

- (void)dealloc {
    
    [_alert release];
    
    [_mediaUploadTaskArray release];
    [_selectedPhotos release];
    [_startDatepicker release];
    [_endDatepicker release];
    
    [_scrollView_bg release];
    [_view_background release];
    
    [_view_section0 release];
    [_lab_title release];
    [_textView_title release];
    
    
    [_view_section1 release];
    [_view_startDate release];
    [_view_endDate release];
    [_view_area release];
    [_view_maxMember release];
    [_view_coin release];
    [_lab_startDate release];
    [_lab_endDate release];
    [_lab_area release];
    [_lab_maxMember release];
    [_lab_coin release];
    [_lab_StartDateContent release];
    [_lab_endDateContent release];
    [_textField_maxMember release];
    [_textField_coin release];
    [_uiImageView_markStartDate release];
    [_uiImageView_markEndDate release];
    
    [_view_section2 release];
    
    [_view_section3 release];
    [_textView_description release];
    
    [_view_section4 release];
    [_lab_isGetMemberInfo release];
    [_switch_isGetMemberInfo release];
    
    [_view_section5 release];
    [_lab_isOpen release];
    [_switch_isOpen release];
    
    [_textView_area release];
    [super dealloc];
}

- (void)prepareData{
    _startDateIsOpen = NO;
    _endDateIsOpen = NO;
    _isFirstResponderAndISTextField = YES;
    _isUploading = NO;
    _selectedPhotos = [[NSMutableArray alloc]init];
    _assetLib = [PublicFunctions defaultAssetsLibrary];
    _activityModel = [[ActivityModel alloc]init];
    _mediaUploadTaskArray = [[NSMutableArray alloc]init];
    _numberOfUploadMedia = 0;
}

#pragma mark ----- viewHandle
- (void)viewWillAppear:(BOOL)animated
{
    _scrollView_bg.frame = self.view.bounds;
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
        [self loadSction2];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_alert dismissWithClickedButtonIndex:0 animated:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self configNavigationBar];
    
    [self uiConfig];
}

- (void)configNavigationBar
{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, 0, 50, 44);
    [cancelButton setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
    [cancelButton setTintColor:[UIColor whiteColor]];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    [self.navigationItem addLeftBarButtonItem:leftBarButton];
    [leftBarButton release];
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    releaseButton.frame = CGRectMake(-100, 0, 50, 44);
    [releaseButton setTitle:NSLocalizedString(@"发布",nil) forState:UIControlStateNormal];
    [releaseButton setTintColor:[UIColor whiteColor]];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [releaseButton addTarget:self action:@selector(releaseButtonAciton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    [self.navigationItem addRightBarButtonItem:rightBarButton];
    [rightBarButton release];
}


- (void)cancelButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)releaseButtonAciton{
    [self.view endEditing:YES];
    
    if ([_textView_title.text isEqualToString:@""]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"活动标题不能为空",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }else if ([_textView_description.text isEqualToString:@""]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"活动详情不能为空",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }else if([_textView_area.text isEqualToString:@""]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"活动地点不能为空",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }else if ([_textField_maxMember.text isEqualToString:@""]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"活动最大人数不能为空",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }else if ([_textField_coin.text isEqualToString:@""]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"活动费用不能为空",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }else if ([NSDate ZeropointWihtDate:[_startDatepicker date]] < [NSDate ZeropointWihtDate:[NSDate date]] ){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"开始日期不能早于今天",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
        return;
        
    }else if ([[_startDatepicker date] timeIntervalSinceDate:[_endDatepicker date]] >= 0){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"结束日期必须晚于开始日期",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:@"确认发布该活动?" delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确认",nil), nil];
        alertView.tag = 88;
        [alertView show];
    }
    
}

- (void)uiConfig{
    [self loadScrollView];
    
    [self loadSction0];
    
    [self loadSction1];
    
    [self loadSction2];
    
    [self loadSction3];
    
    [self loadSction4];
    
    [self loadSction5];
}

- (void)loadScrollView{
    _scrollView_bg.frame = self.view.bounds;
    _scrollView_bg.backgroundColor = [UIColor colorWithRed:251.0/255 green:250.0/255 blue:251.0/255 alpha:1];
    _scrollView_bg.contentSize = CGSizeMake(_view_background.bounds.size.width, _view_background.bounds.size.height);
    [_scrollView_bg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    _scrollView_bg.delegate = self;
}
- (void)tapAction{
    [self.view endEditing:YES];
}


#pragma mark ----- UI component
- (void)loadSction0{
    _lab_title.text = NSLocalizedString(@"标题",nil);
    _textView_title.tag = 100;
    _textView_title.delegate = self;
}

- (void)loadSction1{
    _lab_startDate.text = NSLocalizedString(@"开始时间",nil);
    _lab_endDate.text = NSLocalizedString(@"结束时间",nil);
    _lab_area.text = NSLocalizedString(@"地点",nil);
    _lab_maxMember.text = NSLocalizedString(@"人数限制",nil);
    _lab_coin.text = NSLocalizedString(@"人均花费",nil);
    _textView_area.tag = 101;
    _textView_area.delegate = self;
    _textField_maxMember.tag = 102;
    _textField_maxMember.delegate = self;
    _textField_coin.tag = 103;
    _textField_coin.delegate = self;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年 MM月dd日 HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    _lab_StartDateContent.text = currentDateStr;
    _lab_endDateContent.text = currentDateStr;
    [dateFormatter release];
    
    _view_startDate.userInteractionEnabled = YES;
    _view_startDate.tag = 200;
    _view_startDate.layer.masksToBounds = YES;
    [self loadStartDatePick];
    [_view_startDate addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateTouchAction:)]];
    
    _view_endDate.userInteractionEnabled = YES;
    _view_endDate.tag = 201;
    _view_endDate.layer.masksToBounds = YES;
    [self loadEndDatePick];
    [_view_endDate addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateTouchAction:)]];
}

- (void)loadStartDatePick{
    _startDatepicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, _view_startDate.frame.size.width, 216)];
    _startDatepicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年 MM月 dd日 HH:mm"];
    [dateFormatter release];
    [_view_startDate addSubview:_startDatepicker];
    
    UIButton *timeDoneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    timeDoneBtn.frame = CGRectMake(0, 260, _view_startDate.bounds.size.width, 40);
    [timeDoneBtn setTitle:NSLocalizedString(@"确认",nil) forState:UIControlStateNormal];
    [timeDoneBtn addTarget:self action:@selector(setStartTime) forControlEvents:UIControlEventTouchUpInside];
    [_view_startDate addSubview:timeDoneBtn];
}

- (void)loadEndDatePick{
    _endDatepicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, _view_endDate.frame.size.width, 216)];
    _endDatepicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年 MM月 dd日 HH:mm"];
    
    [dateFormatter release];
    [_view_endDate addSubview:_endDatepicker];
    
    UIButton *timeDoneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    timeDoneBtn.frame = CGRectMake(0, 260, _view_startDate.bounds.size.width, 40);
    [timeDoneBtn setTitle:NSLocalizedString(@"确认",nil) forState:UIControlStateNormal];
    [timeDoneBtn addTarget:self action:@selector(setEndTime) forControlEvents:UIControlEventTouchUpInside];
    [_view_endDate addSubview:timeDoneBtn];
}

-(void)moveToImage:(UITapGestureRecognizer *)recognizer
{
    [self viewActualPhotoWithTager:recognizer.view.tag];
}

- (void)loadSction2{
    UIScrollView* sv_photo = (UIScrollView*)[self.view viewWithTag:TAG_PHOTO_SCROLLVIEW];
    if (sv_photo== nil) {
        sv_photo = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 3, _view_section2.bounds.size.width - 20, _view_section2.bounds.size.height - 6)];
        sv_photo.tag = TAG_PHOTO_SCROLLVIEW;
        sv_photo.contentSize = CGSizeMake(_view_section2.bounds.size.width - 20, _view_section2.bounds.size.height - 6);
        [_view_section2 addSubview:sv_photo];
        [sv_photo release];
    }

    for (UIView* subview in [sv_photo subviews]) {
        [subview removeFromSuperview];
    }
    for (int i = 0; i < [_selectedPhotos count]; i++) {
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 72*i, 10, 64, 64)];
        [sv_photo addSubview:imageview];
        imageview.tag = i;
        imageview.userInteractionEnabled=YES;
        [imageview addGestureRecognizer:[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveToImage:)] autorelease]];
        [imageview release];
        
        
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

- (void)loadSction3{
    _textView_description = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(16, 5, 288, 90)];
    _textView_description.tag = 104;
    _textView_description.delegate = self;
    [self buildInputTextView];
    
    
}
-(void)buildInputTextView{
    _textView_description.placeholder = NSLocalizedString(@"描述", nil);
    //_textView_description.backgroundColor = [UIColor redColor];
    _textView_description.font = [UIFont systemFontOfSize:17];
    [_view_section3 addSubview:_textView_description];
 
}

- (void)loadSction4{
    _lab_isGetMemberInfo.text = NSLocalizedString(@"是否需要报名者提供信息",nil);
    _switch_isGetMemberInfo.on = YES;
}


- (void)loadSction5{
    _lab_isOpen.text = NSLocalizedString(@"是否公开",nil);
    _switch_isOpen.on = YES;
}





#pragma mark ----- setDate
- (void)setStartTime{
    _uiImageView_markStartDate.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    _view_startDate.frame = CGRectMake(_view_startDate.frame.origin.x, _view_startDate.frame.origin.y, _view_startDate.frame.size.width, 44);
    [self setStartDate];
    [self adjustPositionInSection1];
    _startDateIsOpen = !_startDateIsOpen;
}


- (void)setEndTime{
    _uiImageView_markEndDate.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    _view_endDate.frame = CGRectMake(_view_endDate.frame.origin.x, _view_endDate.frame.origin.y, _view_endDate.frame.size.width, 44);
    [self setEndDate];
    [self adjustPositionInSection1];
    _endDateIsOpen = !_endDateIsOpen;
}

- (void)dateTouchAction:(UITapGestureRecognizer *)tap{
    if (tap.view.tag == 200){
        if (_startDateIsOpen){
            _uiImageView_markStartDate.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            _view_startDate.frame = CGRectMake(_view_startDate.frame.origin.x, _view_startDate.frame.origin.y, _view_startDate.frame.size.width, 44);
            [self setStartDate];
        }else{
            _uiImageView_markStartDate.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);
            _view_startDate.frame = CGRectMake(_view_startDate.frame.origin.x, _view_startDate.frame.origin.y, _view_startDate.frame.size.width, 300);
        }
        [self adjustPositionInSection1];
        _startDateIsOpen = !_startDateIsOpen;
        
    }else if (tap.view.tag == 201){
        if (_endDateIsOpen){
            _uiImageView_markEndDate.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            _view_endDate.frame = CGRectMake(_view_endDate.frame.origin.x, _view_endDate.frame.origin.y, _view_endDate.frame.size.width, 44);
            [self setEndDate];
        }else{
            _uiImageView_markEndDate.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);
            _view_endDate.frame = CGRectMake(_view_endDate.frame.origin.x, _view_endDate.frame.origin.y, _view_endDate.frame.size.width, 300);
        }
        [self adjustPositionInSection1];
        _endDateIsOpen = !_endDateIsOpen;
    }
    [self.view endEditing:YES];
}

- (void)setStartDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年 MM月dd日 HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[_startDatepicker date]];
    _lab_StartDateContent.text = currentDateStr;
    [dateFormatter release];
}

- (void)setEndDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年 MM月dd日 HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[_endDatepicker date]];
    _lab_endDateContent.text = currentDateStr;
    [dateFormatter release];
}


#pragma mark ----- adjustPostion
- (void)adjustPosition{
    _view_section1.frame = CGRectMake(0, _view_section0.frame.origin.y + _view_section0.bounds.size.height + 14, _view_section1.bounds.size.width, _view_section1.bounds.size.height);
    _view_section2.frame = CGRectMake(0, _view_section1.frame.origin.y + _view_section1.bounds.size.height + 14, _view_section2.bounds.size.width, _view_section2.bounds.size.height);
    _view_section3.frame = CGRectMake(0, _view_section2.frame.origin.y + _view_section2.bounds.size.height + 14, _view_section3.bounds.size.width, _view_section3.bounds.size.height);
    
    _view_section4.frame = CGRectMake(0, _view_section3.frame.origin.y + _view_section3.bounds.size.height + 14, _view_section4.bounds.size.width, _view_section4.bounds.size.height);
    _view_section5.frame = CGRectMake(0, _view_section4.frame.origin.y + _view_section4.bounds.size.height + 14, _view_section5.bounds.size.width, _view_section5.bounds.size.height);
    
    _view_background.frame = CGRectMake(_view_background.frame.origin.x, _view_background.frame.origin.y, _view_background.frame.size.width, _view_section5.frame.origin.y + _view_section5.frame.size.height + 20);
    _scrollView_bg.contentSize = CGSizeMake(_view_background.bounds.size.width, _view_background.bounds.size.height);
}

- (void)adjustPositionInSection1{
    _view_endDate.frame = CGRectMake(0, _view_startDate.frame.origin.y + _view_startDate.frame.size.height, _view_endDate.frame.size.width, _view_endDate.frame.size.height);
    _view_area.frame = CGRectMake(0, _view_endDate.frame.origin.y + _view_endDate.frame.size.height, _view_area.frame.size.width, _view_area.frame.size.height);
    _view_maxMember.frame = CGRectMake(0, _view_area.frame.origin.y + _view_area.frame.size.height, _view_maxMember.frame.size.width, _view_maxMember.frame.size.height);
    _view_coin.frame = CGRectMake(0, _view_maxMember.frame.origin.y + _view_maxMember.frame.size.height, _view_coin.frame.size.width, _view_coin.frame.size.height);
    
    _view_section1.frame = CGRectMake(_view_section1.frame.origin.x, _view_section1.frame.origin.y, _view_section1.frame.size.width, _view_coin.frame.origin.y + _view_coin.frame.size.height);
    [self adjustPosition];
}

#pragma mark ----- gallery view controller delegate
-(void)didDeletePhotosInGallery:(NSMutableArray *)arr_deleted
{
    for (NSURL* url in arr_deleted) {
        [self.selectedPhotos removeObject:url];
    }
    [self loadSction2];
}


#pragma mark ----- AddPhoto
-(void)viewActualPhotoWithTager:(NSInteger)tag{
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

#pragma mark ----- photo related
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
            
            [self.assetLib writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation*)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                [self.assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    [self.selectedPhotos addObject:assetURL];
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
                [self.selectedPhotos addObject:url];
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




#pragma mark ----- uploadActivity
- (void)uploadActivity{
    if (self.selectedPhotos!=nil && [self.selectedPhotos count] >0) {
        hasImageInfo = YES;
    }
    else{
        hasImageInfo = NO;
    }
    _alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"活动正在上传中...",nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge|UIActivityIndicatorViewStyleGray];
    activeView.center = CGPointMake(_alert.bounds.size.width/2.0, _alert.bounds.size.height/2.0 - 100);
    [activeView setTintColor:[UIColor blackColor]];
    [activeView startAnimating];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        [_alert setValue:activeView forKey:@"accessoryView"];
    }else{
        [_alert addSubview:activeView];
    }
    [activeView release];
    [_alert show];
    
    [WowTalkWebServerIF  uploadEventWithCallBack:@selector(didAddEvent:)
                                        withType:@""
                                   withTextTitle:_textView_title.text
                                     withTextContent:_textView_description.text
                                     andClassifition:@""
                                        withDateInfo:@""
                                            withArea:_textView_area.text
                                       withMaxMember:_textField_maxMember.text
                                            withCoin:_textField_coin.text
                                 withIsGetMemberInfo:[NSString stringWithFormat:@"%d",_switch_isGetMemberInfo.on]
                                          withIsOpen:[NSString stringWithFormat:@"%d",_switch_isOpen.on]
                                       withStartDate:[NSString stringWithFormat:@"%zi",(NSInteger)[[_startDatepicker date] timeIntervalSince1970]]
                                         withEndDate:[NSString stringWithFormat:@"%zi",(NSInteger)[[_endDatepicker date] timeIntervalSince1970]]
                                        withObserver:self];
}


- (void)didAddEvent:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    _event_id = [[notif userInfo][@"event_id"] integerValue];
    if (error.code == NO_ERROR) {
        if (hasImageInfo) {
            __block NSMutableArray* files = [[NSMutableArray alloc] init];
            __block NSMutableArray* fetchedAssetArray = [[NSMutableArray alloc] init];
            for (NSURL* url in _selectedPhotos) {
                [self.assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
                    [fetchedAssetArray addObject:asset];
                    if (fetchedAssetArray.count == [_selectedPhotos count]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            for (ALAsset *aAsset in fetchedAssetArray) {
                                @autoreleasepool {
                                    NSArray* array = [MediaProcessing savePhotoFromLibraryToLocalEvent:aAsset];
                                    if (array) {
                                        WTFile* file = [[WTFile alloc] init];
                                        file.thumbnailid = [array objectAtIndex:1];
                                        file.fileid = [array objectAtIndex:0];
                                        file.ext = @"jpg";
                                        file.duration = 0;
                                        [files addObject:file];
                                        [file release];
                                    }
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_activityModel.mediaArray addObjectsFromArray:files];
                                [files release];
                                for (int i=0; i<_activityModel.mediaArray.count; i++) {
                                    WTFile *file = (_activityModel.mediaArray)[i];
                                    UploadState *uploadState = [[UploadState alloc]init];
                                    uploadState.index = i;
                                    [_mediaUploadTaskArray addObject:uploadState];
                                    [uploadState release];
                                    [WowTalkWebServerIF uploadEventThumbnail:file withIndex:i withCallback:@selector(diduploadThumbnail:) withObserver:self];
                                    [WowTalkWebServerIF uploadEventMedia:file withIndex:i withCallback:@selector(didUploadMedia:) withObserver:self];
                                }
                            });
                        });
                    }
                } failureBlock:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@ "The image file is broken, please select it again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                        [alert show];
                        [alert release];
                        [self enableOperations];
                        return;
                    });
                }];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if (_alert){
            [_alert dismissWithClickedButtonIndex:0 animated:nil];
        }
        return;
    }
}

- (void)diduploadThumbnail:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSInteger index = [([notif userInfo][@"upload_event_media_thumb"])[@"index"] integerValue];
        for (UploadState *uploadState in _mediaUploadTaskArray){
            if (uploadState.index == index){
                uploadState.thumbnailIsOver = YES;
                uploadState.file.thumbnailid = [notif userInfo][@"fileName"];
                uploadState.file.ext = @"jpg";
                if ([self didUploadAll:uploadState]){
                    [self uploadEventMediaRecord:index];
                }
                return;
            }
        }
    }else{
        if (_alert){
            [_alert dismissWithClickedButtonIndex:0 animated:nil];
        }
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"活动上传成功但图片上传失败",nil) delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }
}

-(void)didUploadMedia:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSInteger index = [([notif userInfo][@"upload_event_media"])[@"index"] integerValue];
        for (UploadState *uploadState in _mediaUploadTaskArray){
            if (uploadState.index == index){
                uploadState.originalIsOver = YES;
                uploadState.file.fileid = [notif userInfo][@"fileName"];
                if ([self didUploadAll:uploadState]){ 
                    [self uploadEventMediaRecord:index];
                }
                return;
            }
        }
    }else{
        if (_alert){
            [_alert dismissWithClickedButtonIndex:0 animated:nil];
        }
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"活动上传成功但图片上传失败",nil) delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }
}


- (BOOL)didUploadAll:(UploadState *)uploadState{
    if (uploadState.thumbnailIsOver && uploadState.originalIsOver){
        return YES;
    }
    return NO;
}

- (void)uploadEventMediaRecord:(NSInteger )index{
    [WowTalkWebServerIF uploadEventFileId:[_mediaUploadTaskArray[index] file] withEventId:[NSString stringWithFormat:@"%zi",_event_id] withCallback:@selector(didUploadEventMediaRecord:) withObserver:self];
}

- (void)didUploadEventMediaRecord:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        _numberOfUploadMedia++;
        if (_numberOfUploadMedia == _activityModel.mediaArray.count){
            if ([_delegate respondsToSelector:@selector(refreshActivityListViewController)]){
                [_delegate refreshActivityListViewController];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if (_alert){
            [_alert dismissWithClickedButtonIndex:0 animated:nil];
        }
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"活动上传成功但图片上传失败",nil) delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }
}
 
/*
-(void)didUploadThumbnailAvatar:(NSNotification *)notification
{
    NSError* error = [[notification userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to upload avatar" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}

-(void)didUploadPhoto:(NSNotification *)notification
{
    
    NSError *err = [[notification userInfo] valueForKey:WT_ERROR];
    
    if (err.code== NO_ERROR) {
        [WowTalkWebServerIF getMyProfileWithCallback:@selector(fReloadTableView) withObserver:self];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to upload avatar", nil)  message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
}
*/

-(void)disableOperations{
    UIView* blockview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blockview.tag = TAG_BLOCK_VIEW;
    blockview.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [_view_section2 addSubview:blockview];
    self.navigationItem.rightBarButtonItem.enabled = false;
    self.navigationItem.leftBarButtonItem.enabled = false;
}

-(void)enableOperations{
    UIView* blockview = [self.view viewWithTag:TAG_BLOCK_VIEW];
    [blockview removeFromSuperview];
    self.navigationItem.rightBarButtonItem.enabled = TRUE;
    self.navigationItem.leftBarButtonItem.enabled = TRUE;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 88 && buttonIndex != 0){
        [self uploadActivity];
    }
}


#pragma mark ----- UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 102){
        _inputViewHeight = _view_section1.frame.origin.y + _view_maxMember.frame.origin.y + _view_maxMember.frame.size.height - _scrollView_bg.contentOffset.y;
    }else if (textField.tag == 103){
        _inputViewHeight = _view_section1.frame.origin.y + _view_coin.frame.origin.y + _view_coin.frame.size.height - _scrollView_bg.contentOffset.y;
    }else{
        return;
    }
    if (!_isFirstResponderAndISTextField){
        CGFloat distance = _inputViewHeight + 20 - _keyboardHeight;
        if (distance > 0){
            [UIView animateWithDuration:0.24 animations:^{
                _view_background.frame = CGRectMake(0, -distance, _view_background.frame.size.width, _view_background.frame.size.height);
            }];
        }
    }
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
#pragma mark ----- UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 100){
        _inputViewHeight = _view_section0.frame.origin.y + _view_section0.frame.size.height  - _scrollView_bg.contentOffset.y;
    }else if (textView.tag == 101){
        _inputViewHeight = _view_section1.frame.origin.y + _view_area.frame.origin.y + _view_area.frame.size.height - _scrollView_bg.contentOffset.y;
    }else if (textView.tag == 104){
        _inputViewHeight = _view_section3.frame.origin.y + _view_section3.frame.size.height - _scrollView_bg.contentOffset.y;
    }else{
        return;
    }
    
    CGFloat distance = _inputViewHeight + 20 - _keyboardHeight;
    if (distance > 0){
        [UIView animateWithDuration:0.24 animations:^{
            _view_background.frame = CGRectMake(0, -distance, _view_background.frame.size.width, _view_background.frame.size.height);
        }];
    }
}

#pragma mark ----- Keyboard Response
- (void) keyboardWillShow:(NSNotification *)note{
    _keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat distance = _inputViewHeight + 20 - _keyboardHeight;
    if (_isFirstResponderAndISTextField){
        if (distance > 0){
            [UIView animateWithDuration:0.24 animations:^{
                _view_background.frame = CGRectMake(0, -distance, _view_background.frame.size.width, _view_background.frame.size.height);
            }];
        }
    }
    _isFirstResponderAndISTextField = NO;
}

-(void) keyboardWillHide:(NSNotification *)note{
    if (_view_background.frame.origin.y != 0){
        [UIView animateWithDuration:0.24 animations:^{
            _view_background.frame = CGRectMake(0, 0, _view_background.frame.size.width, _view_background.frame.size.height);
        }completion:^(BOOL finished) {
            _isFirstResponderAndISTextField = YES;
        }];
    }
}


@end