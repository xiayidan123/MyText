//
//  MomentButtomView.h
//  dev01
//
//  Created by 杨彬 on 15/4/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MomentBottomModel;
@class MomentButtomView;

@protocol MomentButtomViewDelegate <NSObject>

- (void)MomentButtomView:(MomentButtomView *)bottomView clickLikeButtom:(MomentBottomModel *)bottom_model;

- (void)MomentButtomView:(MomentButtomView *)bottomView clickCommentButtom:(MomentBottomModel *)bottom_model withDistance:(CGFloat)distance;

- (void)MomentButtomView:(MomentButtomView *)bottomView clickReviewBuddy:(MomentBottomModel *)bottom_model withBuddy_id:(NSString *)buddy_id;

- (void)MomentButtomView:(MomentButtomView *)bottomView didEndEdit:(MomentBottomModel *)bottom_model;


@end

@interface MomentButtomView : UIView

@property (assign, nonatomic)id<MomentButtomViewDelegate>delegate;

@property (retain, nonatomic)MomentBottomModel *bottom_model;





@end
