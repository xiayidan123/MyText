//
//  MomentButtomView.m
//  dev01
//
//  Created by 杨彬 on 15/4/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentButtomView.h"

#import "MomentReviewLikeModel.h"
#import "MomentReviewCellModel.h"

#import "MomentReviewLikeCell.h"
#import "MomentReviewTextCell.h"
#import "MomentReviewActionView.h"

#import "MomentCellDenfine.h"

#import "MomentBottomModel.h"
#import "Moment.h"

#import "OMInputManager.h"
#import "WowTalkWebServerIF.h"
#import "WTHeader.h"


@interface MomentButtomView ()<UITableViewDataSource,UITableViewDelegate,MomentReviewActionViewDelegate,MomentReviewLikeCellDelegate,MomentReviewTextCellDelegate,OMInputManagerDelegate>

@property (retain, nonatomic)UITableView *review_tableView;


@property (retain, nonatomic)NSMutableArray *review_array;// 总共两个元素  1-likeModel(点赞模型) 2-text_array(文字回复模型)

@property (retain, nonatomic)MomentReviewLikeModel *likeModel;

@property (retain, nonatomic)NSArray *review_text_array;


@property (retain, nonatomic)MomentReviewActionView *reviewActionView;


@property (assign, nonatomic) CGFloat click_cell_height;

@property (assign, nonatomic) BOOL didClick_review_text_cell;

@property (retain, nonatomic) MomentReviewCellModel * apply_review_model;



@end


@implementation MomentButtomView

-(void)dealloc{
    self.review_array = nil;
    
    self.likeModel = nil;
    
    self.review_text_array = nil;
    
    self.review_tableView.delegate = nil;
    self.review_tableView.dataSource = nil;
    self.review_tableView = nil;
    
    self.reviewActionView = nil;
    
    self.bottom_model = nil;
    
    [super dealloc];
}

-(void)setReview_array:(NSMutableArray *)review_array{
    [_review_array release],_review_array = nil;
    _review_array = [review_array retain];
    if(_review_array == nil){
        self.likeModel = nil;
        self.review_text_array = nil;
        return;
    }
    
    self.likeModel = [review_array firstObject];
    
    self.review_text_array = [review_array lastObject];
    
    if (self.likeModel == nil && (self.review_text_array== nil || self.review_text_array.count == 0)){
        
    }
    [self.review_tableView reloadData];
}


-(void)setBottom_model:(MomentBottomModel *)bottom_model{
    [_bottom_model release],_bottom_model = nil;
    _bottom_model = [bottom_model retain];
    self.reviewActionView.bottom_model = _bottom_model;
    if(_bottom_model == nil){
        self.review_array = nil;
        return;
    }
    
    self.review_tableView.frame = _bottom_model.reviewViewF;
    
    self.reviewActionView.frame = _bottom_model.actionViewF;
    
    self.review_array = bottom_model.review_array;
    
    self.reviewActionView.bottom_model = _bottom_model;
}


-(UITableView *)review_tableView{
    if (_review_tableView == nil){
        UITableView *review_tableView = [[UITableView alloc]init];
        review_tableView.delegate = self;
        review_tableView.dataSource = self;
        review_tableView.scrollEnabled = NO;
        review_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        review_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
        [self addSubview:review_tableView];
        self.review_tableView = review_tableView;
        [review_tableView release];
    }
    return _review_tableView;
}


-(MomentReviewActionView *)reviewActionView{
    if (_reviewActionView == nil){
        MomentReviewActionView *reviewActionView = [MomentReviewActionView momentReviewActionView];
        reviewActionView.delegate = self;
        [self addSubview:reviewActionView];
        self.reviewActionView = reviewActionView;
    }
    return _reviewActionView;
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        MomentReviewLikeCell *cell = [MomentReviewLikeCell cellWithTableView:tableView];
        cell.likeModel = self.likeModel;
        cell.delegate = self;
        return cell;
    }else{
        MomentReviewTextCell *cell = [MomentReviewTextCell cellWithTableView:tableView];
        cell.delegate = self;
        MomentReviewCellModel *text_model = self.review_text_array[indexPath.row];
        
        cell.review_text_model = text_model;
        
        if (indexPath.row == 0){
            cell.image_view.hidden = NO;
        }else{
            cell.image_view.hidden = YES;
        }
        return cell;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else{
        return self.review_text_array.count;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return self.likeModel.like_review_height;
    }else{
        
        MomentReviewCellModel *model = self.review_text_array[indexPath.row];
        
        return model.cellHeight;
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)return;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    MomentReviewCellModel *model = self.review_text_array[indexPath.row];
    
    self.click_cell_height = model.cellHeight;
    self.apply_review_model = model;
    
    OMInputManager *inputManager = [OMInputManager sharedManager];
    inputManager.delegate = self;
    [inputManager setClick_view:cell];
    Review *review = model.review;
    inputManager.placeholder = [NSString stringWithFormat:@"回复%@:",review.nickName];
}

#pragma mark - OMInputManagerDelegate
- (void)beginShowKeyboardWithDistance:(CGFloat )distance{
    
    CGFloat click_cell_height = 0;
    
    if ( !self.didClick_review_text_cell ){
        click_cell_height = self.click_cell_height;
    }
    
    if ([self.delegate respondsToSelector:@selector(MomentButtomView:clickCommentButtom:withDistance:)]){
        self.didClick_review_text_cell = YES;
        [self.delegate MomentButtomView:self clickCommentButtom:self.bottom_model withDistance:distance + click_cell_height];
    }
}


- (void)didClickReturnWithText:(NSString *)text{
    
    [WowTalkWebServerIF replyToReview:self.apply_review_model.review.review_id inMoment:self.bottom_model.moment.moment_id withType:[NSString stringWithFormat:@"%d", REVIEW_TYPE_TEXT] content:text  withCallback:@selector(didAddComment:) withObserver:self];
}

- (void)didEndHideKeyBoard{
    if ([self.delegate respondsToSelector:@selector(MomentButtomView:didEndEdit:)]){
        self.click_cell_height = 0;
        self.didClick_review_text_cell = NO;
        [self.delegate MomentButtomView:self didEndEdit:self.bottom_model];
    }
}

#pragma mark - NetWork CallBack

-(void)didAddComment:(NSNotification*)notif
{
    
    
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if ([self.delegate respondsToSelector:@selector(MomentButtomView:clickLikeButtom:)]){
            [self.delegate MomentButtomView:self clickLikeButtom:self.bottom_model];
        }
    }
}


#pragma mark - MomentReviewActionViewDelegate
- (void)MomentReviewActionView:(MomentReviewActionView *)reviewwActionView didClickLikeButton:(MomentBottomModel *)bottom_model{
    if ([self.delegate respondsToSelector:@selector(MomentButtomView:clickLikeButtom:)]){
        [self.delegate MomentButtomView:self clickLikeButtom:self.bottom_model];
    }
}

- (void)MomentReviewActionView:(MomentReviewActionView *)reviewwActionView didClickCommentButton:(MomentBottomModel *)bottom_model withDistance:(CGFloat)distance{
    if ([self.delegate respondsToSelector:@selector(MomentButtomView:clickCommentButtom:withDistance:)]){
        [self.delegate MomentButtomView:self clickCommentButtom:self.bottom_model withDistance:distance];
    }
}

- (void)MomentReviewActionView:(MomentReviewActionView *)reviewwActionView didEndEdit:(MomentBottomModel *)bottom_model{
    if ([self.delegate respondsToSelector:@selector(MomentButtomView:didEndEdit:)]){
        [self.delegate MomentButtomView:self didEndEdit:self.bottom_model];
    }
}

#pragma mark - MomentReviewLikeCellDelegate
- (void)MomentReviewLikeCell:(MomentReviewLikeCell *)reviewLikeCell didClickBuddy:(NSString *)buddy_id{
    if ([self.delegate respondsToSelector:@selector(MomentButtomView:clickReviewBuddy:withBuddy_id:)]){
        [self.delegate MomentButtomView:self clickReviewBuddy:self.bottom_model withBuddy_id:buddy_id];
    }
}


#pragma mark - MomentReviewTextCellDelegate
- (void)MomentReviewTextCell:(MomentReviewTextCell *)reviewTextCell didClickBuddy:(NSString *)buddy_id{
    if ([self.delegate respondsToSelector:@selector(MomentButtomView:clickReviewBuddy:withBuddy_id:)]){
        [self.delegate MomentButtomView:self clickReviewBuddy:self.bottom_model withBuddy_id:buddy_id];
    }
}

@end
