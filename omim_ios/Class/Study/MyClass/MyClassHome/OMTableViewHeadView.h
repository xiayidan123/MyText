//
//  OMTableViewHeadView.h
//  dev01
//
//  Created by 杨彬 on 15/3/26.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMTableViewHeadView : UIView

@property (copy, nonatomic)NSString *title;;

+ (instancetype)omTableViewHeadViewWithTitle:(NSString *)title;

@end
