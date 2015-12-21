//
//  OMNavigationBackButton.m
//  dev01
//
//  Created by Starmoon on 15/7/31.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMNavigationBackButton.h"

@implementation OMNavigationBackButton



-(void)layoutSubviews{
    [super layoutSubviews];
    
    
//    CGFloat image_width = self.imageView.width;
//    CGFloat titleLable_width = self.titleLabel.width;
//    CGFloat width = self.imageView.width + self.titleLabel.width + 10;
//    
//    
//    self.width = width;

}


//- (instancetype)initWithFrame:(CGRect )frame
//{
//    self = [super initWithFrame:frame];
//    self.frame = frame;
//    if (self) {
//        [self setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
//    }
//    return self;
//}


-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    
    CGSize titleLabel_size = [title sizeWithFont:self.titleLabel.font];
    [self setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    
//    self.imageView.backgroundColor = [UIColor redColor];
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.width = titleLabel_size.width + 12 + 10;
    self.height = 30;
    
}


@end
