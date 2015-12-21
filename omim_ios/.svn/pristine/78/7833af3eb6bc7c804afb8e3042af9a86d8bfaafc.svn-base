//
//  MomentBaseCell_HeadView.m
//  dev01
//
//  Created by 杨彬 on 15/4/9.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentBaseCell_HeadView.h"

#import "NSDate+FromCurrentTime.h"

#import "OMHeadImgeView.h"
#import "MomentCellTypeView.h"

#import "Moment.h"
#import "MomentHeadModel.h"

#import "momentcellDenfine.h"


@interface MomentBaseCell_HeadView ()

@property (retain, nonatomic)Moment *moment;

@property (retain, nonatomic)OMHeadImgeView *headImageView;

@property (retain, nonatomic)UILabel *name_label;

@property (retain, nonatomic)UILabel *time_label;

@property (retain, nonatomic)MomentCellTypeView *type_view;



@end



@implementation MomentBaseCell_HeadView

-(void)dealloc{
    self.moment = nil;
    self.headModel = nil;
    
    self.headImageView = nil;
    self.name_label = nil;
    self.time_label = nil;
    self.type_view = nil;
    
    [super dealloc];
}


-(void)setMoment:(Moment *)moment{
    [_moment release],_moment = nil;
    _moment = [moment retain];
    
    self.headImageView.buddy = moment.owner;
    
    self.name_label.text = _moment.owner.nickName;
    
    self.time_label.text = [NSDate getTimeFromTheCurrentTime:((NSTimeInterval)_moment.timestamp)];
    
    self.type_view.moment = _moment;
    
}

-(void)setHeadModel:(MomentHeadModel *)headModel{
    [_headModel release],_headModel = nil;
    _headModel = [headModel retain];
    if (_headModel == nil){
        self.moment = nil;
        return;
    }
    
    self.headImageView.frame = _headModel.headImageViewF;
    
    self.name_label.frame = _headModel.nameLabelF;
    
    self.time_label.frame = _headModel.timeLabelF;
    
    self.type_view.frame = _headModel.typeViewF;
    
    self.moment = headModel.moment;
}



-(OMHeadImgeView *)headImageView{
    if (_headImageView == nil){
        OMHeadImgeView *headImageView = [OMHeadImgeView headImageView];
        headImageView.userInteractionEnabled = YES;
        [headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeadImageView:)]];
        [self addSubview:headImageView];
        
        self.headImageView = headImageView;
    }
    return _headImageView;
}

-(UILabel *)name_label{
    if (_name_label == nil){
        UILabel *name_label = [[UILabel alloc]init];
        name_label.userInteractionEnabled = YES;
        [name_label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeadImageView:)]];
        [self addSubview:name_label];
        name_label.font = MomentHead_nameFont;
        
        self.name_label = name_label;
        [name_label release];
    }
    return _name_label;
}

-(UILabel *)time_label{
    if (_time_label == nil){
        UILabel *time_label = [[UILabel alloc]init];
        [self addSubview:time_label];
        time_label.font = [UIFont systemFontOfSize:12];
        time_label.textColor = [UIColor lightGrayColor];
        
        self.time_label = time_label ;
        [time_label release];
 
    }
    return _time_label;
}

-(MomentCellTypeView *)type_view{
    if (_type_view == nil){
        MomentCellTypeView *type_view = [MomentCellTypeView momentCellTypeView];
        [self addSubview:type_view];
        type_view.translatesAutoresizingMaskIntoConstraints = NO;
        self.type_view = type_view;
    }
    return _type_view;
}






- (void)didClickHeadImageView:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(MomentBaseCell_HeadViewDelegate:didClickHeadImageView:)]){
        [self.delegate MomentBaseCell_HeadViewDelegate:self didClickHeadImageView:self.moment.owner];
    }
}





@end
