//
//  ActivityListViewController.m
//  yuanqutong
//
//  Created by Harry on 13-1-11.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "ActivityListViewController.h"

#import "PublicFunctions.h"

#import "WTHeader.h"
#import "Constants.h"

#import "ActivityListCell.h"
#import "ActivityReleaseViewController.h"
#import "ActivityModel.h"
#import "ActivityDetailVC.h"

#import "OMPulldownView.h"
#import "UIView+Extension.h"
#import "UIView+MJExtension.h"
#import "MJRefresh.h"

#import "WTUserDefaults.h"


#define EVENT_FETCH_LIMIT       20

@interface ActivityListViewController ()<OMPulldownViewDelegate,UITableViewDataSource,UITableViewDelegate,ActivityReleaseDelegate>

@property (retain, nonatomic) IBOutlet UITableView *listTableView;

@property (retain, nonatomic) OMPulldownView * pulldown_view;

@property (assign, nonatomic) EventState eventState;

@property (assign, nonatomic) ApplyStateOfEvent applyState;

@property(assign,nonatomic) UILabel *promptLabel ;

@property (retain, nonatomic) NSMutableArray * resultActivity;

@property (assign, nonatomic) NSString * start_time;
@property (assign, nonatomic) NSString * end_state;


@end

@implementation ActivityListViewController


- (void)dealloc
{
    self.pulldown_view = nil;
    self.resultActivity = nil;
    self.listTableView = nil;
    [super dealloc];
}

#pragma mark ----View Handle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadImage:) name:WT_DOWNLOAD_EVENT_MEDIA object:nil];
    
    _promptLabel.hidden=YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadMJRefresh];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareData];// 初始化数据
    
    [self configNavigationBar];// 加载导航栏
    
    self.pulldown_view.plist_file_name = @"OMActivityList";
    
    [self getAllEventsFromLocalDB];
    
//    [self loadMJRefresh];
   
    [self loadAddContactsView];
    
    
}

//没有乐趣活动时，显示的内容
- (void)loadAddContactsView
{
    _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.view.center.y, self.view.bounds.size.width - 30, 44)];
    if ([[WTUserDefaults getUsertype]isEqualToString:@"1"])
    {
        _promptLabel.text = NSLocalizedString(@"没有乐趣活动，去其他界面浏览吧", nil);
    }
    else
    {
        _promptLabel.text = NSLocalizedString(@"没有乐趣活动点击右上角➕发布第一个活动吧", nil);
    }
    _promptLabel.font = [UIFont systemFontOfSize:14];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.61 alpha:1];
    _promptLabel.userInteractionEnabled = YES;
    [self.view addSubview:_promptLabel];
   


}



- (void)loadMJRefresh{
    [self.listTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewEvent)];
    
    [self.listTableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.listTableView.header setTitle:@"释放刷新" forState:MJRefreshHeaderStatePulling];
    [self.listTableView.header setTitle:@"正在加载..." forState:MJRefreshHeaderStateRefreshing];
    
    self.listTableView.header.font = [UIFont systemFontOfSize:14];
    self.listTableView.header.textColor = [UIColor lightGrayColor];
    
    [self.listTableView.header beginRefreshing];
    
    [self.listTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreEvent)];
    
    [self.listTableView.footer setTitle:@"上拉或点击加载更早的通知" forState:MJRefreshFooterStateIdle];
    [self.listTableView.footer setTitle:@"正在加载更多中...." forState:MJRefreshFooterStateRefreshing];
    [self.listTableView.footer setTitle:@"没有更多" forState:MJRefreshFooterStateNoMoreData];
    self.listTableView.footer.font = [UIFont systemFontOfSize:14];
    self.listTableView.footer.textColor = [UIColor lightGrayColor];
}




#pragma mark - Download 

- (void)loadNewEvent{// 加载最新活动
    [WowTalkWebServerIF getAllEventswithMaxStartTime:self.start_time
                                   withFinishedState:self.end_state
                                        withCallback:@selector(didGetAllEventsWithMaxStartTime:)
                                        withObserver:self];

}

- (void)loadMoreEvent{// 加载更多活动
    [WowTalkWebServerIF getAllEventswithMaxStartTime:self.start_time
                                   withFinishedState:self.end_state
                                        withCallback:@selector(didGetMoreEvents:)
                                        withObserver:self];
}


- (void)didDownloadImage:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [_listTableView reloadData];
    }
}


- (void)configNavigationBar
{
    
    self.title = NSLocalizedString(@"乐趣活动",nil);
    
    if([WTUserDefaults isTeacher] && ([[Database fetchAllSchool] count] > 0)){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:NAV_ADD_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(addActivity)];
    }
}


- (void)addActivity{
    [self.pulldown_view fastPackupMenu];
    
    ActivityReleaseViewController *activityReleaseVC = [[ActivityReleaseViewController alloc]initWithNibName:@"ActivityReleaseViewController" bundle:nil];
    activityReleaseVC.delegate = self;
    [self.navigationController pushViewController:activityReleaseVC animated:YES];
    [activityReleaseVC release];
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)prepareData{
    self.eventState = UNStartOfEventState;
    self.applyState = AllEvents;
}

# pragma mark - Network Callback
- (void)didGetAllEventsWithMaxStartTime:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.resultActivity = [Database fetchAllEventsByApplyState:self.applyState ByEventState:self.eventState  withOffset:0 WithLimit:EVENT_FETCH_LIMIT];
    }
    [self.listTableView reloadData];
    [self.listTableView.header endRefreshing];
}

- (void)didGetMoreEvents:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.resultActivity addObjectsFromArray:[Database fetchAllEventsByApplyState:self.applyState ByEventState:self.eventState  withOffset:self.resultActivity.count WithLimit:EVENT_FETCH_LIMIT]];
        
    }
    [self.listTableView reloadData];
    [self.listTableView.footer endRefreshing];
}


- (void)getAllEventsFromLocalDB{
    self.resultActivity = [Database fetchAllEventsByApplyState:self.applyState ByEventState:self.eventState  withOffset:0 WithLimit:EVENT_FETCH_LIMIT];
    [self.listTableView reloadData];
}



- (void)refreshTheDataFormLocalDB{
    self.resultActivity = [Database fetchAllEventsByApplyState:self.applyState ByEventState:self.eventState  withOffset:0 WithLimit:EVENT_FETCH_LIMIT];
    if (self.resultActivity.count == 0 ){
        [self loadNewEvent];
    }else {
        [self.listTableView reloadData];
    }
}


#pragma mark--------ActivityReleaseViewControllerDelegate

- (void)refreshActivityListViewController{
    [self loadNewEvent];
}

#pragma mark - UITableDataSorce

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityListCell *cell = [ActivityListCell cellWithTableView:tableView];
    cell.activityModel = self.resultActivity[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.resultActivity.count>0)
    {
        _promptLabel.hidden=YES;
    }
    else
    {
        _promptLabel.hidden=NO;
    }
    return self.resultActivity.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityDetailVC *activityDetailVC = [[ActivityDetailVC alloc]initWithNibName:@"ActivityDetailVC" bundle:nil];
    activityDetailVC.activityModel = self.resultActivity[indexPath.row];
    [self.navigationController pushViewController:activityDetailVC animated:YES];
    [activityDetailVC release];
}



- (void)didDownloadThumbnailForCell:(NSNotification *)notif
{
    NSInteger row = [[notif.userInfo objectForKey:@"showingorder"] integerValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSArray *reloadItems = [NSArray arrayWithObject:indexPath];
    [self.listTableView reloadRowsAtIndexPaths:reloadItems withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - OMPulldownViewDelegate

- (void)pulldown:(OMPulldownView *)pulldownView didSeletedItem:(OMPulldownItem *)item atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        self.applyState = indexPath.row;
    }else if (indexPath.section == 1){
        self.eventState = indexPath.row;
    }
    [self refreshTheDataFormLocalDB];
}


#pragma mark - Set and Get

- (OMPulldownView *)pulldown_view{
    if (_pulldown_view == nil){
        OMPulldownView *pulldown_view = [[OMPulldownView alloc]init];
        pulldown_view.delegate = self;
        pulldown_view.item_top = YES;
        [self.view addSubview:pulldown_view];
        pulldown_view.x = 0;
        pulldown_view.y = 64;
        pulldown_view.width = self.view.width;
        pulldown_view.height = 44;
        _pulldown_view = pulldown_view;
    }
    return _pulldown_view;
}

// 开始时间
-(NSString *)start_time{
    switch (self.eventState) {
        case DoingOfEventState:
        case EndedOfEventState:
        {
            return [[self.resultActivity lastObject] start_timestamp];
        }break;
        default:
            return nil;
            break;
    }
}

// 结束状态
-(NSString *)end_state{
    switch (self.eventState) {
        case UNStartOfEventState:{
            return @"0";
        }break;
        case EndedOfEventState:{
            return @"1";
        }break;
        default:
            return nil;
            break;
    }
}


-(NSMutableArray *)resultActivity{
    if (_resultActivity == nil){
        _resultActivity = [[NSMutableArray alloc]init];
    }
    return _resultActivity;
}





@end


