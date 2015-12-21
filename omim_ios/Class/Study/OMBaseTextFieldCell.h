//
//  OMBaseTextFieldCell.h
//  dev01
//
//  Created by 杨彬 on 15/2/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMBaseTextFieldCell;
@class OMBaseCellFrameModel;

@protocol OMBaseTextFieldCellDelegate <NSObject>

@optional
- (void)baseTextFieldCell:(OMBaseTextFieldCell *)textFielldCell ShouldBeginEditingWithModel:(OMBaseCellFrameModel *)cellFrameModel;


- (void)baseTextFieldCell:(OMBaseTextFieldCell *)textFielldCell endEditing:(OMBaseCellFrameModel *)cellFrameModel;


@end



@interface OMBaseTextFieldCell : UITableViewCell

@property (nonatomic,assign)id <OMBaseTextFieldCellDelegate> delegate;

@property (nonatomic,retain)OMBaseCellFrameModel *cellFromeModel;

@property (assign, nonatomic)BOOL needAdjustPosition;

/**
 *  构造方法，将cell的返回方法封装起来
 *
 *  @param tableView
 *
 *  @return 返回cell
 */
+ (OMBaseTextFieldCell *)cellWithTableView:(UITableView *)tableView;

@end
