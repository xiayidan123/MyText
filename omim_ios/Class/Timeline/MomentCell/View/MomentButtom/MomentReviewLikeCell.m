//
//  MomentReviewLikeCell.m
//  dev01
//
//  Created by 杨彬 on 15/4/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentReviewLikeCell.h"

#import "MomentReviewLikeModel.h"

#import "YBAttrbutedLabel.h"

#import "MomentReviewCellModel.h"

@interface MomentReviewLikeCell ()<YBAttrbutedLabelDelegate>

@property (retain, nonatomic) IBOutlet YBAttrbutedLabel *like_name_label;

@end



@implementation MomentReviewLikeCell

- (void)dealloc {
    self.likeModel = nil;
    [_like_name_label release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *MomentReviewLikeCellID = @"MomentReviewLikeCellID";
    MomentReviewLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:MomentReviewLikeCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MomentReviewLikeCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(void)setLikeModel:(MomentReviewLikeModel *)likeModel{
    [_likeModel release],_likeModel = nil;
    _likeModel = [likeModel retain];
    if(_likeModel == nil || _likeModel.like_review_string.length == 0)return;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_likeModel.like_review_string];
    self.like_name_label.attributedText = string;
    self.like_name_label.link_array = _likeModel.name_array;
    self.like_name_label.font = [UIFont systemFontOfSize:12];
    [string release];
}

- (void)awakeFromNib {
    self.clipsToBounds = YES;
    self.like_name_label.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - YBAttrbutedLabelDelegate

- (void)YBAttrbutedLabel:(YBAttrbutedLabel *)label click:(YBAttrbutedModel *)model{
    if ([self.delegate respondsToSelector:@selector(MomentReviewLikeCell:didClickBuddy:)]){
        [self.delegate MomentReviewLikeCell:self didClickBuddy:model.data];
    }
}



@end
