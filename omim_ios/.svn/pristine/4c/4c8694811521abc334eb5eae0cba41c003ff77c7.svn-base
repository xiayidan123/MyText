//
//  BuddyDetailCell.h
//  dev01
//
//  Created by 杨彬 on 15/3/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Buddy;
@class BuddyDetailCell;
@class ChatMessage;
@class UserGroup;
@protocol BuddyDetailCellDelegate <NSObject>

- (void)didDownLoadThumbnailImage:(BuddyDetailCell *)buddyDetailCell;
- (void)CallBackBuddys:(NSMutableArray *)buddys;
@end

@interface BuddyDetailCell : UITableViewCell

@property (retain, nonatomic)Buddy *buddy;

@property (retain, nonatomic)ChatMessage *chatMessage;

@property (assign, nonatomic)id *buddyOrGroup;

@property (retain, nonatomic)UserGroup *userGroup;

@property (assign, nonatomic)id<BuddyDetailCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
