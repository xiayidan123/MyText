//
//  MomentMiddleModel.h
//  dev01
//
//  Created by 杨彬 on 15/4/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Moment;
@class WTFile;
@class MomentLocationCellModel;
@class MomentRecordModel;


/** 左右间隔*/
#define MomentMiddle_borderW 10

/** 上下间隔*/
#define MomentMiddle_borderH 5

/** textLable 最大宽度*/
#define TextLableMaxW ( OMScreenW - MomentMiddle_borderW *2)

/** textLable 字体*/
#define TextLableFont [UIFont systemFontOfSize:12]


/** 缩略图 宽高*/
#define PhotoWH 90

/** 视频缩略图 宽高*/
#define VideoWH 90

/** 缩略图之间的间距*/
#define PhotoGap 5


/** 相册控件内边距 */
#define PhotoMargin 5

/** 相册控件 宽度*/
//#define album_collectionviewW (OMScreenW - MomentMiddle_borderW *2)


/** 音频控件 宽度*/
#define recordViewW (OMScreenW - MomentMiddle_borderW *2)

/** 音频控件 高度*/
#define recordViewH 35

/** 投票控件 宽度*/
#define voteViewW (OMScreenW - MomentMiddle_borderW *2)

/** 位置信息控件 宽度*/
#define LocationViewW (OMScreenW - MomentMiddle_borderW *2)


///** ActionView 的默认高度*/
//#define MomentBottom_ActionViewH 30




@interface MomentMiddleModel : NSObject

@property (retain, nonatomic)Moment *moment;


// 图片，视频
@property (retain, nonatomic)NSMutableArray *photo_array;

@property (retain, nonatomic) NSMutableArray * video_array;

// 投票
@property (retain, nonatomic)NSMutableArray *vote_option_array;

@property (assign, nonatomic)BOOL is_voted;

@property (assign, nonatomic)NSInteger voted_count;

// 语言
@property (retain, nonatomic)MomentRecordModel *record_model;

// 位置
@property (retain, nonatomic)MomentLocationCellModel *location_model;

@property (assign, nonatomic) CGFloat content_height;


/** textLable frame */
@property (assign, nonatomic) CGRect textLableF;

/** 相册控件（UICollectionView）*/
@property (assign, nonatomic) CGRect album_collectionviewF;

/** 录音控件 */
@property (assign, nonatomic) CGRect record_viewF;

/** 投票控件 */
@property (assign, nonatomic) CGRect vote_viewF;

/** 位置相关 */
@property (assign, nonatomic) CGRect location_viewF;




@end
