//
//  HeaderView.m
//  MG
//
//  Created by macbook air on 14-9-22.
//  Copyright (c) 2014年 macbook air. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.97 alpha:1];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, frame.size.width - 30, frame.size.height)];
        [self addSubview:_titleLabel];
        
        _arrowsView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 42, 15.5, 22, 13)];
        _arrowsView.image = [UIImage imageNamed:@"contacts_icon_fold"];
        [self addSubview:_arrowsView];
        
    }
    return self;
}

-(void)dealloc{
    [_arrowsView release];
    [_titleLabel release];
    [super dealloc];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctf, 0, self.frame.size.height- 0.5);
    CGContextAddLineToPoint(ctf, self.frame.size.width, self.frame.size.height - 0.5);
    CGContextSetLineWidth(ctf, 0.5);
    CGContextSetRGBStrokeColor(ctf, 0.79, 0.79, 0.81, 1);
    CGContextStrokePath(ctf);
}


@end
