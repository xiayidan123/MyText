//
//  UITextView+Size.h
//  dev01
//
//  Created by coca on 14-6-26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UITextView (Size)

+(CGFloat) txtWidth:(NSString *)text fontType:(int) type withInMaxWidth:(CGFloat)width;
+(CGFloat) txtHeight:(NSString *)text fontSize:(CGFloat)fontSize andWidth:(CGFloat)width;
@end
