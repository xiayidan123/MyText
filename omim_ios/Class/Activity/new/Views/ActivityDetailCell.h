//
//  ActivityDetailCell.h
//  dev01
//
//  Created by 杨彬 on 14-11-3.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@protocol ActivityDetailCellDelegate <NSObject>

- (void)clickImageWithIndex:(NSInteger)index;

@end

@interface ActivityDetailCell : UITableViewCell
@property (nonatomic,assign)id <ActivityDetailCellDelegate>delegate;
@property (nonatomic,retain)ActivityModel *activityModel;

-(void)showCellWithIndexPath:(NSIndexPath *)indexPath;

@end
