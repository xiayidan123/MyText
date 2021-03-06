//
//  OMDateBase_MyClass.m
//  dev01
//
//  Created by 杨彬 on 15/3/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMDateBase_MyClass.h"

#import "GlobalSetting.h"
#import "WTUserDefaults.h"
#import "Database.h"


#import "OMClass.h"
#import "Lesson.h"
#import "ClassScheduleModel.h"
#import "SchoolMember.h"
#import "Anonymous_Moment.h"
#import "WTFile.h"
#import "Review.h"
#import "Option.h"
#import "LessonPerformanceModel.h"

@implementation OMDateBase_MyClass




+ (BOOL)storeClassWithModel:(OMClass *)classModel{
    
    FMDatabase *db = [Database shareDatabase];
    
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    FMResultSet *res = [db executeQuery:@"SELECT `class_id` FROM `class_list` WHERE `class_id` = ?", classModel.groupID];
    
    BOOL isUpdating=false;
    if (res && [res next])
    {
        isUpdating = true;
    }
    BOOL result = FALSE;
    
    
    if(isUpdating){
        result = [db executeUpdate:@"UPDATE `class_list` SET `class_name`=?,`name`=? ,`editable`=?,`short_class_id`=?,`intro`=?,`is_group_name_changed`=?,`is_member`=? ,`latitude`=?,`longitude`=?,`max_member`=?,`member_count`=?,`parent_id`=?,`temp_group_flag`=?,`thumbnail`=?,`photo`=? ,`school_id`=? ,`start_day`=? ,`end_day`=? ,`start_time`=? ,`end_time`=? ,`class_id`= ?  WHERE `class_id`=?",
                  classModel.groupNameOriginal
                  ,classModel.groupNameLocal
                  ,[NSString stringWithFormat:@"%d",classModel.editable]
                  ,classModel.short_class_id
                  ,classModel.intro
                  ,[NSString stringWithFormat:@"%d",classModel.is_group_name_changed]
                  ,[NSString stringWithFormat:@"%d",classModel.is_member]
                  ,classModel.latitude
                  ,classModel.longitude
                  ,[NSString stringWithFormat:@"%zi",classModel.maxNumber]
                  ,[NSString stringWithFormat:@"%zi",classModel.memberCount]
                  ,classModel.parent_id
                  ,classModel.temp_group_flag
                  ,classModel.thumbnail
                  ,classModel.photo
                  ,classModel.school_id
                  ,classModel.start_day
                  ,classModel.end_day
                  ,classModel.start_time
                  ,classModel.end_time
                  ,classModel.groupID
                  ,classModel.groupID];
    } else {
        result = [db executeUpdate:@"INSERT INTO `class_list` ( `class_id` , `class_name` , `name` , `editable` , `short_class_id` ,  `intro` , `is_group_name_changed` ,`is_member` , `latitude` , `longitude` , `max_member` , `member_count` , `parent_id` , `temp_group_flag` , `thumbnail` , `photo` , `school_id` , `start_day` , `end_day`, `start_time`, `end_time`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                  ,classModel.groupID
                  ,classModel.groupNameOriginal
                  ,classModel.groupNameLocal
                  ,[NSString stringWithFormat:@"%d",classModel.editable]
                  ,classModel.short_class_id
                  ,classModel.intro
                  ,[NSString stringWithFormat:@"%d",classModel.is_group_name_changed]
                  ,[NSString stringWithFormat:@"%d",classModel.is_member]
                  ,classModel.latitude
                  ,classModel.longitude
                  ,[NSString stringWithFormat:@"%zi",classModel.maxNumber]
                  ,[NSString stringWithFormat:@"%zi",classModel.memberCount]
                  ,classModel.parent_id
                  ,classModel.temp_group_flag
                  ,classModel.thumbnail
                  ,classModel.photo
                  ,classModel.school_id
                  ,classModel.start_day
                  ,classModel.end_day
                  ,classModel.start_time
                  ,classModel.end_time];
    }
    
    
    if (newTransaction) {
        [db commit];
    }
    [res close];
    return result;
}

+ (BOOL)isClassWithGroupID:(NSString *)group_id{
    
    FMDatabase *db = [Database shareDatabase];
    
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `class_list` WHERE `class_id` = ?", group_id];
    
    BOOL isClass=false;
    if (res && [res next])
    {
        isClass = true;
    }
    
    if (newTransaction) {
        [db commit];
    }
    [res close];
    return isClass;
}

+(void)deleteMyClass{
    FMDatabase *db = [Database shareDatabase];
//    if(PRINT_LOG)NSLog(@"delete all class_list");
    BOOL success = [db executeUpdate:@"DELETE FROM `class_list`"];
    if (success){
        NSLog(@"sucess delete class_list");
    }
}

+(void)deleteMyClassWithSchool_id:(NSString *)school_id{
    FMDatabase *db = [Database shareDatabase];
//    if(PRINT_LOG)NSLog(@"delete all class_list");
    [db executeUpdate:@"DELETE FROM `class_list` WHERE `school_id`=?",school_id];
}


+ (NSMutableArray *)fetchClassWithSchoolID:(NSString *)school_id{
    FMDatabase *db = [Database shareDatabase];
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    
    NSMutableArray * classArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `class_list` WHERE `school_id`= ? ORDER BY `class_id` ASC ",school_id];
    
    while (res && [res next]) {
        OMClass *classModel = [[OMClass alloc]init];
        classModel.groupID = [res stringForColumn:@"class_id"];
        classModel.groupNameOriginal = [res stringForColumn:@"class_name"];
        classModel.groupNameLocal = [res stringForColumn:@"name"];
        classModel.editable = [[res stringForColumn:@"editable"] boolValue];
        classModel.short_class_id = [res stringForColumn:@"short_class_id"];
        classModel.intro = [res stringForColumn:@"intro"];
        classModel.is_group_name_changed = [[res stringForColumn:@"is_group_name_changed"] boolValue];
        classModel.is_member = [[res stringForColumn:@"is_member"] boolValue];
        classModel.latitude = [res stringForColumn:@"latitude"];
        classModel.longitude = [res stringForColumn:@"longitude"];
        classModel.maxNumber = [res stringForColumn:@"max_member"];
        classModel.memberCount = [res stringForColumn:@"member_count"];
        classModel.parent_id = [res stringForColumn:@"parent_id"];
        classModel.temp_group_flag = [res stringForColumn:@"temp_group_flag"];
        classModel.thumbnail = [res stringForColumn:@"thumbnail"];
        classModel.photo = [res stringForColumn:@"photo"];
        classModel.school_id = [res stringForColumn:@"school_id"];
        classModel.start_day = [res stringForColumn:@"start_day"];
        classModel.end_day = [res stringForColumn:@"end_day"];
        classModel.start_time = [res stringForColumn:@"start_time"];
        classModel.end_time = [res stringForColumn:@"end_time"];
        
        [classArray addObject:classModel];
        [classModel release];
    }
    [res close];
    return [classArray autorelease];
}


+ (NSMutableArray *)fetchAllClass{
    FMDatabase *db = [Database shareDatabase];
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    
    
    NSMutableArray * classArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `class_list` ORDER BY `school_id` ASC , `class_id` ASC"];
    
    while (res && [res next]) {
        
        OMClass *classModel = [[OMClass alloc]init];
        classModel.groupID = [res stringForColumn:@"class_id"];
        classModel.groupNameOriginal = [res stringForColumn:@"class_name"];
        classModel.groupNameLocal = [res stringForColumn:@"name"];
        classModel.editable = [[res stringForColumn:@"editable"] boolValue];
        classModel.short_class_id = [res stringForColumn:@"short_class_id"];
        classModel.intro = [res stringForColumn:@"intro"];
        classModel.is_group_name_changed = [[res stringForColumn:@"is_group_name_changed"] boolValue];
        classModel.is_member = [[res stringForColumn:@"is_member"] boolValue];
        classModel.latitude = [res stringForColumn:@"latitude"];
        classModel.longitude = [res stringForColumn:@"longitude"];
        classModel.maxNumber = [res stringForColumn:@"max_member"];
        classModel.memberCount = [res stringForColumn:@"member_count"];
        classModel.parent_id = [res stringForColumn:@"parent_id"];
        classModel.temp_group_flag = [res stringForColumn:@"temp_group_flag"];
        classModel.thumbnail = [res stringForColumn:@"thumbnail"];
        classModel.photo = [res stringForColumn:@"photo"];
        classModel.school_id = [res stringForColumn:@"school_id"];
        classModel.start_day = [res stringForColumn:@"start_day"];
        classModel.end_day = [res stringForColumn:@"end_day"];
        classModel.start_time = [res stringForColumn:@"start_time"];
        classModel.end_time = [res stringForColumn:@"end_time"];
        
        [classArray addObject:classModel];
        [classModel release];
    }
    [res close];
    return [classArray autorelease];
}

+ (OMClass *)getClassWithClassID:(NSString *)class_id{
    FMDatabase *db = [Database shareDatabase];
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `class_list` WHERE `class_id` = ? ",
                        class_id];
    
    while(res && [res next]){
        OMClass *classModel = [[OMClass alloc]init];
        classModel.groupID = [res stringForColumn:@"class_id"];
        classModel.groupNameOriginal = [res stringForColumn:@"class_name"];
        classModel.groupNameLocal = [res stringForColumn:@"name"];
        classModel.editable = [[res stringForColumn:@"editable"] boolValue];
        classModel.short_class_id = [res stringForColumn:@"short_class_id"];
        classModel.intro = [res stringForColumn:@"intro"];
        classModel.is_group_name_changed = [[res stringForColumn:@"is_group_name_changed"] boolValue];
        classModel.is_member = [[res stringForColumn:@"is_member"] boolValue];
        classModel.latitude = [res stringForColumn:@"latitude"];
        classModel.longitude = [res stringForColumn:@"longitude"];
        classModel.maxNumber = [res stringForColumn:@"max_member"];
        classModel.memberCount = [res stringForColumn:@"member_count"];
        classModel.parent_id = [res stringForColumn:@"parent_id"];
        classModel.temp_group_flag = [res stringForColumn:@"temp_group_flag"];
        classModel.thumbnail = [res stringForColumn:@"thumbnail"];
        classModel.photo = [res stringForColumn:@"photo"];
        classModel.school_id = [res stringForColumn:@"school_id"];
        classModel.start_day = [res stringForColumn:@"start_day"];
        classModel.end_day = [res stringForColumn:@"end_day"];
        classModel.start_time = [res stringForColumn:@"start_time"];
        classModel.end_time = [res stringForColumn:@"end_time"];
        [res close];
        return [classModel autorelease];
    }
    [res close];
    return nil;
}


#pragma mark - Lesson

+ (BOOL)deleteLessonWithID:(NSString *)lesson_id{
    FMDatabase *db = [Database shareDatabase];
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    BOOL result = [db executeUpdate:@"DELETE FROM `lesson_list` WHERE `lesson_id` = ?",lesson_id];
    if (!result) {
        if (newTransaction) {
            [db commit];
        }
        return NO;
    }
    if (newTransaction) {
        [db commit];
    }
    return result;
}

+ (BOOL)deleteLessonWithClass_id:(NSString *)class_id{
    FMDatabase *db = [Database shareDatabase];
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    BOOL result = [db executeUpdate:@"DELETE FROM `lesson_list` WHERE `class_id` = ?",class_id];
    if (!result) {
        if (newTransaction) {
            [db commit];
        }
        return NO;
    }
    if (newTransaction) {
        [db commit];
    }
    return result;
}


+ (BOOL)storeLessonWithModel:(Lesson *)lesson{
    FMDatabase *db = [Database shareDatabase];
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `lesson_list` WHERE `class_id` = ? AND `lesson_id`= ? ", lesson.class_id,lesson.lesson_id];
    
    BOOL isUpdating=false;
    if (res && [res next] )
    {
        isUpdating = true;
    }
    else{
        isUpdating=false;
    }
    BOOL result = FALSE;

    
    if(isUpdating){
        result = [db executeUpdate:@"UPDATE `lesson_list` SET `class_id`=? ,`lesson_id`=?, `title`=? , `start_date`=? ,`end_date`=? ,`live`=? ,`class_room_id`=? ,`class_room_name`=?  WHERE  `class_id` = ? AND `lesson_id`= ? ",
                  lesson.class_id,
                  lesson.lesson_id,
                  lesson.title,
                  lesson.start_date,
                  lesson.end_date,
                  lesson.live,
                  lesson.class_room_id,
                  lesson.class_room_name,
                  lesson.class_id,
                  lesson.lesson_id];
    } else {
        result = [db executeUpdate:@"INSERT INTO `lesson_list` (`class_id`, `lesson_id`, `title`,`start_date`,`end_date`,`live`,`class_room_id`,`class_room_name`) VALUES (?,?,?,?,?,?,?,?)"
                  ,lesson.class_id
                  ,lesson.lesson_id
                  ,lesson.title
                  ,lesson.start_date
                  ,lesson.end_date
                  ,lesson.live
                  ,lesson.class_room_id
                  ,lesson.class_room_name];
    }
    
    [db commit];
    [res close];
    return result;
}


/*
 *通过班级ID查询班级列表
 */
+ (NSMutableArray *)fetchLessonWithClassID:(NSString *)class_id {
    FMDatabase *db = [Database shareDatabase];
    NSMutableArray * lessonArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `lesson_list` WHERE `class_id`= ? ORDER BY `start_date` ASC",class_id];
    
    while (res && [res next]) {
        Lesson *lesson = [[Lesson alloc]init];
        lesson.class_id = [res stringForColumn:@"class_id"];
        lesson.lesson_id = [res stringForColumn:@"lesson_id"];
        lesson.title = [res stringForColumn:@"title"];
        lesson.start_date = [res stringForColumn:@"start_date"];
        lesson.end_date = [res stringForColumn:@"end_date"];
        lesson.live = [res stringForColumn:@"live"];
        lesson.class_room_id = [res stringForColumn:@"class_room_id"];
        lesson.class_room_name = [res stringForColumn:@"class_room_name"];
        
        [lessonArray addObject:lesson];
        [lesson release];
    }
    [res close];
    return [lessonArray autorelease];
}



+ (Lesson *)getLivingLessonWithClass_id:(NSString *)class_id withNowTime:(NSString *)nowTime{
    FMDatabase *db = [Database shareDatabase];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `lesson_list` WHERE `class_id`= ? AND `start_date`< ? AND `end_date`> ? AND `live`= ?"
                         ,class_id
                         ,nowTime
                         ,nowTime
                         ,@"1"];
    
    while (res && [res next]) {
        Lesson *lesson = [[Lesson alloc]init];
        lesson.class_id = [res stringForColumn:@"class_id"];
        lesson.lesson_id = [res stringForColumn:@"lesson_id"];
        lesson.title = [res stringForColumn:@"title"];
        lesson.start_date = [res stringForColumn:@"start_date"];
        lesson.end_date = [res stringForColumn:@"end_date"];
        lesson.live = [res stringForColumn:@"live"];
        lesson.class_room_id = [res stringForColumn:@"class_room_id"];
        lesson.class_room_name = [res stringForColumn:@"class_room_name"];
        [res close];
        return [lesson autorelease];
    }
    [res close];
    return nil;
}



+ (BOOL)storeclassScheduleModel:(ClassScheduleModel *)classScheduleModel{
    FMDatabase *db = [Database shareDatabase];
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `class_schedule` WHERE `class_id` = ? AND `lesson_id`= ? ", classScheduleModel.class_id,classScheduleModel.lesson_id];
    
    BOOL isUpdating=false;
    if (res && [res next] )
    {
        isUpdating = true;
    }
    else{
        isUpdating=false;
    }
    BOOL result = FALSE;
    
    if(isUpdating){
        result = [db executeUpdate:@"UPDATE `class_schedule` SET `class_id`=? ,`lesson_id`=?, `title`=? , `start_date`=? ,`end_date`=? ,`live`=?  WHERE  `class_id` = ? AND `lesson_id`= ? ",
                  classScheduleModel.class_id,
                  classScheduleModel.lesson_id,
                  classScheduleModel.title,
                  classScheduleModel.start_date,
                  classScheduleModel.end_date,
                  classScheduleModel.live,
                  classScheduleModel.class_id,
                  classScheduleModel.lesson_id];
    } else {
        result = [db executeUpdate:@"INSERT INTO `class_schedule` (`class_id`, `title`,`start_date`,`end_date`,`lesson_id`,`live`) VALUES (?,?,?,?,?,?)"
                  ,classScheduleModel.class_id
                  ,classScheduleModel.title
                  ,classScheduleModel.start_date
                  ,classScheduleModel.end_date
                  ,classScheduleModel.lesson_id
                  ,classScheduleModel.live];
    }
    
    if (newTransaction) {
        [db commit];
    }
    [res close];
    return result;
}



#pragma mark - SchoolMember

/**
 *  根据班级ID 和用户类型 获取班级成员列表
 */
+ (NSMutableArray *)fetchClassMemberByClassID:(NSString *)class_id andMemberType:(NSString *)user_type{
    FMDatabase *db = [Database shareDatabase];
    NSMutableArray * schoolMember_array = [[NSMutableArray alloc] init];
    
    NSString *mySelf_uid = [WTUserDefaults getUid];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `school_members` WHERE `class_id`= ? AND `user_type`=? AND `uid`<>? ORDER BY `uid` ASC",class_id,user_type,mySelf_uid];
    
    while (res && [res next]) {
        SchoolMember *member = [[SchoolMember alloc]init];
        member.class_id = [res stringForColumn:@"class_id"];
        member.userID = [res stringForColumn:@"uid"];
        member.nickName = [res stringForColumn:@"nickName"];
        member.status = [res stringForColumn:@"last_status"];
        member.sexFlag = [[res stringForColumn:@"sex"] integerValue];
        member.deviceNumber = [res stringForColumn:@"device_number"];
        member.appVer = [res stringForColumn:@"app_ver"];
        member.alias = [res stringForColumn:@"alias"];
        member.photoUploadedTimeStamp = [[res stringForColumn:@"upload_photo_timestamp"] integerValue];
        member.pathOfPhoto = [res stringForColumn:@"photo_filepath"];
        member.pathOfThumbNail = [res stringForColumn:@"thumbnail_filepath"];
        member.needToDownloadPhoto = [res stringForColumn:@"need_to_download_photo"];
        member.needToDownloadThumbnail = [res stringForColumn:@"need_to_download_thumbnail"];
        member.userType = [[res stringForColumn:@"user_type"] integerValue];
        
        [schoolMember_array addObject:member];
        [member release];
    }
    [res close];
    return [schoolMember_array autorelease];
}

+ (SchoolMember *)fetchClassMemberByClass_id:(NSString *)class_id andMember_id:(NSString *)member_id{
    FMDatabase *db = [Database shareDatabase];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `school_members` WHERE `class_id`= ? AND `uid`=? ",class_id,member_id];
    
    while (res && [res next]) {
        SchoolMember *member = [[SchoolMember alloc]init];
        member.class_id = [res stringForColumn:@"class_id"];
        member.userID = [res stringForColumn:@"uid"];
        member.nickName = [res stringForColumn:@"nickName"];
        member.status = [res stringForColumn:@"last_status"];
        member.sexFlag = [[res stringForColumn:@"sex"] integerValue];
        member.deviceNumber = [res stringForColumn:@"device_number"];
        member.appVer = [res stringForColumn:@"app_ver"];
        member.alias = [res stringForColumn:@"alias"];
        member.photoUploadedTimeStamp = [res stringForColumn:@"upload_photo_timestamp"];
        member.pathOfPhoto = [res stringForColumn:@"photo_filepath"];
        member.pathOfThumbNail = [res stringForColumn:@"thumbnail_filepath"];
        member.needToDownloadPhoto = [res stringForColumn:@"need_to_download_photo"];
        member.needToDownloadThumbnail = [res stringForColumn:@"need_to_download_thumbnail"];
        member.userType = [[res stringForColumn:@"user_type"] integerValue];
        [res close];
        return [member autorelease];
    }
    [res close];
    return nil;
}



/**
 *  班级成员是否是已经添加为好友了
 */
+ (BOOL)schoolMemberAlreadyFriendByUserID:(NSString *)user_id{
    FMDatabase *db = [Database shareDatabase];
    
    FMResultSet *res = [db executeQuery:@"SELECT `uid` FROM `buddydetail` WHERE `uid` = ? ", user_id];
    BOOL alreadyAdd = NO;
    while (res && [res next]) {
        alreadyAdd = YES;
    }
    [res close];
    
    FMResultSet *res1 = [db executeQuery:@"SELECT `buddy_flag` FROM `buddys` WHERE `uid` = ? ", user_id];
    BOOL isFriend = NO;
    while (res1 && [res1 next]) {
        if ([[res1 stringForColumn:@"buddy_flag"] integerValue] == 1){
            isFriend = YES;
        }
    }
    [res1 close];
    return (alreadyAdd && isFriend);
}

/**
 *  储存 班级成员对象
 */
+ (BOOL)storeClassMember:(SchoolMember*)member{
    FMDatabase *db = [Database shareDatabase];
    
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    FMResultSet *res = [db executeQuery:@"SELECT `class_id` FROM `school_members` WHERE `uid` = ? AND `class_id` = ?", member.userID,member.class_id];
    
    BOOL isUpdating=false;
    if (res && [res next] )
    {
        isUpdating = true;
    }
    else{
        isUpdating=false;
    }
    [res close];
    
    BOOL result = FALSE;
    if(isUpdating){
        result = [db executeUpdate:@"UPDATE `school_members` SET `nickName`=? ,`upload_photo_timestamp`=?,`alias`=?,`user_type`=? WHERE `class_id`=? AND `uid`=?",
                  member.nickName,
                  [NSString stringWithFormat:@"%zi",member.photoUploadedTimeStamp],
                  member.alias,
                  [NSString stringWithFormat:@"%zi",member.userType],
                  member.class_id,
                  member.userID];
    } else {
        result = [db executeUpdate:@"INSERT INTO `school_members` (`class_id`, `uid`,`nickName`,`alias`,`upload_photo_timestamp`,`user_type`) VALUES (?,?,?,?,?,?)",
                  member.class_id,
                  member.userID,
                  member.nickName,
                  member.alias,
                  [NSString stringWithFormat:@"%zi",member.photoUploadedTimeStamp],
                  [NSString stringWithFormat:@"%zi",member.userType]];
    }
    
    if (newTransaction) {
        [db commit];
    }
    
    
    return result;
}




#pragma mark - anonymous_moment

/**
 *  保存隐私moment
 */
+ (BOOL)storeAnonymousMoment:(Anonymous_Moment*)moment{
    FMDatabase *db = [Database shareDatabase];
    if ([Database isInTheQueue:moment.moment_id]) {
        return FALSE;
    }
    
    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];
    
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `anonymous_moment` WHERE `id` = ? ", moment.moment_id];
    
    BOOL isUpdating=false;
    if (res && [res next]){
        isUpdating = true;
    }
    BOOL rlt=FALSE;
    if(isUpdating){
        rlt=[db executeUpdate:@"UPDATE `anonymous_moment` SET `text`=?, `latitude`=?,`longitude`=?, `allow_review`=?,`owner_uid`=?,`user_type`=?,`privacy_level`=?,`timestamp`=?,`liked_by_me`=?,`place`=?,`momentType`=?,`deadline`=? WHERE `id`=?",
             moment.text,
             [NSString stringWithFormat:@"%f", moment.latitude],
             [NSString stringWithFormat:@"%f", moment.longitude],
             moment.allowReview?@"1":@"0",
             (moment.owner!=nil)?moment.owner.userID:@"",
             (moment.owner!=nil)?[NSString stringWithFormat:@"%zi",moment.owner.userType] :@"",
             [NSString stringWithFormat:@"%zi", moment.privacyLevel],
             [NSString stringWithFormat:@"%zi", moment.timestamp],
             moment.likedByMe?@"1":@"0",
             moment.placename,
             [NSString stringWithFormat:@"%d",moment.momentType],
             [NSString stringWithFormat:@"%f",moment.deadline],
             moment.moment_id];
    }
    else{
        
        rlt=[db executeUpdate:@"INSERT INTO `anonymous_moment` (`id`,`text`, `latitude`,`longitude`, `allow_review`,`owner_uid`,`user_type`,`privacy_level`,`timestamp`,`liked_by_me`,`place`,`momentType`,`deadline`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
             ,moment.moment_id
             ,moment.text
             ,[NSString stringWithFormat:@"%f", moment.latitude]
             ,[NSString stringWithFormat:@"%f", moment.longitude]
             ,moment.allowReview?@"1":@"0"
             ,(moment.owner!=nil)?moment.owner.userID:@""
             ,(moment.owner!=nil)?[NSString stringWithFormat:@"%zi",moment.owner.userType] :@""
             ,[NSString stringWithFormat:@"%zi", moment.privacyLevel]
             ,[NSString stringWithFormat:@"%zi", moment.timestamp]
             ,@"0"
             ,moment.likedByMe?@"1":@"0", moment.placename
             ,[NSString stringWithFormat:@"%d",moment.momentType]
             ,[NSString stringWithFormat:@"%f",moment.deadline]];
    }
    [db commit];
    [res close];
    
    return rlt;
}


+ (BOOL)storeAnonymousMoment_bulletin:(Anonymous_Moment*)moment{
    FMDatabase *db = [Database shareDatabase];
    if ([Database isInTheQueue:moment.moment_id]) {
        return FALSE;
    }
    
    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];
    
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `anonymous_moment` WHERE `bulletin_id` = ? AND `class_id`= ?", moment.bulletin_id,moment.class_id];
    
    BOOL isUpdating=false;
    if (res && [res next]){
        isUpdating = true;
    }
    BOOL rlt=FALSE;
    if(isUpdating){
        rlt=[db executeUpdate:@"UPDATE `anonymous_moment` SET `anonymousType`=? ,`anonymous_uid`=?  WHERE `bulletin_id`=? AND `class_id`=?",
             [NSString stringWithFormat:@"%zi",moment.anonymousType],
             moment.anonymous_uid,
             moment.bulletin_id,
             moment.class_id];
    }
    else{
        rlt=[db executeUpdate:@"INSERT INTO `anonymous_moment` (`anonymousType`,`bulletin_id`,`anonymous_uid`,`class_id`,`id`) VALUES (?,?,?,?,?)"
             ,[NSString stringWithFormat:@"%zi",moment.anonymousType]
             ,moment.bulletin_id
             ,moment.anonymous_uid
             ,moment.class_id
             ,moment.moment_id];
    }
    [db commit];
    [res close];
    
    return rlt;
}



+(Anonymous_Moment *)getAnonymousMomentWithID:(NSString*)moment_id{
    FMDatabase *db = [Database shareDatabase];
    
    NSString* strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`user_type`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline`,`anonymousType`,`bulletin_id`,`anonymous_uid`,`class_id` FROM `anonymous_moment` WHERE `id` = %@ ",moment_id];
    
    FMResultSet *res =  [db executeQuery: strsql];
    if (res && [res next]) {
        int i = -1;
        Anonymous_Moment* moment= [[[Anonymous_Moment alloc] initWithMomentID:[res stringForColumn:@"id"]
                                                 withText:[res stringForColumn:@"text"]
                                               withOwerID:[res stringForColumn:@"owner_uid"]
                                             withUserType:[res stringForColumn:@"user_type"]
                                             withNickname:nil
                                            withTimestamp:[res stringForColumn:@"timestamp"]
                                            withLongitude:[res stringForColumn:@"longitude"]
                                             withLatitude:[res stringForColumn:@"latitude"]
                                         withPrivacyLevel:[res stringForColumn:@"privacy_level"]
                                          withAllowReview:[res stringForColumn:@"allow_review"]
                                            withLikedByMe:[res stringForColumn:@"liked_by_me"]
                                            withPlacename:[res stringForColumn:@"place"]
                                           withMomentType:[res stringForColumn:@"momentType"]
                                             withDeadline:[res stringForColumn:@"deadline"]] autorelease];
        moment.anonymousType = [[res stringForColumn:@"anonymousType"] integerValue];
        moment.bulletin_id = [res stringForColumn:@"bulletin_id"];
        moment.anonymous_uid = [res stringForColumn:@"anonymous_uid"];
        moment.class_id = [res stringForColumn:@"class_id"];
        
        
        FMResultSet * res1 = [db executeQuery:@"SELECT `fileid`,`thumbid`,`ext`,`dbid`,`duration` FROM `moment_media` WHERE `moment_id` = ?", moment.moment_id];
        //   NSLog(@"try to get multimedias: %@",[db lastErrorMessage]);
        
        while (res1 && [res1 next]) {
            
            i=-1;
            
            WTFile* wtfile= [[[WTFile alloc] initWithFileID:[res1 stringForColumnIndex:0]
                                            withThumbnailID:[res1 stringForColumnIndex:1]
                                                    withExt:[res1 stringForColumnIndex:2]
                                              withLocalPath:nil
                                                   withDBid:[res1 stringForColumnIndex:3] withDuration:[[res1 stringForColumnIndex:4] doubleValue]] autorelease];
            
            [moment.multimedias addObject:wtfile];
            
        }
        
        
        res1 = [db executeQuery:@"SELECT `id`,`text`,`uid`,`nickname`,`timestamp`,`type`,`reply_to_review_id`,`reply_to_uid`,`reply_to_nickname`,`read_status`,`invisible` FROM `moment_review` WHERE `moment_id` = ? ORDER BY `timestamp` ASC", moment.moment_id];
        
        //   NSLog(@"try to get reviews: %@",[db lastErrorMessage]);
        while (res1 && [res1 next]) {
            
            i=-1;
            
            Review* review= [[[Review alloc] initWithReviewID:[res1 stringForColumnIndex:0]
                                                     withText:[res1 stringForColumnIndex:1]
                                                   withOwerID:[res1 stringForColumnIndex:2]
                                                 withNickname:[res1 stringForColumnIndex:3]
                                                withTimestamp:[res1 stringForColumnIndex:4]
                                                     withType:[res1 stringForColumnIndex:5]
                                          withReplyToReviewID:[res1 stringForColumnIndex:6]
                                               withReplyToUID:[res1 stringForColumnIndex:7]
                                          withReplyToNickname:[res1 stringForColumnIndex:8]
                                              withAlreadyRead:[[res1 stringForColumnIndex:9] boolValue]] autorelease];
            
            review.invisible = [[res1 stringForColumnIndex:10] boolValue];
            
            [moment.reviews addObject:review];
            
        }
        
        
        // get privacy
        res1 = [db executeQuery:@"SELECT `moment_id`,`group_id` FROM `moment_privacy_detail` WHERE `moment_id` = ?", moment.moment_id];
        while (res1 && [res1 next]) {
            NSString* group_id  = [res1 stringForColumnIndex:1];
            [moment.viewableGroups addObject:group_id];
        }
        
        // get options
        if (moment.momentType == 3 || moment.momentType == 4 ) {
            res1 = [db executeQuery:@"SELECT `moment_id`,`option_id`,`description`,`vote_count`,`is_voted` FROM `moment_survey_option` WHERE `moment_id` = ? ORDER BY `option_id` ASC", moment.moment_id];
            while (res1 && [res1 next]) {
                i = -1;
                Option* option = [[Option alloc] initWithMomentID:[res1 stringForColumnIndex:0]
                                                     WithOptionID:[res1 stringForColumnIndex:1]
                                                  withDescription:[res1 stringForColumnIndex:2] withVoteCount:[res1 stringForColumnIndex:3] withIsVoted:[res1 stringForColumnIndex:4]];
                
                [moment.options addObject:option];
                [option release];
            }
        }
        
        
        [res1 close];
        [res close];
        return moment;
    }
    [res close];
    
    return nil;
    
}


//limit 5,10
+ (NSMutableArray *)fetchClassBulletinWithClass_id:(NSString *)class_id{
    
    FMDatabase *db = [Database shareDatabase];
    
//    res1 = [db executeQuery:@"SELECT `moment_id`,`group_id` FROM `moment_privacy_detail` WHERE `moment_id` = ?", moment.moment_id];
    
//    NSString* strsql=[NSString stringWithFormat:@"SELECT * FROM `anonymous_moment` WHERE `class_id` = %@ ",class_id];
    
    FMResultSet *res =  [db executeQuery: @"SELECT * FROM `anonymous_moment` WHERE `class_id` = ? ORDER BY `timestamp` DESC LIMIT 0, 20",class_id];
    NSMutableArray *anonymous_moment_array = [[NSMutableArray alloc]init];
    
     while (res && [res next]){
        int i = -1;
        Anonymous_Moment* moment= [[[Anonymous_Moment alloc] initWithMomentID:[res stringForColumn:@"id"]
                                                                     withText:[res stringForColumn:@"text"]
                                                                   withOwerID:[res stringForColumn:@"owner_uid"]
                                                                 withUserType:[res stringForColumn:@"user_type"]
                                                                 withNickname:nil
                                                                withTimestamp:[res stringForColumn:@"timestamp"]
                                                                withLongitude:[res stringForColumn:@"longitude"]
                                                                 withLatitude:[res stringForColumn:@"latitude"]
                                                             withPrivacyLevel:[res stringForColumn:@"privacy_level"]
                                                              withAllowReview:[res stringForColumn:@"allow_review"]
                                                                withLikedByMe:[res stringForColumn:@"liked_by_me"]
                                                                withPlacename:[res stringForColumn:@"place"]
                                                               withMomentType:[res stringForColumn:@"momentType"]
                                                                 withDeadline:[res stringForColumn:@"deadline"]] autorelease];
        moment.anonymousType = [[res stringForColumn:@"anonymousType"] integerValue];
        moment.bulletin_id = [res stringForColumn:@"bulletin_id"];
        moment.anonymous_uid = [res stringForColumn:@"anonymous_uid"];
        moment.class_id = [res stringForColumn:@"class_id"];
        
        
        FMResultSet * res1 = [db executeQuery:@"SELECT `fileid`,`thumbid`,`ext`,`dbid`,`duration` FROM `moment_media` WHERE `moment_id` = ?", moment.moment_id];
        //   NSLog(@"try to get multimedias: %@",[db lastErrorMessage]);
        
        while (res1 && [res1 next]) {
            
            i=-1;
            
            WTFile* wtfile= [[[WTFile alloc] initWithFileID:[res1 stringForColumnIndex:0]
                                            withThumbnailID:[res1 stringForColumnIndex:1]
                                                    withExt:[res1 stringForColumnIndex:2]
                                              withLocalPath:nil
                                                   withDBid:[res1 stringForColumnIndex:3] withDuration:[[res1 stringForColumnIndex:4] doubleValue]] autorelease];
            
            [moment.multimedias addObject:wtfile];
            
        }
        
        
        res1 = [db executeQuery:@"SELECT `id`,`text`,`uid`,`nickname`,`timestamp`,`type`,`reply_to_review_id`,`reply_to_uid`,`reply_to_nickname`,`read_status`,`invisible` FROM `moment_review` WHERE `moment_id` = ? ORDER BY `timestamp` ASC", moment.moment_id];
        
        //   NSLog(@"try to get reviews: %@",[db lastErrorMessage]);
        while (res1 && [res1 next]) {
            
            i=-1;
            
            Review* review= [[[Review alloc] initWithReviewID:[res1 stringForColumnIndex:0]
                                                     withText:[res1 stringForColumnIndex:1]
                                                   withOwerID:[res1 stringForColumnIndex:2]
                                                 withNickname:[res1 stringForColumnIndex:3]
                                                withTimestamp:[res1 stringForColumnIndex:4]
                                                     withType:[res1 stringForColumnIndex:5]
                                          withReplyToReviewID:[res1 stringForColumnIndex:6]
                                               withReplyToUID:[res1 stringForColumnIndex:7]
                                          withReplyToNickname:[res1 stringForColumnIndex:8]
                                              withAlreadyRead:[[res1 stringForColumnIndex:9] boolValue]] autorelease];
            
            review.invisible = [[res1 stringForColumnIndex:10] boolValue];
            
            [moment.reviews addObject:review];
            
        }
        
        
        // get privacy
        res1 = [db executeQuery:@"SELECT `moment_id`,`group_id` FROM `moment_privacy_detail` WHERE `moment_id` = ?", moment.moment_id];
        while (res1 && [res1 next]) {
            NSString* group_id  = [res1 stringForColumnIndex:1];
            [moment.viewableGroups addObject:group_id];
        }
        
        // get options
        if (moment.momentType == 3 || moment.momentType == 4 ) {
            res1 = [db executeQuery:@"SELECT `moment_id`,`option_id`,`description`,`vote_count`,`is_voted` FROM `moment_survey_option` WHERE `moment_id` = ? ORDER BY `option_id` ASC", moment.moment_id];
            while (res1 && [res1 next]) {
                i = -1;
                Option* option = [[Option alloc] initWithMomentID:[res1 stringForColumnIndex:0]
                                                     WithOptionID:[res1 stringForColumnIndex:1]
                                                  withDescription:[res1 stringForColumnIndex:2] withVoteCount:[res1 stringForColumnIndex:3] withIsVoted:[res1 stringForColumnIndex:4]];
                
                [moment.options addObject:option];
                [option release];
            }
        }
        
        
        [res1 close];
        
        [anonymous_moment_array addObject:moment];
        
    }
    [res close];
    
    return [anonymous_moment_array autorelease];
    
}

+ (NSMutableArray *)fetch_classBulletinWitchClass_id:(NSString *)class_id with_starTime:(NSString *)start_time{
    
    FMDatabase *db = [Database shareDatabase];
    
    if (start_time.length == 0){
        start_time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    }
    
    
    NSString* strsql = [NSString stringWithFormat:@"SELECT * FROM `anonymous_moment` WHERE `timestamp`< '%@' ",start_time];
    
    if (class_id.length != 0){
        strsql = [NSString stringWithFormat:@"%@ AND `class_id`= '%@'",strsql,class_id];
    }
    
    strsql=[NSString stringWithFormat:@"%@ ORDER BY `timestamp` DESC LIMIT 0, 10",strsql];
    
    
    //    if (start_time.length != 0){
    //        strsql = [NSString stringWithFormat:@"SELECT * FROM `anonymous_moment` WHERE `timestamp` < %@ ORDER BY `timestamp` DESC LIMIT 0, 20",start_time];
    //    }
    
    FMResultSet *res =  [db executeQuery: strsql];
    NSMutableArray *anonymous_moment_array = [[NSMutableArray alloc]init];
    while (res && [res next]) {
        int i = -1;
        Anonymous_Moment* moment= [[[Anonymous_Moment alloc] initWithMomentID:[res stringForColumn:@"id"]
                                                                     withText:[res stringForColumn:@"text"]
                                                                   withOwerID:[res stringForColumn:@"owner_uid"]
                                                                 withUserType:[res stringForColumn:@"user_type"]
                                                                 withNickname:nil
                                                                withTimestamp:[res stringForColumn:@"timestamp"]
                                                                withLongitude:[res stringForColumn:@"longitude"]
                                                                 withLatitude:[res stringForColumn:@"latitude"]
                                                             withPrivacyLevel:[res stringForColumn:@"privacy_level"]
                                                              withAllowReview:[res stringForColumn:@"allow_review"]
                                                                withLikedByMe:[res stringForColumn:@"liked_by_me"]
                                                                withPlacename:[res stringForColumn:@"place"]
                                                               withMomentType:[res stringForColumn:@"momentType"]
                                                                 withDeadline:[res stringForColumn:@"deadline"]] autorelease];
        moment.anonymousType = [[res stringForColumn:@"anonymousType"] integerValue];
        moment.bulletin_id = [res stringForColumn:@"bulletin_id"];
        moment.anonymous_uid = [res stringForColumn:@"anonymous_uid"];
        moment.class_id = [res stringForColumn:@"class_id"];
        
        
        FMResultSet * res1 = [db executeQuery:@"SELECT `fileid`,`thumbid`,`ext`,`dbid`,`duration` FROM `moment_media` WHERE `moment_id` = ?", moment.moment_id];
        //   NSLog(@"try to get multimedias: %@",[db lastErrorMessage]);
        
        while (res1 && [res1 next]) {
            
            i=-1;
            
            WTFile* wtfile= [[[WTFile alloc] initWithFileID:[res1 stringForColumnIndex:0]
                                            withThumbnailID:[res1 stringForColumnIndex:1]
                                                    withExt:[res1 stringForColumnIndex:2]
                                              withLocalPath:nil
                                                   withDBid:[res1 stringForColumnIndex:3] withDuration:[[res1 stringForColumnIndex:4] doubleValue]] autorelease];
            
            [moment.multimedias addObject:wtfile];
            
        }
        
        
        res1 = [db executeQuery:@"SELECT `id`,`text`,`uid`,`nickname`,`timestamp`,`type`,`reply_to_review_id`,`reply_to_uid`,`reply_to_nickname`,`read_status`,`invisible` FROM `moment_review` WHERE `moment_id` = ? ORDER BY `timestamp` ASC", moment.moment_id];
        
        //   NSLog(@"try to get reviews: %@",[db lastErrorMessage]);
        while (res1 && [res1 next]) {
            
            i=-1;
            
            Review* review= [[[Review alloc] initWithReviewID:[res1 stringForColumnIndex:0]
                                                     withText:[res1 stringForColumnIndex:1]
                                                   withOwerID:[res1 stringForColumnIndex:2]
                                                 withNickname:[res1 stringForColumnIndex:3]
                                                withTimestamp:[res1 stringForColumnIndex:4]
                                                     withType:[res1 stringForColumnIndex:5]
                                          withReplyToReviewID:[res1 stringForColumnIndex:6]
                                               withReplyToUID:[res1 stringForColumnIndex:7]
                                          withReplyToNickname:[res1 stringForColumnIndex:8]
                                              withAlreadyRead:[[res1 stringForColumnIndex:9] boolValue]] autorelease];
            
            review.invisible = [[res1 stringForColumnIndex:10] boolValue];
            
            [moment.reviews addObject:review];
            
        }
        
        
        // get privacy
        res1 = [db executeQuery:@"SELECT `moment_id`,`group_id` FROM `moment_privacy_detail` WHERE `moment_id` = ?", moment.moment_id];
        while (res1 && [res1 next]) {
            NSString* group_id  = [res1 stringForColumnIndex:1];
            [moment.viewableGroups addObject:group_id];
        }
        
        // get options
        if (moment.momentType == 3 || moment.momentType == 4 ) {
            res1 = [db executeQuery:@"SELECT `moment_id`,`option_id`,`description`,`vote_count`,`is_voted` FROM `moment_survey_option` WHERE `moment_id` = ? ORDER BY `option_id` ASC", moment.moment_id];
            while (res1 && [res1 next]) {
                i = -1;
                Option* option = [[Option alloc] initWithMomentID:[res1 stringForColumnIndex:0]
                                                     WithOptionID:[res1 stringForColumnIndex:1]
                                                  withDescription:[res1 stringForColumnIndex:2] withVoteCount:[res1 stringForColumnIndex:3] withIsVoted:[res1 stringForColumnIndex:4]];
                
                [moment.options addObject:option];
                [option release];
            }
        }
        
        
        [res1 close];
        
        
        [anonymous_moment_array addObject:moment];
        [moment release];
    }
    [res close];
    
    return [anonymous_moment_array autorelease];
}



+ (NSMutableArray *)fetchAllClassBulletin{
    
    FMDatabase *db = [Database shareDatabase];
    
    
    NSString* strsql = [NSString stringWithFormat:@"SELECT * FROM `anonymous_moment` ORDER BY `timestamp` DESC LIMIT 0, 20 "];
    
    FMResultSet *res =  [db executeQuery: strsql];
    NSMutableArray *anonymous_moment_array = [[NSMutableArray alloc]init];
    while (res && [res next]) {
        int i = -1;
        Anonymous_Moment* moment= [[[Anonymous_Moment alloc] initWithMomentID:[res stringForColumn:@"id"]
                                                                     withText:[res stringForColumn:@"text"]
                                                                   withOwerID:[res stringForColumn:@"owner_uid"]
                                                                 withUserType:[res stringForColumn:@"user_type"]
                                                                 withNickname:nil
                                                                withTimestamp:[res stringForColumn:@"timestamp"]
                                                                withLongitude:[res stringForColumn:@"longitude"]
                                                                 withLatitude:[res stringForColumn:@"latitude"]
                                                             withPrivacyLevel:[res stringForColumn:@"privacy_level"]
                                                              withAllowReview:[res stringForColumn:@"allow_review"]
                                                                withLikedByMe:[res stringForColumn:@"liked_by_me"]
                                                                withPlacename:[res stringForColumn:@"place"]
                                                               withMomentType:[res stringForColumn:@"momentType"]
                                                                 withDeadline:[res stringForColumn:@"deadline"]] autorelease];
        moment.anonymousType = [[res stringForColumn:@"anonymousType"] integerValue];
        moment.bulletin_id = [res stringForColumn:@"bulletin_id"];
        moment.anonymous_uid = [res stringForColumn:@"anonymous_uid"];
        moment.class_id = [res stringForColumn:@"class_id"];
        
        
        FMResultSet * res1 = [db executeQuery:@"SELECT `fileid`,`thumbid`,`ext`,`dbid`,`duration` FROM `moment_media` WHERE `moment_id` = ?", moment.moment_id];
        //   NSLog(@"try to get multimedias: %@",[db lastErrorMessage]);
        
        while (res1 && [res1 next]) {
            
            i=-1;
            
            WTFile* wtfile= [[[WTFile alloc] initWithFileID:[res1 stringForColumnIndex:0]
                                            withThumbnailID:[res1 stringForColumnIndex:1]
                                                    withExt:[res1 stringForColumnIndex:2]
                                              withLocalPath:nil
                                                   withDBid:[res1 stringForColumnIndex:3] withDuration:[[res1 stringForColumnIndex:4] doubleValue]] autorelease];
            
            [moment.multimedias addObject:wtfile];
            
        }
        
        
        res1 = [db executeQuery:@"SELECT `id`,`text`,`uid`,`nickname`,`timestamp`,`type`,`reply_to_review_id`,`reply_to_uid`,`reply_to_nickname`,`read_status`,`invisible` FROM `moment_review` WHERE `moment_id` = ? ORDER BY `timestamp` ASC", moment.moment_id];
        
        //   NSLog(@"try to get reviews: %@",[db lastErrorMessage]);
        while (res1 && [res1 next]) {
            
            i=-1;
            
            Review* review= [[[Review alloc] initWithReviewID:[res1 stringForColumnIndex:0]
                                                     withText:[res1 stringForColumnIndex:1]
                                                   withOwerID:[res1 stringForColumnIndex:2]
                                                 withNickname:[res1 stringForColumnIndex:3]
                                                withTimestamp:[res1 stringForColumnIndex:4]
                                                     withType:[res1 stringForColumnIndex:5]
                                          withReplyToReviewID:[res1 stringForColumnIndex:6]
                                               withReplyToUID:[res1 stringForColumnIndex:7]
                                          withReplyToNickname:[res1 stringForColumnIndex:8]
                                              withAlreadyRead:[[res1 stringForColumnIndex:9] boolValue]] autorelease];
            
            review.invisible = [[res1 stringForColumnIndex:10] boolValue];
            
            [moment.reviews addObject:review];
            
        }
        
        
        // get privacy
        res1 = [db executeQuery:@"SELECT `moment_id`,`group_id` FROM `moment_privacy_detail` WHERE `moment_id` = ?", moment.moment_id];
        while (res1 && [res1 next]) {
            NSString* group_id  = [res1 stringForColumnIndex:1];
            [moment.viewableGroups addObject:group_id];
        }
        
        // get options
        if (moment.momentType == 3 || moment.momentType == 4 ) {
            res1 = [db executeQuery:@"SELECT `moment_id`,`option_id`,`description`,`vote_count`,`is_voted` FROM `moment_survey_option` WHERE `moment_id` = ? ORDER BY `option_id` ASC", moment.moment_id];
            while (res1 && [res1 next]) {
                i = -1;
                Option* option = [[Option alloc] initWithMomentID:[res1 stringForColumnIndex:0]
                                                     WithOptionID:[res1 stringForColumnIndex:1]
                                                  withDescription:[res1 stringForColumnIndex:2] withVoteCount:[res1 stringForColumnIndex:3] withIsVoted:[res1 stringForColumnIndex:4]];
                
                [moment.options addObject:option];
                [option release];
            }
        }
        
        
        [res1 close];
    
        
        [anonymous_moment_array addObject:moment];
        [moment release];
    }
    [res close];
    
    return [anonymous_moment_array autorelease];
}


/**
 *  删除班级成员
 */
+(void)deleteCLassMembersWithClass_id:(NSString *)class_id withMember_type:(NSInteger)member_type
{
    FMDatabase *db = [Database shareDatabase];
//    if(PRINT_LOG)NSLog(@"delete all school_members WHERE `class_id` = ?",class_id);
    if (member_type == 0){
        [db executeUpdate:@"DELETE FROM `school_members` WHERE `class_id`= ? ",class_id];
    }else{
        [db executeUpdate:@"DELETE FROM `school_members` WHERE `class_id`= ? AND `user_type`= ?",class_id,[NSString stringWithFormat:@"%ld",(long)member_type]];
    }
}


+ (BOOL)storeLessonPerformance:(LessonPerformanceModel *)lessonPerformanceModel{
    FMDatabase *db = [Database shareDatabase];
    
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `lesson_performance` WHERE `student_id` = ? AND `lesson_id`= ? AND `property_id`=? ", lessonPerformanceModel.student_id,lessonPerformanceModel.lesson_id,lessonPerformanceModel.property_id];
    
    BOOL isUpdating=false;
    if (res && [res next] )
    {
        isUpdating = true;
    }
    else{
        isUpdating=false;
    }
    BOOL result = FALSE;
    
    if(isUpdating){
        result = [db executeUpdate:@"UPDATE `lesson_performance` SET `lesson_id`=? ,`student_id`=?, `property_id`=? , `property_value`=? ,`property_name`=?,`performance_id`=? WHERE  `student_id` = ? AND `lesson_id`= ? AND `property_id`=? "
                  ,lessonPerformanceModel.lesson_id
                  ,lessonPerformanceModel.student_id
                  ,lessonPerformanceModel.property_id
                  ,lessonPerformanceModel.property_value
                  ,lessonPerformanceModel.property_name
                  ,lessonPerformanceModel.performance_id
                  ,lessonPerformanceModel.student_id
                  ,lessonPerformanceModel.lesson_id
                  ,lessonPerformanceModel.property_id];
    } else {
        result = [db executeUpdate:@"INSERT INTO `lesson_performance` (`lesson_id`, `student_id`,`property_id`,`property_value`,`property_name`,`performance_id`) VALUES (?,?,?,?,?,?)"
                  ,lessonPerformanceModel.lesson_id
                  ,lessonPerformanceModel.student_id
                  ,lessonPerformanceModel.property_id
                  ,lessonPerformanceModel.property_value
                  ,lessonPerformanceModel.property_name
                  ,lessonPerformanceModel.performance_id];
    }
    
    if (newTransaction) {
        [db commit];
    }
    [res close];
    return result;
}


+ (NSMutableArray *)fetchLessonPerformanceWithStudent_id:(NSString *)student_id WithLesson_id:(NSString *)lesson_id withProperty_id:(NSString *)property_id{
    
    return [OMDateBase_MyClass fetchLessonPerformanceWithStudent_id:student_id WithLesson_id:lesson_id withProperty_id:property_id property_value:nil];
}


+ (NSMutableArray *)fetchLessonPerformanceWithStudent_id:(NSString *)student_id WithLesson_id:(NSString *)lesson_id withProperty_id:(NSString *)property_id property_value:(NSString *)property_value{
    
    FMDatabase *db = [Database shareDatabase];
    
    NSString *sql_string = [NSString stringWithFormat:@"SELECT * FROM `lesson_performance` WHERE `lesson_id`= '%@'",lesson_id];
    
    if (property_value.length > 0){
        sql_string = [NSString stringWithFormat:@"%@ AND `property_value` = '%@' ",sql_string,property_value];
    }
    
    
    if (student_id.length !=0){
        sql_string = [NSString stringWithFormat:@"%@ AND `student_id`= '%@'",sql_string,student_id];
    }
    
    if (property_id.length != 0){
        sql_string = [NSString stringWithFormat:@"%@ AND `property_id`= '%@'",sql_string,property_id];
    }
    
    sql_string = [NSString stringWithFormat:@"%@ ORDER BY `student_id` ASC",sql_string];
    
    
    NSMutableArray * lessonPerformanceArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:sql_string];
    
    while (res && [res next]) {
        LessonPerformanceModel *lessonPerformanceModel = [[LessonPerformanceModel alloc]init];
        lessonPerformanceModel.lesson_id = [res stringForColumn:@"lesson_id"];
        lessonPerformanceModel.student_id = [res stringForColumn:@"student_id"];
        lessonPerformanceModel.property_id = [res stringForColumn:@"property_id"];
        lessonPerformanceModel.property_value = [res stringForColumn:@"property_value"];
        lessonPerformanceModel.performance_id = [res stringForColumn:@"performance_id"];
        lessonPerformanceModel.property_name = [res stringForColumn:@"property_name"];
        
        [lessonPerformanceArray addObject:lessonPerformanceModel];
        [lessonPerformanceModel release];
        
    }
    [res close];
    return [lessonPerformanceArray autorelease];
}

+ (NewhomeWorkModel *)fetchHomeworkWithLesson_id:(NSString *)lesson_id{
    return nil;
}

+ (void)storeHomeworkWithLesson_id:(NSString *)lesson_id {
    
}

@end
