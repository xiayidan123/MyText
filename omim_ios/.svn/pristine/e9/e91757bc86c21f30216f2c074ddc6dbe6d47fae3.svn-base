//
//  LogoutButtonView.h
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LogoutButtonView;

@protocol LogoutButtonViewDelegate <NSObject>

- (void)logoutAppWithLogoutButtonView:(LogoutButtonView *)logoutButtonView;

@end


@interface LogoutButtonView : UIView

@property (assign, nonatomic) id<LogoutButtonViewDelegate>delegate;


+ (instancetype)logoutButtonView;

@end
