//
//  CheckHomeworkFrameModel.h
//  dev01
//
//  Created by Huan on 15/7/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
// 间距
#define Margin 15
// 正文字体
#define ContentFont [UIFont systemFontOfSize:14]


@protocol CheckHomeworkFrameModelDelegate <NSObject>

- (void)heightForCheckHomeworkView:(CGFloat)height;

@end


@class NewhomeWorkModel;
@interface CheckHomeworkFrameModel : NSObject

@property (assign, nonatomic) id<CheckHomeworkFrameModelDelegate> delegate;

@property (retain, nonatomic) NewhomeWorkModel * homeworkModel;

@property (assign, nonatomic) CGRect photoViewFrame;

@property (assign, nonatomic) CGRect contentLabelFrame;

@property (assign, nonatomic) CGFloat checkViewHeight;

@end
