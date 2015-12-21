//
//  OMSideslipButton.m
//  dev01
//
//  Created by 杨彬 on 15/3/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMSideslipButton.h"

@interface OMSideslipButton ()

@property (retain, nonatomic)UIView *topView;

@property (retain, nonatomic)UIView *middleView;

@property (retain, nonatomic)UIView *bottomView;

@end


@implementation OMSideslipButton

-(void)dealloc{
    
    [_topView release];
    
    [_middleView release];
    
    [_bottomView release];
    
    [super dealloc];
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, 44, 44)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 44, 44);
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        for (int i=0; i<3; i++){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(7, 12 + i *10 ,30, 5)];
            line.backgroundColor = [UIColor whiteColor];
            [self addSubview:line];
            
            switch (i) {
                case 0:{
                    self.topView = line;
                }break;
                case 1:{
                    self.middleView = line;
                }break;
                case 2:{
                    self.bottomView = line;
                }break;
                    
                default:
                    break;
            }
            [line release];
        }
    }
    return self;
}



-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    self.selected = YES;
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
    
    
}


-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
//    if (selected){
//        self.titleLabel.text = self.text_Selected;
//        if ([self.text_Selected length] == 0 ){
//            self.titleLabel.text = self.text_Normal;
//        }
//        self.titleLabel.textColor = self.titleColor_Selected;
//        
//        self.imageView.image = self.image_Selected;
//        self.image_height.constant = self.image_Selected.size.height;
//        self.image_width.constant = self.image_Selected.size.width;
//    }else{
//        self.titleLabel.text = self.text_Normal;
//        self.titleLabel.textColor = self.titleColor_Normal;
//        self.imageView.image = self.image_Normal;
//        self.image_height.constant = self.image_Normal.size.height;
//        self.image_width.constant = self.image_Normal.size.width;
//    }
}






@end
