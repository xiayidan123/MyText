//
//  GroupAdminCell.h
//  dev01
//
//  Created by 杨彬 on 15/2/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupMember.h"

@protocol GroupAdminCellDelegate <NSObject>

- (void)setManageWithBuddyID:(GroupMember *)member;

- (void)removeManageWithBuddyID:(GroupMember *)member;


@end


@interface GroupAdminCell : UITableViewCell

@property (nonatomic,retain)GroupMember *buddy;

@property (nonatomic,assign)id <GroupAdminCellDelegate>delegate;

@end
