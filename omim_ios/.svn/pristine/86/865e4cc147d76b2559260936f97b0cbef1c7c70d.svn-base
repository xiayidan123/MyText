//
//  LHGrayPageControl.m
//  dev01
//
//  Created by Huan on 15/3/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LHGrayPageControl.h"

@interface LHGrayPageControl()
@property (retain, nonatomic)UIImage *activeImage;
@property (retain, nonatomic)UIImage *inactiveImage;

@end


@implementation LHGrayPageControl

-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    
    self.activeImage = [[UIImage imageNamed:@"RedPoint.png"] retain];
    
    self.inactiveImage = [[UIImage imageNamed:@"BluePoint.png"] retain];
    
    
    return self;
    
}


-(void) updateDots

{
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        CGSize size;
        size.height = 7;     //自定义圆点的大小
        size.width = 7;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        if (i==self.currentPage)dot.image=self.activeImage;
        else dot.image=self.inactiveImage;
    }
    
}

-(void) setCurrentPage:(NSInteger)page

{
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}

@end
