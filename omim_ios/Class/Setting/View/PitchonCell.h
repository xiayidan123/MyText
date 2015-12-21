//
//  PitchonCell.h
//  dev01
//
//  Created by 杨彬 on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PitchonCellModel;

@interface PitchonCell : UITableViewCell


@property (retain, nonatomic)PitchonCellModel *pitchonCellModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
