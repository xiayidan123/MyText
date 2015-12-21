//
//  OMSearchBuddyResultCell.h
//  dev01
//
//  Created by Starmoon on 15/7/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Buddy;
@class OMSearchBuddyResultCell;

@protocol OMSearchBuddyResultCellDelegate <NSObject>
@optional
/** 点击添加按钮 */
-(void)searchBuddyResultCell:(OMSearchBuddyResultCell *)cell addBuddy:(Buddy *)buddy;

@end



@interface OMSearchBuddyResultCell : UITableViewCell

@property (retain, nonatomic) Buddy * buddy;

@property (assign, nonatomic) id <OMSearchBuddyResultCellDelegate> delegate;


+ (instancetype )cellWithTableview:(UITableView *)tableView;

@end
