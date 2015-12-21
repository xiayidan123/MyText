//
//  OMBuddySpaceViewController.m
//  wowtalkbiz
//
//  Created by elvis on 2013/10/09.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "OMBuddySpaceViewController.h"

#import "PublicFunctions.h"
#import "Constants.h"

#import "WTHeader.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "AppDelegate.h"
#import "VoiceMessagePlayer.h"

#import "CoverView.h"
#import "RotateIcon.h"

#import "NormalMomentCell.h"
#import "VideoMomentCell.h"
#import "BizMomentDetailViewController.h"
#import "OMTimelineViewController.h"
#import "BizNewMomentViewController.h"
#import "BizNewQAViewController.h"

#import "ReviewListViewController.h"
#import "SurveyMomentCell.h"
#import "TimelineEmptyContentIndForSingle.h"
#import "TimelineNewReviewCell.h"
#import "ChangeCoverViewController.h"
#import "TimelineContainerVC.h"
#import "OMHeadImgeView.h"

#import "MomentBaseCell.h"
#import "MomentNotificationCell.h"

#import "MomentCellModel.h"

#import "UIView+MJExtension.h"
#import "MJRefresh.h"

#import "menuView.h"
#import "OMNewVideoMomentVC.h"


@interface OMBuddySpaceViewController ()<ChangeCoverViewControllerDelegate,MomentBaseCellDelegate,NewMomentProtocolDelegate,CoverViewDelegate>
{
    int offset;
    int limits;
    UIView* commentBox;
    UIImageView* iv_commetbox_bg;
    UIImageView* iv_inputbox_bg;
    UIButton* btn_send;
    
    BOOL isCommentReview;
    BOOL _reloadingMoments;
    
    BOOL isLoadingMoreMoments;
    
    UIScrollView* headerScrollview;
    
    CGFloat sectionHeaderScrollViewOffsetX;
    
    NSInteger newReviewsCount;
}


@property NSInteger currentCategory;

@property (nonatomic,retain) UITapGestureRecognizer* gestureRecognizer;
@property BOOL isMe;
@property (nonatomic,retain) Buddy* buddy;

@property (nonatomic,retain) CoverView* cover;

@property (nonatomic,retain) UIImageView* iv_cover;
@property (nonatomic,retain) OMHeadImgeView* iv_avatar;

@property (nonatomic,retain) NSMutableArray* arr_moments;
@property (nonatomic,retain) NSMutableArray* arr_dates;

@property (nonatomic,copy) NSString* currentMomentID;
@property (nonatomic,retain) Review* currentReview;

@property (nonatomic,retain) NSIndexPath* currentMomentIndexPath;
@property CGRect currentCellRectInTable;
@property CGRect currentCellRectInView;

@property (nonatomic,retain) NSMutableArray* arr_heights;

@property (nonatomic,retain) CoverImage* coverimage;
@property (retain, nonatomic) NSMutableArray * cellModel_array;;

@property (retain, nonatomic) NSArray * review_aray;


@property (retain, nonatomic) menuView *menuView;



@end

@implementation OMBuddySpaceViewController


@synthesize parent;


- (void)dealloc
{
    self.gestureRecognizer = nil;
    self.cover = nil;
    self.iv_cover = nil;
    self.arr_moments = nil;
    self.arr_dates = nil;
    self.currentMomentID = nil;
    self.currentReview = nil;
    self.currentMomentIndexPath = nil;
    self.arr_heights = nil;
    self.coverimage = nil;
    
    self.tb_moments = nil;
    self.bg_header = nil;
    self.buddyid = nil;
    
    self.cellModel_array = nil;
    self.review_aray = nil;
    
    [super dealloc];
}




#pragma mark - view lifecycle


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.parent){
        [self.parent.navigationController pushViewController:viewController animated:animated];
    }else{
        [self.navigationController pushViewController:viewController animated:animated];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bg_header.backgroundColor = [Colors blackColorUnderMomentTable];
    [self.view setBackgroundColor:[Colors wowtalkbiz_background_gray]];
    
    if ([self.buddyid isEqualToString:[WTUserDefaults getUid]]) {
        self.isMe = TRUE;
    }
    else{
        self.isMe = FALSE;
        self.buddy = [Database buddyWithUserID:self.buddyid];
    }
    
    [self configNav];
    
    offset = 0;
    limits = 20;
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tb_moments setFrame:CGRectMake(0, 0, self.tb_moments.frame.size.width, [UISize screenHeight] - 20 - 44)];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    }
    
    [self initMomentTable];
    
    [self getNewMomentsFromServer];
    
    if (self.arr_moments == nil) {
        self.arr_moments = [[[NSMutableArray alloc] init] autorelease];
    }
    
    
    self.tb_moments.scrollsToTop = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCoverImage) name:TIMELINE_COVER_IMAGE_CHANGED object:nil];
}



-(void)didGetLatestReplyForMe:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR)
        [self checkoutNotification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.arr_moments == nil) {
        self.arr_moments = [[[NSMutableArray alloc] init] autorelease];
    }
    if ([AppDelegate sharedAppDelegate].comeFromViewLargePhoto) {
        [AppDelegate sharedAppDelegate].comeFromViewLargePhoto = FALSE;
    }
    else{
        self.arr_moments = [Database fetchMomentsForBuddy:self.buddyid withLimit:limits andOffset:offset  withtags:nil withOwnerType:99];
    }
    
    [self reloadCoverImage];
    
    [self checkoutNotification];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didVotedTheMoment:) name:WT_VOTE_MOMENT_SURVEY object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetLatestReplyForMe:) name:WT_GET_LATEST_REVIEWS_FOR_ME object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([[RotateIcon sharedRotateIcon].parent isEqual:self]) {
        [[RotateIcon sharedRotateIcon] hide];
    }
    
    if ([VoiceMessagePlayer sharedInstance].isPlaying) {
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    _menuView.maskView.frame = CGRectMake(0, 0, 320,0);
    [UIView animateWithDuration:0.2 animations:^{
        _menuView.bgView.frame = CGRectMake(0, 0, 320, 0);
    }completion:^(BOOL finished) {
        _menuView.frame = CGRectMake(0, 0, 320, 0);
    }];
}

#pragma mark  - navigation bar
-(void)configNav
{
    NSString* title = nil;
    if (self.isMe) {
        title = [WTUserDefaults getNickname];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:NAV_ADD_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(moreOperation)] autorelease];
        
        self.menuView = [[[NSBundle mainBundle] loadNibNamed:@"menuView" owner:self options:nil] firstObject];
        self.menuView.frame = CGRectMake(0, 0, 320, 1);
        self.menuView.layer.masksToBounds = YES;
        self.menuView.bgView.frame = CGRectMake(0, 0, 320, 0);
        self.menuView.bgView.layer.masksToBounds = YES;
        self.menuView.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.menuView.maskView.userInteractionEnabled = YES;
        [self.menuView.maskView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuviewMaskviewTap:)] autorelease]];
        [self.view addSubview:_menuView];
    }
    else{
        title = self.buddy.nickName;
    }
    self.title = title;
}

- (void)goBack
{
    if (self.parent) {
        [self.parent.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)moreOperation{
    
    if (_menuView.frame.size.height < 10){
        [_menuView setCB:^(UIButton *btn) {
            [self newMoment:btn.tag];
        }];
        _menuView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 60);
        _menuView.maskView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 60);
        [UIView animateWithDuration:0.2 animations:^{
            _menuView.bgView.frame = CGRectMake(0, 0, 320, 160);
        }];
    }else{
        _menuView.maskView.frame = CGRectMake(0, 0, 320,0);
        [UIView animateWithDuration:0.2 animations:^{
            _menuView.bgView.frame = CGRectMake(0, 0, 320, 0);
        }completion:^(BOOL finished) {
            _menuView.frame = CGRectMake(0, 0, 320, 0);
        }];
    }
}

- (void)menuviewMaskviewTap:(UITapGestureRecognizer *)tap{
    _menuView.maskView.frame = CGRectMake(0, 0, 320,0);
    [UIView animateWithDuration:0.2 animations:^{
        _menuView.bgView.frame = CGRectMake(0, 0, 320, 0);
    }completion:^(BOOL finished) {
        _menuView.frame = CGRectMake(0, 0, 320, 0);
    }];
}

-(void)newMoment:(NSInteger)type
{
    if (type == 1 ){
        [self changeCategoryWithIndex:2];
    }
    if (type == 2 ){
        [self changeCategoryWithIndex:3];
    }
    if (type == 5 ){
        [self changeCategoryWithIndex:4];
    }
    if (type == 99 ){
        [self changeCategoryWithIndex:5];
    }
    if (type == 0 ){
        [self changeCategoryWithIndex:1];
    }
    if (type == 6 ){
        [self changeCategoryWithIndex:6];
    }
    
    if (type ==TAG_BUTTON_VOTE) {
        
        BizNewQAViewController* qavc = [[BizNewQAViewController alloc] init];
        qavc.delegate = self;
        [self.navigationController pushViewController:qavc animated:TRUE];
        [qavc release];
        
    }
    else if (type==TAG_BUTTON_VIDEO){
        OMNewVideoMomentVC* videovc = [[OMNewVideoMomentVC alloc] init];
        videovc.type = type;
        videovc.delegate = self;
        [self.navigationController pushViewController:videovc animated:TRUE];
        [videovc release];
        
    }
    else{
        BizNewMomentViewController* nmvc = [[BizNewMomentViewController alloc] init];
        nmvc.type = type;
        nmvc.delegate = self;
        [self.navigationController pushViewController:nmvc animated:TRUE];
        [nmvc release];
    }
}


#pragma mark - refresh moments
-(void)refreshMomentsArray{
    
    NSArray* arrTag = [self getTag_array];
    
    self.arr_moments = [Database fetchMomentsForBuddy:self.buddyid withLimit:limits andOffset:offset withtags:arrTag withOwnerType:99 ];
}

-(void)addMoreMomentsToArray{
    NSInteger count = [self.arr_moments count];
    
    NSArray* arrTag = [self getTag_array];
    NSMutableArray *newMomentArray=nil;
    
    newMomentArray = [Database fetchMomentsForBuddy:self.buddyid  withLimit:limits andOffset:(int)count withtags:arrTag withOwnerType:99];
    
    if (nil != newMomentArray) {
        NSMutableArray *moments2noadd = [[[NSMutableArray alloc] init] autorelease];
        for (Moment *aMoment in self.arr_moments) {
            for (Moment *aNewMoment in newMomentArray) {
                if ([aMoment.moment_id isEqualToString:aNewMoment.moment_id]) {
                    [moments2noadd addObject:aNewMoment];
                }
            }
        }
        for (Moment *moment2del in moments2noadd) {
            [newMomentArray removeObject:moment2del];
        }
        
        [self.arr_moments addObjectsFromArray:newMomentArray];
    }
}

-(void)didGetNewMoments:(NSNotification*)notif
{
    NSError* error = [[notif userInfo]valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self refreshMomentsArray];
    }
    
    [self performSelector:@selector(doneLoadingMoments) withObject:nil afterDelay:0.5];
}

-(void)getNewMomentsFromServer
{
    _reloadingMoments = TRUE;
    
    NSArray* arrTag = [self getTag_array];
    
    [self checkoutNotification];
    
    [WowTalkWebServerIF getMomentForBuddy:self.buddyid withTags:arrTag isWithReview:TRUE withCallback:@selector(didGetNewMoments:) withObserver:self];
    
    return;
}

-(void)doneLoadingMoments
{
    [[RotateIcon sharedRotateIcon] hide];
    _reloadingMoments = NO;
    
    [self.cover coverViewDataSourceDidFinishedLoading:self.tb_moments];
    
    [self checkoutNotification];
}



-(void)loadMoreMoments
{
    
    NSArray* arrTag = [self getTag_array];
    
    NSInteger row = [self.arr_moments count];
    // if we don't have data, means that we don't need to call loading more moments
    if (row> -1) {
        isLoadingMoreMoments = TRUE;
        Moment* moment = [self.arr_moments lastObject];
        [WowTalkWebServerIF  getMomentForBuddy:self.buddyid withTags:arrTag isWithReview:TRUE beforeTimeStamp:moment.timestamp withCallback:@selector(didLoadMoreMoments:) withObserver:self];
    }
    else{
        isLoadingMoreMoments = TRUE;
        [WowTalkWebServerIF  getMomentForBuddy:self.buddyid withTags:arrTag isWithReview:TRUE beforeTimeStamp:-1 withCallback:@selector(didLoadMoreMoments:) withObserver:self];
    }
}


#pragma mark -
#pragma markCoverViewDelegate Methods

- (void)coverViewDidTriggerRefresh:(CoverView *)view{
    [RotateIcon sharedRotateIcon].parent = self;
    [[RotateIcon sharedRotateIcon] show];
    [self getNewMomentsFromServer];
}

- (BOOL)coverViewDataSourceIsLoading:(CoverView *)view{
    return _reloadingMoments; // should return if data source model is reloading
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.cover.state == CoverViewLoading) {
        return;
    }
    
    [self.cover coverViewDidScroll:scrollView];
    
    // check whether it is go to the bottom.
    NSArray *visibleRows = [self.tb_moments visibleCells];
    
    if (!visibleRows || [visibleRows count] == 0) {
        return;
    }
    
    UITableViewCell *lastVisibleCell = [visibleRows lastObject];
    
    NSIndexPath *path = [self.tb_moments indexPathForCell:lastVisibleCell];
    
    if(path.section == 0 && path.row == [self.arr_moments count] -1 )
    {
        // Do something here
        CGSize size = scrollView.contentSize;
        CGPoint point = scrollView.contentOffset;
        
        //  NSLog(@"size %f,%f", size.width,size.height);
        int resdue = 0;
        
        if (size.height > [UISize screenHeightNotIncludingStatusBarAndNavBar]) {
            resdue = point.y  - (size.height - [UISize screenHeightNotIncludingStatusBarAndNavBar]);
        }
        else{
            resdue = point.y;
        }
        if ( resdue > 50 && self.cover.state == CoverViewNormal) {
            
            if (!scrollView.isDragging && !isLoadingMoreMoments) {
                
                isLoadingMoreMoments = TRUE;
            }
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.cover coverViewDidEndDragging:scrollView];
}




#pragma mark - UI init
-(void)initMomentTable
{
    // init header view
    
    [self.tb_moments setBackgroundColor:[Colors wowtalkbiz_background_gray ]];
    [self.tb_moments setSeparatorColor:[Colors wowtalkbiz_background_gray]];
    
    
    float start_y=0;
    self.cover = [[[CoverView alloc] initWithFrame:CGRectMake(0, start_y, 320, 200)] autorelease];
    
    self.cover.initialContentOffset =CGPointMake(0, 20);//30
    self.cover.refreshContentOffset = CGPointMake(0, -20);//-30
    self.cover.delegate = self;
    
    self.iv_avatar = [[[OMHeadImgeView alloc] initWithFrame:CGRectMake(10,start_y+self.cover.frame.size.height-60, 50, 50)] autorelease];
    
    self.iv_avatar.buddy = [Database buddyWithUserID:_buddyid];
    
    UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(self.iv_avatar.frame.size.width + self.iv_avatar.frame.origin.x + 15, self.iv_avatar.frame.origin.y + 15, 200, 20)];
    if (self.isMe) {
        name.text = [WTUserDefaults getNickname];
    }
    else
        name.text = self.buddy.nickName;
    
    name.textColor = [UIColor whiteColor];
    name.backgroundColor = [UIColor clearColor];
    name.shadowColor = [UIColor grayColor];
    name.shadowOffset = CGSizeMake(0,1);
    UILabel* signature = [[UILabel alloc] initWithFrame:CGRectMake(self.iv_avatar.frame.size.width + self.iv_avatar.frame.origin.x + 15, name.frame.origin.y + 15, 200, 20)];
    if (self.isMe) {
        signature.text = [WTUserDefaults getStatus];
    }
    else
    signature.text = self.buddy.status;
    signature.font = [UIFont systemFontOfSize:12];
    signature.textColor = [UIColor whiteColor];
    signature.backgroundColor = [UIColor clearColor];
    
    UIImageView* iv_shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0,start_y+self.cover.frame.size.height-50 , 320, 50 )];
    [iv_shadow setImage:[UIImage imageNamed:@"shadow_feed"]];
    iv_shadow.hidden = (signature.text==nil || signature.text.length==0);
    
    if ([self.buddyid isEqualToString:[WTUserDefaults getUid]]) {
        UIButton* changeCover = [[UIButton alloc] initWithFrame:CGRectMake(0,start_y,320,self.cover.frame.size.height)];
        [changeCover setBackgroundColor:[UIColor clearColor]];
        [changeCover addTarget:self action:@selector(clickToPopupActionSheet) forControlEvents:UIControlEventTouchUpInside];
        [self.cover addSubview:changeCover];
    }
    
    [self.cover addSubview:iv_shadow];
    [self.cover addSubview:name];
    [self.cover addSubview:signature];
    [self.cover addSubview:self.iv_avatar];
    
    if (!self.isMe) {
        UIButton* btn_view = [[UIButton alloc] initWithFrame:self.iv_avatar.frame];
        [btn_view setBackgroundColor:[UIColor clearColor]];
        [btn_view addTarget:self action:@selector(viewBuddyDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.cover addSubview:btn_view];
        [btn_view release];
    }
    
    [iv_shadow release];
    [name release];
    [signature release];
    
    [self refreshCoverImage];
    
    self.tb_moments.tableHeaderView = self.cover;//coca comment out in 20140118
    
    [self.tb_moments addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreMoments)];
    [self.tb_moments.footer setTitle:@"上拉或点击刷新" forState:MJRefreshFooterStateIdle];
    [self.tb_moments.footer setTitle:@"正在加载更多中...." forState:MJRefreshFooterStateRefreshing];
    [self.tb_moments.footer setTitle:@"没有更多" forState:MJRefreshFooterStateNoMoreData];
    self.tb_moments.footer.font = [UIFont systemFontOfSize:14];
    self.tb_moments.footer.textColor = [UIColor lightGrayColor];
    
    //new reviews
    newReviewsCount=0;
    
    [self checkoutNotification];
}

-(void)checkoutNotification
{
    if (!self.isMe) {
        self.review_aray = nil;
        return;
    }
    NSArray* arr = [Database getUnreadReviews];
    if (arr.count != self.review_aray.count){
        self.review_aray = arr;
    }
}

-(void)reloadCoverImage{
    self.coverimage = [Database getCoverImageByUid:self.buddyid];
    if (self.coverimage == nil) {
        self.coverimage = [[[CoverImage alloc] init] autorelease];
    }
    if(self.coverimage.coverNotSet){
        [self.cover.coverImage setImage:nil];
    }
    else{
        NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:self.coverimage.file_id WithSubFolder:SDK_MOMENT_COVER_DIR];
        
        NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
        BOOL isDirectory;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:absolutepath isDirectory:&isDirectory];
        if (exist && !isDirectory){
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:absolutepath];
            UIImage *newImage = [self clipImage:image InSize:CGSizeMake(self.cover.coverImage.bounds.size.width, self.cover.coverImage.bounds.size.height)];
            [self.cover.coverImage setImage:newImage];
            [image release];
        }else{
            UIImage *defaultImage = [self cutoutImage:[UIImage imageNamed:@"default_cover"] scaleToSize:CGSizeMake(self.cover.coverImage.bounds.size.width, self.cover.coverImage.bounds.size.height)];
            [self.cover.coverImage setImage:defaultImage];
        }
    }
}

- (UIImage *)cutoutImage:(UIImage *)originalImage scaleToSize:(CGSize)size{
    if (!originalImage || originalImage.size.height== 0 ||originalImage.size.width == 0 || size.width==0 || size.height == 0){
        return nil;
    }
    CGFloat widthscale =  originalImage.size.width / size.width ;
    CGFloat heightscale = originalImage.size.height / size.height;
    CGFloat scale = 1;
    
    if (widthscale < heightscale){
        scale = widthscale;
    }else{
        scale = heightscale;
    }
    CGSize newSize2 = CGSizeMake(size.width * scale, size.height * scale);
    UIGraphicsBeginImageContext(CGSizeMake(newSize2.width, newSize2.height));
    [originalImage drawInRect:CGRectMake(-originalImage.size.width/2 + newSize2.width/2, -originalImage.size.height/2 + newSize2.height/2, originalImage.size.width, originalImage.size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)clipImage:(UIImage *)image InSize:(CGSize)size{
    CGFloat scaleSize = 0;
    if (((image.size.width / image.size.height ) > (size.width/size.height))){
        scaleSize = size.height / image.size.height;
    }else{
        scaleSize = size.width / image.size.width;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(scaledImage.size.width/2 - size.width/2, scaledImage.size.height/2 - size.height/2,size.width , size.height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([scaledImage CGImage], rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}



-(void)refreshCoverImage
{
    // cover images.
    [self reloadCoverImage];
    
    // we will check the cover info everytime we enter in this view.
    [WowTalkWebServerIF getCoverImage:self.buddyid withCallback:@selector(didGetCoverInfo:) withObserver:self];
}


-(void)didGetCoverInfo:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.coverimage = [Database getCoverImageByUid:self.buddyid];
        if (self.coverimage != nil) {
            [self reloadCoverImage];
            
            if (self.coverimage.needDownload) {
                [WowTalkWebServerIF getCoverFromServer:self.coverimage withCallback:@selector(didDownloadCover:) withObserver:self];
            }
            else{
                NSData* data = [MediaProcessing getMediaForFile:self.coverimage.file_id withExtension:self.coverimage.ext];
                if (!data){
                    [WowTalkWebServerIF getCoverFromServer:self.coverimage withCallback:@selector(didDownloadCover:) withObserver:self];
                }
            }
        }
    }
}

-(void)didDownloadCover:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.coverimage = [Database getCoverImageByUid:self.buddyid];
        if (self.coverimage) {
            self.coverimage.needDownload = FALSE;
            [Database storeCoverImage:self.coverimage];
        }
        [self reloadCoverImage];
    }
}




-(void)viewBuddyDetail{
    //    BizMember* buddy = [Database bizMemberWithUserID:self.buddyid];
    //    BizContactViewController *bclvc = [[BizContactViewController alloc] init];
    //    bclvc.contact = buddy;
    //    [self.parent.navigationController pushViewController:bclvc animated:YES];
    //    [bclvc release];
}

-(void)changeCategory:(id)sender{
    sectionHeaderScrollViewOffsetX = headerScrollview.contentOffset.x;
    
    [self.tb_moments.footer endRefreshing];
    [self.tb_moments setContentOffset:CGPointZero animated:NO];
    
    self.currentCategory = [(UIButton*)sender tag] - 2000;
    [self refreshMomentsArray];
}

-(void)changeCategoryWithIndex:(NSInteger)index{
    self.currentCategory = index;
    [self.tb_moments.footer endRefreshing];
    [self.tb_moments setContentOffset:CGPointZero animated:NO];
    [self refreshMomentsArray];
}

#pragma mark  - cover
-(void)clickToPopupActionSheet
{
    UIActionSheet* actionsheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Comment list", nil),NSLocalizedString(@"Change Cover", nil), nil];
    [actionsheet showInView:self.view];
    [actionsheet release];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ReviewListViewController* rlvc = [[ReviewListViewController alloc] init];
        rlvc.newReviewOnly = FALSE;
        [self pushViewController:rlvc animated:YES];
        [rlvc release];
    }
    else if (buttonIndex == 1){
        ChangeCoverViewController *cctvc = [[ChangeCoverViewController alloc] init];
        cctvc.delegate = self;
        [self pushViewController:cctvc animated:YES];
        [cctvc release];
    }
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        self.coverimage.ext = @"jpg";
        if (self.coverimage.file_id) {
            self.coverimage.previousfile_id = self.coverimage.file_id;
        }
        
        self.coverimage.uid = [WTUserDefaults getUid];
        self.coverimage.file_id = [MediaProcessing saveCoverImageToLocal:image];
        self.coverimage.timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];  // we set a timestamp here.
        
        [WowTalkWebServerIF uploadCoverToServer:self.coverimage withCallback:@selector(didUploadCover:) withObserver:self];
        
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - callback for network function
//-(void)didVotedTheMoment:(NSNotification*)notif{
//    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
//    if (error.code == NO_ERROR) {
//        Moment* newmoment = [[notif userInfo] valueForKey:@"moment"];
//        for (Moment* moment in self.arr_moments) {
//            if ([moment.moment_id isEqualToString:newmoment.moment_id]) {
//                int row = [self.arr_moments indexOfObject:moment];
//                moment.options = newmoment.options;
//                [self.tb_moments reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:moment.moment_id];
//            }
//        }
//    }
//}

-(void)didUploadCover:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        [WowTalkWebServerIF uploadCoverImage:self.coverimage withCallback:@selector(didUpdateCoverImageData:) withObserver:self];
        
    }
}

-(void)didUpdateCoverImageData:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        [self reloadCoverImage];
        
        
        [[AppDelegate sharedAppDelegate] setNeedToRefreshCover:TRUE];
        //  NSLog(@"nonono");
    }
}

-(void)stopLoadingView
{
    isLoadingMoreMoments = FALSE;
}

-(void)didLoadMoreMoments:(NSNotification*)notif
{
    
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSInteger download_moment_count = [[[notif userInfo] valueForKey:@"fileName"] integerValue];
        NSInteger existing_moment_count = self.arr_moments.count;
        if (download_moment_count == 0){
            [self.tb_moments.footer noticeNoMoreData];
            return;
        }
        [self refreshMomentsFromDBWithLimit:(int)(download_moment_count + existing_moment_count) andOffset:0];
    }
    [self.tb_moments.footer endRefreshing];
    [self performSelector:@selector(stopLoadingView) withObject:nil afterDelay:0.5];
}

- (NSArray *)getTag_array{
    NSArray* arrTag = nil;
    
    switch (self.currentCategory) {
        case 0:
            arrTag = @[@(0),@(1),@(2),@(3),@(4),@(5),@(6)];
            break;
            
        case 1:
            arrTag= @[@(0)];
            break;
            
        case 2:
            arrTag= @[@(1)];
            break;
            
        case 3:
            arrTag= @[@(2)];
            break;
            
        case 4:
            arrTag= @[@(5)];
            break;
            
        case 5:
            arrTag= @[@(3),@(4)];
            break;
            
        case 6:
            arrTag= @[@(6)];
            break;
            
        default:
            return nil;
    }
    return arrTag;
}

- (void)refreshMomentsFromDBWithLimit:(int)limit andOffset:(int)offSet{
    NSArray* arrTag = [self getTag_array];
    self.arr_moments = [Database fetchMomentsForBuddy:self.buddyid withLimit:limit andOffset:offSet withtags:arrTag withOwnerType:99 ];
}


#pragma mark - voiceplayerdelegate
-(void)didStopPlayingVoice:(VoiceMessagePlayer *)requestor
{
    Moment* moment = requestor.moment;
    if (moment.momentType == 3 || moment.momentType == 4){
        // survey moment
        SurveyMomentCell* cell = (SurveyMomentCell*)[self.tb_moments cellForRowAtIndexPath:requestor.indexpath];
        cell.isPlaying = FALSE;
        UIImageView* recordicon = (UIImageView*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_ICON];
        [recordicon setImage:[UIImage imageNamed:@"timeline_player_play.png"]];
        
        UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
        [recordlabel setText:[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]];
    }
    
    else{
        NormalMomentCell* cell = (NormalMomentCell*)[self.tb_moments cellForRowAtIndexPath:requestor.indexpath];
        cell.isPlaying = FALSE;
        UIImageView* recordicon = (UIImageView*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_ICON];
        [recordicon setImage:[UIImage imageNamed:@"timeline_player_play.png"]];
        
        UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
        [recordlabel setText:[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]];
    }
    
}

-(void)willStartToPlayVoice:(VoiceMessagePlayer *)requestor
{
    Moment* moment = requestor.moment;
    if (moment.momentType == 3 || moment.momentType == 4){
        // survey moment
        SurveyMomentCell* cell = (SurveyMomentCell*)[self.tb_moments cellForRowAtIndexPath:requestor.indexpath];
        cell.isPlaying = TRUE;
        UIImageView* recordicon = (UIImageView*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_ICON];
        [recordicon setImage:[UIImage imageNamed:@"timeline_player_stop.png"]];
        
        UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
        [recordlabel setText:[NSString stringWithFormat:@"%@/%@",[TimeHelper getTimeFromSeconds:requestor.playingTime],[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]]];
    }
    else {
        NormalMomentCell* cell = (NormalMomentCell*)[self.tb_moments cellForRowAtIndexPath:requestor.indexpath];
        cell.isPlaying = TRUE;
        UIImageView* recordicon = (UIImageView*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_ICON];
        [recordicon setImage:[UIImage imageNamed:@"timeline_player_stop.png"]];
        
        UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
        [recordlabel setText:[NSString stringWithFormat:@"%@/%@",[TimeHelper getTimeFromSeconds:requestor.playingTime],[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]]];
    }
    
}

- (void) timeHandler:(VoiceMessagePlayer *)requestor
{
    Moment* moment = requestor.moment;
    
    if (moment.momentType == 3 || moment.momentType == 4){
        // survey moment
        SurveyMomentCell* cell = (SurveyMomentCell*)[self.tb_moments cellForRowAtIndexPath:requestor.indexpath];
        UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
        [recordlabel setText:[NSString stringWithFormat:@"%@/%@",[TimeHelper getTimeFromSeconds:requestor.playingTime],[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]]];
    }
    else{
        NormalMomentCell* cell = (NormalMomentCell*)[self.tb_moments cellForRowAtIndexPath:requestor.indexpath];
        UILabel* recordlabel = (UILabel*)[cell.contentView viewWithTag:TAG_MOMENT_RECORD_LABEL];
        [recordlabel setText:[NSString stringWithFormat:@"%@/%@",[TimeHelper getTimeFromSeconds:requestor.playingTime],[TimeHelper getTimeFromSeconds:cell.voiceclip.duration]]];
    }
}





#pragma mark - momenttypeoptionview delegate


-(void)showMomentType
{
    if(self.parent){
        [self.parent newMomentBtnClicked];
        
    }
    
    
}

-(void)emptyViewClicked:(id)sender
{
    if (self.isMe) {
        [self showMomentType];
    } else {
        //no action
    }
}

-(NSInteger)actualMomentIdxInTable:(NSIndexPath *)indexPath {
    NSInteger momentIdxInArray=indexPath.row;
    if (newReviewsCount > 0) {
        momentIdxInArray -= 1;
    }
    
    return momentIdxInArray;
}   

#pragma mark - UITableView delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        MomentNotificationCell *cell = [MomentNotificationCell cellWithTableView:tableView];
        cell.review_array = self.review_aray;
        return cell;
    }else{
        MomentBaseCell *cell = [MomentBaseCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        cell.delegate = self;
        MomentCellModel *model = self.cellModel_array[indexPath.row];
        cell.cellMoment = model;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 40;
    }else{
        MomentCellModel *model = self.cellModel_array[indexPath.row];
        return model.cellHeight;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        NSInteger count = self.review_aray.count;
        return count == 0 ? 0 : 1 ;
    }else{
        return self.cellModel_array.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    if (indexPath.section == 0){
        if (self.review_aray.count != 0 && [self.delegate respondsToSelector:@selector(OMBuddySpaceViewController:readNewReview:)]){
            [self.delegate OMBuddySpaceViewController:self readNewReview:self.review_aray];
        }else if (self.review_aray.count != 0 && !self.delegate){
            ReviewListViewController* rlvc = [[ReviewListViewController alloc] init];
            rlvc.newReviewOnly = TRUE;
            [self.navigationController pushViewController:rlvc animated:TRUE];
            [rlvc release];
        }
        
        self.review_aray = nil;
        
        NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:0];
        [self.tb_moments reloadSections:set withRowAnimation:UITableViewRowAnimationTop];
        [set release];
        
        return;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 1)return 0;
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 1) return nil;
    
    headerScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headerScrollview setBackgroundColor:[Colors wowtalkbiz_comment_section_gray]];
    NSArray* categoryname = [NSArray arrayWithObjects:CATEGORY_LABEL_ONE,CATEGORY_LABEL_TWO,CATEGORY_LABEL_THREE,CATEGORY_LABEL_FOUR,CATEGORY_LABEL_FIVE, CATEGORY_LABEL_SIX, CATEGORY_LABEL_SEVEN, nil];
    
    CGFloat origin_x = 10;
    CGFloat sv_width = 10;
    
    if([[NSString stringWithFormat:@"%zi",self.buddy.userType] isEqualToString:@"1"]){
        for (int i = 0; i< 7; i++) {
            
            CGFloat width = [UILabel labelWidth: NSLocalizedString([categoryname objectAtIndex:i], nil) FontType:15 withInMaxWidth:320];
            UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(origin_x, 0, width+20, 40)];
            
            if (i == 1 || i==6 || i== 2){
                btn.frame = CGRectMake(origin_x, 0, 0, 40);
                btn.alpha = 0;
            }
            
            
            [btn setTitle: NSLocalizedString([categoryname objectAtIndex:i],nil) forState:UIControlStateNormal];
            [btn setTitleColor:[Colors wowtalkbiz_inactive_text_gray] forState:UIControlStateNormal];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setBackgroundColor:[UIColor clearColor]];
            
            UIView* bar = [[UIView alloc] initWithFrame:CGRectMake(0, 36, btn.frame.size.width, 4)];
            bar.backgroundColor = [UIColor clearColor];
            [btn addSubview:bar];
            [bar release];
            
            if (i == self.currentCategory) {
                switch (i) {
                    case 0:
                        bar.backgroundColor = [Colors wowtalkbiz_moment_bar_gray];
                        break;
                    case 1:
                        bar.backgroundColor = [Colors wowtalkbiz_blue];
                        break;
                    case 2:
                        bar.backgroundColor = [Colors wowtalkbiz_orange];
                        break;
                    case 3:
                        bar.backgroundColor = [Colors wowtalkbiz_red];
                        break;
                    case 4:
                        bar.backgroundColor = [Colors wowtalkbiz_green];
                        break;
                    case 5:
                        bar.backgroundColor = [UIColor cyanColor];
                        break;
                    case 6:
                        bar.backgroundColor = [UIColor greenColor];
                        break;
                    default:
                        break;
                }
                
                [btn setTitleColor:[Colors wowtalkbiz_active_text_gray] forState:UIControlStateNormal];
            }
            
            btn.tag = 2000+i;
            [btn addTarget:self action:@selector(changeCategory:) forControlEvents:UIControlEventTouchUpInside];
            
            [headerScrollview addSubview:btn];
            [btn release];
            
            if ((i != 1) && (i != 6) && (i != 2)){
                origin_x += width+17;
                sv_width += width+17;
            }
        }
    }else{
        for (int i = 0; i< 7; i++) {
            
            CGFloat width = [UILabel labelWidth: NSLocalizedString([categoryname objectAtIndex:i], nil) FontType:15 withInMaxWidth:320];
            
            UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(origin_x, 0, width+20, 40)];
            
            if (i == 1 || i== 2){
                btn.frame = CGRectMake(origin_x, 0, 0, 40);
                btn.alpha = 0;
            }
            
            [btn setTitle: NSLocalizedString([categoryname objectAtIndex:i],nil) forState:UIControlStateNormal];
            [btn setTitleColor:[Colors wowtalkbiz_inactive_text_gray] forState:UIControlStateNormal];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setBackgroundColor:[UIColor clearColor]];
            
            UIView* bar = [[UIView alloc] initWithFrame:CGRectMake(0, 36, btn.frame.size.width, 4)];
            bar.backgroundColor = [UIColor clearColor];
            [btn addSubview:bar];
            [bar release];
            
            if (i == self.currentCategory) {
                switch (i) {
                    case 0:
                        bar.backgroundColor = [Colors wowtalkbiz_moment_bar_gray];
                        break;
                    case 1:
                        bar.backgroundColor = [Colors wowtalkbiz_blue];
                        break;
                    case 2:
                        bar.backgroundColor = [Colors wowtalkbiz_orange];
                        break;
                    case 3:
                        bar.backgroundColor = [Colors wowtalkbiz_red];
                        break;
                    case 4:
                        bar.backgroundColor = [Colors wowtalkbiz_green];
                        break;
                    case 5:
                        bar.backgroundColor = [UIColor cyanColor];
                        break;
                    case 6:
                        bar.backgroundColor = [UIColor greenColor];
                        break;
                    default:
                        break;
                }
                
                [btn setTitleColor:[Colors wowtalkbiz_active_text_gray] forState:UIControlStateNormal];
            }
            
            btn.tag = 2000+i;
            [btn addTarget:self action:@selector(changeCategory:) forControlEvents:UIControlEventTouchUpInside];
            
            [headerScrollview addSubview:btn];
            [btn release];
            
            
            if ((i != 1) && (i != 2)){
                origin_x += width+17;
                sv_width += width+17;
            }
        }
    }
    
    
    [headerScrollview setContentSize:CGSizeMake(sv_width, 40)];
    [headerScrollview setContentOffset:CGPointMake(sectionHeaderScrollViewOffsetX, 0)];
    
    if (sv_width > 320) {
        [headerScrollview setScrollEnabled:TRUE];
        headerScrollview.showsHorizontalScrollIndicator = FALSE;
    }
    else
        [headerScrollview setScrollEnabled:FALSE];
    
    headerScrollview.scrollsToTop = FALSE;
    
    return headerScrollview;
}



#pragma mark - ChangeCoverViewControllerDelegate
-(void)changeCover{
    [self reloadCoverImage];
}


#pragma mark - MomentBaseCellDelegate

//#if 0
- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell didClickHeadImageViewWithBuddy:(Buddy *)owner_buddy{
    if ([self.delegate respondsToSelector:@selector(OMBuddySpaceViewController:didClickHeadImageViewWithBuddy:)]){
        [self.delegate OMBuddySpaceViewController:self didClickHeadImageViewWithBuddy:owner_buddy];
    }
}


- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell didClickLocationModel:(MomentLocationCellModel *)locationModel{
}

- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell didVotedOption_array:(NSArray *)option_array withIndexPath:(NSIndexPath *)indexPath{
    
    MomentCellModel *model = self.cellModel_array[indexPath.row];
    
    Moment *moment = [Database getMomentWithID:model.moment.moment_id];
    
    model.moment = moment;
    
    [self.tb_moments reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
}


- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell clickLikeButton:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath{
    MomentCellModel *model = self.cellModel_array[indexPath.row];
    
    Moment *moment = [Database getMomentWithID:model.moment.moment_id];
    
    model.moment = moment;
    
    [self.tb_moments reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell clickCommentButton:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath withDistance:(CGFloat )distance{
    CGPoint point = self.tb_moments.contentOffset;
    [UIView animateWithDuration:0.2 animations:^{
        self.tb_moments.contentOffset = CGPointMake(point.x, point.y + distance);
    }];
}


- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell clickReviewBuddy:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath withBuddy_id:(NSString *)buddy_id{
    if ([self.delegate respondsToSelector:@selector(OMBuddySpaceViewController:clickReviewBuddy:withIndexPath:withBuddy_id:)]){
        [self.delegate OMBuddySpaceViewController:self clickReviewBuddy:bottomMdel withIndexPath:indexPath withBuddy_id:buddy_id];
    }
}


- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell didEndEdit:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath{
    CGFloat offY = self.tb_moments.contentOffset.y;
    if (offY < 0){
        [self.tb_moments setContentOffset:CGPointZero animated:YES];
    }
}

- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell playVideo:(WTFile *)videl_file withIndexPath:(NSIndexPath *)indexPath {
    
}

//#endif

#pragma mark - NewMomentProtocolDelegate

- (void)didAddNewMoment{
    //    [self.timelineVC didAddNewMoment];
    [self.tb_moments reloadData];
}


#pragma mark - Set and Get


-(void)setArr_moments:(NSMutableArray *)arr_moments{
    [_arr_moments release],_arr_moments = nil;
    
    _arr_moments = [arr_moments retain];
    
    if(nil == _arr_moments){
        
        return;
    }
    
    NSMutableArray *cellModel_array = [[NSMutableArray alloc]init];
    NSInteger count = _arr_moments.count;
    for (int i=0; i<count; i++){
        MomentCellModel *model = [[MomentCellModel alloc]init];
        model.moment = _arr_moments[i];
        [cellModel_array addObject:model];
        [model release];
    }
    self.cellModel_array = cellModel_array;
    [cellModel_array release];
}

-(void)setCellModel_array:(NSMutableArray *)cellModel_array{
    [_cellModel_array release],_cellModel_array = nil;
    _cellModel_array = [cellModel_array retain];
    if (_cellModel_array == nil){
        return;
    }
    
    if ([[VoiceMessagePlayer sharedInstance] isPlaying]) {
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
    }
    
    [self.tb_moments reloadData];
}


-(void)setReview_aray:(NSArray *)review_aray{
    [_review_aray release],_review_aray = nil;
    _review_aray = [review_aray retain];
    
    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:0];
    [self.tb_moments reloadSections:set withRowAnimation:UITableViewRowAnimationTop];
    [set release];
    
}


@end