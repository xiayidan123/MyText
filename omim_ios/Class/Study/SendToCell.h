//
//  SendToCell.h
//  dev01
//
//  Created by Huan on 15/3/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Buddy;
@class UserGroup;
@protocol SendToCellDelegate <NSObject>

- (void)getBuddyFromCell:(Buddy *)buddy;
- (void)getGroupFromCell:(UserGroup *)userGroup;
@end

@interface SendToCell : UICollectionViewCell
@property (assign, nonatomic) id<SendToCellDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *dataArray;
@property (retain, nonatomic) NSMutableArray *groupArray;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
