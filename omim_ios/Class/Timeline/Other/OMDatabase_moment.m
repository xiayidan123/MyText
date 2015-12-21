//
//  OMDatabase_moment.m
//  dev01
//
//  Created by 杨彬 on 15/5/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMDatabase_moment.h"
#import "Database.h"
#import "WTUserDefaults.h"
#import "MediaProcessing.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "WTFile.h"
#import "Review.h"
#import "Option.h"



@interface OMDatabase_moment ()



@end


@implementation OMDatabase_moment

//FMDatabase *db = [Database shareDatabase];


+ (NSMutableArray *)getLastMomentPhotosWithBuddy_id:(NSString *)buddy_id{
    FMDatabase *db = [Database shareDatabase];
    
    NSMutableArray *moment_media_array = [[NSMutableArray alloc] init];
    
    NSString* strsql=@"";
    
    /* @param uID :  the buddy id we want to get moments of;  get moments for all buddies is buddy is nil */
    if(buddy_id == nil){
        strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`user_type`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline` FROM `moment` ORDER BY `timestamp` DESC  "];
    }
    else{
        strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`user_type`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline` FROM `moment` WHERE `owner_uid`='%@'  ORDER BY `timestamp` DESC  ",buddy_id];
    }
    
    
    FMResultSet *res =  [db executeQuery: strsql];
    
    //  NSLog(@"error: %@",[db lastErrorMessage]);
    while (res && [res next]) {
        Moment* moment= [[[Moment alloc] initWithMomentID:[res stringForColumn:@"id"]
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
        
        
        
        
        FMResultSet * res1 = [db executeQuery:@"SELECT `fileid`,`thumbid`,`ext`,`dbid`,`duration` FROM `moment_media` WHERE `moment_id` = ? AND `ext`= ? ORDER BY `dbid` DESC", moment.moment_id,@"jpg"];
        while (res1 && [res1 next]) {
            
            WTFile* wtfile= [[[WTFile alloc] initWithFileID:[res1 stringForColumnIndex:0]
                                            withThumbnailID:[res1 stringForColumnIndex:1]
                                                    withExt:[res1 stringForColumnIndex:2]
                                              withLocalPath:nil
                                                   withDBid:[res1 stringForColumnIndex:3]
                                               withDuration:[[res1 stringForColumnIndex:4] doubleValue]] autorelease];

            
            
            [moment_media_array addObject:wtfile];
        }
        [res1 close];
    }
    [res close];
    
    return [moment_media_array autorelease];
    
}




+ (Moment *) getTheLastMomentWithBuddy_id:(NSString*)buddy_id{
    
    FMDatabase *db = [Database shareDatabase];
    if(buddy_id.length == 0) return nil;
    
    NSString* strsql = [NSString stringWithFormat:@"SELECT MAX(`timestamp`) `id`,`text`,`owner_uid`,`user_type`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline` FROM `moment` WHERE `owner_uid`='%@'",buddy_id];
    
    
    FMResultSet *res =  [db executeQuery: strsql];
    
    //  NSLog(@"error: %@",[db lastErrorMessage]);
    while (res && [res next]) {
        Moment* moment= [[[Moment alloc] initWithMomentID:[res stringForColumn:@"id"]
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
        
        
        
        
        FMResultSet * res1 = [db executeQuery:@"SELECT `fileid`,`thumbid`,`ext`,`dbid`,`duration` FROM `moment_media` WHERE `moment_id` = ?", moment.moment_id];
        while (res1 && [res1 next]) {
            
            WTFile* wtfile= [[[WTFile alloc] initWithFileID:[res1 stringForColumnIndex:0]
                                            withThumbnailID:[res1 stringForColumnIndex:1]
                                                    withExt:[res1 stringForColumnIndex:2]
                                              withLocalPath:nil
                                                   withDBid:[res1 stringForColumnIndex:3]
                                               withDuration:[[res1 stringForColumnIndex:4] doubleValue]] autorelease];
            
            [moment.multimedias addObject:wtfile];
            
        }
        
        
        res1 = [db executeQuery:@"SELECT `id`,`text`,`uid`,`nickname`,`timestamp`,`type`,`reply_to_review_id`,`reply_to_uid`,`reply_to_nickname`,`read_status`,`invisible` FROM `moment_review` WHERE `moment_id` = ? ORDER BY `timestamp` ASC", moment.moment_id];
        while (res1 && [res1 next]) {
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
                Option *option = [[Option alloc] initWithMomentID:[res1 stringForColumnIndex:0]
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




+ (BOOL)store_NewMoment_bySelfUpload:(Moment*)moment withImage_array:(NSArray *)image_array {
    
    FMDatabase *db = [Database shareDatabase];
    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];
    
    FMResultSet *res = [db executeQuery:@"SELECT MIN(`id`)  FROM `moment`"];
    
    // 确定moment_id
    if (res && [res next]){
        int min_moment_id =[[res stringForColumnIndex:0] intValue];
        if (min_moment_id >= 0){
            moment.moment_id = [NSString stringWithFormat:@"-1"];
        }else{
            moment.moment_id = [NSString stringWithFormat:@"%d",min_moment_id - 1];
        }
    }
    [res close];
    
    //1. 存 moment
    
    BOOL result =[db executeUpdate:@"INSERT INTO `moment` (`id`,`text`, `latitude`,`longitude`, `allow_review`,`owner_uid`,`user_type`,`privacy_level`,`timestamp`,`liked_by_me`,`place`,`momentType`,`deadline`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)",
         moment.moment_id,
         moment.text,
         [NSString stringWithFormat:@"%f", moment.latitude],
         [NSString stringWithFormat:@"%f", moment.longitude],
         moment.allowReview?@"1":@"0",
         (moment.owner!=nil)?moment.owner.userID:@"",
         (moment.owner!=nil)?[NSString stringWithFormat:@"%ld",(long)moment.owner.userType] :@"",
         [NSString stringWithFormat:@"%ld", (long)moment.privacyLevel],
         [NSString stringWithFormat:@"%ld", (long)moment.timestamp],
         moment.likedByMe?@"1":@"0", moment.placename,
         [NSString stringWithFormat:@"%d",moment.momentType],
         [NSString stringWithFormat:@"%f",moment.deadline]];
    
    
    //2. 存 moment task
    
    NSString *task_type = @"0";
    NSString *task_unique_id = moment.moment_id;
    NSString *child_task_number = [NSString stringWithFormat:@"%lu",(unsigned long)image_array.count];
    NSString *super_task_id = nil;
    NSString *task_item_number = @"";
    NSString *task_state = @"";
    
    [db executeUpdate:@"DELETE FROM `network_task` WHERE  `task_unique_id`=?",moment.moment_id];
    
    result = [db executeUpdate:@"INSERT INTO `network_task` (`task_type`, `task_unique_id`,`child_task_number`, `super_task_id`,`task_item_number`,`task_state`) VALUES (?, ?, ?, ?, ?, ?);",
              task_type,
              task_unique_id,
              child_task_number,
              super_task_id,
              task_item_number,
              task_state];
    
    int task_id = 0;
    if (result){
        task_id = [db lastInsertRowId];
        
        NSLog(@"moment: task_id = %d",task_id);
    }else{
        // moment进程存储失败  删除moment 和所有之前产生的进程 做用户提醒操作
    }
    
    for (int i=0; i<8; i++){
        result = [db executeUpdate:@"INSERT INTO `network_task_items` (`task_id`, `item_index`,`item_key`, `item_value`) VALUES (?, ?, ?, ?);",
                  [NSString stringWithFormat:@"%d",task_id],
                  task_unique_id,
                  child_task_number,
                  super_task_id,
                  task_item_number,
                  task_state];
    }
    
    
    
    
    
//    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `network_task_items`"
//     @"(`task_id` TEXT,"
//     @" `item_index` TEXT,"
//     @" `item_key` TEXT,"
//     @" `item_value` TEXT)"];
//    + (void)addMoment:(NSString *)content isPublic:(BOOL)ispublic allowReview:(BOOL)allowReview Latitude:(NSString*)latitude Longitutde:(NSString*)longitude withPlace:(NSString*)place withMomentType:(NSString*)type  withSharerange:(NSArray*)groups withCallback:(SEL)selector withObserver:(id)observer
    
    
//    rlt=[db executeUpdate:@"INSERT INTO `moment` (`id`,`text`, `latitude`,`longitude`, `allow_review`,`owner_uid`,`user_type`,`privacy_level`,`timestamp`,`liked_by_me`,`place`,`momentType`,`deadline`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)",
//         moment.moment_id,
//         moment.text,
//         [NSString stringWithFormat:@"%f", moment.latitude],
//         [NSString stringWithFormat:@"%f", moment.longitude],
//         moment.allowReview?@"1":@"0",
//         (moment.owner!=nil)?moment.owner.userID:@"",
//         (moment.owner!=nil)?[NSString stringWithFormat:@"%d",moment.owner.userType] :@"",
//         [NSString stringWithFormat:@"%d", moment.privacyLevel],
//         [NSString stringWithFormat:@"%d", moment.timestamp],
//         moment.likedByMe?@"1":@"0", moment.placename,
//         [NSString stringWithFormat:@"%d",moment.momentType],
//         [NSString stringWithFormat:@"%f",moment.deadline]];
    
    
    
    [db commit];
    [res close];
    
    
    //3. 存 moment_media
    
    
    // (1)存图片 image_array 里面是 选择图片的 url
    ALAssetsLibrary* assetLib = [[[ALAssetsLibrary alloc]init] autorelease];
    
    
    int image_number = image_array.count;
    int stored_image_number = 0;
    __block NSMutableArray *file_array = [[[NSMutableArray alloc]init] autorelease];
    for (NSURL *url in image_array){
        [assetLib assetForURL:url resultBlock:^(ALAsset *asset) {
            NSArray* array = [MediaProcessing savePhotoFromLibraryToLocal:asset];
            if (array){
                WTFile *file = [[WTFile alloc]init];
                file.thumbnailid = [array objectAtIndex:1];
                file.fileid = [array objectAtIndex:0];
                file.ext = @"jpg";
                file.momentid = moment.moment_id;
                [file_array addObject:file];
//                [file release];
                
                // 存momemt多媒体详情表
                
                [db executeUpdate:@"DELETE FROM `moment_media` WHERE  `moment_id`=? ",moment.moment_id];
                [db executeUpdate:@"INSERT INTO `moment_media` (`fileid`,`moment_id`, `ext`,`dbid`,`duration`,`thumbid`) VALUES (?, ?, ?, ?, ?, ?)"
                 ,file.fileid
                 ,file.momentid
                 ,file.ext
                 ,file.dbid
                 ,[NSString stringWithFormat:@"%f",file.duration]
                 ,file.thumbnailid];
                
                

                // 存进程
                [db executeUpdate:@"DELETE FROM `network_task` WHERE  `task_unique_id`=? AND `super_task_id` IS NOT NULL",moment.moment_id];
                
                BOOL store_media_task_result = [db executeUpdate:@"INSERT INTO `network_task` (`task_type`, `task_unique_id`,`child_task_number`, `super_task_id`,`task_item_number`,`task_state`) VALUES (?, ?, ?, ?, ?, ?);",
                          task_type,
                          moment.moment_id,
                          @"0",
                          [NSString stringWithFormat:@"%d",task_id],
                          task_item_number,
                          task_state];
                if (store_media_task_result){
                    
                }else{
                    
                }
                
                
                
                [db commit];
            }else{
                // 图片存储失败  删除moment 和所有之前产生的进程 做用户提醒操作
            }
            
            
            
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
    
    
    
    
    
    //3. 存 moment_media task

    
    
    
    
    
    
    
    
    
    
    
    // if the moment has not finishing uploading, we don't change local data. otherwise, problem occurs
    
    // if one doesn't have access to the moment, we don't store the moment. we need to make sure one doesn't possess this moment.
//    if (moment.viewableGroups!=nil&& [moment.viewableGroups count]>0) {
//        BOOL ableToSee = FALSE;
//        if ([moment.owner.userID isEqualToString:[WTUserDefaults getUid]]) {
//            ableToSee = TRUE;
//        }
//        else{
//            for (NSString* groupid in moment.viewableGroups) {
//                if ([Database isMember:[WTUserDefaults getUid] inDepartment:groupid]) {
//                    ableToSee = TRUE;
//                }
//            }
//        }
//        
//        if (!ableToSee) {
//            return FALSE;
//        }
//        
//    }
//    
//    
//    
//    BOOL isUpdating=false;
//    if (res && [res next]){
//        isUpdating = true;
//    }
//    
//    BOOL rlt=FALSE;
//    if(isUpdating){
//        rlt=[db executeUpdate:@"UPDATE `moment` SET `text`=?, `latitude`=?,`longitude`=?, `allow_review`=?,`owner_uid`=?,`user_type`=?,`privacy_level`=?,`timestamp`=?,`liked_by_me`=?,`place`=?,`momentType`=?,`deadline`=? WHERE `id`=?",
//             moment.text,
//             [NSString stringWithFormat:@"%f", moment.latitude],
//             [NSString stringWithFormat:@"%f", moment.longitude],
//             moment.allowReview?@"1":@"0",
//             (moment.owner!=nil)?moment.owner.userID:@"",
//             (moment.owner!=nil)?[NSString stringWithFormat:@"%d",moment.owner.userType] :@"",
//             [NSString stringWithFormat:@"%d", moment.privacyLevel],
//             [NSString stringWithFormat:@"%d", moment.timestamp],
//             moment.likedByMe?@"1":@"0",
//             moment.placename,
//             [NSString stringWithFormat:@"%d",moment.momentType],
//             [NSString stringWithFormat:@"%f",moment.deadline],
//             moment.moment_id];
//    }
//    else{
//        rlt=[db executeUpdate:@"INSERT INTO `moment` (`id`,`text`, `latitude`,`longitude`, `allow_review`,`owner_uid`,`user_type`,`privacy_level`,`timestamp`,`liked_by_me`,`place`,`momentType`,`deadline`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)",
//             moment.moment_id,
//             moment.text,
//             [NSString stringWithFormat:@"%f", moment.latitude],
//             [NSString stringWithFormat:@"%f", moment.longitude],
//             moment.allowReview?@"1":@"0",
//             (moment.owner!=nil)?moment.owner.userID:@"",
//             (moment.owner!=nil)?[NSString stringWithFormat:@"%d",moment.owner.userType] :@"",
//             [NSString stringWithFormat:@"%d", moment.privacyLevel],
//             [NSString stringWithFormat:@"%d", moment.timestamp],
//             moment.likedByMe?@"1":@"0", moment.placename,
//             [NSString stringWithFormat:@"%d",moment.momentType],
//             [NSString stringWithFormat:@"%f",moment.deadline]];
//    }
//    
//    //  NSLog(@"%@",[db lastErrorMessage]);
//    if(!rlt) {
//        if (newTransaction)
//            [db commit];
//        return false;
//    }
//    // overwrite media table
//    [db executeUpdate:@"DELETE FROM `moment_media` WHERE  `moment_id`=?",moment.moment_id];
//    
//    if(moment.multimedias != nil) {
//        for (WTFile *wtfile in moment.multimedias) {
//            rlt=[db executeUpdate:@"INSERT INTO `moment_media` (`fileid`,`moment_id`, `ext`,`dbid`,`duration`,`thumbid`) VALUES (?, ?, ?, ?,?,?)",
//                 wtfile.fileid,
//                 moment.moment_id,
//                 wtfile.ext,
//                 wtfile.dbid,[NSString stringWithFormat:@"%f",wtfile.duration],wtfile.thumbnailid];
//            if(!rlt) {
//                if (newTransaction)
//                    [db commit];
//                return false;
//            }
//        }
//    }
//    
//    // update review table
//    [db executeUpdate:@"DELETE FROM `moment_review` WHERE  `moment_id`=?",moment.moment_id];
//    
//    if(moment.reviews != nil) {
//        for(Review* r in moment.reviews) {
//            rlt=[Database storeMomentReview:r forMomentID:moment.moment_id];
//            if(!rlt) {
//                if (newTransaction)
//                    [db commit];
//                return false;
//            }
//        }
//    }
//    
//    
//    // update privacy groups and options
//    rlt = [self storeMomentPrivacy:moment];
//    rlt = [self storeMomentOptions:moment];
//    
//    if (newTransaction)
//        [db commit];
    
    
    return result;
    
}



@end
