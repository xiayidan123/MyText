//
//  LearnplanVC.m
//  dev01
//
//  Created by 杨彬 on 14-10-9.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "LearnplanVC.h"
#import "StudyscheduleCell.h"
#import "PublicFunctions.h"

@interface LearnplanVC ()
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSArray *_courseNameArray;
    NSArray *_courseCompleteness;
}

@end

@implementation LearnplanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigation];
    
    [self prepareData];
    
    [self uiConfig];
    
    
}
- (void)configNavigation{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"知识点完成度",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
    [backBarItem release];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareData{
    _dataArray = [[NSMutableArray alloc]init];
    _courseNameArray = [@[@"第一课",@"第二课",@"第三课",@"第四课",@"第五课",@"第六课",@"第七课",@"第八课",@"第九课",@"第十课"] copy];
    _courseCompleteness = [@[@"60",@"76",@"790",@"80",@"77",@"65",@"20",@"80",@"100",@"90",@"65"] copy];
    

}


- (void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}



-(void)dealloc{
    [_courseNameArray release];
    [_courseCompleteness release];
    [_tableView release];
    [_dataArray release];
    [super dealloc];
}



#pragma mark------tableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *studyscheduleCellid = @"studyscheduleCellid";
    StudyscheduleCell *studyscheduleCell = [tableView dequeueReusableCellWithIdentifier:studyscheduleCellid];
    if (!studyscheduleCell){
        studyscheduleCell = [[[NSBundle mainBundle]loadNibNamed:@"StudyscheduleCell" owner:self options:nil] firstObject];
    }
    studyscheduleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [studyscheduleCell loadcellWithTitle:_courseNameArray[indexPath.row] andScore:[_courseCompleteness[indexPath.row] integerValue]];
    [studyscheduleCell setCB:^{
        
    }];
    return studyscheduleCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


@end
