//
//  MomentVoteCellModel.h
//  dev01
//
//  Created by 杨彬 on 15/4/14.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Option.h"

@interface MomentVoteCellModel : NSObject

@property (retain, nonatomic)Option *option;

@property (assign, nonatomic)CGFloat cellHeight;

@end
