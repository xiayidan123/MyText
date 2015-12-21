//
//  UISize.h
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UISize : NSObject

+ (CGFloat)screenHeight;
+ (CGFloat)screenWidth;
+ (CGFloat)statusBarHeight;
+ (CGFloat)statusBarWidth;
+ (CGFloat)screenHeightNotIncludingStatusBar;
+ (CGFloat)screenHeightNotIncludingStatusBarAndNavBar;
+ (CGFloat)heightOfStatusBarAndNavBar;


@end
