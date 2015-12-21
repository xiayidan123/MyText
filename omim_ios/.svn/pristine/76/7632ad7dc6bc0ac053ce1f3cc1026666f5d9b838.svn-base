//
//  MyclassAndHomeworkVC.m
//  dev01
//
//  Created by 杨彬 on 14-10-7.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "MyclassAndHomeworkVC.h"
#import "PublicFunctions.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "ClassCell.h"

#import "WowTalkWebServerIF.h"
#import "WTHeader.h"
#import "OMNetWork_MyClass.h"
#import "OMDateBase_MyClass.h"
#import "MyClassViewController.h"
#import "HomeInMyClassViewController.h"
@interface MyclassAndHomeworkVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger schoolCount;
@property (nonatomic, assign) NSInteger schoolRealCount;
@property (nonatomic, retain) NSMutableArray *schoolArray;
@end

@implementation MyclassAndHomeworkVC


-(void)dealloc{
    [_schoolArray release];
    [_tableView release];
    self.dataArray = nil;
    
    [super dealloc];
}

#pragma mark - View Handler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
    
    [self prepareData];
    
}

- (void)configNavigation{
    self.title = _isMyclass ? NSLocalizedString(@"我的课堂",nil) : NSLocalizedString(@"课后作业",nil) ;
    
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - loadData
- (void)prepareData{
    _schoolCount = 0;
    _schoolRealCount = 0;
    [self loadData];
}

- (void)loadData{
    [OMNetWork_MyClass getClassListWithCallBack:@selector(didGetClassList:) withObserver:self];
}



- (void)didGetClassList:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.dataArray = [OMDateBase_MyClass fetchAllClass];
        if (self.dataArray.count == 0){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先绑定班级" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 200;
            [alertView show];
            [alertView release];
        }
        [self.tableView reloadData];
    }
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 200){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassCell *cell = [ClassCell cellWithTableView:tableView];
    cell.omClass = self.dataArray[indexPath.row];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isMyclass){
        HomeInMyClassViewController *myClassVC = [[HomeInMyClassViewController alloc] init];
        myClassVC.classModel = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:myClassVC animated:YES];
        [myClassVC release];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

#pragma mark - Set and Get

-(NSMutableArray *)dataArray{
    if (_dataArray == nil){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


@end
