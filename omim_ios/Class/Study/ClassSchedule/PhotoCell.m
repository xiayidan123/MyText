//
//  PhotoCell.m
//  dev01
//
//  Created by Huan on 15/2/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}
- (void)layoutSubviews
{
    /*
     CGFloat _w;
     CGFloat _h;
     if (_imageView.image.size.width / _imageView.image.size.height > ((self.bounds.size.width - 20)/(self.bounds.size.height - 84))){
     _w = self.bounds.size.width - 20;
     _h = _w  * _imageView.image.size.height / _imageView.image.size.width ;
     }else{
     _h = self.bounds.size.height - 84;
     _w = (self.bounds.size.height - 84) / _imageView.image.size.height * _imageView.image.size.width;
     }
     
     self.imageView.frame = CGRectMake(0, 0, _w, _h);
     self.imageView.center=CGPointMake(self.bounds.size.width / 2  , self.center.y- 32);
     */
}
- (void)setIcon:(UIImage *)icon
{
    _icon = [icon copy];
    CGFloat _w;
    CGFloat _h;
    if (icon.size.width / icon.size.height > (self.bounds.size.width - 20) / (self.bounds.size.height - 84)) {
        _w = self.bounds.size.width - 20;
        _h = _w * icon.size.height / icon.size.width;
    }
    else
    {
        _h = self.bounds.size.height - 84;
        _w = (self.bounds.size.height - 84) / icon.size.height * icon.size.width;
    }
    self.imageView.frame = CGRectMake(10, 100, _w, _h);
    self.imageView.center=CGPointMake(self.bounds.size.width / 2  , self.bounds.size.height / 2);
    self.imageView.image = icon;
}
@end
