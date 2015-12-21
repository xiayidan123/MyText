//
//  UIImageView+additions.m
//  omim
//
//  Created by coca on 2012/11/06.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "UIImageView+additions.h"

@implementation UIImageView (additions)
-(CGSize)imageScale
{
    if (self.image == nil) {
       return  CGSizeMake(1, 1);
    }
    
    CGFloat sx = self.frame.size.width / self.image.size.width;
    CGFloat sy = self.frame.size.height / self.image.size.height;
    CGFloat s = 1.0;
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFit:
            s = fminf(sx, sy);
            return CGSizeMake(s, s);
            break;
            
        case UIViewContentModeScaleAspectFill:
            s = fmaxf(sx, sy);
            return CGSizeMake(s, s);
            break;
            
        case UIViewContentModeScaleToFill:
            return CGSizeMake(sx, sy);
            
        default:
            return CGSizeMake(s, s);
    }
    
    
}
@end
