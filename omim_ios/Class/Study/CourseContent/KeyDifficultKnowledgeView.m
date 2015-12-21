//
//  KeyDifficultKnowledgeView.m
//  dev01
//
//  Created by 杨彬 on 14-10-15.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "KeyDifficultKnowledgeView.h"

@implementation KeyDifficultKnowledgeView
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
        self.backgroundColor = [UIColor clearColor];
        [self uiConfig];
    }
    return self;
}

- (void)prepareData{
    _dataArray = [[NSMutableArray alloc]init];
    [self loadData];
}

- (void)loadData{
    [_dataArray addObject:@"think 想"];
    [_dataArray addObject:@"little 一点"];
    [_dataArray addObject:@"younger 年幼的"];
    [_dataArray addObject:@"I like the yellow one. 我喜欢黄色的这个"];
    [_dataArray addObject:@"How tall are you? 你多大了？"];
    [_dataArray addObject:@"You're shorter than me. 我10岁了"];
}

- (void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:self.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
}


- (void)adaptHeight{
    _tableView.frame = (_tableView.frame.size.height < (_dataArray.count *44 )) ? _tableView.frame : CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _dataArray.count*44 + 20) ;
}

#pragma mark------tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}




@end
