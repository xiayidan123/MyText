//
//  OMInputBar.h
//  dev01
//
//  Created by 杨彬 on 15/4/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMInputBar;

@protocol OMInputBarDelegate <NSObject>
@optional

- (void)OMInputBar:(OMInputBar *)inputBar didChangeHeight:(CGFloat )distance_height;

- (void)OMInputBar:(OMInputBar *)inputBar didReturn:(NSString *)text_string;

- (void)OMInputBar:(OMInputBar *)inputBar didEndEdit:(NSString *)text_string;

@end


@interface OMInputBar : UIView

@property (assign, nonatomic) id<OMInputBarDelegate>delegate;

@property (nonatomic,copy) NSString* placeholder;

- (void)activateWithView:(UIView *)click_view;

- (void)endEdit;

@end
