//
//  OMSwitchCell.h
//  dev01
//
//  Created by Starmoon on 15/7/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SetCellFrameModel;
@class OMSwitchCell;


@protocol OMSwitchCellDelegate <NSObject>

@optional
- (void)switchCell:(OMSwitchCell *)switchCell didChangeState:(BOOL)on;



@end

@interface OMSwitchCell : UITableViewCell

@property (assign, nonatomic) id <OMSwitchCellDelegate>delegate;

@property (retain, nonatomic) SetCellFrameModel * frame_model;;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
