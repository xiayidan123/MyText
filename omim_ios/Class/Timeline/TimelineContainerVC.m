//
//  TimelineContainerVC
//  omim
//
//  Created by coca on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "TimelineContainerVC.h"
#import "OMBuddySpaceViewController.h"
#import "NewMomentViewController.h"
#import "OMTimelineViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "PulldownView.h"
#import "menuView.h"

#import "WTUserDefaults.h"
#import "BizNewMomentViewController.h"
#import "BizNewQAViewController.h"
#import "OMNewVideoMomentVC.h"
#import "leftBarBtn.h"


#import "OMFMomentListVC.h"
#import "ReviewListViewController.h"
#import "BizMomentDetailViewController.h"
#import "ViewDetailedLocationVC.h"

#import "Buddy.h"
#import "MomentLocationCellModel.h"

#import "GlobalSetting.h"

#import <MediaPlayer/MediaPlayer.h>
#import "WTFile.h"


@interface TimelineContainerVC ()<OMFMomentListVCDelegate,NewMomentProtocolDelegate>
{
    
    menuView *_menuView;
    BOOL _isShowMenuView;
}

//@property (nonatomic, retain) OMTimelineViewController *timelineVC;
@property (nonatomic, retain) OMBuddySpaceViewController *mySpaceVC;
@property (nonatomic, retain) UISegmentedControl* mySeg;

@property (retain, nonatomic) OMFMomentListVC * timelineVC;


@end

@implementation TimelineContainerVC

@synthesize mySeg;
@synthesize mySpaceVC;
@synthesize timelineVC;


-(void)newMoment:(NSInteger)type
{
    if (type == 1 && mySeg.selectedSegmentIndex == 1){
        [mySpaceVC changeCategoryWithIndex:2];
    }
    if (type == 2 && mySeg.selectedSegmentIndex == 1){
        [mySpaceVC changeCategoryWithIndex:3];
    }
    if (type == 5 && mySeg.selectedSegmentIndex == 1){
        [mySpaceVC changeCategoryWithIndex:4];
    }
    if (type == 99 && mySeg.selectedSegmentIndex == 1){
        [mySpaceVC changeCategoryWithIndex:5];
    }
    if (type == 0 && mySeg.selectedSegmentIndex == 1){
        [mySpaceVC changeCategoryWithIndex:1];
    }
    if (type == 6 && mySeg.selectedSegmentIndex == 1){
        [mySpaceVC changeCategoryWithIndex:6];
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
//-(void)newMoment{
//        NewMomentViewController *momentVC = [[NewMomentViewController alloc] initWithNibName:@"NewMomentViewController" bundle:nil];
//        momentVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:momentVC animated:YES];
//        [momentVC release];
//}

#pragma mark - View Life Circle

- (void)newMomentBtnClicked
{
      if (_menuView.frame.size.height < 10){
          if(!self.timelineVC.view.hidden){
             // [elf.timelineVC.pulldownView pulldownViewPackup];

          }
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


-(void)segClicked:(UISegmentedControl*)seg{
    
    if(seg.selectedSegmentIndex == 0){
        [self.timelineVC viewWillAppear:YES];
        
        [self.mySpaceVC.view setHidden:YES];
        [self.mySpaceVC viewWillDisappear:YES];
        [self.timelineVC.view setHidden:NO];
    }
    else{
        [self.mySpaceVC viewWillAppear:YES];
        
        [self.mySpaceVC.view setHidden:NO];
        [self.timelineVC.view setHidden:YES];
        [self.timelineVC viewWillDisappear:YES];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)configNav{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
    
    UIBarButtonItem *barButtonRight = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:@"icon_add_white"] selector:@selector(newMomentBtnClicked)];
    [self.navigationItem addRightBarButtonItem:barButtonRight];
    [barButtonRight release];
    
    mySeg = [[[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"分享", nil),NSLocalizedString(@"我的动态", nil)]] autorelease];
    mySeg.frame = CGRectMake(0, 0, 180, 30);
    mySeg.selectedSegmentIndex = 0;
    //[mySeg setTintColor:[UIColor colorWithRed:0.37 green:0.39 blue:0.43 alpha:1]];
    [mySeg setTintColor:[UIColor whiteColor]];
    [mySeg addTarget:self action:@selector(segClicked:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = mySeg;
    
    leftBarBtn *leftBarBtn = [[[NSBundle mainBundle] loadNibNamed:@"leftBarBtn" owner:nil options:nil] firstObject];
    [leftBarBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self configNav];

    self.timelineVC = [[[OMFMomentListVC alloc] init] autorelease];
    self.timelineVC.delegate = self;
    self.mySpaceVC = [[[OMBuddySpaceViewController alloc] init] autorelease];
    self.mySpaceVC.buddyid  = [WTUserDefaults getUid];

    self.timelineVC.view.frame = CGRectMake(self.timelineVC.view.frame.origin.x, self.timelineVC.view.frame.origin.y, self.timelineVC.view.frame.size.width, self.timelineVC.view.frame.size.height - 64);
    self.mySpaceVC.parent = self;

    [self.view addSubview:self.mySpaceVC.view];
    [self.view addSubview:self.timelineVC.view];
    
    [self.mySpaceVC.view setHidden:YES];
    
    _menuView = [[[NSBundle mainBundle] loadNibNamed:@"menuView" owner:self options:nil] firstObject];
    _menuView.frame = CGRectMake(0, 0, 320, 1);
    _menuView.layer.masksToBounds = YES;
    _menuView.bgView.frame = CGRectMake(0, 0, 320, 0);
    _menuView.bgView.layer.masksToBounds = YES;
    _menuView.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    _menuView.maskView.userInteractionEnabled = YES;
    [_menuView.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuviewMaskviewTap:)]];
    [self.view addSubview:_menuView];
    
}

- (void)menuviewMaskviewTap:(UITapGestureRecognizer *)tap{
    _menuView.maskView.frame = CGRectMake(0, 0, 320,0);
    [UIView animateWithDuration:0.2 animations:^{
        _menuView.bgView.frame = CGRectMake(0, 0, 320, 0);
    }completion:^(BOOL finished) {
        _menuView.frame = CGRectMake(0, 0, 320, 0);
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(mySeg.selectedSegmentIndex == 0){
        [self.timelineVC viewWillAppear:YES];
    }
    else{
        [self.mySpaceVC viewWillAppear:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(mySeg.selectedSegmentIndex == 0){
        [self.timelineVC viewDidAppear:YES];
    }
    else{
        [self.mySpaceVC viewDidAppear:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _menuView.maskView.frame = CGRectMake(0, 0, 320,0);
    [UIView animateWithDuration:0.2 animations:^{
        _menuView.bgView.frame = CGRectMake(0, 0, 320, 0);
    }completion:^(BOOL finished) {
        _menuView.frame = CGRectMake(0, 0, 320, 0);
    }];
}

#pragma mark - OMFMomentListVCDelegate
- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC readNewReview:(NSArray *)review_array{
    ReviewListViewController* rlvc = [[ReviewListViewController alloc] init];
    rlvc.newReviewOnly = TRUE;
    [self.navigationController pushViewController:rlvc animated:TRUE];
    [rlvc release];
}

- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC didClickHeadImageViewWithBuddy:(Buddy *)owner_buddy{
    OMBuddySpaceViewController *OMBuddySpaceVC = [[OMBuddySpaceViewController alloc]init];
    OMBuddySpaceVC.buddyid = owner_buddy.userID;
    [self.navigationController pushViewController:OMBuddySpaceVC animated:YES];
    [OMBuddySpaceVC release];
}

- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC didClickLocationModel:(MomentLocationCellModel *)locationModel{
    
    ViewDetailedLocationVC *locationVC = [[[ViewDetailedLocationVC alloc] initWithNibName:@"ViewDetailedLocationVC" bundle:nil] autorelease];
    
    
    locationVC.mode = VIEW_DATA;
    locationVC.fixOrigin = TRUE;
    locationVC.latitude = locationModel.latitude;
    locationVC.longitude = locationModel.longitude;
    locationVC.address = locationModel.place_text;
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC clickReviewBuddy:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath withBuddy_id:(NSString *)buddy_id{
    OMBuddySpaceViewController *OMBuddySpaceVC = [[OMBuddySpaceViewController alloc]init];
    OMBuddySpaceVC.buddyid = buddy_id;
    [self.navigationController pushViewController:OMBuddySpaceVC animated:YES];
    [OMBuddySpaceVC release];
}

- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC clickMoment:(Moment *)moment{
    BizMomentDetailViewController* bmdv = [[BizMomentDetailViewController  alloc] init];
    bmdv.moment = moment;
    [self.navigationController pushViewController:bmdv animated:TRUE];
    [bmdv release];
}


- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC playVideo:(WTFile *)video_file withIndexPath:(NSIndexPath *)indexPath {
    @try
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        NSString *video_file_id = video_file.fileid;
        NSString *ext = @".mp4";
        if ([video_file_id.lowercaseString hasSuffix:@".mp4"] ){
            NSRange rang = NSMakeRange(0, video_file_id.length - 4);
            video_file_id = [video_file_id substringWithRange:rang];
            ext = @".mp4";
        }else if ([video_file_id.lowercaseString hasSuffix:@".3gp"]){
            NSRange rang = NSMakeRange(0, video_file_id.length - 4);
            video_file_id = [video_file_id substringWithRange:rang];
            ext = @".3gp";
        }
        
        
        
        /*   NSString *mp4File =[ NSString stringWithFormat:@"%@%@%@", @"http://om-im-dev01.oss-cn-hangzhou.aliyuncs.com/momentfile/",file.fileid,@".mp4"];*/
        NSString *mp4File =[ NSString stringWithFormat:@"http://%@.oss-cn-hangzhou.aliyuncs.com/momentfile/%@%@",S3_BUCKET,video_file_id,ext];
        
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"2.mp4" withExtension:nil];
        
        MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:mp4File]];
        [moviePlayerViewController.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        [moviePlayerViewController.moviePlayer setShouldAutoplay:YES];
        [moviePlayerViewController.moviePlayer setFullscreen:NO animated:YES];
        [moviePlayerViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [moviePlayerViewController.moviePlayer setScalingMode:MPMovieScalingModeNone];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self    selector:@selector(moviePlaybackStateDidChange:)      name:MPMoviePlayerPlaybackStateDidChangeNotification    object:moviePlayerViewController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self     selector:@selector(moviePlayBackDidFinish:)    name:MPMoviePlayerPlaybackDidFinishNotification     object:moviePlayerViewController];
        
        [self presentViewController:moviePlayerViewController animated:YES completion:nil];
        
        moviePlayerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;

        [moviePlayerViewController release];
        [pool release];
    }
    @catch (NSException *exception) {
        // throws exception
        NSLog(@"%@",exception.description);
    }
}




#pragma mark - NewMomentProtocolDelegate

- (void)didAddNewMoment{
    [self.timelineVC didAddNewMoment];
}

- (void)dealloc
{
    self.timelineVC = nil;
    self.mySpaceVC = nil;
    [super dealloc];
}


@end
