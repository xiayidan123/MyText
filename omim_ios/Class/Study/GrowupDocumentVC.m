//
//  GrowupDocumentVC.m
//  dev01
//
//  Created by 杨彬 on 14-10-8.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "GrowupDocumentVC.h"
#import "PublicFunctions.h"
#import "SixstarCell.h"
#import "StudyscheduleCell.h"
#import "LearnplanVC.h"

@interface GrowupDocumentVC ()
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation GrowupDocumentVC


#pragma mark -------------View Handler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1];
    
    [self configNavigation];
    
    [self uiConfig];
}

- (void)configNavigation{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"成长档案",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
    [backBarItem release];
    
}

- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}



#pragma mark-------tableVie

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        static NSString *sixstarCellid = @"sixstatCellid";
        SixstarCell *cell = [tableView dequeueReusableCellWithIdentifier:sixstarCellid];
        if (!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SixstarCell" owner:self options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadCell:@[@80,@75,@82,@83,@68,@86]];
        return cell;
    }else{
        static NSString *studyscheduleCellid = @"studyscheduleCell";
        StudyscheduleCell *studyscheduleCell = [tableView dequeueReusableCellWithIdentifier:studyscheduleCellid];
        if (!studyscheduleCell){
            studyscheduleCell = [[[NSBundle mainBundle] loadNibNamed:@"StudyscheduleCell" owner:self options:nil] firstObject];
        }
        studyscheduleCell.contentView.userInteractionEnabled = YES;
        studyscheduleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        studyscheduleCell.backgroundColor = [UIColor whiteColor];
        [studyscheduleCell loadcellWithTitle:((indexPath.row == 0) ? @"秋季班小学六年级英语小升初尖子班": (indexPath.row == 1 ? @"秋季班小学六年级数学小升初尖子班": @"秋季班小学六年级语文小升初尖子班") ) andScore:87];
        [studyscheduleCell setCB:^{
            LearnplanVC *learnplanVC = [[LearnplanVC alloc]init];
            [self.navigationController pushViewController:learnplanVC animated:YES];
        }];
        return studyscheduleCell;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : 3;
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 0 ? nil : NSLocalizedString(@"知识点完成度:",nil) ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 10 : 40 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 260 : 100 ;
}











-(void)dealloc{
    [_tableView release];
    [_dataArray release];
    [super dealloc];
}





@end
