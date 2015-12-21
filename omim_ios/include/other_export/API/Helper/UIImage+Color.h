//
//  UIImage+Color.h
//  omim
//
//  Created by coca on 2012/11/27.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;
+(UIImage *)image:(UIImage *)img withColor:(UIColor *)color;

@end
