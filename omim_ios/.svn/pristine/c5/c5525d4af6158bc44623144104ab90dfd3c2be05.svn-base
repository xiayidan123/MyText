//
//  UISize.m
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "UISize.h"
#import "SDKConstant.h"

@implementation UISize


#pragma mark -
#pragma mark screen and oponents size
+ (CGFloat)screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)statusBarHeight
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (CGFloat)statusBarWidth
{
    return [[UIApplication sharedApplication] statusBarFrame].size.width;
}

+(CGFloat)screenHeightNotIncludingStatusBar
{
    return [UISize screenHeight] - [UISize statusBarHeight];
}

+ (CGFloat)screenHeightNotIncludingStatusBarAndNavBar
{
    return [UISize screenHeightNotIncludingStatusBar] - SDK_NAVIGATION_BAR_HEIGHT;
}

+ (CGFloat)heightOfStatusBarAndNavBar
{
    return [UISize statusBarHeight] + SDK_NAVIGATION_BAR_HEIGHT;
}


@end
