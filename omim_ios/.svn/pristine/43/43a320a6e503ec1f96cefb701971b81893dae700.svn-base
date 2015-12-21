//
//  LPButton.h
//  wallpapers
//
//  Created by Harry on 12-10-4.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPButton;

@protocol LPButtonDelegate <NSObject>

@optional
- (void)singleTapLPButton:(LPButton *)btn;
- (void)longPressLPButton:(LPButton *)btn;
- (void)releaseLPButton:(LPButton *)btn;

@end

@interface LPButton : UIImageView
{
    id<LPButtonDelegate> delegate;
    BOOL isLongPress;
    NSTimer *timer;
}

@property(nonatomic, assign) id<LPButtonDelegate> delegate;

- (void)longPress;

@end
