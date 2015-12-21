//
//  YBAttrbutedLabel.m
//  YBAttributedLabelTest
//
//  Created by 杨彬 on 15/4/29.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "YBAttrbutedLabel.h"
#import <CoreText/CoreText.h>


@implementation YBAttrbutedModel



@end



@interface YBAttrbutedLabel ()

@property (assign, nonatomic) int select_index;

@end

@implementation YBAttrbutedLabel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setText:(NSString *)text{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
    [self setTextStyle:str];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
    NSInteger count = _link_array.count;
    for (int i=0; i< count; i++){
        YBAttrbutedModel *model = _link_array[i];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.17 green:0.48 blue:0.65 alpha:1] range:model.range];
    }
    
    [super setAttributedText:str];
}


-(void)setLink_array:(NSMutableArray *)link_array{
    _link_array = link_array;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    
    [self setTextStyle:str];
}


- (void)setTextStyle:(NSMutableAttributedString *)str{
    NSInteger count = _link_array.count;
    for (int i=0; i< count; i++){
        YBAttrbutedModel *model = _link_array[i];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.17 green:0.48 blue:0.65 alpha:1] range:model.range];
    }
    self.attributedText = str;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    BOOL canLink = [self getClickFrame:point withCallBack:NO];
    if (!canLink ){
        [self.superview touchesBegan:touches withEvent:event];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    BOOL canLink = [self getClickFrame:point withCallBack:YES];
    
    if (!canLink){
        [self.superview touchesEnded:touches withEvent:event];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    NSInteger count = _link_array.count;
    for (int i=0; i< count; i++){
        YBAttrbutedModel *model = _link_array[i];
        
        [str addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:model.range];
    }
    [super setAttributedText:str];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    NSInteger count = _link_array.count;
    for (int i=0; i< count; i++){
        YBAttrbutedModel *model = _link_array[i];
        
        [str addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:model.range];
    }
    [super setAttributedText:str];
    
   
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds ,point)){
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
        NSInteger count = _link_array.count;
        for (int i=0; i< count; i++){
            YBAttrbutedModel *model = _link_array[i];
            
            [str addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:model.range];
        }
        [super setAttributedText:str];
    }
    
}



- (BOOL)getClickFrame:(CGPoint)point withCallBack:(BOOL)needCallBack {
    BOOL canLink = NO;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    //坐标点在左下角
    CGPathAddRect(Path, NULL ,self.bounds);
    NSLog(@"%@",NSStringFromCGRect(self.bounds));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    //得到frame中的行数组
    CFArrayRef lines = CTFrameGetLines(frame);
    
    CFIndex count = CFArrayGetCount(lines);

    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0,0), origins);
    
    CGAffineTransform transform = [self transformForCoreText];
    CGFloat verticalOffset = 0; //不像Nimbus一样设置文字的对齐方式，都统一是TOP,那么offset就为0

    for (CFIndex i = 0; i < count; i++)
    {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        rect = CGRectInset(rect, 0, 0);
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSLog(@"%@",NSStringFromCGRect(rect));
        NSLog(@"%@",NSStringFromCGPoint(point));
        if (CGRectContainsPoint(rect, point))
        {
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line,index, &offset );
            
            if (offset > relativePoint.x){
                index = index - 1;
            }
            
            canLink = NO;
            NSInteger link_count = _link_array.count;
            for (int j=0; j<link_count;j++ ){
                
                YBAttrbutedModel *model = _link_array[j];

                NSRange link_range = model.range ;
                
                if (index >= link_range.location && index < (link_range.location + link_range.length)){
                    UIColor *bg_color = nil;
                    if (needCallBack){
                        if ( (self.select_index == j) && [self.delegate respondsToSelector:@selector(YBAttrbutedLabel:click:)]){
                            [self.delegate YBAttrbutedLabel:self click:model];
                        }
                        bg_color = [UIColor clearColor];
                        canLink = YES;
                    }else{
                        self.select_index = j;
                        bg_color = [UIColor lightGrayColor];
                    }
                    
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
                    [str addAttribute:NSBackgroundColorAttributeName value:bg_color range:link_range];
                    [super setAttributedText:str];
                }
            }
        }else{
            canLink = NO;
        }
    }
    
    return canLink;
}


- (CGAffineTransform)transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}


- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint) point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    
    return CGRectMake(point.x, point.y - descent, width, height);
}



@end
