//
//  MyClassCell.h
//  dev01
//
//  Created by 杨彬 on 15/3/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMClass;

@interface MyClassCell : UITableViewCell

@property (retain, nonatomic)OMClass *classModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
