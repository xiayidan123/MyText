//
//  MomentReviewTextCell.m
//  dev01
//
//  Created by 杨彬 on 15/4/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentReviewTextCell.h"

#import "MomentReviewCellModel.h"


#import "YBAttrbutedLabel.h"
#import "MomentCellDenfine.h"


@interface MomentReviewTextCell ()<YBAttrbutedLabelDelegate>

@property (retain, nonatomic) IBOutlet YBAttrbutedLabel *review_text_label;



@end

@implementation MomentReviewTextCell
- (void)dealloc {
    [_review_text_label release];
    
    self.review_text_model = nil;
    [_image_view release];
    [super dealloc];
}



+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *MomentReviewTextCellID = @"MomentReviewTextCellID";
    MomentReviewTextCell *cell = [tableView dequeueReusableCellWithIdentifier:MomentReviewTextCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MomentReviewTextCell" owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setReview_text_model:(MomentReviewCellModel *)review_text_model{
    [_review_text_model release],_review_text_model = nil;
    _review_text_model = [review_text_model retain];
    if(_review_text_model == nil)return;
    
    Review *review = _review_text_model.review;
    
    
    NSMutableArray *link_array = [NSMutableArray array];
    
    NSString *text_string;
    if ([review.replyToReviewId isEqualToString:@"0"]){// 对moment 评论
        text_string = [NSString stringWithFormat:@"%@: %@",review.nickName,review.text];
        YBAttrbutedModel *model = [[YBAttrbutedModel alloc]init];
        model.text = review.nickName;
        model.data = review.owerID;
        model.range = [text_string rangeOfString:review.nickName];
        [link_array addObject:model];
        [model release];
    }else{// 对评论评论
        text_string = [NSString stringWithFormat:@"%@回复%@: %@",review.nickName,review.replyToNickname,review.text];
        
        YBAttrbutedModel *model1 = [[YBAttrbutedModel alloc]init];
        model1.text = review.nickName;
        model1.data = review.owerID;
        model1.range = [text_string rangeOfString:review.nickName];
        [link_array addObject:model1];
        [model1 release];
        
        
        YBAttrbutedModel *model2 = [[YBAttrbutedModel alloc]init];
        model2.text = review.replyToNickname;
        model2.data = review.replyToUid;
        model2.range = [text_string rangeOfString:review.replyToNickname];
        [link_array addObject:model2];
        [model2 release];
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text_string ];
    
    self.review_text_label.attributedText = attributedText;
    self.review_text_label.link_array = link_array;
    self.review_text_label.font = [UIFont systemFontOfSize:12];
    
    
}


- (void)awakeFromNib {
    self.clipsToBounds = YES;
    
    self.review_text_label.delegate = self;
//    self.review_text_label.preferredMaxLayoutWidth = review_textLabel_width;
//    self.review_text_label.lineBreakMode = NSLineBreakByCharWrapping;
//    self.backgroundColor = [UIColor colorWithRed:arc4random()%10 *0.1 green:arc4random()%10 *0.1 blue:arc4random()%10 *0.1 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - YBAttrbutedLabelDelegate


- (void)YBAttrbutedLabel:(YBAttrbutedLabel *)label click:(YBAttrbutedModel *)model{
    if ([self.delegate respondsToSelector:@selector(MomentReviewTextCell:didClickBuddy:)]){
        [self.delegate MomentReviewTextCell:self didClickBuddy:model.data];
    }
}


@end
