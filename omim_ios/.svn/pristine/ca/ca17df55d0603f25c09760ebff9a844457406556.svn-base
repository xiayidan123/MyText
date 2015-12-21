//
//  curriculumViewController.m
//  dev01
//
//  Created by mac on 14/12/26.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "curriculumViewController.h"
#import "ClassConditionViewController.h"
@interface curriculumViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation curriculumViewController
-(void)dealloc
{
    [_dataArray release],_dataArray = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigation];
    
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"上课状况",@"家庭作业",@"家长意见", nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self .view addSubview:_tableView];
    
    [self setExtraCellLineHidden:_tableView];
}

-(void)configNavigation
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(_mainTitle,nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"我的班级" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 90, 44);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----------tableView

-(void)setExtraCellLineHidden: (UITableView *)tableView

{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = @"已确认";
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = @"待提交意见";
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  
{
    if (indexPath.row == 0) {
        ClassConditionViewController *classCondition = [[ClassConditionViewController alloc]init];
        classCondition.mainTitle = _mainTitle;
        [self.navigationController pushViewController:classCondition animated:YES];
        [classCondition release];
    }
    
}
@end
