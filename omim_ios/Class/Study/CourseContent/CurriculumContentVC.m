//
//  CurriculumContentVC.m
//  dev01
//
//  Created by 杨彬 on 14-10-14.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "CurriculumContentVC.h"

@interface CurriculumContentVC ()
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation CurriculumContentVC

-(void)dealloc{
    [_tableView release];
    [_dataArray release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareData];
    
    [self uiConfig];
}

- (void)prepareData{
    _dataArray = [[NSMutableArray alloc]init];
    
    [self loadData];
}


- (void)loadData{
    [_dataArray addObject:@""];
    [_dataArray addObject:@""];
    [_dataArray addObject:@""];
    [_dataArray addObject:@""];
}

- (void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, self.view.bounds.size.width, self.view.bounds.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}



#pragma mark-----tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zi",indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 150;
    }else if (indexPath.row == 1){
        return 100;
    }else if (indexPath.row == 2){
        return 44;
    }else{
        return 0;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return NSLocalizedString(@"问题1:",nil);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}





@end