//
//  MomentBaseCell_HeadView.h
//  dev01
//
//  Created by 杨彬 on 15/4/9.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MomentBaseCell_HeadView;
@class MomentHeadModel;
@class Buddy;

@protocol MomentBaseCell_HeadViewDelegate <NSObject>

@optional

/**
 *  点击头像 或者 名字
 */
- (void)MomentBaseCell_HeadViewDelegate:(MomentBaseCell_HeadView *)momentBaseCell_HeadView didClickHeadImageView:(Buddy *)buddy;



@end





@interface MomentBaseCell_HeadView : UIView

@property (retain, nonatomic)MomentHeadModel *headModel;

@property (assign, nonatomic)id <MomentBaseCell_HeadViewDelegate>delegate;

@end
