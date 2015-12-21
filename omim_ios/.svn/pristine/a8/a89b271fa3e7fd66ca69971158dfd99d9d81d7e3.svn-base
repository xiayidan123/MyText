//
//  ClassMemberListVC.m
//  dev01
//
//  Created by 杨彬 on 15/3/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassMemberListVC.h"

#import "OMNetWork_MyClass.h"
#import "OMDateBase_MyClass.h"
#import "PublicFunctions.h"
#import "WTUserDefaults.h"

#import "OMClass.h"
#import "SchoolMember.h"

#import "BuddyDetailCell.h"
#import "OMTableViewHeadView.h"

#import "AddBuddyFromSchoolVC.h"
#import "ContactInfoViewController.h"

#import "UIView+MJExtension.h"
#import "MJRefresh.h"


@interface ClassMemberListVC ()<UITableViewDataSource, UITableViewDelegate,BuddyDetailCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView *memberList_tableView;

@property (retain, nonatomic) NSMutableArray *teacher_array;

@property (retain, nonatomic) NSMutableArray *student_array;

@end

@implementation ClassMemberListVC

- (void)dealloc {
    [_memberList_tableView release];
    [_classModel release];
    [_teacher_array release];
    [_student_array release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
    
}

- (void)uiConfig{
    [self configNavigation];
    
    [self loadMJRefresh];
    
    self.memberList_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
}

- (void)configNavigation{
    self.title = NSLocalizedString(@"师生名单", nil);
}

- (void)loadMJRefresh{
    [self.memberList_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.memberList_tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.memberList_tableView.header setTitle:@"释放刷新" forState:MJRefreshHeaderStatePulling];
    [self.memberList_tableView.header setTitle:@"正在加载..." forState:MJRefreshHeaderStateRefreshing];
    self.memberList_tableView.header.font = [UIFont systemFontOfSize:14];
    self.memberList_tableView.header.textColor = [UIColor lightGrayColor];
}

- (void)loadNewData{
    self.omAlertViewForNet.title = @"正在刷新师生名单";
    self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
    [self.omAlertViewForNet showInView:self.view];
    
    [OMNetWork_MyClass getClassMembersWithClass_id:self.classModel.groupID withCallback:@selector(didGetClassMemners:) withObserver:self];
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NetWork CallBack
- (void)didGetClassMemners:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.omAlertViewForNet.title = @"刷新成功";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
        self.teacher_array = nil;
        self.student_array = nil;
        [self.memberList_tableView reloadData];
    }else{
        self.omAlertViewForNet.title = @"刷新失败";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
    
    [self.memberList_tableView.header endRefreshing];
    
}

#pragma mark - OMAlertViewForNetDelegate

- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    
    
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuddyDetailCell *cell = [BuddyDetailCell cellWithTableView:tableView];
    cell.delegate = self;
    if (indexPath.section == 0){
        cell.buddy = self.teacher_array[indexPath.row];
    }else if (indexPath.section == 1){
        cell.buddy = self.student_array[indexPath.row];
    }
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return self.teacher_array.count;
    }else if (section == 1){
        return self.student_array.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return [OMTableViewHeadView omTableViewHeadViewWithTitle:@"老师"];
    }else if (section == 1){
        return [OMTableViewHeadView omTableViewHeadViewWithTitle:@"学生"];
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SchoolMember *school_member;
    if (indexPath.section == 0){
        school_member = self.teacher_array[indexPath.row];
    }else {
        school_member = self.student_array[indexPath.row];
    }
    
    if ([OMDateBase_MyClass schoolMemberAlreadyFriendByUserID:school_member.userID]){
        ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
        infoViewController.buddy = school_member;
        infoViewController.contact_type = CONTACT_FRIEND;
        [self.navigationController pushViewController:infoViewController animated:YES];
        [infoViewController release];
    }else{
        AddBuddyFromSchoolVC *addBuddyFromSchoolVC = [[AddBuddyFromSchoolVC alloc]initWithNibName:@"AddBuddyFromSchoolVC" bundle:nil];
        addBuddyFromSchoolVC.buddy = school_member;
        [self.navigationController pushViewController:addBuddyFromSchoolVC animated:YES];
        [addBuddyFromSchoolVC release];
    }
}

#pragma mark - BuddyDetailCellDelegate

-(void)didDownLoadThumbnailImage:(BuddyDetailCell *)buddyDetailCell{
    [self.memberList_tableView reloadData];
}


- (void)CallBackBuddys:(NSMutableArray *)buddys{
    
}


#pragma mark - Set and Get
-(NSMutableArray *)teacher_array{
    if (_teacher_array == nil){
        self.teacher_array  = [OMDateBase_MyClass fetchClassMemberByClassID:self.classModel.groupID andMemberType:@"2"];
    }
    return _teacher_array;
}


-(NSMutableArray *)student_array{
    if (_student_array == nil){
        self.student_array  = [OMDateBase_MyClass fetchClassMemberByClassID:self.classModel.groupID andMemberType:@"1"];
    }
    return _student_array;
}











@end
