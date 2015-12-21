//
//  OMDatabase_moment.h
//  dev01
//
//  Created by 杨彬 on 15/5/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Moment.h"

@interface OMDatabase_moment : NSObject

/** 获取buddy的朋友圈图片数据 */
+ (NSMutableArray *)getLastMomentPhotosWithBuddy_id:(NSString *)buddy_id;

/** 获取Buddy 最近的一天数据 */
+ (Moment *)getTheLastMomentWithBuddy_id:(NSString*)buddy_id;

+ (BOOL)store_NewMoment_bySelfUpload:(Moment*)moment withImage_array:(NSArray *)image_array;

@end
