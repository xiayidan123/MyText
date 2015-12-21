//
//  OMAlertViewForNet.h
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMAlertViewForNet;


typedef NS_ENUM(NSInteger, OMAlertViewForNetStatus) {
    OMAlertViewForNetStatus_Loading,
    OMAlertViewForNetStatus_Done,
    OMAlertViewForNetStatus_Done1,
    OMAlertViewForNetStatus_Failure
};

@protocol OMAlertViewForNetDelegate <NSObject>

@optional
- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet;


@end

@interface OMAlertViewForNet : UIView

@property (assign, nonatomic) double duration;

/** 是否结束 */
@property (assign, nonatomic) BOOL isEnd;

@property (copy, nonatomic)NSString *title;

@property (assign, nonatomic)OMAlertViewForNetStatus type;

@property (assign, nonatomic)id<OMAlertViewForNetDelegate>delegate;

+ (instancetype)OMAlertViewForNet;

- (void)show;


- (void)showInView:(UIView *)view;


- (void)dismiss;



@end
