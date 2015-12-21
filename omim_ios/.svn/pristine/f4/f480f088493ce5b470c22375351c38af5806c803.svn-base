//
//  ClassListViewController.m
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassListViewController.h"
#import "OMNetWork_MyClass.h"
#import "OMDateBase_MyClass.h"
#import "ClassLessonTeacherCell.h"
#import "WTError.h"
#import "OMClass.h"
@interface ClassListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataArray;
@end

@implementation ClassListViewController
- (void)dealloc {
    self.dataArray = nil;
    [_tableView release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"选择班级";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (void)prepareData
{
    [OMNetWork_MyClass getClassListWithCallBack:@selector(didGetClassList:) withObserver:self];
}
- (void)didGetClassList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.dataArray =[OMDateBase_MyClass fetchAllClass];
        [self.tableView reloadData];
    }
}
#pragma mark tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassLessonTeacherCell *cell = [ClassLessonTeacherCell cellWithTableView:tableView];
    cell.classModel = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(getClassName:)]) {
        [_delegate getClassName:(OMClass *)self.dataArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
