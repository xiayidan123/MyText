//
//  SetUserInforHeadCell.h
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SetCellFrameModel;

@interface SetUserInforHeadCell : UITableViewCell

@property (retain, nonatomic)SetCellFrameModel *frameModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
