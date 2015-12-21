//
//  MomentVotedCell.h
//  dev01
//
//  Created by 杨彬 on 15/4/15.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MomentVoteCellModel;

@interface MomentVotedCell : UITableViewCell

@property (assign, nonatomic)NSInteger voted_count;

@property (retain, nonatomic)MomentVoteCellModel *momentVoteCellModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
