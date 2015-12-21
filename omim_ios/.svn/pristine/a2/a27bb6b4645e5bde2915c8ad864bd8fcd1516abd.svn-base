//
//  OMAlertView.h
//  dev01
//
//  Created by 杨彬 on 15/2/11.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMAlertView;
@protocol OMAlertViewDelegate <NSObject>

- (void)omAlertView:(OMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex customView:(UIView *)customView;

//- (void)omAlertViewCancel:(OMAlertView *)alertView customView:(UIView *)customView;
//
//- (void)willPresentOMAlertView:(OMAlertView *)alertView;  // before animation and showing view
//
//- (void)didPresentOMAlertView:(OMAlertView *)alertView;  // after animation
//
//- (void)omAlertView:(OMAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
//- (void)omAlertView:(OMAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
//
//// Called after edits in any of the default fields added by the style
//- (BOOL)omAlertViewShouldEnableFirstOtherButton:(OMAlertView *)alertView;


@end



@interface OMAlertView : UIView

@property (nonatomic,retain)UIView *bgView;// 背景图片

@property (nonatomic,retain)UIColor *promptViewColor;// 弹窗背景颜色

@property (nonatomic,retain)UIImage *promptBGImage;// 弹窗背景


@property (nonatomic,readonly)UIView *custiomView;// 用户自定义View

- (instancetype)initWithCustomView:(UIView *)customView delegate:(id<OMAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle enterButtonTitle:(NSString *)enterTitle TitleArray:(NSArray *)titleArray;


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (void)show;






@end
