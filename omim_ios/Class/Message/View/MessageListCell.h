//
//  MessageListCell.h
//  dev01
//
//  Created by Huan on 15/4/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatMessage;


@protocol MessageListCellDelegate <NSObject>

- (void)messageTableViewReloadData;

@end



@interface MessageListCell : UITableViewCell

@property (assign, nonatomic) id<MessageListCellDelegate> delegate;
@property (retain, nonatomic) ChatMessage *msg;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
