//
//  ClassRoomVC.h
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class Lesson;
@class ClassRoomVC;
@class ClassRoom;
@class OMClass;


@protocol ClassRoomVCDelegate <NSObject>

- (void)didSelectedClassRoom:(ClassRoomVC *)classRoomVC withClassRoom:(ClassRoom *)classRoom;

- (void)didReleaseRoom:(ClassRoomVC *)classRoomVC withRoomID:(NSString *)room_id;

@end

@interface ClassRoomVC : OMViewController

@property (assign, nonatomic)id<ClassRoomVCDelegate>delegate;

@property (retain, nonatomic)Lesson *lessonModel;

@property (retain, nonatomic)OMClass *classModel;


@end
