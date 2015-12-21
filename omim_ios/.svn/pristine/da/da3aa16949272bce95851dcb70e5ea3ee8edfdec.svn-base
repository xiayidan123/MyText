//
//  MomentReviewLikeCell.h
//  dev01
//
//  Created by 杨彬 on 15/4/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MomentReviewLikeModel;
@class MomentReviewLikeCell;


@protocol MomentReviewLikeCellDelegate <NSObject>

- (void)MomentReviewLikeCell:(MomentReviewLikeCell *)reviewLikeCell didClickBuddy:(NSString *)buddy_id;

@end


@interface MomentReviewLikeCell : UITableViewCell

@property (assign, nonatomic) id <MomentReviewLikeCellDelegate>delegate;

@property (retain, nonatomic)MomentReviewLikeModel *likeModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
