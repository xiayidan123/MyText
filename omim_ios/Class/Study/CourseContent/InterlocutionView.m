//
//  InterlocutionView.m
//  dev01
//
//  Created by 杨彬 on 14-10-16.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "InterlocutionView.h"
#import "AskView.h"

@implementation InterlocutionView
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    CGFloat _h;
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
    [self loadData];
}

- (void)loadData{
    
}

- (void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:self.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}






#pragma mark--------tableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    AskView *askView = [[[NSBundle mainBundle]loadNibNamed:@"AskView" owner:self options:nil] firstObject];
    [askView loadViewWithFrame:cell.bounds andData:nil];
    [cell addSubview:askView];
//    cell.bounds = askView.bounds;
    [askView release];
    _h = askView.bounds.size.height;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _h;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"问题1:";
}




@end
