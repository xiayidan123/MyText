//
//  ActivityDetailVC.m
//  dev01
//
//  Created by 杨彬 on 14-11-3.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//9

#import "ActivityDetailVC.h"
#import "PublicFunctions.h"
#import "WTHeader.h"
#import "Constants.h"

#import "ActivityPhotoViewController.h"
#import "ActivityApplyMembersListVC.h"
#import "WTUserDefaults.h"
#import "ActivityDetailImage.h"

#import "ActivityModel.h"

#import "FillMemberInfoVC.h"

#import "ActivityDetailCell.h"

#define EVENT_FETCH_LIMIT       20

@interface ActivityDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,ActivityDetailCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView * tableView;

@property (assign, nonatomic) CGFloat cellHeight;

@property (assign, nonatomic) BOOL isdidApply;

@property (retain, nonatomic)  NSMutableDictionary *applyMemberInfo;

@end



@implementation ActivityDetailVC

-(void)dealloc{
    [_tableView release];_tableView.delegate = nil;_tableView.dataSource =nil;_tableView = nil;
    self.activityModel = nil;
    self.applyMemberInfo = nil;
    [super dealloc];
}

- (void)prepareData{
}

#pragma mark------View Handle

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadRightBarBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self configNavigationBar];// 加载导航栏
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadImage:) name:WT_DOWNLOAD_EVENT_MEDIA object:nil];
    [self refreshData];// 刷新活动
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didDownloadImage:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.tableView reloadData];
    }
}

- (void)configNavigationBar{
    self.title = NSLocalizedString(@"活动详情",nil);
    
    //    [self loadRightBarBtn];
}

- (void)loadRightBarBtn{
    NSString *rightBtnTitle = nil;
    
    if (_isdidApply){
        rightBtnTitle = NSLocalizedString(@"取消报名",nil);
    }else{
        rightBtnTitle = NSLocalizedString(@"报名",nil);
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:rightBtnTitle style:UIBarButtonItemStylePlain target:self action:@selector(applyButtonAciton)];
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applyButtonAciton{
    if (self.isdidApply){
        // 取消报名
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(NSLocalizedString(@"提示",nil),nil) message:NSLocalizedString(@"确认取消报名?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: NSLocalizedString(@"取消",nil), nil] autorelease];
        [alert show];
    }else{
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[_activityModel.start_timestamp integerValue]];
        if ([endDate timeIntervalSinceDate:[NSDate date]] > 0 && [_activityModel.max_member integerValue] > [_activityModel.member_count integerValue]){
            
            if ([_activityModel.is_get_member_info integerValue]){
                FillMemberInfoVC *fillMemberInfoVC = [[FillMemberInfoVC alloc]initWithNibName:@"FillMemberInfoVC" bundle:nil];
                fillMemberInfoVC.delegate = self;
                fillMemberInfoVC.model = _activityModel;
                [self.navigationController pushViewController:fillMemberInfoVC animated:YES];
                [fillMemberInfoVC release];
            }else{
                // 报名
                [self applyEvent];
            }
        }else if ([_activityModel.max_member integerValue] <= [_activityModel.member_count integerValue] && _isdidApply == NO){
            [self.navigationItem.rightBarButtonItem setTitle:@"报名人数已满"];
            self.navigationItem.rightBarButtonItem.action = nil;
        }else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"活动报名已经结束",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitles: nil] autorelease];
            [alert show];
        }
    }
}




#pragma mark--------getEventInfo From server
- (void)refreshData{
    [WowTalkWebServerIF getEventInfoWithEventId:_activityModel.event_id
                                   WihtCallBack:@selector(didGetEventInfo:)
                                   withObserver:self];
}


- (void)didGetEventInfo:(NSNotification *)notif{
    self.activityModel = [Database fetchEventsWithEventID:self.activityModel.event_id];
    [self.tableView reloadData];
}

#pragma mark---------applyEvent
- (void)applyEvent{
    [WowTalkWebServerIF applyEventWithEventId:_activityModel.event_id withApplyMessage:@"" withMemberInfo:_applyMemberInfo withCallBack:@selector(didApplyEvent:) withObserver:self];
}

- (void)didApplyEvent:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        _isdidApply = !_isdidApply;
        [self loadRightBarBtn];
        [self refreshData];
    }
}

#pragma mark - cancelEvent
- (void)cancelEvent{
    [WowTalkWebServerIF cancelEventWithEventId:_activityModel.event_id withCallBack:@selector(didCancelEvent:) withObserver:self];
}

- (void)didCancelEvent:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        _isdidApply = !_isdidApply;
        [self loadRightBarBtn];
        [self refreshData];
    }
}

#pragma mark - UIScrollerViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView && scrollView.contentOffset.y < -64){
        CGFloat distance = - scrollView.contentOffset.y - 64;
        
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        ActivityDetailImage *activityDeailImage = (ActivityDetailImage *)[cell.contentView viewWithTag:5000];
        [activityDeailImage modifImageContentOff:distance];
    }
}



#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *activityDetailCellid = @"activityDetailCellid";
    ActivityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:activityDetailCellid];
    if (!cell){
        cell = [[[ActivityDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityDetailCellid] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.activityModel = _activityModel;
    cell.delegate = self;
    [cell showCellWithIndexPath:indexPath];
    _cellHeight = cell.bounds.size.height;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 :32;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self HeightForCellAtIndexPath:indexPath];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![_activityModel.owner_id isEqualToString:[WTUserDefaults getUid]] && section == 0 ){
        return 6;
    }else{
        return (section == 0) ? 7 : 1 ;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 6){
        ActivityApplyMembersListVC *activityApplyMembersListVC = [[ActivityApplyMembersListVC alloc]init];
        activityApplyMembersListVC.activityModel = _activityModel;
        [self.navigationController pushViewController:activityApplyMembersListVC animated:YES];
        [activityApplyMembersListVC release];
    }
}


#pragma mark------UIAlerViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self cancelEvent];
    }
}

- (CGFloat)HeightForCellAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0  && indexPath.row == 0){
        return 254.0;
    }else if (indexPath.section == 0 && indexPath.row != 0){
        return 44;
    }else if (indexPath.section == 1){
        return 90;
    }else if (indexPath.section == 2){
        CGRect rect = [_activityModel.text_content boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
        return ((rect.size.height < 44) ? 60 : (rect.size.height + 44)) ;
    }else{
        return 44;
    }
}

#pragma mark-----ActivityDetailCellDelegate
- (void)clickImageWithIndex:(NSInteger)index{
    ActivityPhotoViewController *activityPhotoVC = [[ActivityPhotoViewController alloc]init];
    activityPhotoVC.activityModel = _activityModel;
    activityPhotoVC.indexOfPhoto = index;
    [self.navigationController pushViewController:activityPhotoVC animated:YES];
    [activityPhotoVC release];
}

#pragma mark - Set and Get

-(NSMutableDictionary *)applyMemberInfo{
    if (_applyMemberInfo == nil){
        _applyMemberInfo = [[NSMutableDictionary alloc]init];
    }
    return _applyMemberInfo;
}


-(void)setActivityModel:(ActivityModel *)activityModel{
    [_activityModel release],_activityModel = nil;
    _activityModel = [activityModel retain];
    self.isdidApply = [_activityModel.is_joined integerValue];
}


@end