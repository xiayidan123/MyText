//
//  GradeCell.m
//  MG
//
//  Created by macbook air on 14-9-23.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import "GradeCell.h"
#import "HeaderView.h"
#import "PersonModel.h"


@implementation GradeCell
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
//    NSMutableArray *_stateArray;
    BOOL _isunfold;
    ClassModel *_model;
}

- (void)loadCell:(ClassModel *)model andisunfold:(BOOL)unfold{
    _model = model;
    _isunfold = unfold;
    
    [self prepareData];
    
    [self uiConfig];
    
}

- (void)prepareData{
//    _dataArray = [[NSMutableArray alloc]init];
    _dataArray = _model.personArray ;
//    _stateArray = [[NSMutableArray alloc]init];
    
//    for (int i=0; i< _model.personArray.count; i++){
//        [_stateArray addObject:@"0"];
//    }
}

- (void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44 *( _model.personArray.count + 1)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    [self.contentView addSubview:_tableView];
}

#pragma #mark------------tableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid] autorelease];
    }
    cell.indentationLevel = 2;
    cell.indentationWidth = 20;
    cell.textLabel.text = [_model.personArray[indexPath.row] personName];
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _isunfold ? _dataArray.count : 0 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _model.className;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderView *headerView = [[[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)] autorelease];
    headerView.section = section;
    headerView.userInteractionEnabled = YES;
    headerView.tag = section;
    if (_isunfold){
        headerView.arrowsView.image = [UIImage imageNamed:@"contacts_icon_unfold"];
    }else{
        headerView.arrowsView.image = [UIImage imageNamed:@"contacts_icon_fold"];
        
    }
    NSString *str = _model.className;
    //    headerView.titleLabel.text =  ((tableView == _tableView)? [_dataArray[section][0] substringToIndex:2]:@"搜索结果");
    headerView.titleLabel.frame = CGRectMake(headerView.titleLabel.frame.origin.x + 20, headerView.titleLabel.frame.origin.y, headerView.frame.size.width, headerView.frame.size.height);
    headerView.titleLabel.text =  ((tableView == _tableView)? str :@"搜索结果");
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    return headerView;
}


// headerView点击事件
-(void)tapAction:(UITapGestureRecognizer *)tap{
    _isunfold = !_isunfold;
    _CB(_isunfold);
    [_tableView reloadData];
    
}

-(void)dealloc{
    [_tableView release];
    [_dataArray release];
//    [_stateArray release];
    [_model release];
    [_CB release];
    [super dealloc];
}



@end
