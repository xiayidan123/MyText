//
//  MomentVoteMultipleCell.m
//  dev01
//
//  Created by 杨彬 on 15/5/12.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentVoteMultipleCell.h"

#import "MomentVoteCellModel.h"

@interface MomentVoteMultipleCell ()

@property (retain, nonatomic) IBOutlet UIImageView *seleced_imageView;

@property (retain, nonatomic) IBOutlet UILabel *text_label;

@property (assign, nonatomic) BOOL isSelected;


@end

@implementation MomentVoteMultipleCell


-(void)dealloc{
    self.momentVoteCellModel = nil;
    
    self.seleced_imageView = nil;
    self.text_label = nil;
    
    [super dealloc];
}


-(void)setMomentVoteCellModel:(MomentVoteCellModel *)momentVoteCellModel{
    [_momentVoteCellModel release],_momentVoteCellModel = nil;
    _momentVoteCellModel = [momentVoteCellModel retain];
    
    self.text_label.text = _momentVoteCellModel.option.desc;
    
    if (_momentVoteCellModel.option.is_voted){
        self.seleced_imageView.image = [UIImage imageNamed:@"share_vote_chb_1"];
    }else{
        self.seleced_imageView.image = [UIImage imageNamed:@"share_vote_chb"];
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *MomentVoteMultipleCellID = @"MomentVoteMultipleCellID";
    MomentVoteMultipleCell *cell = [tableView dequeueReusableCellWithIdentifier:MomentVoteMultipleCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MomentVoteMultipleCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected){
        self.isSelected = !self.isSelected;
        if (self.isSelected){
            self.momentVoteCellModel.option.is_voted = YES;
            self.seleced_imageView.image = [UIImage imageNamed:@"share_vote_chb_1"];
        }else{
            self.momentVoteCellModel.option.is_voted = NO;
            self.seleced_imageView.image = [UIImage imageNamed:@"share_vote_chb"];
        }
    }else{
        
    }
}

@end
