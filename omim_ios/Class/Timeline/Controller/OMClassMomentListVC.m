//
//  OMClassMomentListVC.m
//  dev01
//
//  Created by 杨彬 on 15/6/5.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMClassMomentListVC.h"
#import "OMClass.h"

#import "MomentNotificationCell.h"
#import "MomentBaseCell.h"

#import "OMNetWork_MyClass.h"

@interface OMClassMomentListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *moment_tableView;

@property (retain, nonatomic) NSMutableArray * moment_array;
@end

@implementation OMClassMomentListVC

-(void)dealloc{
    self.class_model = nil;
    
    [_moment_tableView release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self uiConfig];
}


- (void)prepareData{
    [OMNetWork_MyClass getClassMomentsWithMaxtime:0 class_id:self.class_model.groupID withTags:nil withReview:YES withCallback:@selector(didGetClassMoment:) withObserver:self];
}


- (void)uiConfig{
    
    self.moment_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
    
}

#pragma mark - Network CallBack

- (void)didGetClassMoment:(NSNotification *)notif{
    
    
    
}



#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        MomentNotificationCell *cell = [MomentNotificationCell cellWithTableView:tableView];
//        cell.review_array = self.reviewArray;
        return cell;
    }else{
        MomentBaseCell *cell = [MomentBaseCell cellWithTableView:tableView];
//        cell.indexPath = indexPath;
        
//        cell.delegate = self;
        
//        MomentCellModel *model = self.cellModel_array[indexPath.row];
        
//        cell.cellMoment = model;
        
        return cell;
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}



#pragma mark - UITableViewDelegate




@end
