//
//  OMQRCodeScanView.m
//  dev01
//
//  Created by Starmoon on 15/7/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMQRCodeScanView.h"

@interface OMQRCodeScanView ()

@property (retain, nonatomic) UIImageView *line;


@property (assign, nonatomic) CGRect scan_rect;

@property (assign, nonatomic) BOOL animation;

@property (retain, nonatomic) UILabel * intro_label;



@end


@implementation OMQRCodeScanView

-(void)dealloc{
    
    self.line = nil;
    self.intro_label = nil;
    [super dealloc];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2 - 50,
                                      self.transparentArea.width,self.transparentArea.height);
    
    self.line.x = clearDrawRect.origin.x;
    self.line.y = clearDrawRect.origin.y;
    
    self.intro_label.width = self.width;
    self.intro_label.height = 30;
    self.intro_label.x = 0;
    self.intro_label.y = CGRectGetMaxY(clearDrawRect) + 10;
    
    
}

- (void)startScan{
    self.animation = YES;
    [self scaning];
}


- (void)stopScan{
    self.animation = NO;
}


- (void)scaning{
    [UIView animateWithDuration:1.5f animations:^{
        self.line.y = CGRectGetMaxY(self.scan_rect);
//        if (!_animation)return;
        
    }completion:^(BOOL finished) {
        self.line.y = self.scan_rect.origin.y;
        if (_animation){
            [self scaning];
        }
    }];
}



- (void)drawRect:(CGRect)rect {
    
    //整个二维码扫描界面的颜色
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2 - 50,
                                      self.transparentArea.width,self.transparentArea.height);
    self.scan_rect = clearDrawRect;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

#pragma mark - Set and Get

-(UIImageView *)line{
    if (_line == nil){
        _line  = [[UIImageView alloc] init];
        _line.image = [UIImage imageNamed:@"signup_scan_line"];
        _line.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_line];
    }
    return _line;
}


-(void)setTransparentArea:(CGSize)transparentArea{
    if (_transparentArea.width == transparentArea.width
        &&_transparentArea.height == transparentArea.height )return;
    _transparentArea = transparentArea;
    self.line.width = _transparentArea.width;
    self.line.height = 2;
}


-(UILabel *)intro_label{
    if (_intro_label == nil){
        _intro_label = [[UILabel alloc]init];
        _intro_label.text = @"将二维码放入框内,即可自动扫描";
        _intro_label.font = [UIFont systemFontOfSize:13];
        _intro_label.textColor = [UIColor whiteColor];
        _intro_label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_intro_label];
    }
    return _intro_label;
}


@end
