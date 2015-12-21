//
//  OMInputManager.h
//  dev01
//
//  Created by 杨彬 on 15/4/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OMInputBar;


@protocol OMInputManagerDelegate <NSObject>

- (void)beginShowKeyboardWithDistance:(CGFloat )distance;

- (void)didClickReturnWithText:(NSString *)text;

- (void)didEndHideKeyBoard;


@end


@interface OMInputManager : NSObject


@property (retain, nonatomic)UIView *click_view;

@property (retain, nonatomic)OMInputBar *input_bar;

@property (nonatomic,copy) NSString* placeholder;


@property (assign, nonatomic)id<OMInputManagerDelegate>delegate;



+ (id)sharedManager;

-(void)setClick_view:(UIView *)click_view;

+ (void)hideKeyBoard;


- (void)releaseManager;


@end
