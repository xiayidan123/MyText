//
//  MomentBottomModel.h
//  dev01
//
//  Created by 杨彬 on 15/4/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Moment;

/** 左右间隔*/
#define MomentBottom_borderW 10

/** 上下间隔*/
#define MomentBottom_borderH 5

/** ActionView 的默认高度*/
#define MomentBottom_ActionViewH 30





@interface MomentBottomModel : NSObject

@property (retain, nonatomic)Moment *moment;


@property (retain, nonatomic)NSMutableArray *review_array;

@property (assign, nonatomic)BOOL alreadyLike;

@property (assign, nonatomic)NSInteger like_count;

@property (assign, nonatomic)BOOL alreadyComment;

@property (assign, nonatomic)NSInteger comment_count;


/** moment底部部分 内容总体frame*/
@property (assign, nonatomic) CGFloat content_height;

/** 回复和点赞部分 frame*/
@property (assign, nonatomic) CGRect reviewViewF;

/** 功能按钮部分 frame*/
@property (assign, nonatomic) CGRect actionViewF;






@end

