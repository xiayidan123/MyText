//
//  MomentCellTypeView.m
//  dev01
//
//  Created by 杨彬 on 15/4/9.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentCellTypeView.h"

#import "Moment.h"

@interface MomentCellTypeView ()

@property (retain, nonatomic)UIView *mark_View;

@property (retain, nonatomic)UILabel *type_label;

@end


@implementation MomentCellTypeView

-(void)dealloc{
    self.mark_View = nil;
    self.type_label = nil;
    self.moment = nil;
    
    [super dealloc];
}


+ (instancetype)momentCellTypeView{
    return [[[self alloc]init] autorelease];
}

//(0:status; 1:q&a; 2:report; 3:single choice survey; 4:multiple choice survey 5:todo;)
-(void)setMoment:(Moment *)moment{
    [_moment release],_moment = nil;
    _moment = [moment retain];
    if (_moment == nil)return;
    
    switch (_moment.momentType) {
        case 0:{
//            self.mark_View.backgroundColor = [UIColor colorWithRed:80.0/255 green:227.0/255 blue:194.0/255 alpha:1];
//            self.type_label.text = @"生活";
        }break;
        case 1:{
//            self.mark_View.backgroundColor = [UIColor colorWithRed:253.0/255 green:80.0/255 blue:82.0/255 alpha:1];
//            self.type_label.text = @"问答";
        }break;
        case 2:{
            //
            self.mark_View.backgroundColor = [UIColor colorWithRed:245.0/255 green:166.0/255 blue:34.0/255 alpha:1];
            self.type_label.text = @"学习";
        }break;
        case 3:{
            //
            self.mark_View.backgroundColor = [UIColor colorWithRed:0 green:121.0/255 blue:1 alpha:1];
            self.type_label.text = @"投票";
        }break;
        case 4:{
//            self.mark_View.backgroundColor = [UIColor colorWithRed:212.0/255 green:97.0/255 blue:242.0/255 alpha:1];
//            self.type_label.text = @"生活";
        }break;
        case 5:{
            //
            self.mark_View.backgroundColor = [UIColor colorWithRed:38.0/255 green:198.0/255 blue:47.0/255 alpha:1];
            self.type_label.text = @"生活";
        }break;
        case 6:{
            //
            self.mark_View.backgroundColor = [UIColor colorWithRed:38.0/255 green:198.0/255 blue:47.0/255 alpha:1];
            self.type_label.text = @"视频";
        }break;
            
        default:
            break;
    }
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat mark_viewX = 0;
    CGFloat mark_viewY = (self.frame.size.height - MomentCellTypeView_markWH)/2;
    self.mark_View.frame = CGRectMake(mark_viewX, mark_viewY, MomentCellTypeView_markWH ,MomentCellTypeView_markWH);
    self.mark_View.layer.cornerRadius = MomentCellTypeView_markWH /2;
    self.mark_View.layer.masksToBounds = YES;
    
    CGFloat type_labelX = CGRectGetMaxX(self.mark_View.frame) + 2;
    self.type_label.frame = CGRectMake(type_labelX, 0, self.frame.size.width - MomentCellTypeView_markWH , self.frame.size.height);
}


-(UIView *)mark_View{
    if (_mark_View == nil){
        UIView *mark_view = [[UIView alloc]init];
        [self addSubview:mark_view];
        self.mark_View = mark_view;
        [mark_view release];
    }
    return _mark_View;
}


-(UILabel *)type_label{
    if (_type_label == nil){
        UILabel *type_label = [[UILabel alloc]init];
        type_label.textColor = [UIColor lightGrayColor];
        type_label.font = [UIFont systemFontOfSize:10];
        type_label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:type_label];
        self.type_label = type_label;
        [type_label release];
    }
    return _type_label;
}


@end
