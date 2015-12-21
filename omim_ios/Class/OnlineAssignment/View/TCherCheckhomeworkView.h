//
//  TCherCheckhomeworkView.h
//  dev01
//
//  Created by Huan on 15/8/4.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCherCheckhomeworkViewDelegate <NSObject>

- (void)pushViewController;

@end

@class TCherHomeworkFrameModel;
@interface TCherCheckhomeworkView : UIView
@property (retain, nonatomic) TCherHomeworkFrameModel * homeworkFrameModel;
@property (assign, nonatomic) id delegate;
@end
