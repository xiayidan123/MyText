//
//  ClasstimetableCell.h
//  dev01
//
//  Created by 杨彬 on 14-10-11.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Lesson;

typedef NS_ENUM(NSInteger, UITableViewCellDateStatus) {
    UITableViewCellDateStatusHasBeen,
    UITableViewCellDateStatusToday,
    UITableViewCellDateStatusDonotStart
};


@interface ClasstimetableCell : UITableViewCell


@property (retain, nonatomic) Lesson *lesson;


@property (assign, nonatomic) UITableViewCellDateStatus status;



+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
