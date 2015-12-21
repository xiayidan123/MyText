//
//  MomentHeadModel.m
//  dev01
//
//  Created by 杨彬 on 15/4/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentHeadModel.h"
#import "MomentCellDenfine.h"

@implementation MomentHeadModel



-(void)dealloc{
    self.moment = nil;
    [super dealloc];
}



-(void)setMoment:(Moment *)moment{
    [_moment release],_moment = nil;
    _moment = [moment retain];
    if(_moment == nil)return;
    
    /** 头像*/
    CGFloat headImageWH = MomentHead_headImageWH;
    CGFloat headImageX = MomentHead_borderW;
    CGFloat headImageY = MomentHead_borderH;
    self.headImageViewF = CGRectMake(headImageX, headImageY, headImageWH, headImageWH);
    
    /** 用户名 */
    CGFloat nameX = CGRectGetMaxX(self.headImageViewF) + MomentHead_borderW;
    CGFloat nameY = headImageY;
    CGSize  nameSize = [moment.owner.nickName sizeWithFont:MomentHead_nameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 时间Label的frame*/
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) ;
    NSString *time_text = [NSDate getTimeFromTheCurrentTime:((NSTimeInterval)moment.timestamp)];
    CGSize timeSize = [time_text sizeWithFont:MomentHead_timeFont];
    self.timeLabelF = (CGRect){{timeX,timeY},{MomentHead_timeLabelW,timeSize.height}};
    
    /** moment类型view的frame*/
    CGFloat typeX = OMScreenW - 35;;
    CGFloat typeY  = MomentHead_borderH ;
    CGSize typeSize  = CGSizeMake(25, 20);
    self.typeViewF = (CGRect){{typeX,typeY},typeSize};
    
    self.content_height = MAX(CGRectGetMaxY(self.headImageViewF), CGRectGetMaxY(self.timeLabelF)) + MomentHead_borderH;
}






@end
