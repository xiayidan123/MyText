//
//  MomentVoteView.m
//  dev01
//
//  Created by 杨彬 on 15/4/11.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentVoteView.h"

#import "Option.h"

//#import "MomentVoteCell.h"

#import "MomentVoteRadioCell.h"
#import "MomentVotedCell.h"
#import "MomentVoteMultipleCell.h"

#import "MomentVoteCellModel.h"

#import "MomentCellDenfine.h"

#import "WowTalkWebServerIF.h"
#import "WTHeader.h"


@interface MomentVoteView ()<UITableViewDataSource,UITableViewDelegate>


@property (retain, nonatomic)UITableView *vote_tableView;


@property (retain, nonatomic) UILabel * deadline_label;



@end

@implementation MomentVoteView


-(void)dealloc{
    self.vote_tableView = nil;
    
    self.vote_option_array = nil;
    self.moment_id = nil;
    
    [super dealloc];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    // tableview 开始的y
    CGFloat tab_y = 0;
    
    if (self.deadline > 0){
        tab_y = 15;
    }
    
    self.deadline_label.x = self.deadline_label.y = 0;
    self.deadline_label.width = self.width;
    self.deadline_label.height = tab_y;
    
    self.vote_tableView.x = 0;
    self.vote_tableView.y = tab_y;
    self.vote_tableView.width = self.width;
    self.vote_tableView.height = self.height - tab_y;
}



#pragma mark - Set and Get

-(void)setVote_option_array:(NSMutableArray *)vote_option_array{
    [_vote_option_array release],_vote_option_array = nil;
    _vote_option_array = [vote_option_array retain];
    if(_vote_option_array == nil){
        return;
    }
    
    if (self.is_voted){
        self.vote_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
    }else{
        UIView *vote_button_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, VoteButtonHeight)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(32, 7, 120, 35 );
        [button setTitle:@"投票" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.28 green:0.54 blue:0.65 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = [UIColor colorWithRed:0.65 green:0.91 blue:0.99 alpha:1];
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(voteAction) forControlEvents:UIControlEventTouchUpInside];
        
        [vote_button_view addSubview:button];
        
        self.vote_tableView.tableFooterView = vote_button_view;
        [vote_button_view release];
    }
    
    [self.vote_tableView reloadData];
}

-(void)setDeadline:(NSTimeInterval)deadline{
    _deadline = deadline;

    NSString *deadLine_string = @"截止日期:";
    
    if (self.isMultiple){
        deadLine_string = [NSString stringWithFormat:@"可以多选,%@",deadLine_string];
    }
    
    NSString *date_string = [NSDate formatTimeWithTimeInterval:_deadline];
    
    deadLine_string = [NSString stringWithFormat:@"%@%@",deadLine_string , date_string];
    
    self.deadline_label.text = deadLine_string;
}


-(UITableView *)vote_tableView{
    if (_vote_tableView == nil){
        _vote_tableView = [[UITableView alloc]init];
        _vote_tableView.dataSource = self;
        _vote_tableView.delegate = self;
        _vote_tableView.bounces = NO;
        _vote_tableView.scrollEnabled = NO;
        _vote_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
        _vote_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_vote_tableView];
    }
    return _vote_tableView;
}


-(UILabel *)deadline_label{
    if (_deadline_label == nil){
        _deadline_label = [[UILabel alloc]init];
        _deadline_label.font = [UIFont systemFontOfSize:12];
        _deadline_label.textColor = [UIColor colorWithRed:0.15 green:0.72 blue:0.94 alpha:1];
        [self addSubview:_deadline_label];
    }
    return _deadline_label;
}


- (void)voteAction{
    NSLog(@"%@",self.moment_id);
    [WowTalkWebServerIF voteSurveryMoment:self.moment_id withOptions:self.vote_option_array withCallback:@selector(didVotedTheMoment:) withObserver:self];
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.is_voted){
        MomentVotedCell *cell = [MomentVotedCell cellWithTableView:tableView];
        cell.voted_count = self.voted_count;
        cell.momentVoteCellModel = self.vote_option_array[indexPath.row];
        return cell;
    }else{
        if (self.isMultiple){
            MomentVoteMultipleCell *cell = [MomentVoteMultipleCell cellWithTableView:tableView];
            cell.momentVoteCellModel = self.vote_option_array[indexPath.row];
            return cell;
        }else{
            MomentVoteRadioCell *cell = [MomentVoteRadioCell cellWithTableView:tableView];
            cell.momentVoteCellModel = self.vote_option_array[indexPath.row];
            return cell;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.vote_option_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentVoteCellModel *momentVoteCellModel = self.vote_option_array[indexPath.row];
    if (self.is_voted){
        return momentVoteCellModel.cellHeight + 10;
    }
    return momentVoteCellModel.cellHeight;
}



#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - NetWork CallBack

-(void)didVotedTheMoment:(NSNotification*)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        Moment *moment = [[notif userInfo] valueForKey:@"moment"];
        NSLog(@"%@",self.moment_id);
        if ([moment.moment_id isEqualToString:self.moment_id]){
            if ([self.delegate respondsToSelector:@selector(MomentVoteView:didVotedWithMoment_id:option_array:)]){
                [self.delegate MomentVoteView:self didVotedWithMoment_id:self.moment_id option_array:self.vote_option_array];
            }
        }
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds =YES;
    }
    return self;
}



@end
