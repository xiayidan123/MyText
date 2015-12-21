//
//  TCherHomeworkFrameModel.h
//  dev01
//
//  Created by Huan on 15/8/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

// 间距
#define Margin 15
// 正文字体
#define ContentFont [UIFont systemFontOfSize:14]

@class NewhomeWorkModel;

@interface TCherHomeworkFrameModel : NSObject


@property (retain, nonatomic) NewhomeWorkModel * homeworkModel;
/** 照片视图frame*/
@property (assign, nonatomic) CGRect photoViewFrame;
/** 补充说明frame*/
@property (assign, nonatomic) CGRect contentTextViewFrame;
/** 右侧按钮frame*/
@property (assign, nonatomic) CGRect rightBtnFrame;
/** 整体viewframe*/
@property (assign, nonatomic) CGSize checkViewSize;


@end
