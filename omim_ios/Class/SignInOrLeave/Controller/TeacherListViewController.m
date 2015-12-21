//
//  TeacherListViewController.m
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "TeacherListViewController.h"
#import "ClassLessonTeacherCell.h"
#import "OMNetWork_MyClass.h"
#import "OMDateBase_MyClass.h"
#import "OMClass.h"
#import "BuddyDetailCell.h"
#import "SchoolMember.h"
#import "OMAlertViewForNet.h"
@interface TeacherListViewController ()<UITableViewDelegate,UITableViewDataSource,OMAlertViewForNetDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataArray;
@property (retain, nonatomic) OMAlertViewForNet *omAlertView;

@end

@implementation TeacherListViewController


- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"老师";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (void)prepareData
{
    self.omAlertView = [OMAlertViewForNet OMAlertViewForNet];
    self.omAlertView.type = OMAlertViewForNetStatus_Loading;
    self.omAlertView.title = @"加载老师列表...";
    self.omAlertView.delegate = self;
    [self.omAlertView show];
    [OMNetWork_MyClass getClassTeachersWithClass_id:self.OMClass.groupID withCallback:@selector(didGetTeacherList:) withObserver:self];
//    [OMNetWork_MyClass getClassStudentsWithClass_id:self.OMClass.groupID withCallback:@selector(didGetStudentList:) withObserver:self];
}
- (void)didGetStudentList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.dataArray = [OMDateBase_MyClass fetchClassMemberByClassID:self.OMClass.groupID andMemberType:@"1"];
        [self.tableView reloadData];
    }
}
- (void)didGetTeacherList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.dataArray = [OMDateBase_MyClass fetchClassMemberByClassID:self.OMClass.groupID andMemberType:@"2"];
        [self.tableView reloadData];
    }
    self.omAlertView.title = @"加载完成";
    self.omAlertView.type = OMAlertViewForNetStatus_Done;
}
- (void)dealloc {
    self.dataArray = nil;
    [_tableView release];
    [super dealloc];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuddyDetailCell *cell = [BuddyDetailCell cellWithTableView:tableView];
    cell.buddy = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(getTeacherList:)]) {
        [_delegate getTeacherList:self.dataArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark -OMAlertViewForNetDelegate

- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    
}
@end
