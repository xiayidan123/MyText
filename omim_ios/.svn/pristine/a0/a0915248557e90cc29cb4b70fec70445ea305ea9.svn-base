//
//  ImageScrollView.h
//  dev01
//
//  Created by jianxd on 13-12-2.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate <NSObject>
@optional
- (void)didClickOnImage:(NSUInteger)index;
@end

@interface ImageScrollView : UIView<UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame imageWidth:(CGFloat)width imageArray:(NSArray *)array;

@end
