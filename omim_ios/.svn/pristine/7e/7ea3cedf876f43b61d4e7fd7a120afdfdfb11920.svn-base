//
//  MomentReviewTextCell.h
//  dev01
//
//  Created by 杨彬 on 15/4/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MomentReviewCellModel;
@class MomentReviewTextCell;

@protocol MomentReviewTextCellDelegate <NSObject>

- (void)MomentReviewTextCell:(MomentReviewTextCell *)reviewTextCell didClickBuddy:(NSString *)buddy_id;

@end



@interface MomentReviewTextCell : UITableViewCell

@property (assign, nonatomic) id <MomentReviewTextCellDelegate>delegate;

@property (retain, nonatomic) IBOutlet UIImageView *image_view;

@property (retain, nonatomic)MomentReviewCellModel *review_text_model;;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
