//
//  OMFMonentListVC.h
//  dev01
//
//  Created by 杨彬 on 15/4/8.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class OMFMomentListVC;
@class Buddy;
@class MomentLocationCellModel;
@class MomentBottomModel;
@class Moment;
@class WTFile;


@protocol OMFMomentListVCDelegate <NSObject>

@optional

- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC readNewReview:(NSArray *)review_array;

- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC didClickHeadImageViewWithBuddy:(Buddy *)owner_buddy;

- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC didClickLocationModel:(MomentLocationCellModel *)locationModel;

- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC clickReviewBuddy:(MomentBottomModel *)bottomMdel withIndexPath:(NSIndexPath *)indexPath withBuddy_id:(NSString *)buddy_id;

- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC clickMoment:(Moment *)moment;


- (void)OMFMomentListVC:(OMFMomentListVC *)momentListVC playVideo:(WTFile *)video_file withIndexPath:(NSIndexPath *)indexPath ;


@end

@interface OMFMomentListVC : OMViewController


@property (assign, nonatomic) id <OMFMomentListVCDelegate>delegate;

- (void)didAddNewMoment;

@end
