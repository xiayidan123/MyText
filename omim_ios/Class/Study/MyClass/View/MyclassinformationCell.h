//
//  MyclassinformationCell.h
//  dev01
//
//  Created by 杨彬 on 14-10-10.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMClass;

@interface MyclassinformationCell : UITableViewCell

@property (nonatomic,retain)OMClass *classModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;




@end
