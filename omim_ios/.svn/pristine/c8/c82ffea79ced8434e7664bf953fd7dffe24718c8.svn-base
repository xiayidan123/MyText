//
//  OMContactRequestListViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMContactRequestListViewController.h"

#import "OMAddContactViewController.h"

#import "OMContactRequestListCell.h"

#import "Constants.h"
#import "WTError.h"
#import "WowTalkWebServerIF.h"
#import "Database.h"
#import "AppDelegate.h"

#import "PendingRequest.h"

#import "UIView+MJExtension.h"
#import "MJRefresh.h"

@interface OMContactRequestListViewController ()<UITableViewDataSource,UITableViewDelegate,OMContactRequestListCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView *request_tableView;


@property (retain, nonatomic) NSMutableArray * request_array;



@end

@implementation OMContactRequestListViewController

- (void)dealloc {
    self.request_array = nil;
    [_request_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
    
}

- (void)uiConfig{
    [self configNav];
    
    self.request_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
    
    [self loadMJRefresh];
}

- (void)configNav{
    self.title = NSLocalizedString(@"Request list",nil);
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:NAV_ADD_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)] autorelease];
}

- (void)loadMJRefresh{
    [self.request_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewRequest)];
    
    [self.request_tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.request_tableView.header setTitle:@"释放刷新" forState:MJRefreshHeaderStatePulling];
    [self.request_tableView.header setTitle:@"正在加载..." forState:MJRefreshHeaderStateRefreshing];
    
    self.request_tableView.header.font = [UIFont systemFontOfSize:14];
    self.request_tableView.header.textColor = [UIColor lightGrayColor];
    
    [self.request_tableView.header beginRefreshing];
}

- (void)loadNewRequest{
    [WowTalkWebServerIF getAllPendingRequest:@selector(didGetPendingRequest:) withObserver:self];
}


#pragma mark - Action

- (void)addFriend{
    
    OMAddContactViewController *addContactVC = [[OMAddContactViewController alloc]initWithNibName:@"OMAddContactViewController" bundle:nil];
    [self.navigationController pushViewController:addContactVC animated:YES];
    [addContactVC release];
}

/** 同意好友申请 */
-(void)acceptFriendRequest:(PendingRequest *)request
{
    [WowTalkWebServerIF addBuddy:request.buddyid withMsg:nil withCallback:@selector(didAddBuddy:) withObserver:self];
}
/** 拒绝好友申请 */
-(void)refuseFriendRequest:(PendingRequest *)request
{
    [WowTalkWebServerIF rejectFriendRequest:request.buddyid withCallback:@selector(didRejectFriendRequest:) withObserver:self];
}

/** 同意群组 */
-(void)acceptGroupApplication:(PendingRequest *)request
{
    [WowTalkWebServerIF acceptJoinApplicationFor:request.groupid FromUser:request.buddyid  withCallback:@selector(didHandleGroupApplicationRequest:) withObserver:self];
}

/** 拒绝群组 */
-(void)refuseGroupApplication:(PendingRequest *)request
{
    [WowTalkWebServerIF rejectCandidate:request.buddyid toJoinGroup:request.groupid withCallback:@selector(didHandleGroupApplicationRequest:) withObserver:self];
}



#pragma mark - Network Callback
- (void)didGetPendingRequest:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.request_array = nil;// 清空请求数组
        NSDictionary *requestdic = (NSDictionary *)[[notif userInfo] valueForKey:WT_PENDING_REQUEST];
        NSMutableArray *buddy_request = [requestdic objectForKey:@"buddyrequest"];
        if (buddy_request == nil){
            buddy_request = [[[NSMutableArray alloc]init] autorelease];
        }
        [self.request_array addObject:buddy_request];
        NSMutableArray *joing_group_request = [requestdic objectForKey:@"joingrouprequest"];
        if (joing_group_request == nil){
            joing_group_request = [[[NSMutableArray alloc]init]autorelease];
        }
        [self.request_array addObject:joing_group_request];
        NSMutableArray *group_invitation_request = [requestdic objectForKey:@"inviterequest"];
        if (group_invitation_request == nil){
            group_invitation_request = [[[NSMutableArray alloc]init] autorelease];
        }
        [self.request_array addObject:group_invitation_request];
        
        [self.request_tableView reloadData];
        [self.request_tableView.header endRefreshing];
    }
}


- (void)didHandleGroupApplicationRequest:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [WowTalkWebServerIF getAllPendingRequest:@selector(didGetPendingRequest:) withObserver:self];
    }
}

- (void)didAddBuddy:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        NSString *buddy_id = [notif userInfo][@"fileName"];
        Buddy *buddy = [Database buddyWithUserID:buddy_id];
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:buddy withFirstChat:YES];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
-(void)didRejectFriendRequest:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [WowTalkWebServerIF getAllPendingRequest:@selector(didGetPendingRequest:) withObserver:self];
    }
}


#pragma mark - OMContactRequestListCellDelegate

-(void)contactRequestListCell:(OMContactRequestListCell *)requestlistCell didDealRequestWithAccept:(BOOL)accept withRequest:(PendingRequest *)request{
    // 同意与否 做相应的操作
    
    if (request.buddyid){// 好友
        if (accept){// 同意
            [self acceptFriendRequest:request];
        }else{
            [self refuseFriendRequest:request];
        }
    }else{// 群组
        if (accept){
            [self acceptGroupApplication:request];
        }else{
            [self refuseGroupApplication:request];
        }
    }
}



#pragma mark - UITableViewDataSource


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OMContactRequestListCell *cell = [OMContactRequestListCell cellWithTableView:tableView];
    cell.request = self.request_array[indexPath.section][indexPath.row];
    cell.delegate = self;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.request_array.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.request_array[section] count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSMutableArray *request_array = self.request_array[section];
    if (request_array.count == 0){
        return 0;
    }else{
        return 20;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    header_view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1];
    
    UILabel *header_label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, header_view.width - 8, header_view.height)];
    header_label.font = [UIFont systemFontOfSize:12];
    header_label.textColor = [UIColor lightGrayColor];
    [header_view addSubview:header_label];
    [header_label release];
    
    
    switch (section) {
        case 0:{
            header_label.text = NSLocalizedString(@"Friend request", nil);
        }break;
        default:header_label.text = NSLocalizedString(@"Join Application / Invitation", nil);
            break;
    }
    
    return [header_view autorelease];
}




#pragma mark - UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Set and Get

-(NSMutableArray *)request_array{
    if (_request_array == nil){
        _request_array = [[NSMutableArray alloc]init];
    }
    return _request_array;
}





@end
