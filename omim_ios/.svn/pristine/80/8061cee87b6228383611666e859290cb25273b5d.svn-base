//
//  OMSaveImageRemindView.h
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMSaveImageRemindView;

@protocol OMSaveImageRemindViewDelegate <NSObject>

- (void)hiddenOMSaveImageRemindView:(OMSaveImageRemindView *)saveImageRemindView;

@end
@interface OMSaveImageRemindView : UIView

@property (copy, nonatomic)NSString *title;

@property (assign, nonatomic)id<OMSaveImageRemindViewDelegate>delegate;

+ (instancetype)OMSaveImageRemindView;

- (void)showInSuperView:(UIView *)superView;

@end
