//
//  MomentNotificationCell.h
//  dev01
//
//  Created by 杨彬 on 15/5/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentNotificationCell : UITableViewCell

@property (retain, nonatomic) NSArray * review_array;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
