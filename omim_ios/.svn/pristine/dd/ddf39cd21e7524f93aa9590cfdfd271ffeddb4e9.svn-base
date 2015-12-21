//
//  ScrollButton.h
//  wallpapers
//
//  Created by Harry on 12-10-4.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

#define CALM_BLUE_CODE              @"#474747"
#define LIGHT_GREY_CODE             @"#bfbfbf"
#define DARK_GREY_CODE              @"#1f1f1f"

#import <UIKit/UIKit.h>

@class ScrollButton;

@protocol ScrollButtonDelegate <NSObject>

@optional
- (void)selectScrollButton:(ScrollButton *)btn;
- (void)longPressScrollButton:(ScrollButton *)btn;
- (void)releaseScrollButton:(ScrollButton *)btn;

@end

@interface ScrollButton : UIView
{
    id<ScrollButtonDelegate> delegate;
    BOOL selected;
    
    UIImageView *contentImage;
    
    BOOL isLongPress;
    NSTimer *timer;
    BOOL isAnime;

}

@property (nonatomic, assign) id<ScrollButtonDelegate> delegate;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *contentImage;
@property (nonatomic, assign) BOOL isAnime;
@property (nonatomic)  BOOL isExpression;

@end
