//
//  OMBaseDatePickerView.h
//  dev01
//
//  Created by 杨彬 on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMBaseCellFrameModel;
@class OMBaseDatePickerView;


@protocol OMBaseDatePickerViewDelegate <NSObject>

@optional
- (void)baseDatePickerView:(OMBaseDatePickerView *)baseDatePickerView enterClick:(OMBaseCellFrameModel *)cellFrameModel;

@end



typedef NS_ENUM(NSInteger, OMBaseDatePickerViewType) {
    OMBaseDatePickerViewTypeDefault,
    OMBaseDatePickerViewTypeDate,
    OMBaseDatePickerViewTypeTime,
    OMBaseDatePickerViewTypeCountDownTimer,
};


@interface OMBaseDatePickerView : UIView

@property (assign, nonatomic)OMBaseDatePickerViewType type;

@property (retain, nonatomic)OMBaseCellFrameModel *cellFrameModel;

@property (assign, nonatomic)id<OMBaseDatePickerViewDelegate>delegate;

+ (instancetype)baseDatePickerViewWithFrame:(CGRect)frame;

- (void)showDatePickerWithAnimated:(BOOL)animated;

- (void)hiddenDatePickerWithAnimated:(BOOL)animated withCompletion:(void(^)(void))CB;

- (void)refreshModel;

@end




