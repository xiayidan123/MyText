//
//  MomentReviewCellModel.h
//  dev01
//
//  Created by 杨彬 on 15/4/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Review.h"

@interface MomentReviewCellModel : NSObject

@property (retain, nonatomic)Review *review;

@property (assign, nonatomic)CGFloat cellHeight;

@end
