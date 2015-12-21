//
//  ClassRoom.h
//  dev01
//
//  Created by 杨彬 on 15/3/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassRoom : NSObject


@property (copy, nonatomic)NSString *classRoom_id;
@property (assign, nonatomic)NSInteger camaraCount;
@property (assign, nonatomic)BOOL has_camera;
@property (assign, nonatomic)BOOL has_multimedia;
@property (copy, nonatomic)NSString *room_name;
@property (copy, nonatomic)NSString *room_num;
@property (copy, nonatomic)NSString *school_id;
@property (assign, nonatomic)NSInteger studentCount;
@property (retain, nonatomic)NSMutableArray *cameraArray;


@property (assign, nonatomic)BOOL isSelected;


- (instancetype)initWithDict:(NSDictionary *)dic;


+ (instancetype)ClassRoomWithDic:(NSDictionary *)dic;


@end
