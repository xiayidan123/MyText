//
//  MomentBaseCell.m
//  dev01
//
//  Created by 杨彬 on 15/4/8.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentBaseCell.h"

#import "NSDate+FromCurrentTime.h"


#import "OMHeadImgeView.h"


#import "MomentBaseCell_HeadView.h"
#import "MomentBaseCell_MiddleView.h"
#import "MomentButtomView.h"
#import "MomentCellDenfine.h"




@interface MomentBaseCell ()<MomentBaseCell_HeadViewDelegate,MomentBaseCell_MiddleViewDelegate,MomentButtomViewDelegate>

@property (retain, nonatomic) UIView *baseCell_bgview;

@property (retain, nonatomic) MomentBaseCell_HeadView *cell_headView;


@property (retain, nonatomic) MomentBaseCell_MiddleView *cell_middleView;


@property (retain, nonatomic) MomentButtomView *cell_bottomView;



@end


@implementation MomentBaseCell

- (void)dealloc {
    
    self.cellMoment = nil;
    
    self.indexPath = nil;
    
    self.baseCell_bgview = nil;
    
    /**
     *  头部
     */
    self.cell_headView = nil;
    
    /**
     *  中部
     */
    self.cell_middleView = nil;
    
    /**
     *  底部
     */
    self.cell_bottomView = nil;
    
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self uiConfig];
    
    return self;
}


- (void)uiConfig{
    
    self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
    
//    UIView *line_top = [[UIView alloc]init];
//    [self.baseCell_bgview addSubview:line_top];
//    line_top.backgroundColor = [UIColor lightGrayColor];
    
    
//    UIView *line_bottom = [[UIView alloc]init];
//    line_bottom.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.baseCell_bgview addSubview:line_bottom];
//    line_bottom.backgroundColor = [UIColor lightGrayColor];
    
}

-(UIView *)baseCell_bgview{
    if (_baseCell_bgview == nil){
        UIView *baseCell_bgview = [[UIView alloc]init];
        [self.contentView addSubview:baseCell_bgview];
        baseCell_bgview.backgroundColor = [UIColor whiteColor];
        self.baseCell_bgview = baseCell_bgview;
        [baseCell_bgview release];
    }
    return _baseCell_bgview;
}


-(MomentBaseCell_HeadView *)cell_headView{
    if (_cell_headView == nil){
        MomentBaseCell_HeadView *cell_headView = [[MomentBaseCell_HeadView alloc]init];
        [self.baseCell_bgview addSubview:cell_headView];
        cell_headView.delegate = self;
        self.cell_headView = cell_headView;
        [cell_headView release];
    }
    return _cell_headView;
}

-(MomentBaseCell_MiddleView *)cell_middleView{
    if (_cell_middleView == nil){
        MomentBaseCell_MiddleView *cell_middleView = [[MomentBaseCell_MiddleView alloc]init];
        cell_middleView.delegate = self;
        [self.baseCell_bgview addSubview:cell_middleView];
        self.cell_middleView = cell_middleView;
        [cell_middleView release];
    }
    return _cell_middleView;
}

-(MomentButtomView *)cell_bottomView{
    if (_cell_bottomView == nil){
        MomentButtomView *cell_bottomView = [[MomentButtomView alloc]init];
        cell_bottomView.delegate = self;
        [self.baseCell_bgview addSubview:cell_bottomView];
        self.cell_bottomView = cell_bottomView;
        [cell_bottomView release];
    }
    return _cell_bottomView;
}




#pragma mark - Set Model

-(void)setCellMoment:(MomentCellModel *)cellMoment{
    [_cellMoment release],_cellMoment = nil;
    _cellMoment = [cellMoment retain];
    if(_cellMoment == nil)return;
    
    self.cell_headView.headModel = _cellMoment.headModel;
    self.cell_headView.frame = _cellMoment.headViewF;
    
    self.cell_middleView.middleModel = _cellMoment.middleModel;
    self.cell_middleView.frame = _cellMoment.middleViewF;
    
    self.cell_bottomView.bottom_model = _cellMoment.bottomModel;
    self.cell_bottomView.frame = _cellMoment.bottomViewF;
    
    self.baseCell_bgview.frame = _cellMoment.bgViewF;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *MomentBaseCellID = @"MomentBaseCellID";
    MomentBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:MomentBaseCellID];
    if (!cell){
        cell = [[[MomentBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MomentBaseCellID] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}





#pragma mark - MomentBaseCell_HeadViewDelegate

- (void)MomentBaseCell_HeadViewDelegate:(MomentBaseCell_HeadView *)momentBaseCell_HeadView didClickHeadImageView:(Buddy *)buddy{
    if ([self.delegate respondsToSelector:@selector(MomentBaseCell:didClickHeadImageViewWithBuddy:)]){
        [self.delegate MomentBaseCell:self didClickHeadImageViewWithBuddy:buddy];
    }
}


#pragma mark - MomentBaseCell_MiddleViewDelegate

- (void)MomentBaseCell_MiddleView:(MomentBaseCell_MiddleView *)middleView locationModel:(MomentLocationCellModel *)locationModel{
    if ([self.delegate respondsToSelector:@selector(MomentBaseCell:didClickLocationModel:)]){
        [self.delegate MomentBaseCell:self didClickLocationModel:locationModel];
    }
}


- (void)MomentBaseCell_MiddleView:(MomentBaseCell_MiddleView *)middleView didVotedWithMoment_id:(NSString *)moment_id option_array:(NSArray *)option_array{
    if ([self.delegate respondsToSelector:@selector(MomentBaseCell:didVotedOption_array: withIndexPath:)]){
        [self.delegate MomentBaseCell:self didVotedOption_array:option_array withIndexPath:self.indexPath];
    }
}


- (void)MomentBaseCell_MiddleView:(MomentBaseCell_MiddleView *)middleView playVideoWithMoment_id:(NSString *)moment_id videoFile:(WTFile *)video_file{
    if ([self.delegate respondsToSelector:@selector(MomentBaseCell:playVideo:withIndexPath:)]){
        [self.delegate MomentBaseCell:self playVideo:video_file withIndexPath:self.indexPath];
    }
}

#pragma mark - MomentButtomViewDelegate

- (void)MomentButtomView:(MomentButtomView *)bottomView clickLikeButtom:(MomentBottomModel *)bottom_model{
    if ([self.delegate respondsToSelector:@selector(MomentBaseCell:clickLikeButton:withIndexPath:)]){
        [self.delegate MomentBaseCell:self clickLikeButton:bottom_model withIndexPath:self.indexPath];
    }
}


- (void)MomentButtomView:(MomentButtomView *)bottomView clickCommentButtom:(MomentBottomModel *)bottom_model withDistance:(CGFloat)distance{
    if ([self.delegate respondsToSelector:@selector(MomentBaseCell:clickCommentButton:withIndexPath:withDistance:)]){
        [self.delegate MomentBaseCell:self clickCommentButton:bottom_model withIndexPath:self.indexPath withDistance:distance];
    }
}


- (void)MomentButtomView:(MomentButtomView *)bottomView clickReviewBuddy:(MomentBottomModel *)bottom_model withBuddy_id:(NSString *)buddy_id{
    if ([self.delegate respondsToSelector:@selector(MomentBaseCell:clickReviewBuddy:withIndexPath:withBuddy_id:)]){
        [self.delegate MomentBaseCell:self clickReviewBuddy:bottom_model withIndexPath:self.indexPath withBuddy_id:buddy_id];
    }
}

- (void)MomentButtomView:(MomentButtomView *)bottomView didEndEdit:(MomentBottomModel *)bottom_model{
    if([self.delegate respondsToSelector:@selector(MomentBaseCell:didEndEdit:withIndexPath:)]){
        [self.delegate MomentBaseCell:self didEndEdit:bottom_model withIndexPath:self.indexPath];
    }
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
