//
//  CommentView.m
//  dev01
//
//  Created by 杨彬 on 14-10-15.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "CommentView.h"
#import "TeachVideoListView.h"

@implementation CommentView
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_videoArray;
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
    _videoArray = [[NSMutableArray alloc]init];
    [self loadData];
}

- (void)loadData{
    [_dataArray addObject:@"堂上发言积极主动，思维活跃，能积极参与今天的课题讨论，如果声音能够再大一些，让每个同学都能听到你的观点，那就更加美妙了。"];
    [_videoArray addObject:@""];
    [_videoArray addObject:@""];
    [_videoArray addObject:@""];
    [_videoArray addObject:@""];
    [_videoArray addObject:@""];
    [_videoArray addObject:@""];
    [_videoArray addObject:@""];
    [_videoArray addObject:@""];
    [_videoArray addObject:@""];
}


- (void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:self.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}


#pragma mark-------tableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    if (indexPath.section == 0){
        TeachVideoListView *teachVideoListView = [[TeachVideoListView alloc]initWithFrame:cell.bounds andVideoArray:_videoArray];
        [cell.contentView addSubview:teachVideoListView];
        [teachVideoListView release];
    }else if (indexPath.section == 1){
        CGRect rect = [_dataArray[indexPath.row] boundingRectWithSize:CGSizeMake(290, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, rect.size.width, rect.size.height)];
        label.text = _dataArray[indexPath.row];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        [label release];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (_videoArray.count % 4 == 0){
            return (40 + (_videoArray.count / 4) * 70);
        }
        return (40 + (_videoArray.count / 4 + 1) * 70) ;
    }else if (indexPath.section == 1){
        CGRect rect = [_dataArray[indexPath.row] boundingRectWithSize:CGSizeMake(290, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
        return rect.size.height + 30;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : _dataArray.count ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 0 ? NSLocalizedString(@"已掌握:",nil) : NSLocalizedString(@"老师点评:",nil);
}




@end
