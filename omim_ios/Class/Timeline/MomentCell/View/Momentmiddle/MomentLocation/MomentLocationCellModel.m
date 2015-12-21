//
//  MomentLocationCellModel.m
//  dev01
//
//  Created by 杨彬 on 15/4/15.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentLocationCellModel.h"
#import "MomentCellDenfine.h"

@implementation MomentLocationCellModel


-(void)dealloc{
    self.place_text = nil;
    
    
    [super dealloc];
}





-(void)setPlace_text:(NSString *)place_text{
    [_place_text release],_place_text = nil;
    _place_text = [place_text copy];

    CGSize text_size = [_place_text sizeWithFont:[UIFont systemFontOfSize:LocationViewFontSize] maxW:self.maxW];
    
    if (text_size.height < 20){
        self.cellHeight = LocationMinHeight;
    }else{
        self.cellHeight = text_size.height + 30;
    }
}


@end
