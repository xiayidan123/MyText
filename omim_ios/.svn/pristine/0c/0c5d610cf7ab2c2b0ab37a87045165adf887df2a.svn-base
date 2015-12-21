//
//  MomentCellModel.h
//  dev01
//
//  Created by 杨彬 on 15/4/8.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Moment.h"

#import "MomentHeadModel.h"
#import "MomentMiddleModel.h"
#import "MomentBottomModel.h"


/** 左右间隔*/
#define MomentCell_TopHeight 10

/** 左右间隔*/
#define MomentCell_borderW 0

/** 上下间隔*/
#define MomentCell_borderH 0

///** ActionView 的默认高度*/
//#define MomentBottom_ActionViewH 30


@class WTFile;
@class MomentLocationCellModel;
@interface MomentCellModel : NSObject

@property (retain, nonatomic)Moment *moment;

#pragma mark - 头部

@property (retain, nonatomic)MomentHeadModel *headModel;

@property (assign, nonatomic) CGRect headViewF;


#pragma mark - 中部


@property (retain, nonatomic)MomentMiddleModel *middleModel;

@property (assign, nonatomic) CGRect middleViewF;


#pragma mark - 底部

@property (retain, nonatomic)MomentBottomModel *bottomModel;

@property (assign, nonatomic) CGRect bottomViewF;


/**
 *  cell的 总高度
 */

@property (assign, nonatomic) CGRect bgViewF;

@property (assign, nonatomic)CGFloat cellHeight;



























@end
