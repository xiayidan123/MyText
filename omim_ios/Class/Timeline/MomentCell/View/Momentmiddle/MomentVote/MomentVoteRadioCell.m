//
//  MomentVoteRadioCell.m
//  dev01
//
//  Created by 杨彬 on 15/4/14.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentVoteRadioCell.h"

#import "MomentVoteCellModel.h"

#import "Option.h"

@interface MomentVoteRadioCell ()

@property (retain, nonatomic) IBOutlet UIImageView *seleced_imageView;


@property (retain, nonatomic) IBOutlet UILabel *text_label;

@end


@implementation MomentVoteRadioCell

- (void)dealloc {
    self.momentVoteCellModel = nil;
    [_seleced_imageView release];
    [_text_label release];
    [super dealloc];
}


-(void)setMomentVoteCellModel:(MomentVoteCellModel *)momentVoteCellModel{
    [_momentVoteCellModel release],_momentVoteCellModel = nil;
    _momentVoteCellModel = [momentVoteCellModel retain];
    
    self.text_label.text = _momentVoteCellModel.option.desc;

    if (_momentVoteCellModel.option.is_voted){
        self.seleced_imageView.image = [UIImage imageNamed:@"icon_checked"];
    }else{
        self.seleced_imageView.image = [UIImage imageNamed:@"icon_unchecked"];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *MomentVoteRadioCellID = @"MomentVoteRadioCellID";
    MomentVoteRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:MomentVoteRadioCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MomentVoteRadioCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.text_label.lineBreakMode = NSLineBreakByCharWrapping;
    
//    self.backgroundColor = [UIColor colorWithRed:arc4random()%10 *0.1 green:arc4random()%10 *0.1 blue:arc4random()%10 *0.1 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected){
        self.seleced_imageView.image = [UIImage imageNamed:@"icon_checked"];
    }else{
        self.seleced_imageView.image = [UIImage imageNamed:@"icon_unchecked"];
    }
    self.momentVoteCellModel.option.is_voted = selected;

    // Configure the view for the selected state
}


@end
