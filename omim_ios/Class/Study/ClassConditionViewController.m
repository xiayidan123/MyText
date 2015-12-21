//
//  ClassConditionViewController.m
//  dev01
//
//  Created by mac on 14/12/26.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ClassConditionViewController.h"
#import "ConditionTableViewCell.h"

#import "EvaluateTableViewCell.h"
@interface ClassConditionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView ;
    NSMutableArray *_dataArray;
    NSMutableArray *_detailDataArray;
}
@end

@implementation ClassConditionViewController
-(void)dealloc
{
    [_dataArray release],_dataArray = nil;
    [_detailDataArray release],_detailDataArray = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigation];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"精神状态",@"参与程度",@"参与效果",@"认真",@"自信",@"思维的条理性",@"思维的创造性",@"善于与人合作", nil];
     _detailDataArray = [[NSMutableArray alloc] initWithObjects:@"Spirit",@"participate",@"Effect",@"Serious",@"Self Confidence",@"Organization",@"Creative ",@"Corporation", nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //[self headView];
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
   
}
-(void)headView
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(200, 7, 50, 30)];
    label1.text = @"棒极了";
    label1.textColor = [UIColor grayColor];
    [view addSubview:label1];

    _tableView.tableHeaderView = view;
}
-(void)configNavigation
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"上课状态",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_mainTitle forState:UIControlStateNormal];
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
    
    if (indexPath.row == 0) {
        static NSString *myclassformationCellid = @"ConditionTableViewCell";
        ConditionTableViewCell *conditionTableViewCell = [tableView dequeueReusableCellWithIdentifier:myclassformationCellid];
        if (!conditionTableViewCell){
            conditionTableViewCell = [[[NSBundle mainBundle]loadNibNamed:@"ConditionTableViewCell" owner:self options:nil] firstObject];
        }
        conditionTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return conditionTableViewCell;

    }else{
        static NSString *myclassformationCellid = @"EvaluateTableViewCell";
        EvaluateTableViewCell *familySureTableViewCell = [tableView dequeueReusableCellWithIdentifier:myclassformationCellid];
        if (!familySureTableViewCell){
            familySureTableViewCell = [[[NSBundle mainBundle]loadNibNamed:@"EvaluateTableViewCell" owner:self options:nil] firstObject];
        }
        familySureTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return familySureTableViewCell;
    }
    
}


@end
