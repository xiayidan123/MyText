//
//  ClassBulletinVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/31.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassBulletinVC.h"

#import "PulldownMenuView.h"
#import "ClassBulletinCell.h"

#import "OMNetWork_MyClass.h"
#import "OMDateBase_MyClass.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "WTUserDefaults.h"

#import "OMClass.h"
#import "Moment.h"
#import "Anonymous_Moment_Frame.h"

#import "AddClassBulletinVC.h"

#import "UIView+MJExtension.h"
#import "MJRefresh.h"


@interface ClassBulletinVC ()<UITableViewDataSource,UITableViewDelegate,PulldownMenuViewDelegate,AddClassBulletinVCDelegate,ClassBulletinCellDelegate>

@property (retain, nonatomic) PulldownMenuView *pulldownMenuView;

@property (retain, nonatomic) NSMutableArray *class_array;

@property (retain, nonatomic) NSMutableArray *items_array;

@property (retain, nonatomic) NSMutableArray *bulletin_array;

@property (retain, nonatomic) NSMutableArray *bulletin_items_array;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topY_tableView;

@property (retain, nonatomic) IBOutlet UITableView *bulletin_tableView;

@property (assign, nonatomic) NSInteger selected_class_index;

@property (assign, nonatomic) BOOL didGetTeacherList;

@property (assign, nonatomic) BOOL didGetBulletinList;

@property (assign, nonatomic) BOOL didGetClassList;

@property (assign, nonatomic) BOOL loadingNewData;

@property (assign, nonatomic) BOOL loadingMoreData;

@end

@implementation ClassBulletinVC

- (void)dealloc {
    self.pulldownMenuView = nil;
    self.class_array = nil;
    self.items_array = nil;
    self.bulletin_array = nil;
    self.bulletin_items_array = nil;
    [_topY_tableView release];
    [_bulletin_tableView release];
    
    self.classModel = nil;
    
    [super dealloc];
}


- (void)loadBulletinFromDatabase{
    if (nil != self.classModel){
        if (_didGetTeacherList && _didGetBulletinList){
            if (self.loadingNewData){
              self.bulletin_array = [OMDateBase_MyClass fetch_classBulletinWitchClass_id:self.classModel.groupID with_starTime:nil];
            }else if (self.loadingMoreData){
                Anonymous_Moment *moment = [self.bulletin_array lastObject];
                
                NSMutableArray *bulletin_array = [[NSMutableArray alloc]initWithArray:self.bulletin_array];
                [bulletin_array addObjectsFromArray:[OMDateBase_MyClass fetch_classBulletinWitchClass_id:self.classModel.groupID with_starTime: [NSString stringWithFormat:@"%zi",moment.timestamp]]];
                self.bulletin_array = bulletin_array;
                [bulletin_array release];
            }
        }
    }else{
        if (_didGetClassList && _didGetBulletinList && _didGetTeacherList){
            
            if (self.selected_class_index == 0){
                if (self.loadingNewData){
                    self.bulletin_array = [OMDateBase_MyClass fetch_classBulletinWitchClass_id:nil with_starTime:nil];
                }else if (self.loadingMoreData){
                    
                    Anonymous_Moment *moment = [self.bulletin_array lastObject];
                    
                    NSMutableArray *bulletin_array = [[NSMutableArray alloc]initWithArray:self.bulletin_array];
                    [bulletin_array addObjectsFromArray:[OMDateBase_MyClass fetch_classBulletinWitchClass_id:nil with_starTime:[NSString stringWithFormat:@"%zi",moment.timestamp]]];
                    self.bulletin_array = bulletin_array;
                    [bulletin_array release];
                    //               self.bulletin_array = [OMDateBase_MyClass fetchAllClassBulletin];
                }
            }else{
                OMClass *selected_class = self.class_array[self.selected_class_index - 1];
                if (self.loadingNewData){
                    self.bulletin_array = [OMDateBase_MyClass fetch_classBulletinWitchClass_id:selected_class.groupID with_starTime:nil];
                    //                self.bulletin_array = [OMDateBase_MyClass fetchAllClassBulletin];
                }else if (self.loadingMoreData){
                    
                    Anonymous_Moment *moment = [self.bulletin_array lastObject];
                    
                    NSMutableArray *bulletin_array = [[NSMutableArray alloc]initWithArray:self.bulletin_array];
                    [bulletin_array addObjectsFromArray:[OMDateBase_MyClass fetch_classBulletinWitchClass_id:selected_class.groupID with_starTime:[NSString stringWithFormat:@"%zi",moment.timestamp]]];
                    self.bulletin_array = bulletin_array;
                    [bulletin_array release];
                    //               self.bulletin_array = [OMDateBase_MyClass fetchAllClassBulletin];
                }
            }
            
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}

- (void)prepareData{
    _didGetBulletinList = NO;
    _didGetTeacherList = NO;
    _didGetClassList = NO;
    _loadingMoreData = NO;
    _loadingNewData = NO;
    
    [self loadData];
}

- (void)loadData{
    if (self.classModel ){
        if (!_didGetTeacherList){
            [OMNetWork_MyClass getClassTeachersWithClass_id:self.classModel.groupID withCallback:@selector(didGetTeacherList:) withObserver:self];
        }
    }else{
        if (!_didGetTeacherList){
            [WowTalkWebServerIF getSchoolMembersWithCallBack:@selector(didGetTeacherList:) withObserver:self];
        }
        
        if (!_didGetClassList){
          [OMNetWork_MyClass getClassListWithCallBack:@selector(didGetClassList:) withObserver:self];
        }
    }
    
//    if (!_didGetBulletinList){
       [OMNetWork_MyClass getClassBulletinWithClassModel:self.classModel timestamp:nil count:0 WithCallBack:@selector(didGetClassBulletinList:) withObserver:self];
//    }
}


- (void)uiConfig{
    self.title = @"班级通知";
    
    if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]){
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_add_white.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addBulletin)] autorelease];
    }
    
    [self loadMJRefresh];
    
    if (self.classModel){
        
    }else{
        self.class_array = [OMDateBase_MyClass fetchAllClass];
        self.topY_tableView.constant = 44;
    }
}

- (void)loadMJRefresh{
    [self.bulletin_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self.bulletin_tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.bulletin_tableView.header setTitle:@"释放刷新" forState:MJRefreshHeaderStatePulling];
    [self.bulletin_tableView.header setTitle:@"正在加载..." forState:MJRefreshHeaderStateRefreshing];
    
    self.bulletin_tableView.header.font = [UIFont systemFontOfSize:14];
    self.bulletin_tableView.header.textColor = [UIColor lightGrayColor];
    
    [self.bulletin_tableView.header beginRefreshing];
    
    
    
    [self.bulletin_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.bulletin_tableView.footer setTitle:@"上拉或点击加载更早的通知" forState:MJRefreshFooterStateIdle];
    [self.bulletin_tableView.footer setTitle:@"正在加载更多中...." forState:MJRefreshFooterStateRefreshing];
    [self.bulletin_tableView.footer setTitle:@"没有更多" forState:MJRefreshFooterStateNoMoreData];
    
    self.bulletin_tableView.footer.font = [UIFont systemFontOfSize:14];
    self.bulletin_tableView.footer.textColor = [UIColor lightGrayColor];
}



- (void)loadNewData{
    self.loadingNewData = YES;
    [self loadData];
    
    
}

- (void)loadMoreData{
    self.loadingMoreData = YES;
    Anonymous_Moment *moment = [self.bulletin_array lastObject];
    
    [OMNetWork_MyClass getClassBulletinWithClassModel:self.classModel timestamp:[NSString stringWithFormat:@"%zi",moment.timestamp] count:0 WithCallBack:@selector(didGetClassBulletinList:) withObserver:self];
}

- (void)addBulletin{
    if (self.classModel == nil && self.class_array.count == 0){
        NSString *message = @"请绑定班级" ;
        
        UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips",nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil] autorelease];
        [alertView show];
        return;
    }
    
    AddClassBulletinVC *addClassBulletinVC = [[AddClassBulletinVC alloc]initWithNibName:@"AddClassBulletinVC" bundle:nil];
    addClassBulletinVC.delegate = self;
    if (self.classModel){
        addClassBulletinVC.class_model = self.classModel;
    }
    [self.navigationController pushViewController:addClassBulletinVC animated:YES];
    [addClassBulletinVC release];
}


- (void)loadPulldownMenuView{
    self.pulldownMenuView = [[[NSBundle mainBundle] loadNibNamed:@"PulldownMenuView" owner:self options:nil] lastObject];
    [self.pulldownMenuView loadPulldownViewWithFram:CGRectMake(0, 64, self.view.bounds.size.width, 44) andCTagArry:self.items_array];
    self.pulldownMenuView.delegate = self;
    [self.view addSubview:self.pulldownMenuView];
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassBulletinCell *cell = [ClassBulletinCell cellWithTableView:tableView];
    cell.frame_model = self.bulletin_items_array[indexPath.row];
    cell.delegate = self;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bulletin_items_array.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Anonymous_Moment_Frame *frame_model = self.bulletin_items_array[indexPath.row];
    return frame_model.cellHeight;
}


#pragma mark - UITableViewDelegate



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - ClassBulletinCellDelegate

- (void)classBulletinCell:(ClassBulletinCell *)classBulletinCell withUser_id:(NSString *)user_id{
    [self.bulletin_tableView reloadData];
}


#pragma mark - PulldownMenuViewDelegate
- (void)didSelecteWithState:(NSArray *)stateArray{
    NSString *class_id = @"all";
    NSInteger index = [[stateArray firstObject] integerValue];
    self.selected_class_index = index;
    if (index != 0){
        OMClass *class = self.class_array[index - 1];
        
        class_id = class.groupID;
        self.bulletin_array = [OMDateBase_MyClass fetchClassBulletinWithClass_id:class_id];
    }else{
        self.bulletin_array = [OMDateBase_MyClass fetchAllClassBulletin];
    }
}

#pragma mark - AddClassBulletinVCDelegate

- (void)addClassBulletinVC:(AddClassBulletinVC *)AddClassBulletinVC moment:(Moment *)moment{
    
    [self loadNewData];
}


#pragma mark - NetWork CallBack

- (void)didGetClassBulletinList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSInteger bulletion_count = [notif.userInfo[@"fileName"] integerValue];
        MJRefreshFooterState footer_state = self.bulletin_tableView.footer.state;
        if (bulletion_count == 0 && footer_state == MJRefreshFooterStateRefreshing){
            [self.bulletin_tableView.footer noticeNoMoreData];
        }else{
            [self.bulletin_tableView.footer resetNoMoreData];
        }
        self.didGetBulletinList = YES;
    }
        [self.bulletin_tableView.header endRefreshing];
        MJRefreshFooterState footer_state = self.bulletin_tableView.footer.state;
        if(footer_state != MJRefreshFooterStateNoMoreData){
            [self.bulletin_tableView.footer endRefreshing];
        }

}

- (void)didGetTeacherList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.didGetTeacherList = YES;
    }
}


- (void)didGetClassList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.didGetClassList = YES;
        self.class_array = [OMDateBase_MyClass fetchAllClass];
    }
}


#pragma mark - Set and Get

-(void)setClass_array:(NSMutableArray *)class_array{
    [_class_array release],_class_array = nil;
    _class_array = [class_array retain];
    
    if (_class_array == nil)return;
    
    NSMutableArray *items_array = [[NSMutableArray alloc]init];
    for (int i=0; i<1; i++){
        Tag *tag = [[Tag alloc]init];
        tag.tagTitle =@[NSLocalizedString(@"班级",nil)][i];
        NSMutableArray *contentArray = [[NSMutableArray alloc]init];
        NSInteger count = _class_array.count;
        [contentArray addObject:@"全部"];
        for (int j=0; j<count; j++){
            OMClass *classModel = _class_array[j];
            [contentArray addObject:classModel.groupNameOriginal];
        }
        tag.contentArray = contentArray;
        [contentArray release];
        
        [items_array addObject:tag];
        [tag release];
    }
    self.items_array = items_array;
    [self loadPulldownMenuView];
    [items_array release];
}


- (void)setBulletin_array:(NSMutableArray *)bulletin_array{
    [_bulletin_array release];_bulletin_array = nil;
    _bulletin_array = [bulletin_array retain];
    
    NSInteger count = _bulletin_array.count;
    
    NSMutableArray *items_array = [[NSMutableArray alloc]init];
    for(int i=0 ; i<count; i++){
        Anonymous_Moment_Frame *frame = [[Anonymous_Moment_Frame alloc]init];
        frame.moment = _bulletin_array[i];
        [items_array addObject:frame];
        [frame release];
    }
    self.bulletin_items_array = items_array;
    [self.bulletin_tableView reloadData];
}


- (void)setDidGetBulletinList:(BOOL)didGetBulletinList{
    _didGetBulletinList = didGetBulletinList;
    if (_didGetBulletinList){
        [self loadBulletinFromDatabase];
    }
}

- (void)setDidGetTeacherList:(BOOL)didGetTeacherList{
    _didGetTeacherList = didGetTeacherList;
    [self loadBulletinFromDatabase];
}

- (void)setDidGetClassList:(BOOL)didGetClassList{
    _didGetClassList = didGetClassList;
    [self loadBulletinFromDatabase];
}

- (void)setLoadingNewData:(BOOL)loadingNewData{
    _loadingNewData = loadingNewData;
    if (_loadingNewData){
        _loadingMoreData = NO;
    }
}

- (void)setLoadingMoreData:(BOOL)loadingMoreData{
    _loadingMoreData = loadingMoreData;
    if (_loadingMoreData){
        _loadingNewData = NO;
    }
}


@end
