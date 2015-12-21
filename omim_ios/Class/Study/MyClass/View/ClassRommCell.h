//
//  ClassRommCell.h
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassRoom;


@interface ClassRommCell : UITableViewCell


@property (retain, nonatomic)ClassRoom *classRoom;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
