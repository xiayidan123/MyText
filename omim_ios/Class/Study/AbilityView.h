//
//  AbilityView.h
//  仪表盘
//
//  Created by 杨彬 on 14-10-11.
//  Copyright (c) 2014年 LiuHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbilityView : UIView



@property (nonatomic,retain)NSMutableArray *pointArray;

- (instancetype)initWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)image andScoreArray:(NSArray *)scoreArray;

@end
