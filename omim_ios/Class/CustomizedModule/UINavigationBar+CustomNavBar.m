//
//  UINavigationBar+CustomNavBar.m
//  omim
//
//  Created by Harry on 12-8-7.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "UINavigationBar+CustomNavBar.h"
#import "PublicFunctions.h"
#import "Constants.h"

@implementation UINavigationBar (CustomNavBar)
/*
- (void)layoutSubviews
{
    if (IS_IOS5){
      //  [self setBackgroundImage:[[UIImage imageNamed:NAVIGATIONBAR_BACKGROUND_IMAGE] stretchableImageWithLeftCapWidth:30 topCapHeight:30] forBarMetrics:UIBarMetricsDefault];

    }
    else
    {
        [super layoutSubviews];
        self.backgroundColor = [UIColor clearColor];
    }
}
 */

- (void)drawRect:(CGRect)rect
{
  //  if (!IS_IOS5)
  //  {
        UIImage *image = [PublicFunctions strecthableImage:NAVIGATIONBAR_BACKGROUND_IMAGE];
        [image drawInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
       // [image drawInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
  //  }
}

@end 
