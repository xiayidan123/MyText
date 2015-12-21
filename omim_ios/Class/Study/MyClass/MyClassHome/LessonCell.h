//
//  LessonCell.h
//  dev01
//
//  Created by 杨彬 on 15/3/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Lesson;

@interface LessonCell : UITableViewCell

@property (retain, nonatomic)Lesson *lesson;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
