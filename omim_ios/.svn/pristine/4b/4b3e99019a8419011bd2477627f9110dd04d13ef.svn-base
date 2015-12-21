//
//  GroupAdminVC.m
//  dev01
//
//  Created by 杨彬 on 15/2/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "GroupAdminVC.h"
#import "WTHeader.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "GroupAdminCell.h"

#import "ContactInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ApplyViewController.h"



@interface GroupAdminVC ()<UITableViewDataSource,UITableViewDelegate,GroupAdminCellDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GroupAdminVC

-(void)dealloc{
    [_arr_members release],_arr_members = nil;
    [_groupid release],_groupid = nil;
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNav];
    
    if (self.arr_members == nil) {
        self.arr_members = [Database getAllMembersButMeInFixedGroup:self.groupid]; // better to get one from server.
    }
    
    for (int i = 0; i<[self.arr_members count];i ++ ) {
        
        GroupMember* member = [self.arr_members objectAtIndex:i];
        if (member.isCreator) {
            [self.arr_members removeObject:member];
            continue;
        }
    }

    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:false];
        [self setAutomaticallyAdjustsScrollViewInsets:false];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self loadTableView];
}




#pragma mark -- navigation bar
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNav
{
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  NSLocalizedString(@"Member management",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
}

- (void)loadTableView{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[[UIView alloc]init] autorelease];
    [_tableView registerNib:[UINib nibWithNibName:@"GroupAdminCell" bundle:nil] forCellReuseIdentifier:@"GroupAdminCell"];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark -
#pragma mark - UITableViewDelegate


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupAdminCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupAdminCell"];
    cell.buddy = self.arr_members[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_members.count;
}


//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width, 20)];
//    headerView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
//    UILabel *label = [[UILabel alloc]initWithFrame:headerView.frame];
//    label.text = NSLocalizedString(@"Member authority", nil);;
//    [headerView addSubview:label];
//    [label release];
//    return [headerView autorelease];
//}


#pragma mark - 
#pragma mark - GroupAdminCellDelegate

- (void)setManageWithBuddyID:(GroupMember *)member{
    [WowTalkWebServerIF setLevel:@"1" forUser:member.userID forGroup:self.groupid withCallback:@selector(didSetManager:) withObserver:self];
}

- (void)removeManageWithBuddyID:(GroupMember *)member{
    [WowTalkWebServerIF setLevel:@"9" forUser:member.userID forGroup:self.groupid withCallback:@selector(didRemoveManager:) withObserver:self];
}


#pragma mark -
#pragma mark - network
-(void)didSetManager:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.arr_members removeAllObjects];
        self.arr_members = [Database getAllMembersButMeInFixedGroup:self.groupid];
        [self.tableView reloadData];
        if ([_delegate respondsToSelector:@selector(didChangeManage)]){
            [_delegate didChangeManage];
        }
    }
}

-(void)didRemoveManager:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.arr_members removeAllObjects];
        self.arr_members = [Database getAllMembersButMeInFixedGroup:self.groupid];
        [self.tableView reloadData];
    }
    if ([_delegate respondsToSelector:@selector(didChangeManage)]){
        [_delegate didChangeManage];
    }
}


@end
