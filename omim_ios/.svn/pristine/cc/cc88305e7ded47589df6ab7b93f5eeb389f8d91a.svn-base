//
//  MomentVoteCellModel.m
//  dev01
//
//  Created by 杨彬 on 15/4/14.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentVoteCellModel.h"

#import "MomentCellDenfine.h"


@implementation MomentVoteCellModel


-(void)dealloc{
    self.option = nil;
    [super dealloc];
}


-(void)setOption:(Option *)option{
    [_option release],_option = nil;
    _option = [option retain];
    
    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:VoteCellFontSize]};
    
    CGSize maxSize = CGSizeMake(VoteCellTextWidth, MAXFLOAT);
    
    CGSize text_size = [_option.desc boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    if (text_size.height < 15){
        self.cellHeight =  VoteCellMinHeight;
    }else{
        self.cellHeight =  text_size.height + 15;
    }
}







@end
