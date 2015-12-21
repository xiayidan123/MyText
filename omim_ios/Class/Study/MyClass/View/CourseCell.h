//
//  CourseCell.h
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMBaseCellFrameModel;

@interface CourseCell : UITableViewCell


@property (retain, nonatomic)OMBaseCellFrameModel *cellFrameModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
