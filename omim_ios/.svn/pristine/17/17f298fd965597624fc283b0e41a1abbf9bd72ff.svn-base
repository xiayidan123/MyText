//
//  PointsofknowledgeVIew.m
//  dev01
//
//  Created by 杨彬 on 14-10-14.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "PointsofknowledgeVIew.h"

@implementation PointsofknowledgeVIew
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
-(void)dealloc{
    [_tableView release];
    [_dataArray release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareData];
        
        [self uiConfig];
    }
    return self;
}

- (void)prepareData{
    _dataArray = [[NSMutableArray alloc]init];
    
    NSArray *arr1 = @[@"taller 更高的",@"shorter 更矮的",@"younger 年幼的",@"stronger 更强壮的",@"How tall are you? 你有多高？",@"You're shorter than me. 你比我矮"];
    NSArray *arr2 = @[@"think 想",@"little 一点",@"I like yellow one. 我喜欢黄色这个"];
    [_dataArray addObject:arr1];
    [_dataArray addObject:arr2];
    
}

- (void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
}









#pragma mark--------tableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid] ;
    }
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 0 ? NSLocalizedString(@"已掌握:",nil) : NSLocalizedString(@"未掌握:",nil) ;
}




@end
