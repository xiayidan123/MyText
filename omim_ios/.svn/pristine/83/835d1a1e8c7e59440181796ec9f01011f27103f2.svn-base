//
//  MomentBaseCell_MiddleView.h
//  dev01
//
//  Created by 杨彬 on 15/4/10.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MomentCellModel;
@class MomentMiddleModel;
@class MomentBaseCell_MiddleView;
@class MomentLocationCellModel;
@class WTFile;

@protocol MomentBaseCell_MiddleViewDelegate <NSObject>

- (void)MomentBaseCell_MiddleView:(MomentBaseCell_MiddleView *)middleView locationModel:(MomentLocationCellModel *)locationModel;

- (void)MomentBaseCell_MiddleView:(MomentBaseCell_MiddleView *)middleView didVotedWithMoment_id:(NSString *)moment_id option_array:(NSArray *)option_array;

- (void)MomentBaseCell_MiddleView:(MomentBaseCell_MiddleView *)middleView playVideoWithMoment_id:(NSString *)moment_id videoFile:(WTFile *)video_file;

@end

@interface MomentBaseCell_MiddleView : UIView

@property (assign, nonatomic)id<MomentBaseCell_MiddleViewDelegate>delegate;

@property (retain, nonatomic)MomentMiddleModel *middleModel;


@end
