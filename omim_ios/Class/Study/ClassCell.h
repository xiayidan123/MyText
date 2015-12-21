//
//  ClassCell.h
//  dev01
//
//  Created by 杨彬 on 14-10-8.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
@class OMClass;

@interface ClassCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *bgImgv;
@property (retain, nonatomic) IBOutlet UILabel *lbl_className;
@property (retain, nonatomic) OMClass *omClass;
@property (retain, nonatomic)ClassModel *classModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
