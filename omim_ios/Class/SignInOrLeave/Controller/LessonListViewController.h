//
//  LessonListViewController.h
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class Lesson;
@protocol LessonListViewController <NSObject>

- (void)getLessonList:(Lesson *)lesson;

@end



@class OMClass;
@interface LessonListViewController : OMViewController
@property (retain, nonatomic) id<LessonListViewController>delegate;
@property (retain, nonatomic) OMClass *classModel;
@property (assign, nonatomic) BOOL isScreen;
//判断是否是签到请假页面过来
@property(assign,nonatomic)BOOL isLeave;
//判断是否是学生请假页面过来
@property(assign,nonatomic)BOOL  isSingln;
@end
