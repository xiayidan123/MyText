//
//  AbilityView.m
//  仪表盘
//
//  Created by 杨彬 on 14-10-11.
//  Copyright (c) 2014年 LiuHuan. All rights reserved.
//

#import "AbilityView.h"
#define LINE_WIDTH 10

@implementation AbilityView



-(void)dealloc{
    [_pointArray release];
    [super dealloc];
}
- (instancetype)initWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)image andScoreArray:(NSArray *)scoreArray
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat _w = frame.size.width / 2;
        CGFloat _h = frame.size.height / 2;
        self.backgroundColor = [UIColor yellowColor];
        
        UIImageView *_bgimgv = [[UIImageView alloc]initWithFrame:self.bounds];
        _bgimgv.image = image;;
        [self addSubview:_bgimgv];
        [_bgimgv release];
        
        CALayer *mainLayer = [CALayer layer];
        //形状
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.lineWidth = 0;
        layer.lineCap = kCALineCapRound;
//        layer.fillColor = [UIColor yellowColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(_w, 0)];
        
        CGFloat angle = M_PI * 2.0 / scoreArray.count;
        
        _pointArray = [[NSMutableArray alloc]init];
        for (int i=0; i<scoreArray.count; i++){
            CGPoint point = CGPointMake(_w + cos(-M_PI / 2.0 + angle *i)* _h * [scoreArray[i] integerValue] / 100 , _h + sin(-M_PI / 2.0 + angle *i)* _h * [scoreArray[i] integerValue] / 100 );
            if (i == 0){
                [path moveToPoint:point];
            }else{
                [path addLineToPoint:point];
            }
            [_pointArray addObject:[NSValue valueWithCGPoint:point]];
        }
        [path addLineToPoint:CGPointMake(_w + cos(-M_PI / 2.0 )* _h * [scoreArray[0] integerValue] / 100 , _h + sin(-M_PI / 2.0 )* _h * [scoreArray[0] integerValue] / 100)];
        
        layer.path = [path CGPath];
        [self.layer addSublayer:layer];
        layer.strokeEnd = 100 / 100.0;
    
        [self.layer addSublayer:mainLayer];
//        使用形状图层去裁剪钱一个普通的图层
        [self.layer setMask:layer];
    }
    return self;
}





- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


@end
