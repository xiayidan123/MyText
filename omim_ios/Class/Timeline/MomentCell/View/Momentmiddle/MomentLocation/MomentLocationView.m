//
//  MomentLocationView.m
//  dev01
//
//  Created by 杨彬 on 15/4/14.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentLocationView.h"

#import "MomentLocationCellModel.h"


@interface MomentLocationView ()

@property (retain, nonatomic)UIImageView *location_imageView;

@property (retain, nonatomic)UILabel *location_label;

@end


@implementation MomentLocationView

-(void)dealloc{
    self.location_imageView = nil;
    self.location_label = nil;
    self.locationCellModel = nil;
    
    [super dealloc];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self uiConfig];
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    }
    return self;
}


-(void)setLocationCellModel:(MomentLocationCellModel *)locationCellModel{
    [_locationCellModel release];_locationCellModel = nil;
    _locationCellModel = [locationCellModel retain];
    
    
    self.location_label.text = _locationCellModel.place_text;
}



- (void)uiConfig{
    [self draw_location_imageView];
    
    [self draw_loaction_label];
}



- (void)draw_location_imageView{
    UIImageView *location_imageView = [[UIImageView alloc]init];
    location_imageView.translatesAutoresizingMaskIntoConstraints = NO;
    location_imageView.image = [UIImage imageNamed:@"timeline_location_a"];
    [self addSubview:location_imageView];
    //    timeline_location_a 16 16
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:location_imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self addConstraint:leading];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:location_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:12];
    [self addConstraint:top];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:location_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:16];
    [location_imageView addConstraint:width];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:location_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:16];
    [location_imageView addConstraint:height];
    
    self.location_imageView = location_imageView;
    [location_imageView release];
}


- (void)draw_loaction_label{
    UILabel *location_label = [[UILabel alloc]init];
    location_label.translatesAutoresizingMaskIntoConstraints = NO;
    location_label.numberOfLines = 0;
    location_label.font = [UIFont systemFontOfSize:12];
    [self addSubview:location_label];

    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:location_label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.location_imageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10];
    [self addConstraint:leading];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:location_label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.location_imageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:top];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:location_label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-25];
    [self addConstraint:trailing];
    self.location_label = location_label;
    [location_label release];
}


- (void)click{
    if([self.delegate respondsToSelector:@selector(MomentLocationView:momentLocationCellModel:)]){
        [self.delegate MomentLocationView:self momentLocationCellModel:self.locationCellModel];
    }
}

@end
