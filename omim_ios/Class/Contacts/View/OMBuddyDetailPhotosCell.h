//
//  OMBuddyDetailPhotosCell.h
//  dev01
//
//  Created by Starmoon on 15/8/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBuddyDetailItem;

@interface OMBuddyDetailPhotosCell : UITableViewCell

@property (retain, nonatomic) OMBuddyDetailItem * item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
