//
//  SixstarCell.m
//  dev01
//
//  Created by 杨彬 on 14-10-8.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "SixstarCell.h"
#import "AbilityBgView.h"

@implementation SixstarCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)loadCell:(NSArray *)array{
    //    AbilityView *abilityView = [[AbilityView alloc]initWithFrame:CGRectMake(0, 0, 130, 150) andBackgroundImage:[UIImage imageNamed:@"growup_polygon_color"] andScoreArray:array];
    
    AbilityBgView *abilityBgView = [[AbilityBgView alloc]initWithFrame:CGRectMake(0, 0, 130, 150) andBackgroundimage:[UIImage imageNamed:@"growup_bg_polygon"] andAbilityImage:[UIImage imageNamed:@"growup_polygon_color"] andAbilityArray:array];
    abilityBgView.center = self.contentView.center;
    [self.contentView addSubview:abilityBgView];
    [abilityBgView release];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
