//
//  OMContactRequestListCell.h
//  dev01
//
//  Created by Starmoon on 15/7/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PendingRequest;
@class OMContactRequestListCell;

@protocol OMContactRequestListCellDelegate <NSObject>

@optional
/** 已经处理了请求 （accept = YES 同意   NO 拒绝） */
- (void)contactRequestListCell:(OMContactRequestListCell *)requestlistCell didDealRequestWithAccept:(BOOL) accept withRequest:(PendingRequest *)request;

@end


@interface OMContactRequestListCell : UITableViewCell

@property (assign, nonatomic) id <OMContactRequestListCellDelegate>delegate;

@property (retain, nonatomic) PendingRequest * request;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
