//
//  OMViewState.m
//  dev01
//
//  Created by 杨彬 on 15/4/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewState.h"
#import "WTFile.h"

@implementation OMViewState

-(void)dealloc{
    self.superview = nil;
    self.original_view = nil;
    self.file = nil;
    self.moment_id = nil;
    [super dealloc];
}


- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        [self setStateWithView:view];
    }
    return self;
}


- (void)setStateWithView:(UIView *)view{
    self.superview = view.superview;
    self.original_view = view;
    
    CGAffineTransform trans = view.transform;
    view.transform = CGAffineTransformIdentity;
    
    self.frame     = view.frame;
    self.transform = trans;
    self.userInteratctionEnabled = view.userInteractionEnabled;
    
    view.transform = trans;
}



@end
