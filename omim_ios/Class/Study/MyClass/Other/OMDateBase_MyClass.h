//
//  OMDateBase_MyClass.h
//  dev01
//
//  Created by 杨彬 on 15/3/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMClass;
@class ClassScheduleModel;
@class Lesson;
@class Anonymous_Moment;
@class SchoolMember;
@class LessonPerformanceModel;
@class NewhomeWorkModel;
@interface OMDateBase_MyClass : NSObject


/**
 *  class 数据库存储
 *
 */
+ (BOOL)storeClassWithModel:(OMClass *)classModel;

/**
 *  判断聊天组是否是班级
 *
 */
+ (BOOL)isClassWithGroupID:(NSString *)group_id;

/**
 *  删除班级列表
 */
+(void)deleteMyClass;

/**
 *  删除某个学校的班级
 *
 */
+(void)deleteMyClassWithSchool_id:(NSString *)school_id;


/**
 *  根据school_id 获取班级列表
 *
 */
+ (NSMutableArray *)fetchClassWithSchoolID:(NSString *)school_id;


/**
 *  获取该用户所有相关联的班级
 *
 */
+ (NSMutableArray *)fetchAllClass;

/**
 *  存储课表
 *
 */
+ (BOOL)storeclassScheduleModel:(ClassScheduleModel *)classScheduleModel;



/**
 *  根据class_id 后去班级详情
 *
 */
+ (OMClass *)getClassWithClassID:(NSString *)class_id;



#pragma mark - Lesson

/**
 *  根据lesson_id 删除lesson
 *
 */
+ (BOOL)deleteLessonWithID:(NSString *)lesson_id;


/**
 *  删除班级里的全部lesson
 *
 */
+ (BOOL)deleteLessonWithClass_id:(NSString *)class_id;

/**
 *  存储lesson
 *
 */
+ (BOOL)storeLessonWithModel:(Lesson *)lesson;

/**
 *  获取当前班级正在直播的课程
 *
 */
+ (Lesson *)getLivingLessonWithClass_id:(NSString *)class_id withNowTime:(NSString *)nowTime;


/**
 *  利用 class_id 获取lesson 列表
 *
 */
+ (NSMutableArray *)fetchLessonWithClassID:(NSString *)class_id;



#pragma mark - SchoolMember

/**
 *  根据班级ID 和用户类型 获取班级成员列表
 */
+ (NSMutableArray *)fetchClassMemberByClassID:(NSString *)class_id andMemberType:(NSString *)user_type;

/**
 *  根据class_id 和 Member_id 获取班级成员对象
 */
+ (SchoolMember *)fetchClassMemberByClass_id:(NSString *)class_id andMember_id:(NSString *)member_id;


/**
 *  班级成员是否是已经添加为好友了
 */
+ (BOOL)schoolMemberAlreadyFriendByUserID:(NSString *)user_id;

/**
 *  储存 班级成员对象
 */
+ (BOOL)storeClassMember:(SchoolMember*)member;


#pragma mark - Anonymous Moment
/**
 *  存储隐私moment
 */
+ (BOOL)storeAnonymousMoment:(Anonymous_Moment*)moment;

+ (BOOL)storeAnonymousMoment_bulletin:(Anonymous_Moment*)moment;


/**
 *  根据id 获取班级通知
 */
+(Anonymous_Moment*)getAnonymousMomentWithID:(NSString*)moment_id;



/**
 *  获取某个班级的班级通知
 */
+ (NSMutableArray *)fetchClassBulletinWithClass_id:(NSString *)class_id;



/**
 *  获取所有班级通知
 */
+ (NSMutableArray *)fetchAllClassBulletin;

+ (NSMutableArray *)fetch_classBulletinWitchClass_id:(NSString *)class_id with_starTime:(NSString *)start_time;

/**
 *  删除班级成员
 */
+(void)deleteCLassMembersWithClass_id:(NSString *)class_id withMember_type:(NSInteger)member_type;


/**
 *  存储签到or 课堂表现
 */
+ (BOOL)storeLessonPerformance:(LessonPerformanceModel *)lessonPerformanceModel;

/**
 *  获取学生课堂表现or 签到情况
 */
+ (NSMutableArray *)fetchLessonPerformanceWithStudent_id:(NSString *)student_id WithLesson_id:(NSString *)lesson_id withProperty_id:(NSString *)property_id;

/**
 *  获取签到学生列表
 */
+ (NSMutableArray *)fetchLessonPerformanceWithStudent_id:(NSString *)student_id WithLesson_id:(NSString *)lesson_id withProperty_id:(NSString *)property_id property_value:(NSString *)property_value;


/**
 *  存储homework对象
 */
+ (void)storeHomeworkWithLesson_id:(NSString *)lesson_id;

/**
 *  获取homework对象
 */
+ (NewhomeWorkModel *)fetchHomeworkWithLesson_id:(NSString *)lesson_id;
@end
