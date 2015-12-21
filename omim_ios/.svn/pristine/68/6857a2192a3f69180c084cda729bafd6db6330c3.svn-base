//
//  LessonDetailModel.h
//  dev01
//
//  Created by 杨彬 on 15/3/10.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassScheduleModel.h"
@class NewhomeWorkModel;

@interface LessonDetailModel : ClassScheduleModel

@property (retain, nonatomic)NSMutableArray *cameraArray;

@property (retain, nonatomic)NSMutableArray *roomArray;

@property (retain, nonatomic)NSMutableArray *performanceArray;

@property (retain, nonatomic)NSMutableArray *parentFeedbackArray;

@property (retain, nonatomic)NSMutableArray *homeWorkArray;

- (instancetype)initWithDict:(NSDictionary *)dic;


+ (instancetype)LessonDetailModelWithDic:(NSDictionary *)dic;

+ (NSMutableArray *)parseLessonDetailModel:(LessonDetailModel *)lessonDetailModel isTeacher:(BOOL)isTeacher;

@end
