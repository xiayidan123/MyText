//
//  MomentCellDenfine.h
//  dev01
//
//  Created by 杨彬 on 15/4/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

/**
 *  朋友圈页面 cell 各个子视图高度宏文件，修改宏文件即修改实际cell各个子控件的位置尺寸，cell会自适应这个变化（已过期）
 */


#ifndef dev01_MomentCellDenfine_h
#define dev01_MomentCellDenfine_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define Top_Distance 10

#define HeadImageView_height 30 // moment 头像的尺寸 正方形|圆（宽度一样）


#define Distance_to_top 5 // 基本的距离顶部距离

#define Distance_to_bottom 5

#define Distance_to_leading 10

#define Distance_to_trailing -10



/**
 *  中间控件
 */

#define TextViewFontSize 12 // 文字的字体大小 默认系统字体

#define TextViewTop 0 // 文字距离上部距离

#define TextViewWidth (ScreenWidth - Distance_to_leading + Distance_to_trailing - 10)


#define PhotoWidth 90 //单个照片的宽高


#define VideoWidth 100 //视频的宽高

#define AlbumViewTop 5 // 相册视图距离上部距离

#define PhotoSpace 5 // 相片每行之间的间距

#define AlbumViewWidth 280 //整个相册视图的宽度


#define RecordViewTop 0 // 语音视图距离上部距离

#define recoredButtonHeight 30 // 语音播放按钮高度

#define RecordViewHeight 35 // 语音视图的高度（有语言时，没语言的时候直接等于0）


#define VoteViewTop 0 // 投票视图距离上部距离

#define VoteButtonHeight 50 // 投票按钮视图高度


#define VoteCellFontSize 12 // 投票cell的字体大小 默认系统字体

#define VoteCellTextWidth (ScreenWidth - 57) // 投票cell 文字label 宽度

#define VoteCellMinHeight 44; // 投票cell 最小的高度



#define LocationViewFontSize 12 // 位置视图的字体大小 默认系统字体

#define LocationTextWidth (ScreenWidth - 81) // 位置视图 文字label 宽度

#define LocationMinHeight 40; // 位置视图 最小的高度

/**
 *  底部控件
 */

#define review_tableView_top 10 // 回复tableView顶部距离高度


#define review_likeLabel_width (ScreenWidth - 29 - 25 - Distance_to_leading + Distance_to_trailing)// 点赞cell 中label的宽度

#define review_likeCell_minHeight 25 // 点赞cell 最小高度

#define review_textLabel_width (ScreenWidth - 29 - 25 - Distance_to_leading + Distance_to_trailing)// 点赞cell 中label的宽度

#define review_textCell_minHeight 20 // 文字回复cell 最小高度


#define review_actionView_top 5 // 底部功能view距离上一个控件高度

#define reviewActionView_height 40 // 底部功能view高度

#define aaa (HeadImageView_height + 20)




#endif
