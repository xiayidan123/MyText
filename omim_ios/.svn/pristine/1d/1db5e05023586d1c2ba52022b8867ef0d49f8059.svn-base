//
//  HomeworkReviewRankCell.m
//  dev01
//
//  Created by 杨彬 on 15/5/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "HomeworkReviewRankCell.h"

#import "TQStarRatingView.h"

@interface HomeworkReviewRankCell ()

@property (retain, nonatomic) IBOutlet UILabel *title_label;

@property (retain, nonatomic) TQStarRatingView *star_view;






@end

@implementation HomeworkReviewRankCell

-(void)dealloc{
    
    self.rank_model = nil;
    
    [_title_label release];
    [_star_view release];
    [super dealloc];
}



+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *HomeworkReviewRankCellID = @"HomeworkReviewRankCellID";
    HomeworkReviewRankCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeworkReviewRankCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkReviewRankCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(void)setRank_model:(HomeworkReviewRankModel *)rank_model{
    [_rank_model release],_rank_model = nil;
    _rank_model = [rank_model retain];
    if(_rank_model == nil)return;
    
    self.title_label.text = _rank_model.rank_title;
    
    self.star_view.numberOfStar_set = [_rank_model.rank_value intValue];
}


- (void)awakeFromNib {
    
    self.star_view = [[[TQStarRatingView alloc]initWithFrame:CGRectMake(50, 0, 160, Homework_Review_rankCell_height) numberOfStar:5] autorelease];
    self.star_view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.star_view];
    
    self.star_view.userInteractionEnabled = NO;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
