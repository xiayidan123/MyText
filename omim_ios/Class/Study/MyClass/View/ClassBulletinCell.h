//
//  ClassBulletinCell.h
//  dev01
//
//  Created by 杨彬 on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassBulletinCell;

@class Anonymous_Moment_Frame;

@protocol ClassBulletinCellDelegate <NSObject>

- (void)classBulletinCell:(ClassBulletinCell *)classBulletinCell withUser_id:(NSString *)user_id;

@end


@interface ClassBulletinCell : UITableViewCell

@property (assign, nonatomic) id<ClassBulletinCellDelegate>delegate;

@property (retain, nonatomic)Anonymous_Moment_Frame *frame_model;

@property (retain, nonatomic) IBOutlet UILabel *text_label;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
