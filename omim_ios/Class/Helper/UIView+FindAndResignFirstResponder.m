//
//  UIView+FindAndResignFirstResponder.m
//  dev01
//
//  Created by elvis on 2013/09/03.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "UIView+FindAndResignFirstResponder.h"

@implementation UIView (FindAndResignFirstResponder)
- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}
@end
