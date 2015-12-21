//
//  MomentCellModel.m
//  dev01
//
//  Created by 杨彬 on 15/4/8.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentCellModel.h"


#import "Moment.h"
#import "MomentAlbumFile.h"

#import "Option.h"
#import "MomentVoteCellModel.h"
#import "MomentLocationCellModel.h"
#import "MomentReviewCellModel.h"
#import "MomentReviewLikeModel.h"

#import "MomentCellDenfine.h"




@interface MomentCellModel ()


@end


@implementation MomentCellModel



-(void)dealloc{
    self.moment = nil;
    /** 头部 */
    self.headModel = nil;

    /** 中部 */
    self.middleModel = nil;
    
    /** 底部  */
    self.bottomModel = nil;
    
    [super dealloc];
}


-(void)setMoment:(Moment *)moment{
    [_moment release],_moment = nil;
    _moment = [moment retain];
    if (_moment == nil)return;
    
    /**
     *  头部控件 模型
     */
    MomentHeadModel *headModel = [[MomentHeadModel alloc]init];
    headModel.moment = _moment;
    
    // 确定 headView的frame
    CGFloat headView_height = headModel.content_height;
    CGFloat headViewX = MomentCell_borderW;
    CGFloat headViewY = MomentCell_borderH;
    CGSize headViewSize = CGSizeMake(OMScreenW, headView_height);
    self.headViewF = (CGRect){{headViewX,headViewY},headViewSize};
    
    self.headModel = headModel;
    [headModel release];
    
    
    /**
     *  中间控件模型 内部包括各个子控件数据和高度等信息
     */
    MomentMiddleModel *middleModel = [[MomentMiddleModel alloc]init];
    middleModel.moment = _moment;
    
    // 确定 middleView的frame
    CGFloat middleView_height = middleModel.content_height;
    CGFloat middleViewX = MomentCell_borderW;
    CGFloat middleViewY = CGRectGetMaxY(self.headViewF) + MomentCell_borderH;
    CGSize middleViewSize = CGSizeMake(OMScreenW, middleView_height);
    self.middleViewF = (CGRect){{middleViewX,middleViewY},middleViewSize};
    
    self.middleModel = middleModel;
    [middleModel release];

    
    /**
     *  底部控件
     */
    MomentBottomModel *bottomModel = [[MomentBottomModel alloc]init];
    bottomModel.moment = _moment;
    
    // 确定 bottomView的frame
    CGFloat bottomView_height = bottomModel.content_height;
    CGFloat bottomX = MomentCell_borderW;
    CGFloat bottomY = CGRectGetMaxY(self.middleViewF) + MomentCell_borderH;;
    CGSize bottomViewSize = CGSizeMake(OMScreenW, bottomView_height);
    self.bottomViewF = (CGRect){{bottomX,bottomY},bottomViewSize};

    self.bottomModel = bottomModel;
    [bottomModel release];
    
    CGFloat bgViewX = MomentCell_borderW;
    CGFloat bgViewY = MomentCell_TopHeight;
    CGSize bgViewSize = CGSizeMake(OMScreenW, CGRectGetMaxY(self.bottomViewF));
    self.bgViewF = (CGRect){{bgViewX,bgViewY},bgViewSize};
    
    self.cellHeight = CGRectGetMaxY(self.bgViewF) + MomentCell_borderH;
}





@end
