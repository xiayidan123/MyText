//
//  ActivityApplyMembersListVC.m
//  dev01
//
//  Created by 杨彬 on 15-1-3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ActivityApplyMembersListVC.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"

#import "EventApplyMemberModel.h"

#import "ActivityApplyMembersListCell.h"

@interface ActivityApplyMembersListVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) UITableView * members_tableView;

@property (retain, nonatomic) NSMutableArray * members_array;;


@end

@implementation ActivityApplyMembersListVC


-(void)dealloc{
    
    self.members_tableView = nil;
    self.members_array = nil;
    self.activityModel = nil;
    
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"活动报名者列表",nil);
    self.members_array = [NSMutableArray array];
    [self loadDataFromServer];
}


- (void)loadDataFromServer{
    [WowTalkWebServerIF getEventMembersListWithEventID:_activityModel.event_id withCallBack:@selector(didGetEventMembers:) withObserver:self];
}

- (void)didGetEventMembers:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.members_array = [Database fetchMembersWithEventID:_activityModel.event_id];
        [self.members_tableView reloadData];
        
        if(self.members_array.count ==0){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"无人报名",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认",nil), nil];
            [alertView show];
            [alertView release];
        }
    }
}



- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityApplyMembersListCell *cell = [ActivityApplyMembersListCell cellWithTableView:tableView];
    EventApplyMemberModel *member = _members_array[indexPath.row];
    cell.member = member;
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.members_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Set and Get

-(NSMutableArray *)members_array{
    if (_members_array == nil){
       _members_array = [Database fetchMembersWithEventID:_activityModel.event_id];
    }
    return _members_array;
}


-(UITableView *)members_tableView{
    if (_members_tableView == nil){
        _members_tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _members_tableView.delegate = self;
        _members_tableView.dataSource = self;
        _members_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
        [self.view addSubview:_members_tableView];
        if (_members_tableView.contentInset.top == 0){
            _members_tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
    return _members_tableView;
}


@end
