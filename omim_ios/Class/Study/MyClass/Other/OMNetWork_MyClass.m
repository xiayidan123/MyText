//
//  OMNetWork_MyClass.m
//  dev01
//
//  Created by 杨彬 on 15/3/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMNetWork_MyClass.h"

#import "NSString+Compare.h"

#import "WTUserDefaults.h"
#import "WTNetworkTask.h"
#import "WTNetworkTaskConstant.h"
#import "NSString+Compare.h"
#import "GlobalSetting.h"

// Model
#import "ClassRoom.h"
#import "ClassScheduleModel.h"
#import "Communicator_get_camera.h"
#import "ClassRoomCamera.h"
#import "OMClass.h"
#import "Lesson.h"
#import "Moment.h"
#import "Anonymous_Moment.h"

// Communicator
#import "Communicator_get_room.h"
#import "Communicator_use_room.h"
#import "Communicator_release_room.h"

#import "Communicator_NoDataCallBack.h"

#import "Communicator_get_lesson_detail.h"


#import "Communicator_AddLesson.h"
#import "Communicator_ModifyLesson.h"
#import "Communicator_deleteLesson.h"

#import "Communicator_GetSchoolList.h"
#import "Communicator_GetClassList.h"

#import "Communicator_GetLessonList.h"

#import "Communicator_NoDataFeedback.h"

#import "Communicator_Bind_Invitation_code.h"

#import "Communicator_get_class_bulletin.h"
#import "Communicator_add_class_bulletin.h"

#import "Communicator_AddMoment.h"

#import "Communicator_GetSchoolMembers.h"

#import "Communicator_get_class_member.h"


#import "Communicator_Upload_Lesson_Sign_In_Status.h"
#import "Communicator_Get_Lesson_Sign_In_Status.h"
#import "Communicator_ask_for_leave.h"
#import "Communicator_GetLessonHomework.h"
#import "Communicator_add_Lesson_Homework.h"
#import "Communicator_get_lesson_homework.h"
#import "Communicator_add_homework_result.h"
#import "Communicator_get_homework_state.h"
#import "Communicator_del_lesson_homework.h"
#import "Communicator_add_homework_review.h"
#import "Communicator_modify_homework.h"

#import "Communicator_get_class_moment.h"

#import "Communicator_GetBuddy.h"

@implementation OMNetWork_MyClass

+ (void)getClassRoomWithSchoolID:(NSString *)schoolID andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate withCallBack:(SEL)selector withObserver:(id)observer{
    if([NSString isEmptyString:schoolID]|| [NSString isEmptyString:startDate] || [NSString isEmptyString:endDate]){
        if(PRINT_LOG)NSLog(@"fRequireAccessCodeForUserName parametar cannot be null");
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_SCHOOL_LESSON_ROOM taskInfo:nil taskType:WT_GET_SCHOOL_LESSON_ROOM notificationName:WT_GET_SCHOOL_LESSON_ROOM notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_GET_SCHOOL_LESSON_ROOM];
    [postKeys addObject:@"uid"]; [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"]; [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"school_id"]; [postValues addObject:schoolID];
    [postKeys addObject:@"start_date"]; [postValues addObject:@([startDate longLongValue])];
    [postKeys addObject:@"end_date"]; [postValues addObject:@([endDate longLongValue])];
    [postKeys addObject:@"with_cameras_detail"]; [postValues addObject:@"1"];
    
    Communicator_get_room* netIFCommunicator = [[Communicator_get_room alloc] init];
    netIFCommunicator.delegate = task;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
//    [netIFCommunicator release];
}


+ (void)selectClassRoomWithClassRoom:(ClassRoom *)classRoom andLessonModel:(Lesson *)classSchedule withCallBack:(SEL)selector withObserver:(id)observer{
    if(! classRoom || !classSchedule){
        if(PRINT_LOG)NSLog(@"fRequireAccessCodeForUserName parametar cannot be null");
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_USE_SCHOOL_LESSON_ROOM taskInfo:nil taskType:WT_USE_SCHOOL_LESSON_ROOM notificationName:WT_USE_SCHOOL_LESSON_ROOM notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_USE_SCHOOL_LESSON_ROOM];
    [postKeys addObject:@"uid"]; [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"]; [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"room_id"]; [postValues addObject:classRoom.classRoom_id];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:classSchedule.lesson_id];
    
    
    
    Communicator_use_room* netIFCommunicator = [[Communicator_use_room alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.classRoom = classRoom;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
//    [netIFCommunicator release];
}


+ (void)getCameraWithClassRoom:(ClassRoom *)classRoom withCallBack:(SEL)selector withObserver:(id)observer{
    if(!classRoom){
        if(PRINT_LOG)NSLog(@"WT_GET_SCHOOL_LESSON_CAMERA 接口入口参数不全");
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_SCHOOL_LESSON_CAMERA taskInfo:nil taskType:WT_GET_SCHOOL_LESSON_CAMERA notificationName:WT_GET_SCHOOL_LESSON_CAMERA notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_GET_SCHOOL_LESSON_CAMERA];
    [postKeys addObject:@"uid"]; [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"]; [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"school_id"]; [postValues addObject:classRoom.school_id];
    [postKeys addObject:@"room_id"]; [postValues addObject:classRoom.classRoom_id];
    
    Communicator_get_camera* netIFCommunicator = [[Communicator_get_camera alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.portName = WT_GET_SCHOOL_LESSON_CAMERA;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    //    [netIFCommunicator release];
}


+ (void)getCameraByLessonID:(NSString *)lesson_id withClassModel:(ClassModel *)classModel  withCallBack:(SEL)selector withObserver:(id)observer{
    if([NSString isEmptyString:lesson_id]){
        if(PRINT_LOG)NSLog(@"WT_GET_SCHOOL_LESSON_CAMERA_BYLESSONID 接口入口参数不全");
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_SCHOOL_LESSON_CAMERA_BYLESSONID taskInfo:nil taskType:WT_GET_SCHOOL_LESSON_CAMERA_BYLESSONID notificationName:WT_GET_SCHOOL_LESSON_CAMERA_BYLESSONID notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_GET_SCHOOL_LESSON_CAMERA_BYLESSONID];
    [postKeys addObject:@"uid"]; [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"]; [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"school_id"]; [postValues addObject:classModel.school_id];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    
    
    Communicator_get_camera* netIFCommunicator = [[Communicator_get_camera alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.portName = WT_GET_SCHOOL_LESSON_CAMERA_BYLESSONID;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    //    [netIFCommunicator release];
}



+ (void)setCameraStatusWithCameraArray:(NSArray *)cameraArray withCallBack:(SEL)selector withObserver:(id)observer{
    if(!cameraArray || cameraArray.count == 0){
        if(PRINT_LOG)NSLog(@"WT_SET_SCHOOL_LESSON_CAMERA_STATUS 接口入口参数不全");
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_SET_SCHOOL_LESSON_CAMERA_STATUS taskInfo:nil taskType:WT_SET_SCHOOL_LESSON_CAMERA_STATUS notificationName:WT_SET_SCHOOL_LESSON_CAMERA_STATUS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_SET_SCHOOL_LESSON_CAMERA_STATUS];
    [postKeys addObject:@"uid"]; [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"]; [postValues addObject:[WTUserDefaults getHashedPassword]];
    
    int cameraArrayCount = (int)(cameraArray.count);
    for (int i=0 ; i < cameraArrayCount; i++) {
        ClassRoomCamera *classRoomCamera = cameraArray[i];
        if (i==0){
            [postKeys addObject:@"school_id"]; [postValues addObject:classRoomCamera.school_id];
        }
        
        [postKeys addObject:@"camera_id[]"]; [postValues addObject:classRoomCamera.camera_id];
        [postKeys addObject:@"status[]"]; [postValues addObject:@(classRoomCamera.status)];
    }
    
    Communicator_get_camera* netIFCommunicator = [[Communicator_get_camera alloc] init];
    netIFCommunicator.delegate = task;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    //    [netIFCommunicator release];
}
+ (void)StudentGetLessonDetailWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer{
    if([NSString isEmptyString:lesson_id]){
        if(PRINT_LOG)NSLog(@"WT_GET_SCHOOL_LESSON_DETAIL 接口入口参数不全");
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_SCHOOL_LESSON_DETAIL taskInfo:nil taskType:WT_GET_SCHOOL_LESSON_DETAIL notificationName:WT_GET_SCHOOL_LESSON_DETAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_GET_SCHOOL_LESSON_DETAIL];
    [postKeys addObject:@"uid"]; [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"]; [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [postKeys addObject:@"with_all_students_performances"];[postValues addObject:@"0"];
    [postKeys addObject:@"with_all_students_parent_feedbacks"];[postValues addObject:@"0"];
    Communicator_get_lesson_detail * netIFCommunicator = [[Communicator_get_lesson_detail alloc] init];
    netIFCommunicator.delegate = task;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}
//get_lesson_detail
+ (void)getLessonDetailWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer{
    if([NSString isEmptyString:lesson_id]){
        if(PRINT_LOG)NSLog(@"WT_GET_SCHOOL_LESSON_DETAIL 接口入口参数不全");
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_SCHOOL_LESSON_DETAIL taskInfo:nil taskType:WT_GET_SCHOOL_LESSON_DETAIL notificationName:WT_GET_SCHOOL_LESSON_DETAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_GET_SCHOOL_LESSON_DETAIL];
    [postKeys addObject:@"uid"]; [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"]; [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [postKeys addObject:@"with_all_students_performances"];[postValues addObject:@"1"];
    [postKeys addObject:@"with_all_students_parent_feedbacks"];[postValues addObject:@"1"];
    Communicator_get_lesson_detail * netIFCommunicator = [[Communicator_get_lesson_detail alloc] init];
    netIFCommunicator.delegate = task;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    //    [netIFCommunicator release];
}

//release_room
+ (void)releaseRoomWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer{
    if([NSString isEmptyString:lesson_id]){
        if(PRINT_LOG)NSLog(@"WT_RELEASE_SCHOOL_LESSON_ROOM 接口入口参数不全");
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_RELEASE_SCHOOL_LESSON_ROOM taskInfo:nil taskType:WT_RELEASE_SCHOOL_LESSON_ROOM notificationName:WT_RELEASE_SCHOOL_LESSON_ROOM notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_RELEASE_SCHOOL_LESSON_ROOM];
    [postKeys addObject:@"uid"]; [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"]; [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    
    Communicator_release_room * netIFCommunicator = [[Communicator_release_room alloc] init];
    netIFCommunicator.delegate = task;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}



+ (void)addLessonWithLessonModel:(Lesson *)lesson WithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if (lesson == nil
        ||[NSString isEmptyString:lesson.class_id]
        ||[NSString isEmptyString:lesson.title]
        ||[NSString isEmptyString:lesson.start_date]
        ||[NSString isEmptyString:lesson.end_date]){
        [WTHelper WTLog:[NSString stringWithFormat:@"network for %@ Param is lack",WT_ADD_SCHOOL_LESSON]];
        return;
        
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_ADD_SCHOOL_LESSON taskInfo:nil taskType:WT_ADD_SCHOOL_LESSON notificationName:WT_ADD_SCHOOL_LESSON notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_AddLesson *netIFCommunitor = [[Communicator_AddLesson alloc]init];
    netIFCommunitor.lesson = lesson;
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"class_id",@"title",@"start_date",@"end_date",@"live",nil];
    NSMutableArray *postValues = [[NSMutableArray alloc] initWithObjects:WT_ADD_SCHOOL_LESSON, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],lesson.class_id,lesson.title,lesson.start_date,lesson.end_date,lesson.live,nil] ;
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}


+ (void)modifyLessonWithLessonModel:(Lesson *)lesson WithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if (lesson == nil
        ||[NSString isEmptyString:lesson.class_id]
        ||[NSString isEmptyString:lesson.title]
        ||[NSString isEmptyString:lesson.start_date]
        ||[NSString isEmptyString:lesson.end_date]
        ||[NSString isEmptyString:lesson.lesson_id]){
        [WTHelper WTLog:[NSString stringWithFormat:@"network for %@ Param is lack",WT_MODIFY_SCHOOL_LESSON]];
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_MODIFY_SCHOOL_LESSON taskInfo:nil taskType:WT_MODIFY_SCHOOL_LESSON notificationName:WT_MODIFY_SCHOOL_LESSON notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_ModifyLesson *netIFCommunitor = [[Communicator_ModifyLesson alloc]init];
    netIFCommunitor.delegate = task;
    netIFCommunitor.lesson = lesson;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"class_id",@"lesson_id",@"title",@"start_date",@"end_date",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_MODIFY_SCHOOL_LESSON, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],lesson.class_id,lesson.lesson_id,lesson.title,lesson.start_date,lesson.end_date,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}

+ (void)deletecLessonWithLessonModel:(Lesson *)lesson WithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if (lesson == nil
        ||[NSString isEmptyString:lesson.lesson_id]){
        [WTHelper WTLog:[NSString stringWithFormat:@"network for %@ Param is lack",WT_DEL_SCHOOL_LESSON]];
        return;
        
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_DEL_SCHOOL_LESSON taskInfo:nil taskType:WT_DEL_SCHOOL_LESSON notificationName:WT_DEL_SCHOOL_LESSON notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_deleteLesson *netIFCommunitor = [[Communicator_deleteLesson alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"lesson_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_DEL_SCHOOL_LESSON, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],lesson.lesson_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
    
}

/**
 *  get_school_user_in
 *
 */
+ (void)getSchoolListWithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_SCHOOL_USER_IN taskInfo:nil taskType:MY_CLASS_GET_SCHOOL_USER_IN notificationName:MY_CLASS_GET_SCHOOL_USER_IN notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetSchoolList *netIFCommunitor = [[Communicator_GetSchoolList alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:MY_CLASS_GET_SCHOOL_USER_IN, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}


+ (void)getClassroomListWithSchoolID:(NSString *)school_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if (school_id==nil) {
        NSLog(@"getClassroomListWithSchoolID:nil....do nothing");
        return;
    }
    
    NSString *unqstr = [MY_CLASS_GET_CLASS_LIST stringByAppendingString:school_id];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:nil taskType:MY_CLASS_GET_CLASS_LIST notificationName:MY_CLASS_GET_CLASS_LIST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetClassList *netIFCommunitor = [[Communicator_GetClassList alloc]init];
    netIFCommunitor.delegate = task;
    netIFCommunitor.school_id = school_id;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"corp_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:MY_CLASS_GET_CLASS_LIST, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],school_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}


//get_classroom_user_in
+ (void)getClassListWithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_CLASS_LIST taskInfo:nil taskType:MY_CLASS_GET_CLASS_LIST notificationName:MY_CLASS_GET_CLASS_LIST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetClassList *netIFCommunitor = [[Communicator_GetClassList alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:MY_CLASS_GET_CLASS_LIST, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}



//get_lesson
+ (void)getLessoListWithClassID:(OMClass *)classModel WithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted] || [classModel.groupID length]==0) {
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@%@",MY_CLASS_GET_LESSON_LIST,classModel.groupID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:key taskInfo:nil taskType:MY_CLASS_GET_LESSON_LIST notificationName:MY_CLASS_GET_LESSON_LIST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetLessonList *netIFCommunitor = [[Communicator_GetLessonList alloc]init];
    netIFCommunitor.class_id = classModel.groupID;
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"class_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:MY_CLASS_GET_LESSON_LIST, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],classModel.groupID,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}



//bind_with_invitation_code
+ (void)bindInvitationCode:(NSString *)invitationCode withCallback:(SEL)selector withObserver:(id)observer{
    if (invitationCode==nil) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [WTHelper WTLog:@"engine is not set up"];
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_BIND_INVITATION_CODE taskInfo:nil taskType:WT_BIND_INVITATION_CODE notificationName:WT_BIND_INVITATION_CODE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_Bind_Invitation_code * netIFCommunicator = [[Communicator_Bind_Invitation_code alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"action"]; [postValues addObject:WT_BIND_INVITATION_CODE];
    [postKeys addObject:@"invitation_code"]; [postValues addObject:invitationCode];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}


+ (void)modifyClassInfoWithClassModel:(OMClass *)classModel  WithCallBack:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [WTHelper WTLog:@"engine is not set up"];
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_MODIFY_CLASS_INFO taskInfo:nil taskType:MY_CLASS_MODIFY_CLASS_INFO notificationName:MY_CLASS_MODIFY_CLASS_INFO notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_NoDataFeedback* netIFCommunicator = [[Communicator_NoDataFeedback alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_MODIFY_CLASS_INFO];
    [postKeys addObject:@"class_id"]; [postValues addObject:classModel.groupID];
    [postKeys addObject:@"start_day"]; [postValues addObject:classModel.start_day];
    [postKeys addObject:@"end_day"]; [postValues addObject:classModel.end_day];
    [postKeys addObject:@"start_time"]; [postValues addObject:classModel.start_time];
    [postKeys addObject:@"end_time"]; [postValues addObject:classModel.end_time];
    [postKeys addObject:@"intro"]; [postValues addObject:classModel.intro];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}




//get_class_bulletin
+ (void)getClassBulletinWithClassModel:(OMClass *)classModel timestamp:(NSString *)start_timeInterval count:(NSInteger)count WithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted] ) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_CLASS_BULLETIN taskInfo:nil taskType:MY_CLASS_GET_CLASS_BULLETIN notificationName:MY_CLASS_GET_CLASS_BULLETIN notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_get_class_bulletin *netIFCommunitor = [[Communicator_get_class_bulletin alloc]init];
    netIFCommunitor.delegate = task;
    
    
    NSMutableArray *postKeys = [[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,nil];
    NSMutableArray *postValues = [[NSMutableArray alloc] initWithObjects:MY_CLASS_GET_CLASS_BULLETIN, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],nil];
    
    if (count != 0){
        [postKeys addObject:@"count"];
        [postValues addObject:@(count)];
    }
    
    if (classModel != nil && classModel.groupID.length != 0){
        [postKeys addObject:@"class_id"];
        [postValues addObject:classModel.groupID];
    }
    
    [postKeys addObject:@"older_than"];
    if (start_timeInterval == nil){
        NSString *older_than = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        [postValues addObject:older_than];
    }else{
        [postValues addObject:start_timeInterval];
    }
    
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
//    [netIFCommunitor release];
}



//add_class_bulletin
+ (void)addClassBulletinWithClass_array:(NSMutableArray *)class_array moment_id:(NSString *)moment_id  WithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted] || moment_id.length == 0 || class_array.count == 0) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_ADD_CLASS_BULLETIN taskInfo:nil taskType:MY_CLASS_ADD_CLASS_BULLETIN notificationName:MY_CLASS_ADD_CLASS_BULLETIN notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_add_class_bulletin *netIFCommunitor = [[Communicator_add_class_bulletin alloc]init];
    netIFCommunitor.class_array = class_array;
    netIFCommunitor.delegate = task;
    
    
    NSMutableArray *postKeys = [[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"moment_id",nil];
    NSMutableArray *postValues = [[NSMutableArray alloc] initWithObjects:MY_CLASS_ADD_CLASS_BULLETIN, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],moment_id,nil];
    
    int count = (int)(class_array.count);
    for (int i=0; i<count; i++){
        OMClass *class = class_array[i];
        [postKeys addObject:@"class_id[]"];
        [postValues addObject:class.groupID];
    }
    
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}


// add_moment
+ (void)addMomentToClassBulletin:(NSString *)content withCallback:(SEL)selector withObserver:(id)observer
{
    if (content == nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_ADD_CLASS_BULLETIN_MOMENT taskInfo:nil taskType:MY_CLASS_ADD_CLASS_BULLETIN_MOMENT notificationName:MY_CLASS_ADD_CLASS_BULLETIN_MOMENT notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Anonymous_Moment* moment = [[Anonymous_Moment alloc] initWithMomentID:nil withText:content withOwerID:[WTUserDefaults getUid] withUserType:[WTUserDefaults getUsertype] withNickname:[WTUserDefaults getNickname] withTimestamp:nil withLongitude:nil withLatitude:nil withPrivacyLevel:@"0" withAllowReview:@"0" withLikedByMe:nil withPlacename:nil withMomentType:nil withDeadline:Nil];
    
    Communicator_AddMoment *netIFCommunicator = [[Communicator_AddMoment alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.moment = moment;
    netIFCommunicator.isAnonymous = YES;
    
    [moment release];
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, TEXT_CONTENT,@"anonymous", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:MY_CLASS_ADD_CLASS_BULLETIN_MOMENT,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],content,@"1", nil] autorelease];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


//get_class_teachers
+ (void)getClassTeachersWithClass_id:(NSString *)class_id withCallback:(SEL)selector withObserver:(id)observer
{
    if (class_id.length == 0) return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_CLASS_TEACHER_LIST taskInfo:nil taskType:MY_CLASS_GET_CLASS_TEACHER_LIST notificationName:MY_CLASS_GET_CLASS_TEACHER_LIST notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Communicator_get_class_member *netIFCommunicator = [[Communicator_get_class_member alloc] init];
    netIFCommunicator.class_id = class_id;
    netIFCommunicator.member_type = 2;
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"class_id", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:MY_CLASS_GET_CLASS_TEACHER_LIST,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],class_id, nil] autorelease];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}




//get_class_students
+ (void)getClassStudentsWithClass_id:(NSString *)class_id withCallback:(SEL)selector withObserver:(id)observer
{
    if (class_id.length == 0) return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_CLASS_STUDENT_LIST taskInfo:nil taskType:MY_CLASS_GET_CLASS_STUDENT_LIST notificationName:MY_CLASS_GET_CLASS_STUDENT_LIST notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Communicator_get_class_member *netIFCommunicator = [[Communicator_get_class_member alloc] init];
    netIFCommunicator.class_id = class_id;
    netIFCommunicator.member_type = 1;
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"class_id", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:MY_CLASS_GET_CLASS_STUDENT_LIST,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],class_id, nil] autorelease];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+ (void)getClassMembersWithClass_id:(NSString *)class_id withCallback:(SEL)selector withObserver:(id)observer{
    if (class_id.length == 0) return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_CLASS_MEMBERS taskInfo:nil taskType:MY_CLASS_GET_CLASS_MEMBERS notificationName:MY_CLASS_GET_CLASS_MEMBERS notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Communicator_get_class_member *netIFCommunicator = [[Communicator_get_class_member alloc] init];
    netIFCommunicator.class_id = class_id;
    netIFCommunicator.member_type = 0;
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"class_id", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:MY_CLASS_GET_CLASS_MEMBERS,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],class_id, nil] autorelease];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+ (void)uploadLesson_sign_in_status_withLessonID:(NSString *)lesson_id withStudent_array:(NSArray *)student_array withStatus_array:(NSArray *)status_array WithCallBack:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]
        || lesson_id.length == 0
        || status_array.count == 0
        || status_array.count == 0) {
        return;
    }
    
    
    NSString *uniqueKey = [NSString stringWithFormat:@"%@-%@",MY_CLASS_ADD_LESSON_SIGN_IN_STATUS,[status_array firstObject]];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueKey taskInfo:nil taskType:MY_CLASS_ADD_LESSON_SIGN_IN_STATUS notificationName:MY_CLASS_ADD_LESSON_SIGN_IN_STATUS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_Upload_Lesson_Sign_In_Status * netIFCommunicator = [[Communicator_Upload_Lesson_Sign_In_Status alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_ADD_LESSON_SIGN_IN_STATUS];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [postKeys addObject:@"notify"]; [postValues addObject:@"1"];
    
    NSInteger student_count = status_array.count;
    NSInteger status_count = status_array.count;
    if (student_count != status_count) return;
    
    for (int i=0; i< student_count; i++){
        NSString *student_id = student_array[i];
        NSString *status_id = status_array[i];
        [postKeys addObject:@"student_id[]"];
        [postValues addObject:student_id];
        
        [postKeys addObject:@"property_id[]"];
        [postValues addObject:@"10"];
        
        [postKeys addObject:@"property_value[]"];
        [postValues addObject:status_id];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+ (void)getLesson_sign_in_status_withLessonID:(NSString *)lesson_id withStudent_id:(NSString *)student_id withCallBack:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]
        || lesson_id.length == 0) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_LESSON_SIGN_IN_STATUS taskInfo:nil taskType:MY_CLASS_GET_LESSON_SIGN_IN_STATUS notificationName:MY_CLASS_GET_LESSON_SIGN_IN_STATUS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    
    Communicator_Get_Lesson_Sign_In_Status * netIFCommunicator = [[Communicator_Get_Lesson_Sign_In_Status alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.lesson_id = lesson_id;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_GET_LESSON_SIGN_IN_STATUS];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [postKeys addObject:@"property_id"]; [postValues addObject:@"10"];
    [postKeys addObject:@"student_id"];[postValues addObject:student_id];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+ (void)uploadLesson_ask_for_leaveWithLesson_id:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]
        || lesson_id.length == 0) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_ASK_FOR_LEAVE taskInfo:nil taskType:MY_CLASS_ASK_FOR_LEAVE notificationName:MY_CLASS_ASK_FOR_LEAVE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    Communicator_ask_for_leave * netIFCommunicator = [[Communicator_ask_for_leave alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_ASK_FOR_LEAVE];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}


#pragma mark - HomeWork
+ (void)getHomeWorkWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]
        || lesson_id.length == 0) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_LESSON_HOMEWORK taskInfo:nil taskType:MY_CLASS_GET_LESSON_HOMEWORK notificationName:MY_CLASS_GET_LESSON_HOMEWORK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    Communicator_GetLessonHomework * netIFCommunicator = [[Communicator_GetLessonHomework alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_GET_LESSON_HOMEWORK];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+ (void)AddLessonHomeWorkWithLessonID:(NSString *)lesson_id WithMomentID:(NSString *)moment_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]
        || lesson_id.length == 0) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_ADD_LESSON_HOMEWORK taskInfo:nil taskType:MY_CLASS_ADD_LESSON_HOMEWORK notificationName:MY_CLASS_ADD_LESSON_HOMEWORK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    Communicator_add_Lesson_Homework * netIFCommunicator = [[Communicator_add_Lesson_Homework alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_ADD_LESSON_HOMEWORK];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [postKeys addObject:@"moment_id"]; [postValues addObject:moment_id];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+ (void)getHomeWorkStateWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]
        || lesson_id.length == 0) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_HOMEWORK_STATE taskInfo:nil taskType:MY_CLASS_GET_HOMEWORK_STATE notificationName:MY_CLASS_GET_HOMEWORK_STATE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    Communicator_get_homework_state * netIFCommunicator = [[Communicator_get_homework_state alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_GET_HOMEWORK_STATE];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}



+ (void)getLessonHomeWorkWithLessonID:(NSString *)lesson_id withStudent_id:(NSString *)student_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]
        || lesson_id.length == 0) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_GET_LESSON_HOMEWORK taskInfo:nil taskType:MY_CLASS_GET_LESSON_HOMEWORK notificationName:MY_CLASS_GET_LESSON_HOMEWORK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    Communicator_get_lesson_homework * netIFCommunicator = [[Communicator_get_lesson_homework alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_GET_LESSON_HOMEWORK];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    
    if (student_id.length > 0){
        [postKeys addObject:@"student_id"]; [postValues addObject:student_id];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}


+ (void)getLessonHomeWorkWithLessonID:(NSString *)lesson_id withCallBack:(SEL)selector withObserver:(id)observer{
    [OMNetWork_MyClass getLessonHomeWorkWithLessonID:lesson_id withStudent_id:nil withCallBack:selector withObserver:observer];
}


+ (void)addHomeworkResultWithHomeworkID:(NSString *)homework_id WithMomentID:(NSString *)moment_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]
        || homework_id.length == 0 || moment_id.length == 0) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_ADD_HOMEWOKR_RESULT taskInfo:nil taskType:MY_CLASS_ADD_HOMEWOKR_RESULT notificationName:MY_CLASS_ADD_HOMEWOKR_RESULT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    Communicator_add_homework_result * netIFCommunicator = [[Communicator_add_homework_result alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_ADD_HOMEWOKR_RESULT];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"homework_id"]; [postValues addObject:homework_id];
    [postKeys addObject:@"moment_id"]; [postValues addObject:moment_id];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+ (void)deleteHomeworkWithHomeWorkID:(NSString *)homework_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]
        || homework_id.length == 0) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_DEL_HOMEWORK taskInfo:nil taskType:MY_CLASS_DEL_HOMEWORK notificationName:MY_CLASS_DEL_HOMEWORK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    Communicator_del_lesson_homework * netIFCommunicator = [[Communicator_del_lesson_homework alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_DEL_HOMEWORK];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"homework_id"]; [postValues addObject:homework_id];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}

+ (void)addHomeworkReviewWithHomeworkResultID:(NSString *)homeworkresult_id withRankDic:(NSDictionary *)rankDic WithContent:(NSString *)content withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]
        ) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_ADD_HOMEWORK_REVIEW taskInfo:nil taskType:MY_CLASS_ADD_HOMEWORK_REVIEW notificationName:MY_CLASS_ADD_HOMEWORK_REVIEW notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    Communicator_add_homework_review * netIFCommunicator = [[Communicator_add_homework_review alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_ADD_HOMEWORK_REVIEW];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"homeworkresult_id"]; [postValues addObject:homeworkresult_id];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"rank1"]; [postValues addObject:rankDic[@"rank1"]];
    [postKeys addObject:@"rank2"]; [postValues addObject:rankDic[@"rank2"]];
    [postKeys addObject:@"rank3"]; [postValues addObject:rankDic[@"rank3"]];
    [postKeys addObject:@"text"]; [postValues addObject:content];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}




+ (void)modifyLessonHomeWorkWithHomeworkID:(NSString *)homework_id WithMomentID:(NSString *)moment_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]
        || homework_id.length == 0) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_MODIFY_LESSON_HOMEWORK taskInfo:nil taskType:MY_CLASS_MODIFY_LESSON_HOMEWORK notificationName:MY_CLASS_MODIFY_LESSON_HOMEWORK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    NSString* strUID = [WTUserDefaults getUid];
    NSString* strPwd = [WTUserDefaults getHashedPassword];
    Communicator_modify_homework * netIFCommunicator = [[Communicator_modify_homework alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:MY_CLASS_MODIFY_LESSON_HOMEWORK];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"homework_id"]; [postValues addObject:homework_id];
    [postKeys addObject:@"moment_id"]; [postValues addObject:moment_id];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}


+ (void)getClassMomentsWithMaxtime:(NSInteger)maxTimeStamp class_id:(NSString *)class_id withTags:(NSArray*)tags withReview:(BOOL)needReview withCallback:(SEL)selector withObserver:(id)observer{
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:MY_CLASS_MOMENTS taskInfo:nil taskType:MY_CLASS_MOMENTS notificationName:MY_CLASS_MOMENTS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_get_class_moment *netIFCommunicator = [[Communicator_get_class_moment alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"class_id",@"with_review", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:MY_CLASS_MOMENTS,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],class_id,needReview?@"1":@"0", nil] autorelease];
    
    if(maxTimeStamp>0){
        [postKeys addObject:MAX_TIMESTAMP];
        [postValues addObject:[NSString stringWithFormat:@"%ld",(long)maxTimeStamp]];
    }
    
    for (NSNumber* number in tags) {
        [postKeys addObject:@"tag[]"];
        [postValues addObject:[NSString stringWithFormat:@"%ld",(long)number.integerValue]];
    }
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}





// 获取学校详情
+(void) getSchoolInfoWithUID:(NSString*)school_id withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(school_id==NULL){
        return;
    }
    
    NSString* uniquestr = [WT_GET_USER_BY_UID stringByAppendingString:school_id];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_USER_BY_UID notificationName:MY_CLASS_GETSCHOOLINFO notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_GetBuddy* netIFCommunicator = [[Communicator_GetBuddy alloc] init];
    netIFCommunicator.delegate = task;
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_buddy"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"buddy_id"]; [postValues addObject:school_id];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues forBuddyID:school_id];
    
    [postKeys release];
    [postValues release];
    
}






@end
