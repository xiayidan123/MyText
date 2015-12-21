//
//  MomentBaseCell.h
//  dev01
//
//  Created by 杨彬 on 15/4/8.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MomentCellModel.h"


@class MomentBaseCell;
@class MomentLocationCellModel;
@class MomentBottomModel;


typedef NS_ENUM(NSInteger, MomentCellUseForType) {
    MomentCellUseForType_CircleOfFriends,
    MomentCellUseForType_CircleOfStudy
};

@protocol MomentBaseCellDelegate <NSObject>

/**
 *  点击头像或者名字
 *
 */
- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell didClickHeadImageViewWithBuddy:(Buddy *)owner_buddy;

/**
 *  点击位置信息
 *
 */
- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell didClickLocationModel:(MomentLocationCellModel *)locationModel;

/**
 *  点击投票
 */
- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell didVotedOption_array:(NSArray *)option_array withIndexPath:(NSIndexPath *)indexPath;


/**
 *  点击赞
 */
- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell clickLikeButton:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath;

/**
 *  点击回复按钮
 */
- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell clickCommentButton:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath withDistance:(CGFloat )distance;


/**
 *  点击视频播放
 */
- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell playVideo:(WTFile *)videl_file withIndexPath:(NSIndexPath *)indexPath;



/**
 *  点击回复
 */
- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell clickReviewBuddy:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath withBuddy_id:(NSString *)buddy_id;

/**
 *  键盘收回
 */
- (void)MomentBaseCell:(MomentBaseCell *)momentBaseCell didEndEdit:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath;

@end




@interface MomentBaseCell : UITableViewCell

@property (retain, nonatomic)MomentCellModel *cellMoment;

@property (assign, nonatomic)MomentCellUseForType useForType;

@property (retain, nonatomic)NSIndexPath *indexPath;

@property (assign, nonatomic)id <MomentBaseCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end
