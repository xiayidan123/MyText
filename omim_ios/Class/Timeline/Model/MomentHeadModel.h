//
//  MomentHeadModel.h
//  dev01
//
//  Created by 杨彬 on 15/4/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Moment.h"

/** 左右间距 */
#define MomentHead_borderW 10

/** 上下间距 */
#define MomentHead_borderH 5

// 头像尺寸
#define MomentHead_headImageWH 30

/** 用户名字体 */
#define MomentHead_nameFont [UIFont systemFontOfSize:14]

/** 时间字体 */
#define MomentHead_timeFont [UIFont systemFontOfSize:12]

/** 默认时间Lable 宽度 */
#define MomentHead_timeLabelW 200





@interface MomentHeadModel : NSObject




@property (retain, nonatomic)Moment *moment;

/** 整个Moment顶部 部分的高度*/
@property (assign, nonatomic) CGFloat content_height;

/** 头像View的frame*/
@property (assign, nonatomic) CGRect headImageViewF;

/** 用户名Label的frame*/
@property (assign, nonatomic) CGRect nameLabelF;

/** 时间Label的frame*/
@property (assign, nonatomic) CGRect timeLabelF;

/** 用户类型View的frame*/
@property (assign, nonatomic) CGRect typeViewF;



@end
