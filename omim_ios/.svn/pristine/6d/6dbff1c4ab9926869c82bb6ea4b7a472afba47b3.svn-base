//
//  OMNetWork_MyClass.h
//  dev01
//
//  Created by 杨彬 on 15/3/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTNetworkTaskConstant.h"
#import "Database.h"
#import "WTError.h"

#import "OMNetWork_MyClass_Constant.h"

@class ClassRoom;
@class ClassScheduleModel;
@class OMClass;
@class Lesson;

@interface OMNetWork_MyClass : NSObject

/**
 *  获取物理教室列表
 *
 */
+ (void)getClassRoomWithSchoolID:(NSString *)schoolID andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate withCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  选择教室
 *
 */
//+ (void)selectClassRoomWithClassRoom:(ClassRoom *)classRoom andClassScheduleModel:(ClassScheduleModel *)classSchedule withCallBack:(SEL)selector withObserver:(id)observer;
+ (void)selectClassRoomWithClassRoom:(ClassRoom *)classRoom andLessonModel:(Lesson *)classSchedule withCallBack:(SEL)selector withObserver:(id)observer;

/**
 *  获取选定教室的相机列表
 *
 */
+ (void)getCameraWithClassRoom:(ClassRoom *)classRoom withCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  利用lesson_id获取摄像头列表
 *
 */
+ (void)getCameraByLessonID:(NSString *)lesson_id withClassModel:(ClassModel *)classModel  withCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  设置教室摄像头开关
 *
 */
+ (void)setCameraStatusWithCameraArray:(NSArray *)cameraArray withCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  获取课程详情
 *
 */
+ (void)getLessonDetailWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer;

/**
 *  解除绑定教室
 *
 */
+ (void)releaseRoomWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer;



/**
 *  添加新课表
 *
 */
+ (void)addLessonWithLessonModel:(Lesson *)lesson WithCallBack:(SEL)selector withObserver:(id)observer;

/**
 *  修改课表
 *
 */
+ (void)modifyLessonWithLessonModel:(Lesson *)lesson WithCallBack:(SEL)selector withObserver:(id)observer;

/**
 *  删除课表
 *
 */
+ (void)deletecLessonWithLessonModel:(Lesson *)lesson WithCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  get_school_user_in
 *
 */
+ (void)getSchoolListWithCallBack:(SEL)selector withObserver:(id)observer;


+ (void)getClassListWithCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  获取Lesson
 *
 */
+ (void)getLessoListWithClassID:(OMClass *)classModel WithCallBack:(SEL)selector withObserver:(id)observer;
/**
 *  学生本堂课的表现
 *
 */
+ (void)StudentGetLessonDetailWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer;

/**
 *  绑定邀请码
 *
 */
+(void) bindInvitationCode:(NSString *)invitationCode withCallback:(SEL)selector withObserver:(id)observer;


/**
 *  修改班级详情
 *
 */
+ (void)modifyClassInfoWithClassModel:(OMClass *)classModel  WithCallBack:(SEL)selector withObserver:(id)observer;



/**
 *  获取班级公告
 *  get_class_bulletin
 */
+ (void)getClassBulletinWithClassModel:(OMClass *)classModel timestamp:(NSString *)start_timeInterval count:(NSInteger)count WithCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  添加班级公告
 *  add_class_bulletin
 */
+ (void)addClassBulletinWithClass_array:(NSMutableArray *)class_array moment_id:(NSString *)moment_id  WithCallBack:(SEL)selector withObserver:(id)observer;

/**
 *  添加班级公告 moment
 *  add_moment
 */
+ (void)addMomentToClassBulletin:(NSString *)content withCallback:(SEL)selector withObserver:(id)observer;




/**
 *  根据class_id 获取老师名单
 *  get_class_teachers
 */
+ (void)getClassTeachersWithClass_id:(NSString *)class_id withCallback:(SEL)selector withObserver:(id)observer;



/**
 *  根据clas_id 获取学生名单
 *  get_class_students
 */
+ (void)getClassStudentsWithClass_id:(NSString *)class_id withCallback:(SEL)selector withObserver:(id)observer;

/**
 *  根据clas_id 获取班级成员名单
 */
+ (void)getClassMembersWithClass_id:(NSString *)class_id withCallback:(SEL)selector withObserver:(id)observer;

/**
 *  课堂签到
 *  add_lesson_performance
 */
+ (void)uploadLesson_sign_in_status_withLessonID:(NSString *)lesson_id withStudent_array:(NSArray *)student_array withStatus_array:(NSArray *)status_array WithCallBack:(SEL)selector withObserver:(id)observer;

/**
 *  获取课堂签到数据
 */
+ (void)getLesson_sign_in_status_withLessonID:(NSString *)lesson_id withStudent_id:(NSString *)student_id withCallBack:(SEL)selector withObserver:(id)observer;

/**
 *  学生请假
 */
+ (void)uploadLesson_ask_for_leaveWithLesson_id:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer;


/**
 * 根据lesson_id 获取homework对象
 */
+ (void)getHomeWorkWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer;

/**
 * 根据lesson_id 布置作业
 */
+ (void)AddLessonHomeWorkWithLessonID:(NSString *)lesson_id WithMomentID:(NSString *)moment_id withCallBack:(SEL)selector withObserver:(id)observer;


/**
 * 根据lesson_id 获取作业状态
 */

+ (void)getHomeWorkStateWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  根据lesson_id student_id 获取作业列表
 */

+ (void)getLessonHomeWorkWithLessonID:(NSString *)lesson_id withStudent_id:(NSString *)student_id withCallBack:(SEL)selector withObserver:(id)observer;
+ (void)getLessonHomeWorkWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer;



/**
 *  根据homework_id moment_id提交作业
 */

+ (void)addHomeworkResultWithHomeworkID:(NSString *)homework_id WithMomentID:(NSString *)moment_id withCallBack:(SEL)selector withObserver:(id)observer;

/**
 *  根据homework_id删除作业
 */

+ (void)deleteHomeworkWithHomeWorkID:(NSString *)homework_id withCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  根据学生提交的作业的ID 3个等级 和text评语 评论学生作业完成情况
 */

+ (void)addHomeworkReviewWithHomeworkResultID:(NSString *)homeworkresult_id withRankDic:(NSDictionary *)rankDic WithContent:(NSString *)content withCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  老师修改作业
 */
+ (void)modifyLessonHomeWorkWithHomeworkID:(NSString *)homework_id WithMomentID:(NSString *)moment_id withCallBack:(SEL)selector withObserver:(id)observer;


/**
 *  获取班级圈 moment
 */
+ (void)getClassMomentsWithMaxtime:(NSInteger)maxTimeStamp class_id:(NSString *)class_id withTags:(NSArray*)tags withReview:(BOOL)needReview withCallback:(SEL)selector withObserver:(id)observer;

/** 获取学校详情 */
+(void) getSchoolInfoWithUID:(NSString*)school_id withCallback:(SEL)selector withObserver:(id)observer;


@end
