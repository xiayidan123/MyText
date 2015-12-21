//
//  EditClassInfomationCell.h
//  dev01
//
//  Created by 杨彬 on 15/2/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditClassInformationModel;
@class EditClassInfomationCell;

@protocol EditClassInfomationCellDelegate <NSObject>
@optional
- (void)editClassInfomationCell:(EditClassInfomationCell *)cell didChangeModel:(EditClassInformationModel *)model;

- (void)editClassInfomationCell:(EditClassInfomationCell *)cell didChangeStatus:(EditClassInformationModel *)model;

- (void)editClassInfomationCell:(EditClassInfomationCell *)cell endEdit:(EditClassInformationModel *)model;

@end




@interface EditClassInfomationCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,retain)EditClassInformationModel *editClassInfoModel;

@property (nonatomic,assign)id <EditClassInfomationCellDelegate>delegate;

@end
