//
//  OMBaseDatePickerCell.h
//  dev01
//
//  Created by 杨彬 on 15/2/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMBaseCellFrameModel;
@class OMBaseDatePickerCell;

@protocol OMBaseDatePickerCellDelegate <NSObject>

//- (void)baseDatePickerCell:(OMBaseDatePickerCell *)baseDatePickerCell showWithModel:(OMBaseCellFrameModel *)cellFrameModel;

- (void)baseDatePickerCell:(OMBaseDatePickerCell *)baseDatePickerCell hiddenWithModel:(OMBaseCellFrameModel *)cellFrameModel;

- (void)baseDatePickerCell:(OMBaseDatePickerCell *)baseDatePickerCell changeDateWithModel:(OMBaseCellFrameModel *)cellFrameModel;


@end

@interface OMBaseDatePickerCell : UITableViewCell

@property (retain, nonatomic) UIColor *content_color;

@property (assign, nonatomic) id<OMBaseDatePickerCellDelegate>delegate;

@property (retain, nonatomic) UITableView *superTableView;

@property (retain,nonatomic)OMBaseCellFrameModel *cellFrameModel;

@property (assign, nonatomic)BOOL isSettingVCInit;

+ (OMBaseDatePickerCell *)cellWithTableView:(UITableView *)tableView;

@end
