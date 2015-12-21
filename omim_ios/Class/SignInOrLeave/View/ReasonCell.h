//
//  ReasonCell.h
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReasonCell;

@protocol ReasonCellDelegate <NSObject>

@optional

- (void)getNotiContent:(UITextView *)textView;

- (void)ReasonCell:(ReasonCell *)reasonCell textViewCoverdByKeyboardWithDistance:(CGFloat)distance;

@end

@interface ReasonCell : UITableViewCell

@property (assign, nonatomic) id<ReasonCellDelegate>delegate;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
