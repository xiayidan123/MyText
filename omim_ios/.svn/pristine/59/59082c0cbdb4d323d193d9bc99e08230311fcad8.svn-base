//
//  MomentReviewActionView.h
//  dev01
//
//  Created by 杨彬 on 15/4/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MomentBottomModel;
@class MomentReviewActionView;


@protocol MomentReviewActionViewDelegate <NSObject>

@optional
- (void)MomentReviewActionView:(MomentReviewActionView *)reviewwActionView didClickLikeButton:(MomentBottomModel *)bottom_model;


- (void)MomentReviewActionView:(MomentReviewActionView *)reviewwActionView didClickCommentButton:(MomentBottomModel *)bottom_model withDistance:(CGFloat)distance;

- (void)MomentReviewActionView:(MomentReviewActionView *)reviewwActionView didEndEdit:(MomentBottomModel *)bottom_model;

@end




@interface MomentReviewActionView : UIView

@property (assign, nonatomic)id<MomentReviewActionViewDelegate>delegate;

@property (retain, nonatomic)MomentBottomModel *bottom_model;

+ (instancetype)momentReviewActionView;



@end
