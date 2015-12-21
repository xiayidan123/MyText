//
//  ActivityListVC.m
//  dev01
//
//  Created by 杨彬 on 14-10-24.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ActivityListVC.h"
#import "PublicFunctions.h"
#import "PulldownMenuView.h"
#import "ActivityListCell.h"
#import "ActivityModel.h"
#import "TableHeaderView.h"
#import "TableFooterView.h"

@interface ActivityListVC ()
{
    PulldownMenuView *_pulldownView;
    UITableView *_listTableView;
    TableHeaderView *_headerView;
    TableFooterView *_footerView;
    
    
    NSMutableArray *_listDataArray;
    
    BOOL _isRefreshing;// 是否正在刷新
    BOOL _isDragging;// 是否正在拖动
    BOOL _isLoadingMore;// 是否正在加载更多
}

@end


@implementation ActivityListVC

- (void)dealloc
{
    [_listTableView release];
    [_listDataArray release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];// 数据操作
    
    [self uiConfig]; // UI操作
    
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}



- (void)prepareData{
    
    _listDataArray = [[NSMutableArray alloc]init];
    [self loadData];
}

- (void)loadData{
    for (int i=0; i<5; i++){
        ActivityModel *activityModel = [[ActivityModel alloc]init];
        [_listDataArray addObject:activityModel];
        [activityModel release];
    }
}

- (void)uiConfig{
    [self configNavigationBar];
    [self loadListTableView];
    [self loadPulldownMenuView];// 加载下拉菜单
    [self loadHeaderView];// 加载下拉刷新
    [self loadFooterView];// 加载上来刷新
    
}

- (void)configNavigationBar
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"乐趣活动",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadPulldownMenuView{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++){
        Tag *tag = [[Tag alloc]init];
        tag.tagTitle =@[@"主办方",@"类型",@"时间"][i];
        tag.contentArray = @[@[@"主办方1",@"主办方2",@"主办方3"],@[@"类型1",@"类型2",@"类型3",@"类型4"],@[@"时间1",@"时间2",@"时间3",@"时间4"]][i];
        [array addObject:tag];
        [tag release];
    }
    _pulldownView = [[[NSBundle mainBundle] loadNibNamed:@"PulldownMenuView" owner:self options:nil] firstObject];
    [_pulldownView loadPulldownViewWithFram:CGRectMake(0, 0, 320, 44) andCTagArry:array];
    [array release];
    [self.view addSubview:_pulldownView];
    _listTableView.frame = CGRectMake(0, _pulldownView.bounds.size.height + _pulldownView.frame.origin.y , self.view.bounds.size.width, self.view.bounds.size.height - _pulldownView.bounds.size.height- _pulldownView.frame.origin.y - 64);
}

- (void)loadListTableView{
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - _pulldownView.bounds.size.height- _pulldownView.frame.origin.y)];
    _listTableView.backgroundColor = [UIColor greenColor];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_listTableView];
}


- (void)loadHeaderView{
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil] firstObject];
    CGRect headerFrame = _headerView.frame;
    _headerView.frame = CGRectMake(0, -headerFrame.size.height, headerFrame.size.width, headerFrame.size.height);
    _headerView.backgroundColor = [UIColor yellowColor];
    [_listTableView addSubview:_headerView];
}

- (void)loadFooterView{
    _footerView = [[[NSBundle mainBundle] loadNibNamed:@"TableFooterView" owner:self options:nil] firstObject];
//    [self setFooterViewVisibility:YES];
    [_footerView updateState:FooterViewStatePullBegin];
    _footerView.backgroundColor = [UIColor orangeColor];
}



#pragma mark------------ListTabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ActivityListCellId = @"ActivityListCellId";
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityListCellId];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ActivityListCell" owner:self options:nil] firstObject];
    }
    [cell loadActivityListCell:_listDataArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listDataArray.count;
}

#pragma mark----------ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}




@end
