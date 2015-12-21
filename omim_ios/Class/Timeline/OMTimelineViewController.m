//
//  OMTimelineViewController.m
//  wowtalkbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "OMTimelineViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "WTHeader.h"
#import "PublicFunctions.h"
#import "Constants.h"


#import "AppDelegate.h"

#import "MomentTypeView.h"

#import "BizNewMomentViewController.h"
#import "BizNewQAViewController.h"
#import "NormalMomentCell.h"
#import "VideoMomentCell.h"
#import "VoiceMessagePlayer.h"

#import "CoverView.h"
#import "ReviewListViewController.h"

#import "RotateIcon.h"

#import "BizMomentDetailViewController.h"
#import "OMBuddySpaceViewController.h"
#import "SurveyMomentCell.h"

#import "MessagesVC.h"
#import "TimelineEmptyContentIndForAll.h"
#import "TimelineNewReviewCell.h"
#import "ChangeCoverViewController.h"


//#define InitialContentOffset     80
//#define startToRefreshOffset      20

#define TAG_HEAD_SCROLLVIEW      100000;

@interface OMTimelineViewController ()<CoverViewDelegate>
{
    BOOL isGroupListShown;
    UIView* footerview;
    UIActivityIndicatorView* indicator;
    UILabel* lbl_loading;
    BOOL isLoadingMoreMoments;
    UIImageView* rotateIcon;
    BOOL rotateIsShown;
    BOOL _reloadingMoments;
    BOOL getMomentsAtFirstLoad;
    MomentOwnerType _momentOwnerType;
    NewMomentType _momentType;
    
    CGFloat sectionHeaderScrollViewOffsetX;
    
    UIImageView* blur_iv;
    
    int limits;
    int offset;
    
    UIScrollView* headerScrollview;
    
    BOOL isInited;
    NSInteger newReviewsCount;
    
//    PulldownView *_pulldownView;
    PulldownMenuView *_pulldownView;

    BOOL isViewingNewReviews;
    BOOL isViewingDetailMoment;
    BOOL isVCVisible;
}

@property (nonatomic,retain) NSString* selectedGroupID;
@property (nonatomic,retain) NSMutableArray* arr_moments;
@property (nonatomic,retain) CoverImage* coverimage;
@property (nonatomic,retain) CoverView* cover;
@property (nonatomic,retain) UIImageView* iv_cover;
@property (nonatomic,retain) UIImageView* iv_avatar;
@property (nonatomic, retain) UIImageView *navbarImageView;

@property int currentCategory;

@end

@implementation OMTimelineViewController

@synthesize parent;

-(void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion{
    if(self.parent){
        [self.parent.navigationController presentViewController:viewController animated:animated completion:nil];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.parent){
        [self.parent.navigationController pushViewController:viewController animated:animated];
    }
}


-(void)pulldownViewMenuClicked:(NSArray*)pressaArr{
    int type = [[pressaArr objectAtIndex:0] intValue];
    switch (type) {
        case 0:{
            _momentOwnerType = MomentOwnerTypeALL;
        }break;
        case 1:{
            _momentOwnerType = MomentOwnerTypePublicAccount;
        }break;
        case 2:{
            _momentOwnerType = MomentOwnerTypeTeacher;
        }break;
        case 3:{
            _momentOwnerType = MomentOwnerTypeStudent;
        }break;
        default:
            break;
    }
    
    int menuitem = [[pressaArr objectAtIndex:1] intValue];
    switch (menuitem) {
        case 0:{
            _momentType = NewMomentTypeAll;
        }break;
//        case 1:{
//            _momentType = NewMomentTypeNotification;
//        }break;
//        case 2:{
//            _momentType = NewMomentTypeQA;
//        }break;
        case 1:{
            _momentType = NewMomentTypeStudy;
        }break;
        case 2:{
            _momentType = NewMomentTypeLife;
        }break;
        case 3:{
            _momentType = NewMomentTypeSurvey;
        }break;
        case 4:{
            _momentType = NewMomentTypeVideo;
        }break;
        default:
            break;
    }
    [self changeCategory:menuitem];
    /*
    if (type == 1) {
        //TODO:coca
    }
    else  if (type == 2) {
        [self changeCategory:menuitem];
    }*/
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadPulldownMenuView];
    [self.tb_moments setFrame:CGRectMake(0, 40, self.tb_moments.frame.size.width, [UISize screenHeight] - 20 - 44 -40)];

    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.selectedGroupID = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedGroupToBeViewed"];
    if ([NSString isEmptyString:self.selectedGroupID]) {
        if([Database getFirstLevelDepartments]!=nil && [[Database getFirstLevelDepartments] count]>0){
            self.selectedGroupID = [[[Database getFirstLevelDepartments] objectAtIndex:0] groupID];
        }
    }

    
    
    [self.bg_header setBackgroundColor:[Colors blackColorUnderMomentTable]];
    [self.view setBackgroundColor:[Colors wowtalkbiz_background_gray]];
    
    if (self.arr_moments == nil) {
        self.arr_moments = [[[NSMutableArray alloc] init] autorelease];
    }
    
    limits = 20;
    offset = 0;
    _momentOwnerType = MomentOwnerTypeALL;
    
    self.arr_moments = [Database fetchMomentsForAllBuddiesWithLimit:limits andOffset:offset withtags:nil withOwnerType:_momentOwnerType];
    
    [self initMomentTable];
    
    self.tb_moments.scrollsToTop = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetLatestReplyForMe:) name:WT_GET_LATEST_REVIEWS_FOR_ME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needReloadData:) name:WT_NEED_RELOAD_TIMELINE_MOMENT_TABLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewNewReviews) name:TIMELINE_VIEW_NEW_REVIEWS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData:) name:TIMELINE_MOMENT_STATUS_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(momentActionNewMomentHandle:) name:MOMENT_ACTION_NEW_MOMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(momentActionDeleteMomentHandle:) name:MOMENT_ACTION_DELETE_MOMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(momentActionRefreshMomentHandle:) name:MOMENT_ACTION_REFRESH_MOMENT object:nil];
}





-(void)viewWillAppear:(BOOL)animated{
    isVCVisible=true;
    isViewingNewReviews=false;
    isViewingDetailMoment=false;

    
    
    [VoiceMessagePlayer sharedInstance].isLocked = FALSE;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didVotedTheMoment:) name:WT_VOTE_MOMENT_SURVEY object:nil];
    
    if (IS_IOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    if (!isInited) {
        [self getNewMomentsFromServer];//todo coca
        isInited = TRUE;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self checkoutNotification];
    if([AppDelegate sharedAppDelegate].comeFromViewLargePhoto){
        [AppDelegate sharedAppDelegate].comeFromViewLargePhoto = FALSE;
    }
    else {
        [self tbDataReload];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WT_VOTE_MOMENT_SURVEY object:nil];
    isVCVisible=false;
    if ([VoiceMessagePlayer sharedInstance].isPlaying) {
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
    }
}


- (void)loadPulldownMenuView{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i=0; i<2; i++){
        Tag *tag = [[Tag alloc]init];
        tag.tagTitle =@[NSLocalizedString(@"分享者",nil),NSLocalizedString(@"分类",nil)][i];
        tag.contentArray = @[@[NSLocalizedString(@"全部",nil),NSLocalizedString(@"公众账号",nil),NSLocalizedString(@"老师",nil),NSLocalizedString(@"学生",nil)],@[NSLocalizedString(@"全部",nil),NSLocalizedString(@"学习",nil),NSLocalizedString(@"生活",nil),NSLocalizedString(@"投票",nil),NSLocalizedString(@"视频教程",nil)]][i];
        [array addObject:tag];
        [tag release];
    }
    _pulldownView = [[[NSBundle mainBundle] loadNibNamed:@"PulldownMenuView" owner:self options:nil] firstObject];
    [_pulldownView loadPulldownViewWithFram:CGRectMake(0, 0, 320, 44) andCTagArry:array];
    _pulldownView.delegate = self;
    [array release];
    [self.view addSubview:_pulldownView];
}

- (void)dealloc
{
    [super dealloc];
    [_navbarImageView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - PulldownMenuViewDelegate 
- (void)didSelecteWithState:(NSArray *)stateArray{
    [self pulldownViewMenuClicked:stateArray];
}

#pragma mark - markCoverViewDelegate Methods

- (void)coverViewDidTriggerRefresh:(CoverView *)view{
    
    [RotateIcon sharedRotateIcon].parent = self;
    [[RotateIcon sharedRotateIcon] show];
    
    [self getNewMomentsFromServer];
}

- (BOOL)coverViewDataSourceIsLoading:(CoverView *)view{
    return _reloadingMoments; // should return if data source model is reloading
}


#pragma mark UIScrollViewDelegate Methods

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
        
        if (size.height > [UISize screenHeightNotIncludingStatusBarAndNavBar] + 60) {
            resdue = point.y  - (size.height - [UISize screenHeightNotIncludingStatusBarAndNavBar]);
        }
        else{
            resdue = point.y - 60;
        }
        if ( resdue > 50 && self.cover.state == CoverViewNormal) {
            
            if (!scrollView.isDragging && !isLoadingMoreMoments) {
                
                isLoadingMoreMoments = TRUE;
                [lbl_loading setHidden:FALSE];
                [indicator setHidden:FALSE];
                [indicator startAnimating];
                [self loadMoreMoments];
            }
        }
    }
    
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.cover coverViewDidEndDragging:scrollView];
}


-(void)stopLoadingView
{
    [indicator stopAnimating];
    [indicator setHidden:TRUE];
    [lbl_loading setHidden:TRUE];
    isLoadingMoreMoments = FALSE;
}



-(void)doneLoadingMoments
{
    [[RotateIcon sharedRotateIcon] hide];
    
    _reloadingMoments = NO;
    
    [self.cover coverViewDataSourceDidFinishedLoading:self.tb_moments];
    
    [self checkoutNotification];
}



#pragma mark - moment data relate
-(void)reloadTableData:(NSNotification*) notification
{
    Moment *moment2update=[notification object];
    if (nil != moment2update) {
        for (int i = 0; i< [self.arr_moments count]; i ++) {
            Moment* moment = [self.arr_moments objectAtIndex:i];
            if ([moment2update.moment_id isEqualToString:moment.moment_id]) {
                Moment* newmoment = [Database getMomentWithID:moment.moment_id];
                
                if(newmoment){
                    [self.arr_moments replaceObjectAtIndex:i withObject:newmoment];
                    
                }
            }
        }
        
        
    }
    
    [self.tb_moments reloadData];
}



-(void)initMomentTable
{
    sectionHeaderScrollViewOffsetX = 0;
    
    [self.tb_moments setBackgroundColor:[Colors wowtalkbiz_background_gray ]];
    [self.tb_moments setSeparatorColor:[Colors wowtalkbiz_background_gray]];

    
    float start_y=0;
    self.cover = [[[CoverView alloc] initWithFrame:CGRectMake(0, start_y, 320, 1)] autorelease];
    
    self.cover.initialContentOffset =CGPointMake(0, 0);//30
    self.cover.refreshContentOffset = CGPointMake(0, -20);//-30
    self.cover.delegate = self;
    
    self.iv_avatar = [[[UIImageView alloc] initWithFrame:CGRectMake(260, start_y+self.cover.frame.size.height-60, 50, 50)] autorelease];
    self.iv_avatar.layer.masksToBounds = YES;
    self.iv_avatar.layer.cornerRadius = self.iv_avatar.frame.size.height/2;
    
    NSData* data = [AvatarHelper getThumbnailForUser:[WTUserDefaults getUid]];
    if (data) {
        [self.iv_avatar setImage:[UIImage imageWithData:data]];
    }
    else{
        [self.iv_avatar setImage:[PublicFunctions strecthableImage:DEFAULT_AVATAR]];
    }
    
    UILabel* name = [[UILabel alloc] init];
    name.text = [WTUserDefaults getNickname];
    name.font = [UIFont systemFontOfSize:15];
    name.textAlignment = NSTextAlignmentRight;
    name.textColor = [UIColor whiteColor];
    name.backgroundColor = [UIColor clearColor];
    name.shadowColor = [UIColor grayColor];
    name.shadowOffset = CGSizeMake(0,1);
    
    int width = [UILabel labelWidth:name.text FontType:17 withInMaxWidth:200];
    [name setFrame:CGRectMake(self.iv_avatar.frame.origin.x - width - 10, start_y+self.cover.frame.size.height-50, width, 25)];
    
    UILabel* signature = [[UILabel alloc] init];
    signature.text = [WTUserDefaults getStatus];
    signature.textAlignment = NSTextAlignmentRight;
    signature.font = [UIFont systemFontOfSize:12];
    signature.textColor = [UIColor whiteColor];
    signature.backgroundColor = [UIColor clearColor];
    
    width = [UILabel labelWidth:signature.text FontType:15 withInMaxWidth:200];
    [signature setFrame:CGRectMake(self.iv_avatar.frame.origin.x - width - 10, start_y+self.cover.frame.size.height-25, width, 20)];
    
    
    UIImageView* iv_shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0,start_y+self.cover.frame.size.height-50 , 320, 50 )];
    [iv_shadow setImage:[UIImage imageNamed:@"shadow_feed2.png"]];
    iv_shadow.hidden = (signature.text==nil || signature.text.length==0);
    
    
    
    UIButton* btn = [[UIButton alloc] initWithFrame:self.iv_avatar.frame];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(seeMyMoments:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* changeCover = [[UIButton alloc] initWithFrame:CGRectMake(0,start_y,320,self.cover.frame.size.height)];
    [changeCover setBackgroundColor:[UIColor clearColor]];
    
    [self.cover addSubview:changeCover];
    [self.cover addSubview:iv_shadow];
    [self.cover addSubview:self.iv_avatar];
    [self.cover addSubview:name];
    [self.cover addSubview:signature];
    [self.cover addSubview:btn];
    
    [iv_shadow release];
    [name release];
    [signature release];
    [btn release];
    [changeCover release];
    
    //self.tb_moments.tableHeaderView = self.cover; //coca:comment out at 20140217
    
    
    newReviewsCount=0;
    
    [self checkoutNotification];
    self.tb_moments.tableFooterView = [self customFootView];
}

-(void)checkoutNotification
{
    NSArray* arr = [Database getUnreadReviews];
    NSInteger oldNewReviewsCountValue=newReviewsCount;
    if (nil != arr) {
        newReviewsCount=arr.count;
    }
    if (oldNewReviewsCountValue != newReviewsCount) {
        [self.tb_moments reloadData];
    }
//[[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
}

-(void)getNewMomentsFromServer
{
    _reloadingMoments = TRUE;
    
    
    NSArray* arrTag;
    
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
            return;
    }
    
    
    
    [WowTalkWebServerIF getMomentsOfAll:-1 withTags:arrTag withReview:true withCallback:@selector(didGetAllMomemts:) withObserver:self];
    
    return;
}

-(void)loadMoreMoments
{
    NSArray* arrTag;
    
    
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
            return;
    }
    
    
    
    
    
    int count = [self.arr_moments count];
    // if we don't have data, means that we don't need to call loading more moments
    if (count> 0) {
        isLoadingMoreMoments = TRUE;
        Moment* moment = [self.arr_moments objectAtIndex:count-1];
        
        [WowTalkWebServerIF getMomentsOfAll:moment.timestamp withTags:arrTag withReview:TRUE withCallback:@selector(didLoadMoreMoments:) withObserver:self];
        
    }
    else{
        isLoadingMoreMoments = TRUE;
        [WowTalkWebServerIF getMomentsOfAll:-1 withTags:arrTag withReview:TRUE withCallback:@selector(didLoadMoreMoments:) withObserver:self];
    }
}




-(void)momentActionNewMomentHandle:(NSNotification*) notification
{
    NSString *momentId=[notification object];
    Moment* moment = [Database getMomentWithID:momentId];
    if (moment) {
        [self.arr_moments insertObject:moment  atIndex:0];
        if (isVCVisible) {
            [self tbDataReload];
        }
    }
}

-(void)momentActionDeleteMomentHandle:(NSNotification*) notification
{
    NSString *momentId=[notification object];
    NSMutableArray *moment2del=[[NSMutableArray alloc] init];
    
    for (int i = 0; i< [self.arr_moments count]; i ++) {
        Moment* moment = [self.arr_moments objectAtIndex:i];
        if ([momentId isEqualToString:moment.moment_id]) {
            [moment2del addObject:moment];
        }
    }
    
    for (Moment *aMoment in moment2del) {
        [self.arr_moments removeObject:aMoment];
    }
    
    if (moment2del.count > 0) {
        if (isVCVisible) {
            [self tbDataReload];
        }
    }
    
    [moment2del release];
}

-(void)momentActionRefreshMomentHandle:(NSNotification*) notification
{
    NSString *momentId=[notification object];
    
    if(momentId==nil)return;
    
    BOOL momentRefreshed=false;
    for (int i = 0; i< [self.arr_moments count]; i ++) {
        Moment* moment = [self.arr_moments objectAtIndex:i];
        if ([momentId isEqualToString:moment.moment_id]) {
            Moment* newmoment = [Database getMomentWithID:moment.moment_id];
            if(newmoment) {
                [self.arr_moments replaceObjectAtIndex:i withObject:newmoment];
                momentRefreshed=true;
            }
            
        }
    }
    
    if (momentRefreshed) {
        if (isVCVisible) {
            [self tbDataReload];
        }
    }
}







#pragma mark - button action
-(void)viewNewReviews
{
    if (isViewingNewReviews || isViewingDetailMoment) {
        return;
    }
    isViewingNewReviews=true;
    ReviewListViewController* rlvc = [[ReviewListViewController alloc] init];
    rlvc.newReviewOnly = TRUE;
    [self.parent.navigationController pushViewController:rlvc animated:TRUE];
    [rlvc release];
}

-(void)changeCategory:(int)category{
    /*
     #define CATEGORY_LABEL_ONE           @"All"
     #define CATEGORY_LABEL_TWO           @"Notice"//tag0  category1
     #define CATEGORY_LABEL_THREE         @"Q&A" //tag1  category2
     #define CATEGORY_LABEL_FOUR          @"Study"  //tag2  category3
     #define CATEGORY_LABEL_FIVE          @"Life"   //tag5  category4
     #define CATEGORY_LABEL_SIX           @"Survey"  //tag 3 and 4  category5
     #define CATEGORY_LABEL_SEVEN         @"Video"  //tag 6  category6
     */
    sectionHeaderScrollViewOffsetX = headerScrollview.contentOffset.x;
    headerScrollview.scrollsToTop = FALSE;
    
    self.currentCategory = category;
    
    [self refreshMomentsArray];
    [self tbDataReload];
}

-(void)seeMyMoments:(id)sender{
    
    OMBuddySpaceViewController * bsvc = [[OMBuddySpaceViewController alloc] init];
    bsvc.buddyid = [WTUserDefaults getUid];
    [self.parent.navigationController pushViewController:bsvc animated:TRUE];
    [bsvc release];
    
}

#pragma mark - callback
-(void)didVotedTheMoment:(NSNotification*)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
//        Moment* newmoment = [[notif userInfo] valueForKey:@"moment"];
//        for (Moment* moment in self.arr_moments) {
//            if ([moment.moment_id isEqualToString:newmoment.moment_id]) {
//                int row = [self.arr_moments indexOfObject:moment];
//                moment.options = newmoment.options;
//                [self.tb_moments reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:moment.moment_id];
//            }
//        }
        [self refreshMomentsArray];
        [self tbDataReload];
    }
}


-(void)refreshMomentsArray{
    NSArray* arrTag;
    
    switch (self.currentCategory) {
        case 0:
            arrTag = nil;
            break;
            
//        case 1:
//            arrTag= @[@(0)];
//            break;
//            
//        case 2:
//            arrTag= @[@(1)];
//            break;
            
        case 1:
            arrTag= @[@(2)];
            break;
            
        case 2:
            arrTag= @[@(5)];
            break;
            
        case 3:
            arrTag= @[@(3),@(4)];
            break;
            
        case 4:
            arrTag= @[@(6)];
            break;
            
        default:
            NSLog(@"not implemented");
            return;
    }
    self.arr_moments = [Database fetchMomentsForAllBuddiesWithLimit:limits andOffset:offset withtags:arrTag withOwnerType:_momentOwnerType];
    
}

-(void)addMoreMomentsToArray{
    int count = [self.arr_moments count];
    
    NSArray* arrTag;
    NSMutableArray *newMomentArray=nil;

    switch (self.currentCategory) {
        case 0:
            arrTag = nil;
            break;
            
//        case 1:
//            arrTag= @[@(0)];
//            break;
//            
//        case 2:
//            arrTag= @[@(1)];
//            break;
            
        case 1:
            arrTag= @[@(2)];
            break;
            
        case 2:
            arrTag= @[@(5)];
            break;
            
        case 3:
            arrTag= @[@(3),@(4)];
            break;
            
        case 4:
            arrTag= @[@(6)];
            break;
    
            
        default:
            return;
    }

    newMomentArray = [Database fetchMomentsForAllBuddiesWithLimit:limits andOffset:count withtags:arrTag withOwnerType:_momentOwnerType];
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

-(void)tbDataReload
{
    if ([[VoiceMessagePlayer sharedInstance] isPlaying]) {
        [[VoiceMessagePlayer sharedInstance] stopPlayingVoiceMessage];
    }
    [self.tb_moments reloadData];    
}

-(void)didLoadMoreMoments:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self addMoreMomentsToArray];
        [self.tb_moments reloadData];
    }
    [self performSelector:@selector(stopLoadingView) withObject:nil afterDelay:0.5];
}



-(void)didGetAllMomemts:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        [self refreshMomentsArray];
        [self tbDataReload];

    }
    
    [self performSelector:@selector(doneLoadingMoments) withObject:nil afterDelay:0.3];
}














-(void)needReloadData:(NSString *)info
{
    [self.tb_moments reloadData];
}

-(void)didGetLatestReplyForMe:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR)
        [self checkoutNotification];
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
    else {
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

-(NSInteger)actualMomentIdxInTable:(NSIndexPath *)indexPath {
    NSInteger momentIdxInArray=indexPath.row;
    if (newReviewsCount > 0) {
        momentIdxInArray -= 1;
    }
    
    return momentIdxInArray;
}

#pragma mark - table delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //new reviews cell for the first row
    if (newReviewsCount > 0 && 0 == indexPath.row) {
        TimelineNewReviewCell* newReviewCell = [tableView dequeueReusableCellWithIdentifier:@"new_review_cell"];
        if (newReviewCell == Nil) {
            newReviewCell = [[[TimelineNewReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"new_review_cell"] autorelease];
        }

        newReviewCell.detailText=[NSString stringWithFormat:@"%ld%@", (long)newReviewsCount,NSLocalizedString(@" new notifications", nil)];
        return newReviewCell;
    }
    
    //no new reviews and no moment,show empty cell
    if ([self.arr_moments count] <= 0 && newReviewsCount <= 0) {
        TimelineEmptyContentIndForAll* cell = [tableView dequeueReusableCellWithIdentifier:@"emptycell"];
        if (cell == Nil) {
            cell = [[[TimelineEmptyContentIndForAll alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptycell"] autorelease];
        }
        return cell;
    }
    
    //show normal moment
    NSInteger momentIdxInArray=[self actualMomentIdxInTable:indexPath];
    
    Moment* moment = [self.arr_moments objectAtIndex:momentIdxInArray];
    
    if (moment.momentType == 3 || moment.momentType == 4) {
        SurveyMomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"surveycell"];
        if (cell == Nil) {
            cell = [[[SurveyMomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"surveycell"] autorelease];
            cell.hasCommentPart = FALSE;
        }
        cell.parent = self;
        cell.indexPath = indexPath;
        cell.moment = [self.arr_moments objectAtIndex:momentIdxInArray];
        return cell;
    }
    else if (moment.momentType == 6) {
        VideoMomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"videocell"];
        if (cell == Nil) {
            cell = [[[VideoMomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videocell"] autorelease];
            cell.hasCommentPart = FALSE;
        }
        cell.parent = self;
        cell.indexPath = indexPath;
        cell.moment = [self.arr_moments objectAtIndex:momentIdxInArray];
        return cell;
    }

    else{
        NormalMomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"normalcell"];
        if (cell == Nil) {
            cell = [[[NormalMomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalcell"] autorelease];
            cell.hasCommentPart = FALSE;
        }
        cell.parent = self;
        cell.indexPath = indexPath;
        cell.moment = [self.arr_moments objectAtIndex:momentIdxInArray];
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //new reviews cell height
    if (newReviewsCount > 0 && 0 == indexPath.row) {
        return [TimelineNewReviewCell cellHeight];
    }
    
    //empty cell height
    if ([self.arr_moments count] <= 0 && newReviewsCount <= 0) {
        return [TimelineEmptyContentIndForAll cellHeight];
    }
    
    //normal moment height
    NSInteger momentIdxInArray=[self actualMomentIdxInTable:indexPath];
    
    Moment* moment = [self.arr_moments objectAtIndex:momentIdxInArray];
    
    if (moment.momentType == 3 || moment.momentType == 4) {
        return [SurveyMomentCell heightForMoment:moment];
    }
    else if(moment.momentType == 6){
        return [VideoMomentCell heightForMoment:moment];
    }
    else{
        return [NormalMomentCell heightForMoment:moment];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //if with new reviews,count=moment_count+newReview
    if (newReviewsCount > 0) {
        return [self.arr_moments count]+1;
    }
    
    //no new reviews,moment count or empty cell
    NSInteger cellCount=[self.arr_moments count];
    if (cellCount <= 0) {
        cellCount = 1;
    }
    return cellCount;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    //if with new reviews
    if (newReviewsCount > 0 && 0 == indexPath.row) {
        //new review clicked,cell will send notification,so need not call here
//        [self viewNewReviews];
        return;
    }
    
    //no new reviews
    if ([self.arr_moments count] <= 0) {
        return;
    }
    
    BizMomentDetailViewController* bmdv = [[BizMomentDetailViewController  alloc] init];
    
    NSInteger momentIdxInArray=[self actualMomentIdxInTable:indexPath];
    bmdv.moment = [self.arr_moments objectAtIndex:momentIdxInArray];
    [self.parent.navigationController pushViewController:bmdv animated:TRUE];
    [bmdv release];
}


-(UIView*)customFootView
{
    footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,  70)];
    [footerview setBackgroundColor:[UIColor clearColor]];
    lbl_loading = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 30)];
    lbl_loading.text = NSLocalizedString(@"Loading more moments", nil);
    lbl_loading.font = [UIFont systemFontOfSize:15];
    lbl_loading.textAlignment = NSTextAlignmentCenter;
    lbl_loading.textColor = [UIColor blackColor];
    lbl_loading.backgroundColor =[UIColor clearColor];
    
    [footerview addSubview:lbl_loading];
    [lbl_loading release];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setFrame:CGRectMake((320-indicator.frame.size.width)/2, 15, indicator.frame.size.width, indicator.frame.size.height)];
    [footerview addSubview:indicator];
    [indicator release];
    
    [indicator setHidden:TRUE];
    lbl_loading.hidden = TRUE;
    
    return footerview;
}




@end
