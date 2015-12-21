#import "Database.h"
#import "FMDatabase.h"
#import "WowTalkVoipIF.h"
#import "GlobalSetting.h"

#import "Buddy.h"
#import "ChatMessage.h"
#import "CallLog.h"
#import "GroupChatRoom.h"

#import "WTUserDefaults.h"
#import "Activity.h"
#import "ActivityModel.h"
#import "Moment.h"
#import "Review.h"
#import "WTFile.h"
#import "QueuedMedia.h"

#import "UserGroup.h"
#import "GroupMember.h"
#import "CoverImage.h"

#import "Department.h"
#import "WTHelper.h"

#import "BizMember.h"
#import "Option.h"
#import "EventDate.h"


#import "AppDelegate.h" // not good way to implement. temp solution
#import "NSDateFormatterGregorianCalendar.h"







static FMDatabase *db = nil;
//static NSString* currentDBName =nil;

#define DB_VERSION  10

@interface Database (Private)
+ (BOOL) enableForeignKeySupport;
@end

@implementation Database

#pragma mark -
#pragma mark Database Initialization


+(FMDatabase *)shareDatabase{
    return db;
}

// Initialize the database.
+ (void) initializeDatabase {
    if(db!=nil){
        if(PRINT_LOG)NSLog(@"initializeDatabase: Database already initialized. Do nothing here.");
        return;
    }
    
	//if(PRINT_LOG)NSLog(@"Initializing database with SQLite version: %@", [FMDatabase sqliteLibVersion]);
    
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
																	   NSUserDomainMask,
																	   YES);
	NSString *directory = [documentDirectories objectAtIndex:0];
    
	NSError *err = nil;
	NSFileManager *manager = [NSFileManager defaultManager];
    
	// Hide the SQLite database from the iTunes document inspector.
	NSString *oldPath = [directory stringByAppendingPathComponent:@".wowtalk.sqlite"];
	NSString *newPath = [directory stringByAppendingPathComponent:@".onemeter.sqlite"];
	if (![manager fileExistsAtPath:newPath] && [manager fileExistsAtPath:oldPath]) {
		if (![manager moveItemAtPath:oldPath toPath:newPath error:&err]) {
			if(PRINT_LOG)NSLog(@"Database: Unable to move file to new spot");
		}
	}
    
	NSString *dbPath = newPath;
	db = [[FMDatabase alloc] initWithPath:dbPath];
	if (!db)
		return;
	if ([db open]) {
		if(PRINT_LOG)NSLog(@"Database: Initialized database at %@", dbPath);
	} else {
		if(PRINT_LOG)NSLog(@"Database: Could not open database at %@", dbPath);
		[db release];
		db = nil;
		return;
	}
    
    
	if ([Database enableForeignKeySupport] == NO) {
		if(PRINT_LOG)NSLog(@"Databse: No foreign key support found in SQLite. Bad things *will* happen.");
	}
    
    
    ////////////////////////////////////////
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger old_db_version = [defaults integerForKey:@"database_version"];
    
    if(old_db_version<DB_VERSION){
        [Database dropAllTables:YES];
        [defaults setInteger:DB_VERSION forKey:@"database_version"];
        [defaults synchronize];

    }
    
    ////////////////////////////////////////
    
    
    

    //创建聊天消息数据库
	[db executeUpdate:@"CREATE TABLE IF NOT EXISTS `chatmessages` "
     @"(`id` INTEGER PRIMARY KEY AUTOINCREMENT,"
     @" `chattarget` TEXT,"
     @" `display_name` TEXT,"
     @" `msgtype` TEXT,"
     @" `sentdate` TEXT,"
     @" `iotype` TEXT,"
     @" `sentstatus` TEXT,"
     @" `is_group_chat` TEXT,"
     @" `group_chat_sender_id` TEXT,"
     @" `read_count` TEXT,"
     @" `path_thumbnail` TEXT,"
     @" `path_multimedia` TEXT,"
     @" `msgcontent` TEXT,"
     @" `remote_key` TEXT)"];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `unsent_receipts` "
     @"(`id` INTEGER PRIMARY KEY AUTOINCREMENT,"
     @" `chattarget` TEXT,"
     @" `messagebody` TEXT)"];
    
    
    
	[db executeUpdate:@"CREATE TABLE IF NOT EXISTS `calllogs` "
     @"(`id` INTEGER PRIMARY KEY AUTOINCREMENT,"
     @" `contact` TEXT,"
     @" `display_name` TEXT,"
     @" `callstatus` TEXT,"
     @" `direction` TEXT,"
     @" `startdate` TEXT,"
     @" `duration` TEXT,"
     @" `quality` TEXT)"];
    
    //创建群消息房间数据库
	[db executeUpdate:@"CREATE TABLE IF NOT EXISTS `group_chatroom` "
     @"(`group_id` TEXT PRIMARY KEY,"
     @" `group_name_original` TEXT,"
     @" `group_name_local` TEXT,"
     @" `group_status` TEXT,"
     @" `max_number` TEXT,"
     @" `member_count` TEXT,"
     @" `createdplace` TEXT,"
     @" `latitude` TEXT,"
     @" `lonitude` TEXT,"
     @" `grouptype` TEXT,"
     @" `avatartimestamp` TEXT,"
     @" `introduction` TEXT,"
     @" `needtodownloadthumbnail` TEXT,"
     @" `needtodownloadphoto` TEXT,"
     @" `isinvisible` TEXT,"
     @" `shortid` TEXT,"
     @" `parent_id` TEXT,"
     @" `editable` TEXT,"
     @" `level` TEXT,"
     @" `is_group_name_changed` TEXT,"
     @" `group_weight` TEXT,"
     @" `temp_group_flag` TEXT)" ];
    
    //创建群成员数据库
	[db executeUpdate:@"CREATE TABLE IF NOT EXISTS `group_member` "
     @"(`group_id` TEXT,"
     @" `member_id` TEXT,"
     @" `member_level` TEXT)"];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `buddys` "
     @"(`uid` TEXT PRIMARY KEY,"
     @" `phone_number` TEXT,"
     @" `buddy_flag` TEXT)" ];  //1 : friend ;  0: possible friend from server ; -1: possible friend added by group member  2: added from contact, he is not a user yet.
    
	
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `buddydetail` "
     @"(`uid` TEXT PRIMARY KEY,"
     
     @" `nickname` TEXT,"
     @" `last_status` TEXT,"
     @" `sex` TEXT,"
     @" `device_number` TEXT,"
     @" `app_ver` TEXT,"
     @" `alias` TEXT,"
     @" `photo_upload_timestamp` TEXT,"
     @" `photo_filepath` TEXT,"
     @" `thumbnail_filepath` TEXT,"
     @" `need_to_download_photo` TEXT,"
     @" `need_to_download_thumbnail` TEXT)" ];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `buddy_more_detail` "
     @"(`uid` TEXT PRIMARY KEY,"
     @" `wowtalk_id` TEXT,"
     @" `user_type` TEXT,"
     @" `allowPeopleToAdd` TEXT,"
     @" `last_longitude` TEXT,"
     @" `last_latitude` TEXT,"
     @" `last_login_timestamp` TEXT)"];
    
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `biz_member_info` "
     @"(`uid` TEXT PRIMARY KEY,"
     @" `department` TEXT,"
     @" `position` TEXT,"
     @" `district` TEXT,"
     @" `employeeid` TEXT,"
     @" `landline` TEXT,"
     @" `email` TEXT,"
     @" `phonetic_name` TEXT,"
     @" `phonetic_first_name` TEXT,"
     @" `phonetic_middle_name` TEXT,"
     @" `phonetic_last_name` TEXT,"
     @" `mobile` TEXT)"];
    
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `block_list` "
     @"(`uid` TEXT PRIMARY KEY)" ];
    
    
	[db executeUpdate:@"CREATE TABLE IF NOT EXISTS `videocall_unsupported_device_list` "
     @"(`device_number` TEXT PRIMARY KEY)" ];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `numbers_in_contact` "
     @"(`number` TEXT PRIMARY KEY)" ];
    
    // user information and custom infomation saved locally
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `user_infos` "
     @"(`uid` TEXT,"
     @" `wowtalk_id` TEXT,"
     @" `pwd` TEXT,"
     @" `hashed_pwd` TEXT,"
     @" `status` TEXT,"
     @" `nickname` TEXT,"
     @" `birthday` TEXT,"
     @" `gender` TEXT,"
     @" `area` TEXT,"
     @" `user_type` TEXT,"
     @" `server_version` TEXT,"
     @" `client_version` TEXT,"
     @" `domain` TEXT,"
     @" `username` TEXT,"
     @" `id_changed` TEXT,"
     @" `pwd_changed` TEXT,"
     @" `email` TEXT,"
     @" `token_pushed` TEXT,"
     @" `phone_number` TEXT,"
     @" `allow_people_add_me` TEXT,"
     @" `list_me_nearby` TEXT,"
     @" `company_mobile` TEXT,"
     @" `company_email` TEXT,"
     @" `phonetic_name` TEXT,"
     @" `branchoffice` TEXT,"
     @" `landline` TEXT,"
     @" `department` TEXT,"
     @" `position` TEXT,"
     @" `employeeid` TEXT,"
     @" `country_code` TEXT)"];
    
    

    
        FMResultSet *res = [Database runQueryForResult:@"SELECT `wowtalk_id` FROM `user_infos`"];
        if (!res || ![res next]){
            [db executeUpdate:@"INSERT INTO `user_infos` (`wowtalk_id`) VALUES (?)", @"1"];
        }
        [res close];
    
    
    // activity detail

    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS event_detail(event_id TEXT,owner_id TEXT,owner_name TEXT,tag TEXT, category TEXT,insert_timestamp TEXT,latitude TEXT,longitude TEXT,area TEXT,max_member TEXT,member_count TEXT,text_title TEXT,text_content TEXT,coin TEXT,date_type TEXT,date_info TEXT,classification TEXT,is_get_member_info TEXT,is_open TEXT,start_timestamp TEXT,end_timestamp TEXT, is_joined TEXT, mediaArray )"];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `event` "
     @"(`event_id` TEXT,"
     @"`insert_timestamp` TEXT,"
     @"`max_member` TEXT,"
     @"`owner_id` TEXT,"
     @"`latitude` TEXT,"
     @"`longitude` TEXT,"
     @"`area` TEXT,"
     @"`text_title` TEXT,"
     @"`text_content` TEXT,"
     @"`coin` TEXT,"
     @"`currency_unit` TEXT,"
     @"`date_type` TEXT,"
     @"`date_info` TEXT,"
     @"`classification` TEXT,"
     @"`telephone` TEXT,"
     @"`is_get_member_info` TEXT,"
     @"`member_info_list` TEXT,"
     @"`nickname` TEXT,"
     @"`thumbnail` TEXT,"
     @"`thumbnail_local` TEXT,"
     @"`is_member_join` TEXT,"
     @"`member_info` TEXT,"
     @"`start_time` TEXT,"
     @"`insert_time` TEXT)"];
	
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `event_media` "
     @"(`event_id` TEXT,"
     @"`file_id` TEXT,"
     @"`thumb_id` TEXT,"
     @"`ext` TEXT,"
     @"`duration` TEXT,"
     @"`remote_id` TEXT)"];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `event_date` "
     @"(`event_id` TEXT,"
     @"`date` TEXT,"
     @"`time` TEXT,"
     @"`joined_number` TEXT,"
     @"`is_join` TEXT)"];
    
	// create event review table
	[db executeUpdate:@"CREATE TABLE IF NOT EXISTS `event_review` "
     @"(`id` TEXT PRIMARY KEY,"
     @"`event_id` TEXT,"
     @"`text` TEXT,"
     @"`timestamp` TEXT,"
     @"`type` TEXT,"
     @"`uid` TEXT,"
     @"`nickname` TEXT,"
     @"`reply_to_review_id` TEXT,"
     @"`reply_to_uid` TEXT,"
     @"`read_status` TEXT,"
     @"`invisible` TEXT,"
     @"`reply_to_nickname` TEXT)"];
    
    // create event apply members
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `event_apply_members`"
     @"(`event_id` TEXT,"
     @"`member_id` TEXT,"
     @"`nickname` TEXT,"
     @"`status` TEXT,"
     @"`real_name` TEXT,"
     @"`telephone_number` TEXT,"
     @" `upload_photo_timestamp` TEXT)"];

    
    // create moments table
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `moment` "
     @"(`id` TEXT PRIMARY KEY,"
     @"`text` TEXT,"
     @"`latitude` TEXT,"
     @"`longitude` TEXT,"
     @"`allow_review` TEXT,"
     @"`owner_uid` TEXT,"
     @"`user_type` TEXT,"
     @"`privacy_level` TEXT,"
     @"`timestamp` TEXT,"
     @"`liked_by_me` TEXT,"
     @"`momentType` TEXT,"
     @"`deadline` TEXT,"
     @"`place` TEXT)"];
    
    // create event multimedia table
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `moment_media` "
     @"(`fileid` TEXT,"   //file id in S3
     @"`moment_id` TEXT,"
     @"`ext` TEXT,"
     @"`duration` TEXT,"
     @"`thumbid` TEXT,"
     @"`dbid` TEXT)"];  //moment_media id in server
    
    // create event review table
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `moment_review` "
     @"(`id` TEXT PRIMARY KEY,"
     @"`moment_id` TEXT,"
     @"`text` TEXT,"
     @"`timestamp` TEXT,"
     @"`type` TEXT,"
     @"`uid` TEXT,"
     @"`nickname` TEXT,"
     @"`reply_to_review_id` TEXT,"
     @"`reply_to_uid` TEXT,"
     @"`read_status` TEXT,"
     @"`invisible` TEXT,"
     @"`reply_to_nickname` TEXT)"];
    
    
    // create anonymous moments table
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `anonymous_moment` "
     @"(`id` TEXT ,"
     @"`text` TEXT,"
     @"`latitude` TEXT,"
     @"`longitude` TEXT,"
     @"`allow_review` TEXT,"
     @"`owner_uid` TEXT,"
     @"`user_type` TEXT,"
     @"`privacy_level` TEXT,"
     @"`timestamp` TEXT,"
     @"`liked_by_me` TEXT,"
     @"`momentType` TEXT,"
     @"`anonymousType` TEXT,"
     @"`bulletin_id` TEXT,"
     @"`anonymous_uid` TEXT,"
     @"`deadline` TEXT,"
     @"`class_id` TEXT,"
     @"`place` TEXT)"];
    
    
    // create a queue table to check which file is not uploaded.
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `media_queue` "
     @"(`fileid` TEXT,"   //file id in S3
     @"`is_thumbnail` TEXT,"
     @"`ext` TEXT,"
     @"`moment_id` TEXT)"];  //moment id in server
    
    
    // create moment cover table
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `cover_image` "
     @"(`uid` TEXT PRIMARY KEY,"
     @" `file_id` TEXT,"
     @" `ext` TEXT,"
     @" `timestamp` TEXT,"
     @" `need_to_download` TEXT)"];
    
    
    // create nearby buddy table
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `nearby_buddy` "
     @"(`buddy_id` TEXT,"
     @" `buddy_flag` TEXT)"];
    
    
    // create favorite group table
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `favoritegroup` "
     @"(`order` TEXT,"
     @" `groupid` TEXT)"];
    
    // create favorite buddy table
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `favoritebuddy` "
     @"(`buddyid` TEXT)"];
    
    
    //TODO: add group in the future
    // create nearby group table
 //   [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `nearbybuddy` "
 //    @"(`buddyid` TEXT)"];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `moment_survey_option`"
     @"(`moment_id` TEXT,"
     @" `option_id` TEXT,"
     @" `description` TEXT,"
     @" `vote_count` TEXT,"
     @" `is_voted` TEXT)"];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `moment_privacy_detail`"
     @"(`moment_id` TEXT,"
     @" `group_id` TEXT)"];

    
    [db executeUpdate:@"VACUUM"];
    

    // create schoolList
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `my_school`"
     @"(`school_id` TEXT,"
     @" `school_name` TEXT)"];
    
    // create classList
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `class_list`"
     @"(`class_id` TEXT,"
     @" `class_name` TEXT,"
     @" `name` TEXT,"
     @" `editable` TEXT,"
     @" `short_class_id` TEXT,"
     @" `intro` TEXT,"
     @" `is_group_name_changed` TEXT,"
     @" `is_member` TEXT,"
     @" `latitude` TEXT,"
     @" `longitude` TEXT,"
     @" `max_member` TEXT,"
     @" `member_count` TEXT,"
     @" `parent_id` TEXT,"
     @" `temp_group_flag` TEXT,"
     @" `thumbnail` TEXT,"
     @" `photo` TEXT,"
     @" `start_day` TEXT,"
     @" `end_day` TEXT,"
     @" `start_time` TEXT,"
     @" `end_time` TEXT,"
     @" `school_id` TEXT)"];
    
    
//    // create classList
//    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `school_class`"
//     @"(`class_id` TEXT,"
//     @" `name` TEXT,"
//     @" `school_id` TEXT,"
//     @" `introduction` TEXT,"
//     @" `class_name` TEXT)"];
    
    
    // create lesson
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `lesson_list`"
     @"(`class_id` TEXT,"
     @" `lesson_id` TEXT,"
     @" `title` TEXT,"
     @" `class_room_id` TEXT,"
     @" `class_room_name` TEXT,"
     @" `live` TEXT,"
     @" `start_date` TEXT,"
     @" `end_date` TEXT)"];
    
    // create lesson_performance
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `lesson_performance`"
     @"(`lesson_id` TEXT,"
     @" `student_id` TEXT,"
     @" `property_id` TEXT,"
     @" `property_value` TEXT,"
     @" `property_name` TEXT,"
     @" `performance_id` TEXT)"];

    // create homework
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `homework`"
     @"(`lesson_id` TEXT,"
     @" `homework_id` TEXT,"
     @" `title` TEXT)"];
    
    // create parent_feedback
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `feedback`"
     @"(`feedback_id` TEXT,"
     @" `lesson_id` TEXT,"
     @" `moment_id` TEXT,"
     @" `student_id` TEXT)"];
    
    // create person
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `school_members`"
     @"(`class_id` TEXT,"
     @" `uid` TEXT,"
     @" `nickName` TEXT,"
     @" `last_status` TEXT,"
     @" `sex` TEXT,"
     @" `device_number` TEXT,"
     @" `app_ver` TEXT,"
     @" `alias` TEXT,"
     @" `upload_photo_timestamp` TEXT,"
     @" `photo_filepath` TEXT,"
     @" `thumbnail_filepath` TEXT,"
     @" `need_to_download_photo` TEXT,"
     @" `need_to_download_thumbnail` TEXT,"
     @" `user_type` TEXT)"];
    

    
#warning test netWork_progress
#if 0
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `network_task`"
     @"(`id` INTEGER PRIMARY KEY AUTOINCREMENT,"
     @" `task_type` TEXT,"
     @" `task_unique_id` TEXT,"
     @" `child_task_number` TEXT,"
     @" `super_task_id` TEXT,"
     @" `task_item_number` TEXT,"
     @" `task_state` TEXT)"];
    
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS `network_task_items`"
     @"(`task_id` TEXT,"
     @" `item_index` TEXT,"
     @" `item_key` TEXT,"
     @" `item_value` TEXT)"];
#endif
    
	if ([db hadError]) {
		if(PRINT_LOG)NSLog(@"Database: Error: %@ (Code: %i)", [db lastErrorMessage], [db lastErrorCode]);
	}
    
    
   
    
}



+ (NSString *)getWowtalkidForUser:(NSString *)uid
{
    FMResultSet *res = [db executeQuery:@"SELECT `wowtalk_id` FROM `buddy_more_detail` WHERE `uid` = ?", uid];
    
    NSString *wowtalkid = nil;
    if (res && [res next])
    {
        wowtalkid = [res stringForColumnIndex:0];
    }
    [res close];
    
    return wowtalkid;
}

// Enable foreign key support in SQLite
+ (BOOL) enableForeignKeySupport {
	FMResultSet *res;
	BOOL supported;
    
	// Check for foreign key support in SQLite
	res = [db executeQuery:@"PRAGMA foreign_keys"];
	[res next];
	supported = [res intForColumnIndex:0] == 0;
	[res close];
    
	if (!supported) {
		return NO;
	}
    
	[db executeUpdate:@"PRAGMA foreign_keys = ON"];
    
	// Check for foreign key support in SQLite
	res = [db executeQuery:@"PRAGMA foreign_keys"];
	[res next];
	supported = [res intForColumnIndex:0] == 1;
	[res close];
    
	return supported;
}

// Tear down the database
+ (void) teardown {
    if (db)
    {
        [db release];
        db = nil;
    }
}

+ (void) dropAllTables:(BOOL)keepUserInfo {
    if(!keepUserInfo){
        [db executeUpdate:@"DROP TABLE `user_infos`"];
        
    }
    
    
	[db executeUpdate:@"DROP TABLE `buddys`"];
    [db executeUpdate:@"DROP TABLE `buddydetail`"];
	[db executeUpdate:@"DROP TABLE `block_list`"];
    [db executeUpdate:@"DROP TABLE `buddy_more_detail`"];
    
	[db executeUpdate:@"DROP TABLE `chatmessages`"];
	[db executeUpdate:@"DROP TABLE `calllogs`"];
	[db executeUpdate:@"DROP TABLE `group_chatroom`"];
	[db executeUpdate:@"DROP TABLE `group_member`"];
    [db executeUpdate:@"DROP TABLE `videocall_unsupported_device_list`"];
    
    [db executeUpdate:@"DROP TABLE `numbers_in_contact`"];
    

    
    [db executeUpdate:@"DROP TABLE `event`"];
    [db executeUpdate:@"DROP TABLE `event_detail`"];
    [db executeUpdate:@"DROP TABLE `event_review`"];
    [db executeUpdate:@"DROP TABLE `event_media`"];
    [db executeUpdate:@"DROP TABLE `event_date`"];
    
    [db executeUpdate:@"DROP TABLE 'moment'"];
    [db executeUpdate:@"DROP TABLE 'moment_media'"];
    [db executeUpdate:@"DROP TABLE 'moment_review'"];
    [db executeUpdate:@"DROP TABLE `anonymous_moment`"];
    
    
    [db executeUpdate:@"DROP TABLE 'my_school'"];
    [db executeUpdate:@"DROP TABLE 'class_list'"];
    [db executeUpdate:@"DROP TABLE 'school_members'"];
    [db executeUpdate:@"DROP TABLE 'lesson_performance'"];
    [db executeUpdate:@"DROP TABLE 'homework'"];
    [db executeUpdate:@"DROP TABLE 'feedback'"];
    
    [db executeUpdate:@"DROP TABLE 'lesson_list'"];
    
    [db executeUpdate:@"DROP TABLE 'unsent_receipts'"];

    
}

#pragma mark - Activities

+ (NSMutableArray *) fetchALLEventsDetail{
    
    NSMutableArray * acitivities = [[NSMutableArray alloc] init];
    NSString *strsql = [NSString stringWithFormat:@"SELECT * FROM  event_detail"];
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
    
    FMResultSet *res =  [db executeQuery:strsql];
    
    while (res && [res next]) {
        ActivityModel *activityModel = [[ActivityModel alloc]init];
        activityModel.event_id = [res stringForColumn:@"event_id"];
        activityModel.owner_id = [res stringForColumn:@"owner_id"];
        activityModel.insert_timestamp = [res stringForColumn:@"insert_timestamp"];
        activityModel.latitude = [res stringForColumn:@"latitude"];
        activityModel.longitude = [res stringForColumn:@"longitude"];
        activityModel.area = [res stringForColumn:@"area"];
        activityModel.max_member = [res stringForColumn:@"max_member"];
        activityModel.member_count = [res stringForColumn:@"member_count"];
        activityModel.text_title = [res stringForColumn:@"text_title"];
        activityModel.text_content = [res stringForColumn:@"text_content"];
        activityModel.coin = [res stringForColumn:@"coin"];
        activityModel.date_type = [res stringForColumn:@"date_type"];
        activityModel.date_info = [res stringForColumn:@"date_info"];
        activityModel.classification = [res stringForColumn:@"classification"];
        activityModel.is_get_member_info = [res stringForColumn:@"is_get_member_info"];
        activityModel.is_open = [res stringForColumn:@"is_open"];
        activityModel.tag = [res stringForColumn:@"tag"];
        
        [acitivities addObject:activityModel];
        [activityModel release];
    }
    
    return [acitivities autorelease];
}

+ (ActivityModel *) fetchEventsWithEventID:(NSString *)event_id{
    NSString *strsql = [NSString stringWithFormat:@"SELECT * FROM  event_detail where event_id = %@",event_id];
    
    FMResultSet *res =  [db executeQuery:strsql];
    ActivityModel *activityModel = [[ActivityModel alloc]init];
    while (res && [res next]) {
        activityModel.event_id = [res stringForColumn:@"event_id"];
        activityModel.owner_id = [res stringForColumn:@"owner_id"];
        activityModel.owner_name = [res stringForColumn:@"owner_name"];
        activityModel.tag = [res stringForColumn:@"tag"];
        activityModel.category = [res stringForColumn:@"category"];
        activityModel.insert_timestamp = [res stringForColumn:@"insert_timestamp"];
        activityModel.latitude = [res stringForColumn:@"latitude"];
        activityModel.longitude = [res stringForColumn:@"longitude"];
        activityModel.area = [res stringForColumn:@"area"];
        activityModel.max_member = [res stringForColumn:@"max_member"];
        activityModel.member_count = [res stringForColumn:@"member_count"];
        activityModel.text_title = [res stringForColumn:@"text_title"];
        activityModel.text_content = [res stringForColumn:@"text_content"];
        activityModel.coin = [res stringForColumn:@"coin"];
        activityModel.date_type = [res stringForColumn:@"date_type"];
        activityModel.date_info = [res stringForColumn:@"date_info"];
        activityModel.classification = [res stringForColumn:@"classification"];
        activityModel.is_get_member_info = [res stringForColumn:@"is_get_member_info"];
        activityModel.is_open = [res stringForColumn:@"is_open"];
        activityModel.start_timestamp = [res stringForColumn:@"start_timestamp"];
        activityModel.end_timestamp = [res stringForColumn:@"end_timestamp"];
        activityModel.is_joined = [res stringForColumn:@"is_joined"];
    }
    
    strsql = [NSString stringWithFormat:@"SELECT * FROM  event_media where event_id = %@",event_id];
    FMResultSet *res2 =  [db executeQuery:strsql];
    while (res2 && [res2 next]) {
        WTFile *file = [[WTFile alloc]init];
        file.fileid = [res2 stringForColumn:@"file_id"];
        file.thumbnailid = [res2 stringForColumn:@"thumb_id"];
        file.ext = [res2 stringForColumn:@"ext"];
        file.duration = [[res2 stringForColumn:@"duration"] floatValue];
        [activityModel.mediaArray addObject:file];
        [file release];
    }
    
    return activityModel;
}

+ (NSMutableArray *) fetchAllEventsByApplyState:(ApplyStateOfEvent)applyState ByEventState:(EventState)eventState withOffset:(NSInteger)offset WithLimit:(int)limit{
    
    NSMutableArray * acitivities = [[NSMutableArray alloc] init];
    NSString *strsql = nil;
    if (applyState == AllEvents){
        strsql = @"SELECT * FROM  event_detail WHERE";
    }else if (applyState == ApplyedEvents){
        strsql = [NSString stringWithFormat:@"SELECT * FROM  event_detail WHERE is_joined = %d and", 1];
    }else if (applyState == ReleaseByMyselfEvents){
        strsql = [NSString stringWithFormat:@"SELECT * FROM  event_detail WHERE owner_id = '%@' and", [WTUserDefaults getUid]];
    }
    
    NSString *dateString =  [NSString stringWithFormat:@"%zi",(NSInteger)[[NSDate date] timeIntervalSince1970]];
    if (eventState == UNStartOfEventState){
        
        strsql = [NSString stringWithFormat:@"%@ %@ %@ LIMIT %zi, %d"
                  ,strsql,
                  [NSString stringWithFormat:@" start_timestamp > '%@'",dateString]
                  ,@"ORDER BY start_timestamp ASC "
                  ,offset
                  ,limit];
        
    }else if (eventState == DoingOfEventState){
        
        strsql = [NSString stringWithFormat:@"%@ %@ and %@ %@ LIMIT %zi, %d"
                  ,strsql
                  ,[NSString stringWithFormat:@" start_timestamp < '%@'",dateString]
                  ,[NSString stringWithFormat:@" end_timestamp > '%@'",dateString]
                  ,@"ORDER BY start_timestamp ASC "
                  ,offset
                  ,limit];
        
    }else if (eventState == EndedOfEventState){
        strsql = [NSString stringWithFormat:@"%@ %@ %@ LIMIT %zi, %d"
                  ,strsql
                  ,[NSString stringWithFormat:@" end_timestamp < '%@'",dateString]
                  ,@"ORDER BY end_timestamp DESC "
                  ,offset
                  ,limit];
    }
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
    
    FMResultSet *res =  [db executeQuery:strsql];
    while (res && [res next]) {
        ActivityModel *activityModel = [[ActivityModel alloc]init];
        activityModel.event_id = [res stringForColumn:@"event_id"];
        activityModel.owner_id = [res stringForColumn:@"owner_id"];
        activityModel.owner_name = [res stringForColumn:@"owner_name"];
        activityModel.tag = [res stringForColumn:@"tag"];
        activityModel.category = [res stringForColumn:@"category"];
        activityModel.insert_timestamp = [res stringForColumn:@"insert_timestamp"];
        activityModel.latitude = [res stringForColumn:@"latitude"];
        activityModel.longitude = [res stringForColumn:@"longitude"];
        activityModel.area = [res stringForColumn:@"area"];
        activityModel.max_member = [res stringForColumn:@"max_member"];
        activityModel.member_count = [res stringForColumn:@"member_count"];
        activityModel.text_title = [res stringForColumn:@"text_title"];
        activityModel.text_content = [res stringForColumn:@"text_content"];
        activityModel.coin = [res stringForColumn:@"coin"];
        activityModel.date_type = [res stringForColumn:@"date_type"];
        activityModel.date_info = [res stringForColumn:@"date_info"];
        activityModel.classification = [res stringForColumn:@"classification"];
        activityModel.is_get_member_info = [res stringForColumn:@"is_get_member_info"];
        activityModel.is_open = [res stringForColumn:@"is_open"];
        activityModel.start_timestamp = [res stringForColumn:@"start_timestamp"];
        activityModel.end_timestamp = [res stringForColumn:@"end_timestamp"];
        activityModel.is_joined = [res stringForColumn:@"is_joined"];
        
        
        
        FMResultSet * res1 = [db executeQuery:@"SELECT `file_id`,`thumb_id`,`ext`,`duration` ,`event_id` FROM `event_media` WHERE `event_id` = ?", [res stringForColumn:@"event_id"]];
        while (res1 && [res1 next]) {
            WTFile *file = [[WTFile alloc]init];
            file.momentid = [res1 stringForColumn:@"event_id"];
            file.fileid = [res1 stringForColumn:@"file_id"];
            file.thumbnailid = [res1 stringForColumn:@"thumb_id"];
            file.ext = [res1 stringForColumn:@"ext"];
            file.duration = [[res1 stringForColumn:@"duration"] doubleValue];
            [activityModel.mediaArray addObject:file];
            [file release];
        }
        
        
        
        
        [acitivities addObject:activityModel];
        [activityModel release];
    }
    
    
    
    
    return [acitivities autorelease];
    
}

+ (NSMutableArray *) fetchEventsDetailWithOffset:(int)offset WithLimit:(int)limit
{
    NSMutableArray * acitivities = [[NSMutableArray alloc] init];
    
    NSString *strsql = [NSString stringWithFormat:@"SELECT * FROM  event_detail ORDER BY insert_timestamp DESC LIMIT %d, %d", offset, limit];

    if(PRINT_LOG)NSLog(@"%@",strsql);
    
    FMResultSet *res =  [db executeQuery:strsql];
    
    while (res && [res next]) {
        ActivityModel *activityModel = [[ActivityModel alloc]init];
        activityModel.event_id = [res stringForColumn:@"event_id"];
        activityModel.owner_id = [res stringForColumn:@"owner_id"];
        activityModel.owner_name = [res stringForColumn:@"owner_name"];
        activityModel.tag = [res stringForColumn:@"tag"];
        activityModel.category = [res stringForColumn:@"category"];
        activityModel.insert_timestamp = [res stringForColumn:@"insert_timestamp"];
        activityModel.latitude = [res stringForColumn:@"latitude"];
        activityModel.longitude = [res stringForColumn:@"longitude"];
        activityModel.area = [res stringForColumn:@"area"];
        activityModel.max_member = [res stringForColumn:@"max_member"];
        activityModel.member_count = [res stringForColumn:@"member_count"];
        activityModel.text_title = [res stringForColumn:@"text_title"];
        activityModel.text_content = [res stringForColumn:@"text_content"];
        activityModel.coin = [res stringForColumn:@"coin"];
        activityModel.date_type = [res stringForColumn:@"date_type"];
        activityModel.date_info = [res stringForColumn:@"date_info"];
        activityModel.classification = [res stringForColumn:@"classification"];
        activityModel.is_get_member_info = [res stringForColumn:@"is_get_member_info"];
        activityModel.is_open = [res stringForColumn:@"is_open"];
        activityModel.start_timestamp = [res stringForColumn:@"start_timestamp"];
        activityModel.end_timestamp = [res stringForColumn:@"end_timestamp"];
        activityModel.is_joined = [res stringForColumn:@"is_joined"];
        [acitivities addObject:activityModel];
        [activityModel release];
    }
    
    return [acitivities autorelease];
}

+ (NSMutableArray *)fetchJoinedEvents{
    NSMutableArray * acitivities = [[NSMutableArray alloc] init];
    
    NSString *strsql = [NSString stringWithFormat:@"SELECT * FROM  event_detail WHERE is_joined = 1 ORDER BY insert_timestamp DESC "];
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
    
    FMResultSet *res =  [db executeQuery:strsql];
    while (res && [res next]) {
        ActivityModel *activityModel = [[ActivityModel alloc]init];
        activityModel.event_id = [res stringForColumn:@"event_id"];
        activityModel.owner_id = [res stringForColumn:@"owner_id"];
        activityModel.owner_name = [res stringForColumn:@"owner_name"];
        activityModel.tag = [res stringForColumn:@"tag"];
        activityModel.category = [res stringForColumn:@"category"];
        activityModel.insert_timestamp = [res stringForColumn:@"insert_timestamp"];
        activityModel.latitude = [res stringForColumn:@"latitude"];
        activityModel.longitude = [res stringForColumn:@"longitude"];
        activityModel.area = [res stringForColumn:@"area"];
        activityModel.max_member = [res stringForColumn:@"max_member"];
        activityModel.member_count = [res stringForColumn:@"member_count"];
        activityModel.text_title = [res stringForColumn:@"text_title"];
        activityModel.text_content = [res stringForColumn:@"text_content"];
        activityModel.coin = [res stringForColumn:@"coin"];
        activityModel.date_type = [res stringForColumn:@"date_type"];
        activityModel.date_info = [res stringForColumn:@"date_info"];
        activityModel.classification = [res stringForColumn:@"classification"];
        activityModel.is_get_member_info = [res stringForColumn:@"is_get_member_info"];
        activityModel.is_open = [res stringForColumn:@"is_open"];
        activityModel.start_timestamp = [res stringForColumn:@"start_timestamp"];
        activityModel.end_timestamp = [res stringForColumn:@"end_timestamp"];
        activityModel.is_joined = [res stringForColumn:@"is_joined"];
        
        [acitivities addObject:activityModel];
        [activityModel release];
    }
    
    return [acitivities autorelease];
}

+ (NSMutableArray *) fetchEventsWithOffset:(int)offset WithLimit:(int)limit
{
	NSMutableArray * acitivities = [[NSMutableArray alloc] init];
    
    NSString *strsql = [NSString stringWithFormat:@"SELECT `event_id`, `insert_timestamp`, `max_member`, `owner_id`, `latitude`, `longitude`, `area`, `text_title`, `text_content`, `coin`, `date_type`, `date_info`, `classification`, `telephone`, `is_get_member_info`, `member_info_list`, `nickname`, `thumbnail`, `thumbnail_local`, `is_member_join`, `member_info`, `start_time`, `insert_time`, `currency_unit` FROM `event` ORDER BY `start_time` ASC LIMIT %d, %d", offset, limit];
    
	if(PRINT_LOG)NSLog(@"%@",strsql);
    
	FMResultSet *res =  [db executeQuery:strsql];
    
    while (res && [res next]) {
        
        int i = -1;
        
        
        Activity * activity = [[Activity alloc] initwithID:[res stringForColumnIndex:++i]
                                                insertTime:[[res stringForColumnIndex:++i] longLongValue]
                                                 maxMember:[[res stringForColumnIndex:++i] integerValue]
                                                   ownerId:[res stringForColumnIndex:++i]
                                                  latitude:[[res stringForColumnIndex:++i] doubleValue]
                                                 longitude:[[res stringForColumnIndex:++i] doubleValue]
                                                      area:[res stringForColumnIndex:++i]
                                                     title:[res stringForColumnIndex:++i]
                                                   content:[res stringForColumnIndex:++i]
                                                      coin:[[res stringForColumnIndex:++i] integerValue]
                                                  dateType:[[res stringForColumnIndex:++i] integerValue]
                                                  dateInfo:[res stringForColumnIndex:++i]
                                            classification:[res stringForColumnIndex:++i]
                                                 telephone:[res stringForColumnIndex:++i]
                                             getMemberInfo:[[res stringForColumnIndex:++i] isEqualToString:@"0"] ? NO : YES
                                            memberInfoList:[res stringForColumnIndex:++i]
                                                  nickname:[res stringForColumnIndex:++i]
                                               thumbnailId:[res stringForColumnIndex:++i]
                                             thumbnailPath:[res stringForColumnIndex:++i]
                                            memberJoinable:[[res stringForColumnIndex:++i] isEqualToString:@"0"] ? NO : YES
                                                memberInfo:[res stringForColumnIndex:++i]
                                                 startTime:[res stringForColumnIndex:++i]
                                                insertTime:[res stringForColumnIndex:++i]
                                              currencyUnit:[res stringForColumnIndex:++i]];
        NSLog(@"joinable %d", activity.memberJoinable);
        FMResultSet* mediaResultSet =  [db executeQuery:@"SELECT `file_id`,`thumb_id`,`ext`,`remote_id`,`duration` FROM `event_media` WHERE `event_id` = ?", activity.eventId];
        while (mediaResultSet && [mediaResultSet next]) {
            
            i=-1;
            
            WTFile* wtfile= [[[WTFile alloc] initWithFileID:[mediaResultSet stringForColumn:@"file_id"]
                                            withThumbnailID:[mediaResultSet stringForColumn:@"thumb_id"]
                                                    withExt:[mediaResultSet stringForColumn:@"ext"]
                                              withLocalPath:@""
                                                   withDBid:[mediaResultSet stringForColumn:@"remote_id"]
                                               withDuration:[[mediaResultSet stringForColumn:@"duration"] doubleValue] ] autorelease];
            
            [activity.mediaArray addObject:wtfile];
            
        }
        
        FMResultSet *dateResultSet = [db executeQuery:@"SELECT `date`, `time`, `joined_number`, `is_join` FROM `event_date` WHERE `event_id` = ?", activity.eventId];
        while (dateResultSet && [dateResultSet next]) {
            i = -1;
            EventDate *date = [[EventDate alloc] initWithDate:[dateResultSet stringForColumn:@"date"]
                                                         time:[dateResultSet stringForColumn:@"time"]
                                                 joinedNumber:[[dateResultSet stringForColumn:@"joined_number"] integerValue]
                                                       joined:[[dateResultSet stringForColumn:@"is_join"] boolValue]];
            [activity.dateArray addObject:date];
            [date release];
        }
        
        
        
        [mediaResultSet close];
        
		[acitivities addObject:activity];
        [activity release];
	}
    
	return [acitivities autorelease];        
}

+ (void)storeEvents:(NSMutableArray*)events
{
    for (Activity* event in events) {
        [Database storeEvent:event];
    }
}


+ (NSMutableArray *)fetchMyEvents
{
    NSMutableArray *acitivities = [[NSMutableArray alloc] init];
    
	NSString* strsql=@"SELECT `event_id`,`owner_id`, `insert_timestamp`, `longitude`,`latitude`, `startdate`,`place`,`max_member`  ,`text_title` ,`text_content`  ,`event_type`,`contact_email`,`member_count`,`membership`,`thumbnail` ,`possible_member_count` ,`deadline`,`creator` FROM `event` WHERE `membership` = 2";
	
    
	if(PRINT_LOG)NSLog(@"%@",strsql);
    
	FMResultSet *res =  [db executeQuery: strsql];
	
	while (res && [res next]) {
        
        int i=-1;
        
        Activity * activity = [[[Activity alloc] initwithID:[res stringForColumnIndex:++i]
                                                insertTime:[[res stringForColumnIndex:++i] longLongValue]
                                                 maxMember:[[res stringForColumnIndex:++i] integerValue]
                                                   ownerId:[res stringForColumnIndex:++i]
                                                  latitude:[[res stringForColumnIndex:++i] doubleValue]
                                                 longitude:[[res stringForColumnIndex:++i] doubleValue]
                                                      area:[res stringForColumnIndex:++i]
                                                     title:[res stringForColumnIndex:++i]
                                                   content:[res stringForColumnIndex:++i]
                                                      coin:[[res stringForColumnIndex:++i] integerValue]
                                                  dateType:[[res stringForColumnIndex:++i] integerValue]
                                                  dateInfo:[res stringForColumnIndex:++i]
                                            classification:[res stringForColumnIndex:++i]
                                                 telephone:[res stringForColumnIndex:++i]
                                             getMemberInfo:[[res stringForColumnIndex:++i] isEqualToString:@"0"] ? NO : YES
                                            memberInfoList:[res stringForColumnIndex:++i]
                                                  nickname:[res stringForColumnIndex:++i]
                                               thumbnailId:[res stringForColumnIndex:++i]
                                             thumbnailPath:[res stringForColumnIndex:++i]
                                            memberJoinable:[[res stringForColumnIndex:++i] isEqualToString:@"0"] ? NO : YES
                                                memberInfo:[res stringForColumnIndex:++i]
                                                 startTime:[res stringForColumnIndex:++i]
                                                insertTime:[res stringForColumnIndex:++i]
                                              currencyUnit:[res stringForColumnIndex:++i]] autorelease];
        
        
       FMResultSet* res1 =  [db executeQuery:@"SELECT `fileid`,`thumbid`,`ext`,`dbid`,`duration` FROM `event_media` WHERE `event_id` = ?", activity.eventId];
        while (res1 && [res1 next]) {
            
            i=-1;
            
            WTFile* wtfile= [[[WTFile alloc] initWithFileID:[res stringForColumnIndex:++i]
                                            withThumbnailID:[res stringForColumnIndex:++i]
                                                    withExt:[res stringForColumnIndex:++i]
                                              withLocalPath:nil
                                                   withDBid:[res stringForColumnIndex:++i]
                                               withDuration:[[res stringForColumnIndex:++i] doubleValue] ] autorelease];
            
            [activity.mediaArray addObject:wtfile];
            
        }
        
        [res1 close];
        
		[acitivities addObject:activity];
        
	}
	[res close];
    
	return [acitivities autorelease];
}

+ (BOOL)updateEvent:(Activity *)activity
{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    
    BOOL result = [db executeUpdate:@"UPDATE `event` SET `event_id`=?, `insert_timestamp`=?, `max_member`=?, `owner_id`=?, `latitude`=?, `longitude`=?, `area`=?, `text_title`=?, `text_content`=?, `coin`=?, `date_type`=?, `date_info`=?, `classification`=?, `telephone`=?, `is_get_member_info`=?, `member_info_list`=?, `nickname`=?, `thumbnail`=?, `thumbnail_local`=?, `is_member_join`=?, `member_info`=?, `start_time`=?, `insert_time`=?, `currency_unit`=? WHERE `event_id`=?",
                  activity.eventId,
                  [NSString stringWithFormat:@"%ld", activity.insertTimestamp],
                  [NSString stringWithFormat:@"%zi", activity.maxMemberNumber],
                  activity.ownerId,
                  [NSString stringWithFormat:@"%f", activity.latitude],
                  [NSString stringWithFormat:@"%f", activity.longitude],
                  activity.area,
                  activity.title,
                  activity.content,
                  [NSString stringWithFormat:@"%zi", activity.coin],
                  [NSString stringWithFormat:@"%zi", activity.dateType],
                  activity.dateInfo,
                  activity.classification,
                  activity.telephone,
                  [NSString stringWithFormat:@"%d", activity.getMemberInfo],
                  activity.memberInfoList,
                  activity.nickname,
                  activity.thumbnailId,
                  activity.thumbnailPath,
                  [NSString stringWithFormat:@"%d", activity.memberJoinable],
                  activity.memberInfo, activity.startTime, activity.insertTime,
                  activity.currencyUnit,
                  activity.eventId];
    if(!result) {
        if (newTransaction) {
            [db commit];
        }
        return NO;
    }
    
    // overwrite media table
    [db executeUpdate:@"DELETE FROM `event_media` WHERE  `event_id`=?", activity.eventId];
    if(activity.mediaArray != nil) {
        for (WTFile *wtfile in activity.mediaArray) {
            result = [db executeUpdate:@"INSERT INTO `event_media` (`event_id`,`file_id`, `thumb_id`,`ext`, `duration`, `remote_id`) VALUES (?, ?, ?, ?, ?, ?)",
                      activity.eventId,
                      wtfile.fileid,
                      wtfile.thumbnailid,
                      wtfile.ext,
                      [NSString stringWithFormat:@"%f", wtfile.duration],
                      wtfile.dbid];
            if(!result) {
                if (newTransaction) {
                    [db commit];
                }
                return NO;
            }
            
        }
    }
    [db executeUpdate:@"DELETE FROM `event_date` WHERE `event_id`=?", activity.eventId];
    if (activity.dateArray != nil) {
        for (EventDate *date in activity.dateArray) {
            result = [db executeUpdate:@"INSERT INTO `event_date` (`event_id`, `date`, `time`, `joined_number`, `is_join`) VALUES (?, ?, ?, ?, ?)",
                      activity.eventId,
                      date.date,
                      date.time,
                      [NSString stringWithFormat:@"%zi", date.joinedNumber],
                      [NSString stringWithFormat:@"%d", date.hasJoined]];
            if (!result) {
                if (newTransaction) {
                    [db commit];
                }
                return NO;
            }
        }
    }
    
    if (newTransaction) {
        [db commit];
    }
    
    return result;
}

+ (BOOL)storeEvent:(Activity *)activity{
    
    BOOL newTransaction = ![db inTransaction];
	if (newTransaction) {
        [db beginTransaction];
    }
	
    FMResultSet *res = [db executeQuery:@"SELECT `event_id` FROM `event` WHERE `event_id` = ?", activity.eventId];
    
    BOOL isUpdating=false;
    if (res && [res next])
    {
        isUpdating = true;
    }
    BOOL result = FALSE;
    if(isUpdating){
        result = [db executeUpdate:@"UPDATE `event` SET `event_id`=?, `insert_timestamp`=?, `max_member`=?, `owner_id`=?, `latitude`=?, `longitude`=?, `area`=?, `text_title`=?, `text_content`=?, `coin`=?, `date_type`=?, `date_info`=?, `classification`=?, `telephone`=?, `is_get_member_info`=?, `member_info_list`=?, `nickname`=?, `thumbnail`=?, `thumbnail_local`=?, `is_member_join`=?, `member_info`=?, `start_time`=?, `insert_time`=?, `currency_unit`=? WHERE `event_id`=?",
               activity.eventId,
               [NSString stringWithFormat:@"%ld", activity.insertTimestamp],
               [NSString stringWithFormat:@"%zi", activity.maxMemberNumber],
               activity.ownerId,
               [NSString stringWithFormat:@"%f", activity.latitude],
               [NSString stringWithFormat:@"%f", activity.longitude],
               activity.area,
               activity.title,
               activity.content,
               [NSString stringWithFormat:@"%zi", activity.coin],
               [NSString stringWithFormat:@"%zi", activity.dateType],
               activity.dateInfo,
               activity.classification,
               activity.telephone,
               [NSString stringWithFormat:@"%d", activity.getMemberInfo],
               activity.memberInfoList,
               activity.nickname,
               activity.thumbnailId,
               activity.thumbnailPath,
               [NSString stringWithFormat:@"%d", activity.memberJoinable],
               activity.memberInfo, activity.startTime, activity.insertTime,
               activity.currencyUnit,
               activity.eventId];
    } else {
        result = [db executeUpdate:@"INSERT INTO `event` (`event_id`, `insert_timestamp`, `max_member`, `owner_id`, `latitude`, `longitude`, `area`, `text_title`, `text_content`, `coin`, `date_type`, `date_info`, `classification`, `telephone`, `is_get_member_info`, `member_info_list`, `nickname`, `thumbnail`, `thumbnail_local`, `is_member_join`, `member_info`, `start_time`, `insert_time`, `currency_unit`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
               activity.eventId,
               [NSString stringWithFormat:@"%ld", activity.insertTimestamp],
               [NSString stringWithFormat:@"%zi", activity.maxMemberNumber],
               activity.ownerId,
               [NSString stringWithFormat:@"%f", activity.latitude],
               [NSString stringWithFormat:@"%f", activity.longitude],
               activity.area,
               activity.title,
               activity.content,
               [NSString stringWithFormat:@"%zi", activity.coin],
               [NSString stringWithFormat:@"%zi", activity.dateType],
               activity.dateInfo,
               activity.classification,
               activity.telephone,
               [NSString stringWithFormat:@"%d", activity.getMemberInfo],
               activity.memberInfoList,
               activity.nickname,
               activity.thumbnailId,
               activity.thumbnailPath,
               [NSString stringWithFormat:@"%d", activity.memberJoinable],
               activity.memberInfo, activity.startTime, activity.insertTime, activity.currencyUnit];
    }
    
    if(!result) {
        if (newTransaction) {
            [db commit];
        }
        return NO;
    }
    
    // overwrite media table
    [db executeUpdate:@"DELETE FROM `event_media` WHERE  `event_id`=?", activity.eventId];
    if(activity.mediaArray != nil) {
        for (WTFile *wtfile in activity.mediaArray) {
            result = [db executeUpdate:@"INSERT INTO `event_media` (`event_id`,`file_id`, `thumb_id`,`ext`, `duration`, `remote_id`) VALUES (?, ?, ?, ?, ?, ?)",
                      activity.eventId,
                      wtfile.fileid,
                      wtfile.thumbnailid,
                      wtfile.ext,
                      [NSString stringWithFormat:@"%f", wtfile.duration],
                      wtfile.dbid];
            if(!result) {
                if (newTransaction) {
                    [db commit];
                }
                return NO;
            }
            
        }
    }
    [db executeUpdate:@"DELETE FROM `event_date` WHERE `event_id`=?", activity.eventId];
    if (activity.dateArray != nil) {
        for (EventDate *date in activity.dateArray) {
            result = [db executeUpdate:@"INSERT INTO `event_date` (`event_id`, `date`, `time`, `joined_number`, `is_join`) VALUES (?, ?, ?, ?, ?)",
                      activity.eventId,
                      date.date,
                      date.time,
                      [NSString stringWithFormat:@"%zi", date.joinedNumber],
                      [NSString stringWithFormat:@"%d", date.hasJoined]];
            if (!result) {
                if (newTransaction) {
                    [db commit];
                }
                return NO;
            }
        }
    }
    
    if (newTransaction) {
        [db commit];
    }
    
    return result;
    
}


+ (BOOL)storeEventWithModel:(ActivityModel *)activityModel{
    
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    NSLog(@"%@",NSHomeDirectory());
    FMResultSet *res = [db executeQuery:@"SELECT event_id FROM event_detail WHERE event_id = ?", activityModel.event_id];
    
    BOOL isUpdating=false;
    if (res && [res next])
    {
        isUpdating = true;
    }
    BOOL result = FALSE;

    if(isUpdating){
        result = [db executeUpdate:@"UPDATE event_detail SET event_id=?, owner_id=?, owner_name=?,tag=?,category=?,insert_timestamp=?, latitude=?, longitude=?, area=?, max_member=?, member_count=?, text_title=?, text_content=?, coin=?, date_type=?, date_info=?, classification=?, is_get_member_info=?, is_open=? , start_timestamp=?, end_timestamp=?,is_joined=? ,mediaArray=? WHERE event_id=?",
                  activityModel.event_id,
                  activityModel.owner_id,
                  activityModel.owner_name,
                  activityModel.tag,
                  activityModel.category,
                  activityModel.insert_timestamp,
                  activityModel.latitude,
                  activityModel.longitude,
                  activityModel.area,
                  activityModel.max_member,
                  activityModel.member_count,
                  activityModel.text_title,
                  activityModel.text_content,
                  activityModel.coin,
                  activityModel.date_type,
                  activityModel.date_info,
                  activityModel.classification,
                  activityModel.is_get_member_info,
                  activityModel.is_open,
                  activityModel.start_timestamp,
                  activityModel.end_timestamp,
                  activityModel.is_joined,
                  [NSNumber numberWithInteger:[activityModel.mediaArray count]],
                  activityModel.event_id];
    } else {
        result = [db executeUpdate:@"INSERT INTO event_detail (event_id,owner_id,owner_name,tag,category,insert_timestamp,latitude,longitude,area,max_member,member_count,text_title ,text_content,coin,date_type ,date_info,classification,is_get_member_info,is_open,start_timestamp,end_timestamp,is_joined,mediaArray) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                  activityModel.event_id,
                  activityModel.owner_id,
                  activityModel.owner_name,
                  activityModel.tag,
                  activityModel.category,
                  activityModel.insert_timestamp,
                  activityModel.latitude,
                  activityModel.longitude,
                  activityModel.area,
                  activityModel.max_member,
                  activityModel.member_count,
                  activityModel.text_title,
                  activityModel.text_content,
                  activityModel.coin,
                  activityModel.date_type,
                  activityModel.date_info,
                  activityModel.classification,
                  activityModel.is_get_member_info,
                  activityModel.is_open,
                  activityModel.start_timestamp,
                  activityModel.end_timestamp,
                  activityModel.is_joined,
                  [NSNumber numberWithInteger:[activityModel.mediaArray count]]];
    }
    
    if(!result) {
        if (newTransaction) {
            [db commit];
        }
        return NO;
    }
    
    if (activityModel.mediaArray != nil && activityModel.mediaArray.count != 0){
        [db executeUpdate:@"DELETE FROM `event_media` WHERE  `event_id`=?",activityModel.event_id];
        
        if(activityModel.mediaArray != nil) {
            for (WTFile *file in activityModel.mediaArray) {
                result=[db executeUpdate:@"INSERT INTO `event_media` (`file_id`,`event_id`, `ext`,`duration`,`thumb_id`) VALUES (?, ?, ?, ?,?)",
                     file.fileid,
                     activityModel.event_id,
                     file.ext,
                     [NSString stringWithFormat:@"%f",file.duration] ,
                     file.thumbnailid];
            }
            if(!result) {
                if (newTransaction)
                    [db commit];
                return false;
            }
        }
    }
    
    if (newTransaction) {
        [db commit];
    }
    
    return result;
    
}

+ (BOOL)deleteAllEvents
{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    BOOL result = [db executeUpdate:@"DELETE FROM `event`"];
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

+ (BOOL)updateEvent:(Activity *)activity withJoined:(BOOL)joined andMemberInfo:(NSString *)memberInfo
{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    BOOL result = [db executeUpdate:@"UPDATE `event` SET `is_member_join`=?, `member_info`=? WHERE `event_id`=?",
                   [NSString stringWithFormat:@"%d", joined],
                   [NSString stringWithFormat:@"%@", memberInfo],
                   activity.eventId];
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

+ (WTFile *)getThumbnailForEvent:(Activity *)aActivity
{
    WTFile *file = nil;
    FMResultSet *resultSet = [db executeQuery:@"SELECT `file_id`, `thumb_id`, `ext` FROM `event_media` WHERE `event_id` =? AND `thumb_id`=?",
                              aActivity.eventId, aActivity.thumbnailId];
    if (resultSet && [resultSet next]) {
        file = [[WTFile alloc] initWithFileID:[resultSet stringForColumn:@"file_id"]
                              withThumbnailID:[resultSet stringForColumn:@"thumb_id"]
                                      withExt:[resultSet stringForColumn:@"ext"]
                                withLocalPath:@""
                                     withDBid:@""
                                 withDuration:0];
    }
    return [file autorelease];
}



+ (BOOL)storeEventApplyMembersWithModel:(EventApplyMemberModel *)eventApplyMemberModel{
    
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    FMResultSet *res = nil;
    res =[db executeUpdate:@"DELETE FROM `event_apply_members` WHERE `event_id`=? AND `member_id`=?"
                        ,eventApplyMemberModel.event_id
                        ,eventApplyMemberModel.member_id];
    
    BOOL result = FALSE;
    
    result = [db executeUpdate:@"INSERT INTO `event_apply_members` (`event_id`,`member_id`,`nickname`,`status`,`upload_photo_timestamp`,`real_name`,`telephone_number`) VALUES (?,?,?,?,?,?,?)"
              ,eventApplyMemberModel.event_id
              ,eventApplyMemberModel.member_id
              ,eventApplyMemberModel.nickname
              ,eventApplyMemberModel.status
              ,eventApplyMemberModel.upload_photo_timestamp
              ,eventApplyMemberModel.real_name
              ,eventApplyMemberModel.telephone_number];
    
    if(!result) {
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



+ (BOOL)deleteEventApplyMembersWithEventID:(NSString *)event_id
{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    BOOL result = [db executeUpdate:@"DELETE FROM `event_apply_members` WHERE `event_id`=?"
                   ,event_id];
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

+ (BOOL)deleteAllEventDetail{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    BOOL result = [db executeUpdate:@"DELETE FROM `event_detail`"];
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

+ (NSMutableArray *)fetchMembersWithEventID:(NSString *)event_id{
    NSMutableArray * memberArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `event_apply_members` WHERE `event_id`= ?",event_id];
    
    while (res && [res next]) {
        EventApplyMemberModel *eventApplyMemberModel = [[EventApplyMemberModel alloc]init];
        eventApplyMemberModel.event_id = [res stringForColumn:@"event_id"];
        eventApplyMemberModel.member_id = [res stringForColumn:@"member_id"];
        eventApplyMemberModel.nickname = [res stringForColumn:@"nickname"];
        eventApplyMemberModel.status = [res stringForColumn:@"status"];
        eventApplyMemberModel.upload_photo_timestamp = [res stringForColumn:@"upload_photo_timestamp"];
        eventApplyMemberModel.real_name = [res stringForColumn:@"real_name"];
        eventApplyMemberModel.telephone_number = [res stringForColumn:@"telephone_number"];
        [memberArray addObject:eventApplyMemberModel];
        [eventApplyMemberModel release];
    }
    [res close];
    return [memberArray autorelease];
}


#pragma mark - Moment
+ (BOOL)storeMoment:(Moment*)moment{
    
    
    
    // if the moment has not finishing uploading, we don't change local data. otherwise, problem occurs
    if ([Database isInTheQueue:moment.moment_id]) {
        return FALSE;
    }
    
    // if one doesn't have access to the moment, we don't store the moment. we need to make sure one doesn't possess this moment.
    if (moment.viewableGroups!=nil&& [moment.viewableGroups count]>0) {
        BOOL ableToSee = FALSE;
        if ([moment.owner.userID isEqualToString:[WTUserDefaults getUid]]) {
            ableToSee = TRUE;
        }
        else{
            for (NSString* groupid in moment.viewableGroups) {
                if ([Database isMember:[WTUserDefaults getUid] inDepartment:groupid]) {
                    ableToSee = TRUE;
                }
            }
        }
        
        if (!ableToSee) {
            return FALSE;
        }
        
    }
    
    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];
    
    FMResultSet *res = [db executeQuery:@"SELECT `id` FROM `moment` WHERE `id` = ?", moment.moment_id];
    
    BOOL isUpdating=false;
    if (res && [res next]){
        isUpdating = true;
    }
    
    BOOL rlt=FALSE;
    if(isUpdating){
        rlt=[db executeUpdate:@"UPDATE `moment` SET `text`=?, `latitude`=?,`longitude`=?, `allow_review`=?,`owner_uid`=?,`user_type`=?,`privacy_level`=?,`timestamp`=?,`liked_by_me`=?,`place`=?,`momentType`=?,`deadline`=? WHERE `id`=?",
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
        rlt=[db executeUpdate:@"INSERT INTO `moment` (`id`,`text`, `latitude`,`longitude`, `allow_review`,`owner_uid`,`user_type`,`privacy_level`,`timestamp`,`liked_by_me`,`place`,`momentType`,`deadline`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)",
             moment.moment_id,
             moment.text,
             [NSString stringWithFormat:@"%f", moment.latitude],
             [NSString stringWithFormat:@"%f", moment.longitude],
             moment.allowReview?@"1":@"0",
             (moment.owner!=nil)?moment.owner.userID:@"",
             (moment.owner!=nil)?[NSString stringWithFormat:@"%zi",moment.owner.userType] :@"",
             [NSString stringWithFormat:@"%zi", moment.privacyLevel],
             [NSString stringWithFormat:@"%zi", moment.timestamp],
             moment.likedByMe?@"1":@"0", moment.placename,
             [NSString stringWithFormat:@"%d",moment.momentType],
             [NSString stringWithFormat:@"%f",moment.deadline]];
    }
    
    //  NSLog(@"%@",[db lastErrorMessage]);
    if(!rlt) {
        if (newTransaction)
            [db commit];
        return false;
    }
    // overwrite media table
    [db executeUpdate:@"DELETE FROM `moment_media` WHERE  `moment_id`=?",moment.moment_id];
    
    if(moment.multimedias != nil) {
        for (WTFile *wtfile in moment.multimedias) {
            rlt=[db executeUpdate:@"INSERT INTO `moment_media` (`fileid`,`moment_id`, `ext`,`dbid`,`duration`,`thumbid`) VALUES (?, ?, ?, ?,?,?)",
                 wtfile.fileid,
                 moment.moment_id,
                 wtfile.ext,
                 wtfile.dbid,[NSString stringWithFormat:@"%f",wtfile.duration],wtfile.thumbnailid];
            if(!rlt) {
                if (newTransaction)
                    [db commit];
                return false;
            }
        }
    }
    
    // update review table
    [db executeUpdate:@"DELETE FROM `moment_review` WHERE  `moment_id`=?",moment.moment_id];
    
    if(moment.reviews != nil) {
        for(Review* r in moment.reviews) {
            rlt=[Database storeMomentReview:r forMomentID:moment.moment_id];
            if(!rlt) {
                if (newTransaction)
                    [db commit];
                return false;
            }
        }
    }
    
    
    // update privacy groups and options
    rlt = [self storeMomentPrivacy:moment];
    rlt = [self storeMomentOptions:moment];
    
    if (newTransaction)
        [db commit];
    
    
    return rlt;
    
}


+(BOOL)storeMomentPrivacy:(Moment*)moment{
    
    [db executeUpdate:@"DELETE FROM `moment_privacy_detail` WHERE  `moment_id`=?",moment.moment_id];
    
    BOOL success = FALSE;
    
    if (moment.viewableGroups != nil) {
        for (NSString* group_id in moment.viewableGroups) {
            success = [db executeUpdate:@"INSERT INTO `moment_privacy_detail` (`moment_id`,`group_id`) VALUES (?, ?)",
                       moment.moment_id,
                       group_id];
            if (!success) {
                return FALSE;
            }
        }
    }
    
    return TRUE;
    
}

+(BOOL)storeMomentOptions:(Moment*)moment{
    [db executeUpdate:@"DELETE FROM `moment_survey_option` WHERE  `moment_id`=?",moment.moment_id];
    
    BOOL success = FALSE;
    
    if (moment.options != nil) {
        for (Option* option in moment.options) {
            success = [db executeUpdate:@"INSERT INTO `moment_survey_option` (`moment_id`,`option_id`,`description`,`vote_count`,`is_voted`) VALUES (?, ?,?,?,?)",
                       moment.moment_id,[NSString stringWithFormat:@"%d",option.option_id], option.desc, [NSString stringWithFormat:@"%d",option.vote_count],option.is_voted?@"1":@"0"];
            if (!success) {
                return FALSE;
            }
        }
    }
    
    return TRUE;
}


+ (BOOL)updateMoment:(NSString*)momentID withDBidInServer:(NSString*)dbid{
    
    if (momentID==nil || dbid==nil) {
        return FALSE;
    }
    
    return
    [db executeUpdate:@"UPDATE `moment_media` SET `dbid`=? WHERE `moment_id`=?",
     dbid,
     momentID];
}

+(Moment*)getMomentWithID:(NSString*)moment_id
{
    NSString* strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`user_type`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline` FROM `moment` WHERE `id` = %@ ",moment_id];
    
    FMResultSet *res =  [db executeQuery: strsql];
    if (res && [res next]) {
        int i = -1;
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


+(CoverImage*) getCoverImageByUid:(NSString*)uid
{
    //  NSLog(@"to get the cover image by uid");
   	if (uid==nil) {
        return nil;
    }
    FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`uid`, `file_id`,`ext`,`timestamp`,`need_to_download`"
                        @"FROM `cover_image`"
                        @"WHERE uid=? ",uid];
    
    if (res && [res next]) {
        CoverImage *ident = [[[CoverImage alloc] init] autorelease];
        ident.uid = [res stringForColumnIndex:0];
        ident.file_id = [res stringForColumnIndex:1];
        ident.ext = [res stringForColumnIndex:2];
        ident.timestamp = [res stringForColumnIndex:3];
        ident.needDownload = [[res stringForColumnIndex:4] boolValue] ;
        ident.coverNotSet =[[res stringForColumnIndex:3] intValue]<0 ;
        [res close];
        return ident;
    }
    
    return nil;
    
    
}
+(BOOL) storeCoverImage:(CoverImage*)coverimage
{
    if (coverimage == nil) {
        return FALSE;
    }
    
    if(PRINT_LOG)NSLog(@"store cover image for buddy: %@",coverimage.uid);
    
    // We're already inside a transaction if we were called from within
    // storebuddys. If that isn't the case, make sure we start a new
    // transaction.
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction)
        [db beginTransaction];
    
    FMResultSet *res = [db executeQuery:@"SELECT `uid` FROM `cover_image` WHERE `uid`=?",coverimage.uid];
    
    if (res && [res next]) {
        
        if(PRINT_LOG)NSLog(@"cover image exist ,do update");
        
        [db executeUpdate:@"UPDATE `cover_image` SET `uid`=?, `file_id`=?,`ext`=?,`timestamp`=?,`need_to_download`=?  WHERE `uid`=? ",
         coverimage.uid,
         coverimage.file_id,
         coverimage.ext,
         coverimage.timestamp?coverimage.timestamp:@"-1",
         coverimage.needDownload?@"1":@"0",
         coverimage.uid
         ];
        
    }
    else {
        if(PRINT_LOG)NSLog(@"cover image doesnt exist ,do insert");
        [db executeUpdate:@"INSERT INTO `cover_image` (`uid`, `file_id`,`ext`,`timestamp`,`need_to_download`) VALUES (?, ?, ?, ?, ?)",
         coverimage.uid,
         coverimage.file_id,
         coverimage.ext,
         coverimage.timestamp?coverimage.timestamp:@"-1",
         coverimage.needDownload?@"1":@"0"];
    }
    
    //   NSLog(@"error: %@",[db lastErrorMessage]);
    if (newTransaction)
        [db commit];
    
    return TRUE;
}


// method to fecth moments in a category for a given group.
+(NSMutableArray*)fetchStatusMomentsInGroup:(NSString*)groupid withLimit:(int)limit andOffset:(int)offset{
    
    NSMutableArray *moments = [[NSMutableArray alloc] init];
    
    NSString* strsql= [NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline`, `member_id`, `user_type` FROM `group_member` INNER JOIN  `moment` on `group_member`.`member_id` = `moment`.`owner_uid`  WHERE `group_member`.`group_id`='%@' AND `moment`.`momentType` = 0 ORDER BY `timestamp` DESC  LIMIT %d,%d",groupid,offset,limit];
    
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
    FMResultSet *res =  [db executeQuery: strsql];
    
    //  NSLog(@"error: %@",[db lastErrorMessage]);
    while (res && [res next]) {
        
        Moment* moment= [[[Moment alloc] initWithMomentID:[res stringForColumnIndex:0]
                                                 withText:[res stringForColumnIndex:1]
                                               withOwerID:[res stringForColumnIndex:2]
                                             withUserType:[res stringForColumn:@"user_type"]
                                             withNickname:nil
                                            withTimestamp:[res stringForColumnIndex:3]
                                            withLongitude:[res stringForColumnIndex:4]
                                             withLatitude:[res stringForColumnIndex:5]
                                         withPrivacyLevel:[res stringForColumnIndex:6]
                                          withAllowReview:[res stringForColumnIndex:7]
                                            withLikedByMe:[res stringForColumnIndex:8]
                                            withPlacename:[res stringForColumnIndex:9]
                                           withMomentType:[res stringForColumnIndex:10]
                                             withDeadline:[res stringForColumnIndex:11]] autorelease];
        
        
        
        
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
        
        [moments addObject:moment];
        [res1 close];
    }
    [res close];
    [Database addSpecificPrivacyMomentToArray:moments withGroup:groupid withTag:0];
    return [moments autorelease];
}

+(NSMutableArray*)fetchQAMomentsInGroup:(NSString*)groupid withLimit:(int)limit andOffset:(int)offset{
    
    NSMutableArray *moments = [[NSMutableArray alloc] init];
    
    NSString* strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline`, `member_id`,`user_type` FROM `group_member` INNER JOIN  `moment` on `group_member`.`member_id` = `moment`.`owner_uid`  WHERE `group_member`.`group_id`='%@' AND `moment`.`momentType` = 1 ORDER BY `timestamp` DESC  LIMIT %d,%d",groupid,offset,limit];
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
    FMResultSet *res =  [db executeQuery: strsql];
    
    //  NSLog(@"error: %@",[db lastErrorMessage]);
    while (res && [res next]) {
        Moment* moment= [[[Moment alloc] initWithMomentID:[res stringForColumnIndex:0]
                                                 withText:[res stringForColumnIndex:1]
                                               withOwerID:[res stringForColumnIndex:2]
                                             withUserType:[res stringForColumn:@"user_type"]
                                             withNickname:nil
                                            withTimestamp:[res stringForColumnIndex:3]
                                            withLongitude:[res stringForColumnIndex:4]
                                             withLatitude:[res stringForColumnIndex:5]
                                         withPrivacyLevel:[res stringForColumnIndex:6]
                                          withAllowReview:[res stringForColumnIndex:7]
                                            withLikedByMe:[res stringForColumnIndex:8]
                                            withPlacename:[res stringForColumnIndex:9]
                                           withMomentType:[res stringForColumnIndex:10]
                                             withDeadline:[res stringForColumnIndex:11]] autorelease];
        
        
        
        
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
        
        [moments addObject:moment];
        [res1 close];
    }
    [res close];
    [Database addSpecificPrivacyMomentToArray:moments withGroup:groupid withTag:1];
    return [moments autorelease];
    
    
}

+(NSMutableArray*)fetchSurveyMomentsInGroup:(NSString*)groupid withLimit:(int)limit andOffset:(int)offset{
    
    NSMutableArray *moments = [[NSMutableArray alloc] init];
    
    NSString*  strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline`, `member_id`,`user_type` FROM `group_member` INNER JOIN  `moment` on `group_member`.`member_id` = `moment`.`owner_uid`  WHERE `group_member`.`group_id`='%@' AND (`moment`.`momentType` = 3 OR  `moment`.`momentType` = 4) ORDER BY `timestamp` DESC  LIMIT %d,%d",groupid,offset,limit];
    
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
    FMResultSet *res =  [db executeQuery: strsql];
    
    //  NSLog(@"error: %@",[db lastErrorMessage]);
    while (res && [res next]) {
        
        Moment* moment= [[[Moment alloc] initWithMomentID:[res stringForColumnIndex:0]
                                                 withText:[res stringForColumnIndex:1]
                                               withOwerID:[res stringForColumnIndex:2]
                                             withUserType:[res stringForColumn:@"user_type"]
                                             withNickname:nil
                                            withTimestamp:[res stringForColumnIndex:3]
                                            withLongitude:[res stringForColumnIndex:4]
                                             withLatitude:[res stringForColumnIndex:5]
                                         withPrivacyLevel:[res stringForColumnIndex:6]
                                          withAllowReview:[res stringForColumnIndex:7]
                                            withLikedByMe:[res stringForColumnIndex:8]
                                            withPlacename:[res stringForColumnIndex:9]
                                           withMomentType:[res stringForColumnIndex:10]
                                             withDeadline:[res stringForColumnIndex:11]] autorelease];
        
        
        
        
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
                
                Option* option = [[Option alloc] initWithMomentID:[res1 stringForColumnIndex:0]
                                                     WithOptionID:[res1 stringForColumnIndex:1]
                                                  withDescription:[res1 stringForColumnIndex:2] withVoteCount:[res1 stringForColumnIndex:3] withIsVoted:[res1 stringForColumnIndex:4]];
                
                [moment.options addObject:option];
                [option release];
            }
        }
        
        
        
        [moments addObject:moment];
        [res1 close];
    }
    [res close];
    [Database addSpecificPrivacyMomentToArray:moments withGroup:groupid withTag:3];
    return [moments autorelease];
    
}

+(NSMutableArray*)fetchReportMomentsInGroup:(NSString*)groupid withLimit:(int)limit andOffset:(int)offset{
    
    NSMutableArray *moments = [[NSMutableArray alloc] init];
    
    NSString* strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline`, `member_id`,`user_type` FROM `group_member` INNER JOIN  `moment` on `group_member`.`member_id` = `moment`.`owner_uid`  WHERE `group_member`.`group_id`='%@' AND `moment`.`momentType` = 2 ORDER BY `timestamp` DESC  LIMIT %d,%d",groupid,offset,limit];
    
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
    FMResultSet *res =  [db executeQuery: strsql];
    
    //  NSLog(@"error: %@",[db lastErrorMessage]);
    while (res && [res next]) {
        
        Moment* moment= [[[Moment alloc] initWithMomentID:[res stringForColumnIndex:0]
                                                 withText:[res stringForColumnIndex:1]
                                               withOwerID:[res stringForColumnIndex:2]
                                             withUserType:[res stringForColumn:@"user_type"]
                                             withNickname:nil
                                            withTimestamp:[res stringForColumnIndex:3]
                                            withLongitude:[res stringForColumnIndex:4]
                                             withLatitude:[res stringForColumnIndex:5]
                                         withPrivacyLevel:[res stringForColumnIndex:6]
                                          withAllowReview:[res stringForColumnIndex:7]
                                            withLikedByMe:[res stringForColumnIndex:8]
                                            withPlacename:[res stringForColumnIndex:9]
                                           withMomentType:[res stringForColumnIndex:10]
                                             withDeadline:[res stringForColumnIndex:11]] autorelease];
        
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
        
        [moments addObject:moment];
        [res1 close];
    }
    [res close];
    [Database addSpecificPrivacyMomentToArray:moments withGroup:groupid withTag:2];
    return [moments autorelease];
}



/**
 * Fetch the Moments of all buddies, ordered by timestamp desc.
 *
 * @param limit Limits the number of rows returned by the query,
 * @param offset the offset of row from where to start the query,
 */
+ (NSMutableArray*) fetchMomentsForAllBuddiesWithLimit:(int)limit andOffset:(int)offset{
    return [Database fetchMomentsForBuddy:nil withLimit:limit andOffset:offset];
    
}


+ (NSMutableArray*) fetchMomentsForAllBuddiesWithLimit:(int)limit andOffset:(int)offset withtags:(NSArray*)tags withOwnerType:(NSInteger )momentOwnerType{
    return [Database fetchMomentsForBuddy:nil withLimit:limit andOffset:offset withtags:tags withOwnerType:momentOwnerType];

}


+(void)deleteAllMoment
{
    [db executeUpdate:@"DELETE FROM `moment`"];
    [db executeUpdate:@"DELETE FROM `moment_media`"];
    [db executeUpdate:@"DELETE FROM `moment_review`"];
    [db executeUpdate:@"DELETE FROM `moment_privacy_detail`"];
    [db executeUpdate:@"DELETE FROM `moment_survey_option`"];
    [db executeUpdate:@"DELETE FROM `my_favorite`"];
}

+(void)addSpecificPrivacyMomentToArray:(NSMutableArray *)momentsArray withGroup:(NSString *)grupId withTag:(int)tag
{
    NSMutableDictionary *privacyMomentIds = [[NSMutableDictionary alloc] init];
    FMResultSet *res1 = [db executeQuery:@"SELECT `moment_id` FROM `moment_privacy_detail` WHERE `group_id` = ?", grupId];
    while (res1 && [res1 next]) {
        NSString* moment_id  = [res1 stringForColumnIndex:0];
        [privacyMomentIds setObject:moment_id forKey:moment_id];
    }
    
    for (Moment *aMoment in momentsArray) {
        if (nil != [privacyMomentIds objectForKey:aMoment.moment_id]) {
            [privacyMomentIds removeObjectForKey:aMoment.moment_id];
        }
    }
    
    for (NSString *aMomentId in privacyMomentIds) {
        Moment *moment2add=[Database getMomentWithID:aMomentId];
        if (nil != moment2add && (tag < 0 || tag == moment2add.momentType)) {
            [momentsArray addObject:moment2add];
        }
    }
    
    if ([privacyMomentIds count] > 0) {
        NSSortDescriptor * sortByA = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
        [momentsArray sortUsingDescriptors:[NSArray arrayWithObject:sortByA]];
    }
    
    [privacyMomentIds release];
}

+(NSMutableArray*)fetchMomentsForAllBuddiesInGroup:(NSString*)groupid WithLimit:(int)limit andOffset:(int)offset
{
    
    if(PRINT_LOG)NSLog(@"fetchMomentsForBuddysInGroup for %@,and limit %d ,and offset=%d",groupid,limit,offset);
    
    NSMutableArray *moments = [[NSMutableArray alloc] init];
    
    NSString* strsql=@"";
    
    strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline`, `member_id`,`user_type` FROM `group_member` INNER JOIN  `moment` on `group_member`.`member_id` = `moment`.`owner_uid`  WHERE `group_member`.`group_id`='%@'  ORDER BY `timestamp` DESC  LIMIT %d,%d",groupid,offset,limit];
    
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
    FMResultSet *res =  [db executeQuery: strsql];
    
    while (res && [res next]) {
        
        Moment* moment= [[[Moment alloc] initWithMomentID:[res stringForColumnIndex:0]
                                                 withText:[res stringForColumnIndex:1]
                                               withOwerID:[res stringForColumnIndex:2]
                                             withUserType:[res stringForColumn:@"user_type"]
                                             withNickname:nil
                                            withTimestamp:[res stringForColumnIndex:3]
                                            withLongitude:[res stringForColumnIndex:4]
                                             withLatitude:[res stringForColumnIndex:5]
                                         withPrivacyLevel:[res stringForColumnIndex:6]
                                          withAllowReview:[res stringForColumnIndex:7]
                                            withLikedByMe:[res stringForColumnIndex:8]
                                            withPlacename:[res stringForColumnIndex:9]
                                           withMomentType:[res stringForColumnIndex:10]
                                             withDeadline:[res stringForColumnIndex:11]] autorelease];
        
        
        
        
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
                Option* option = [[Option alloc] initWithMomentID:[res1 stringForColumnIndex:0]
                                                     WithOptionID:[res1 stringForColumnIndex:1]
                                                  withDescription:[res1 stringForColumnIndex:2] withVoteCount:[res1 stringForColumnIndex:3] withIsVoted:[res1 stringForColumnIndex:4]];
                
                [moment.options addObject:option];
                [option release];
            }
        }
        [moments addObject:moment];
        [res1 close];
    }
    [res close];
    
    [Database addSpecificPrivacyMomentToArray:moments withGroup:groupid withTag:-1];
    return [moments autorelease];
    
    
}



/**
 * Fetch the Moments of a Buddy, ordered by timestamp desc.
 * @param uID :  the buddy id we want to get moments of;  get moments for all buddies is buddy is nil
 * @param limit Limits the number of rows returned by the query,
 * @param offset the offset of row from where to start the query,
 */
+ (NSMutableArray*) fetchMomentsForBuddy:(NSString*)uID withLimit:(int)limit andOffset:(int)offset{
    
    
    
    if(PRINT_LOG)NSLog(@"fetchMomentsForBuddy for %@,and limit %d ,and offset=%d",uID,limit,offset);
    
    NSMutableArray *moments = [[NSMutableArray alloc] init];
    
    NSString* strsql=@"";
    
    /* @param uID :  the buddy id we want to get moments of;  get moments for all buddies is buddy is nil */
    if(uID==nil){
        strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`user_type`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline` FROM `moment` ORDER BY `timestamp` DESC  LIMIT %d,%d",offset,limit];
    }
    else{
        strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`user_type`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline` FROM `moment` WHERE `owner_uid`='%@'  ORDER BY `timestamp` DESC  LIMIT %d,%d",uID,offset,limit];
        
    }
    
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
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
                Option* option = [[Option alloc] initWithMomentID:[res1 stringForColumnIndex:0]
                                                     WithOptionID:[res1 stringForColumnIndex:1]
                                                  withDescription:[res1 stringForColumnIndex:2] withVoteCount:[res1 stringForColumnIndex:3] withIsVoted:[res1 stringForColumnIndex:4]];
                
                [moment.options addObject:option];
                [option release];
            }
        }
        
        
        
        [moments addObject:moment];
        [res1 close];
    }
    [res close];
    
    return [moments autorelease];
    
    
}



#pragma mark - coca
+ (NSMutableArray*) fetchMomentsForBuddy:(NSString*)uID  withLimit:(int)limit andOffset:(int)offset withtags:(NSArray*)tags withOwnerType:(NSInteger)momentOwnerType{
    
    
    
    if(PRINT_LOG)NSLog(@"fetchMomentsForBuddy for %@,and limit %d ,and offset=%d, and tags=%@",uID,limit,offset,tags);
    
    NSMutableArray *moments = [[NSMutableArray alloc] init];
    
    
    NSString* sqlConUID = (uID==nil)?@"1=1":[NSString stringWithFormat:@"`owner_uid`='%@'",uID];
    NSString* sqlConTag = @"1=1";
    if (tags!=nil) {
        sqlConTag = [NSString stringWithFormat:@" (`momentType` =%@", tags[0]];
        for (int i=1; i<[tags count]; i++) {
            sqlConTag = [NSString stringWithFormat:@"%@ OR `momentType` =%@", sqlConTag, tags[i] ];
        }
        sqlConTag = [NSString stringWithFormat:@"%@)", sqlConTag];

    }
    NSString *sqlMomentOwnerType = (momentOwnerType == 99)? @"1 = 1":[NSString stringWithFormat:@"`user_type` =%zi",momentOwnerType];
    
    
    NSString* strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`owner_uid`,`user_type`,`timestamp`,`longitude`,`latitude`, `privacy_level`,`allow_review`, `liked_by_me`,`place`,`momentType`,`deadline` FROM `moment` WHERE `owner_uid`<> '(anonymous)' AND %@ AND %@ AND %@ ORDER BY `timestamp` DESC  LIMIT %d,%d",sqlConUID,sqlConTag,sqlMomentOwnerType,offset,limit];
        
    
    
    if(PRINT_LOG)NSLog(@"%@",strsql);
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
                Option* option = [[Option alloc] initWithMomentID:[res1 stringForColumnIndex:0]
                                                     WithOptionID:[res1 stringForColumnIndex:1]
                                                  withDescription:[res1 stringForColumnIndex:2] withVoteCount:[res1 stringForColumnIndex:3] withIsVoted:[res1 stringForColumnIndex:4]];
                
                [moment.options addObject:option];
                [option release];
            }
        }
        
        
        
        [moments addObject:moment];
        [res1 close];
    }
    [res close];
    
    return [moments autorelease];
    
    
}






+ (NSMutableArray*) getUnreadReviews
{
    //   if(PRINT_LOG)NSLog(@"getUnreadReviews");
    
    NSMutableArray *reviews = [[NSMutableArray alloc] init];
    
    NSString* strsql=@"";
    
    
    strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`uid`,`nickname`,`timestamp`,`type`,`reply_to_review_id`,`reply_to_uid`,`reply_to_nickname`,`read_status`,`moment_id`,`invisible` FROM `moment_review` WHERE `uid`!= '%@' AND `reply_to_uid`= '%@' AND `read_status` = 0  ORDER BY `timestamp` DESC" ,[WTUserDefaults getUid],[WTUserDefaults getUid]];
    
    
    
    //	if(PRINT_LOG)NSLog(@"%@",strsql);
    FMResultSet *res =  [db executeQuery: strsql];
    
    //  NSLog(@"fetch review list error: %@",[db lastErrorMessage]);
    while (res && [res next]) {
        
        Review* review= [[[Review alloc] initWithReviewID:[res stringForColumnIndex:0]
                                                 withText:[res stringForColumnIndex:1]
                                               withOwerID:[res stringForColumnIndex:2]
                                             withNickname:[res stringForColumnIndex:3]
                                            withTimestamp:[res stringForColumnIndex:4]
                                                 withType:[res stringForColumnIndex:5]
                                      withReplyToReviewID:[res stringForColumnIndex:6]
                                           withReplyToUID:[res stringForColumnIndex:7]
                                      withReplyToNickname:[res stringForColumnIndex:8]
                                          withAlreadyRead:[[res stringForColumnIndex:9] boolValue]] autorelease];
        
        review.moment_id = [res stringForColumnIndex:10];
        review.invisible = [[res stringForColumnIndex:11] boolValue];
        
        [reviews addObject:review];
        
    }
    
    [res close];
    
    return [reviews autorelease];
    
}

+ (NSMutableArray*) fetchMomentReviewListWithLimit:(int)limit andOffset:(int)offset
{
    
    if(PRINT_LOG)NSLog(@"fetchReviewlist and limit %d ,and offset=%d",limit,offset);
    
    NSMutableArray *reviews = [[NSMutableArray alloc] init];
    
    NSString* strsql=@"";
    
    
    strsql=[NSString stringWithFormat:@"SELECT `id`,`text`,`uid`,`nickname`,`timestamp`,`type`,`reply_to_review_id`,`reply_to_uid`,`reply_to_nickname`,`read_status`,`moment_id`,`invisible` FROM `moment_review` WHERE `reply_to_uid`= '%@' AND `invisible` = 0  ORDER BY `timestamp` DESC  LIMIT %d,%d",[WTUserDefaults getUid], offset,limit];
    
    
    
    //	if(PRINT_LOG)NSLog(@"%@",strsql);
    FMResultSet *res =  [db executeQuery: strsql];
    
    //   NSLog(@"fetch review list error: %@",[db lastErrorMessage]);
    while (res && [res next]) {
        Review* review= [[[Review alloc] initWithReviewID:[res stringForColumnIndex:0]
                                                 withText:[res stringForColumnIndex:1]
                                               withOwerID:[res stringForColumnIndex:2]
                                             withNickname:[res stringForColumnIndex:3]
                                            withTimestamp:[res stringForColumnIndex:4]
                                                 withType:[res stringForColumnIndex:5]
                                      withReplyToReviewID:[res stringForColumnIndex:6]
                                           withReplyToUID:[res stringForColumnIndex:7]
                                      withReplyToNickname:[res stringForColumnIndex:8]
                                          withAlreadyRead:[[res stringForColumnIndex:9] boolValue]] autorelease];
        
        review.moment_id = [res stringForColumnIndex:10];
        review.invisible = [[res stringForColumnIndex:11] boolValue];
        
        [reviews addObject:review];
        
    }
    
    [res close];
    
    return [reviews autorelease];
    
}
+ (Review*) getMyLikedReviewForMoment:(NSString*)moment_id
{
    if (moment_id == nil) {
        return nil;
    }
    
    FMResultSet * res = [db executeQuery:@"SELECT `id`,`text`,`uid`,`nickname`,`timestamp`,`type`,`reply_to_review_id`,`reply_to_uid`,`reply_to_nickname`,`read_status`,`invisible` FROM `moment_review` WHERE `moment_id` = ? AND `uid` = ? AND `type` = ?", moment_id,[WTUserDefaults getUid], @"0"];
    
    //   NSLog(@"error: %@",[db lastErrorMessage]);
    
    if (res&&[res next]) {
        Review* review= [[Review alloc] initWithReviewID:[res stringForColumnIndex:0]
                                                withText:[res stringForColumnIndex:1]
                                              withOwerID:[res stringForColumnIndex:2]
                                            withNickname:[res stringForColumnIndex:3]
                                           withTimestamp:[res stringForColumnIndex:4]
                                                withType:[res stringForColumnIndex:5]
                                     withReplyToReviewID:[res stringForColumnIndex:6]
                                          withReplyToUID:[res stringForColumnIndex:7]
                                     withReplyToNickname:[res stringForColumnIndex:8]
                                         withAlreadyRead:[[res stringForColumnIndex:9] boolValue]];
        
        
        
        review.invisible = [[res stringForColumnIndex:10] boolValue];
        return [review autorelease];
        
    }
    
    return nil;
    
}


+ (BOOL) deleteMomentWithMomentID:(NSString*) moment_id{
    if (moment_id==nil) {
        return FALSE;
    }
    BOOL rlt=FALSE;
    rlt=[db executeUpdate:@"DELETE FROM `moment` WHERE  `id`=?",moment_id];
    
    if(!rlt)return rlt;
    
    rlt=[db executeUpdate:@"DELETE FROM `moment_media` WHERE  `moment_id`=?",moment_id];
    
    if(!rlt)return rlt;
    
    rlt=[db executeUpdate:@"DELETE FROM `moment_privacy_detail` WHERE  `moment_id`=?",moment_id];
    
    if(!rlt)return rlt;
    
    rlt=[db executeUpdate:@"DELETE FROM `moment_survey_option` WHERE  `moment_id`=?",moment_id];
    
    if(!rlt)return rlt;
    
    rlt=[db executeUpdate:@"DELETE FROM `moment_review` WHERE  `moment_id`=?",moment_id];
    
    return rlt;
    
    
}


+ (BOOL) storeMomentReview:(Review*) review  forMomentID:(NSString*)moment_id{
    
    [Database deleteReview:review.review_id ForMomemt:moment_id];
    
    BOOL rlt=FALSE;
    
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction)
        [db beginTransaction];
    
    rlt=[db executeUpdate:@"INSERT INTO `moment_review` (`id`,`moment_id`, `text`,`timestamp`, `type`, `uid`,`nickname`,`reply_to_review_id`,`reply_to_uid`,`reply_to_nickname`,`read_status`,`invisible`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)",
         review.review_id,
         moment_id,
         review.text,
         [NSString stringWithFormat:@"%zi",review.timestamp],
         [NSString stringWithFormat:@"%d",review.type],
         review.owerID,
         review.nickName,
         review.replyToReviewId,
         review.replyToUid,
         review.replyToNickname,
         [NSString stringWithFormat:@"%d",review.read],
         [NSString stringWithFormat:@"%d",review.invisible]];
    
    if ([db hadError]) {
        //   NSLog(@"store review error:%@",[db lastErrorMessage]);
    }
    
    if (newTransaction)
        [db commit];
    
    return rlt;
}


+(BOOL)storeQueuedMediaFile:(NSString*)fileid withExt:(NSString*)ext forMoment:(NSString*)momentid isThumbnail:(BOOL)isthumbnail;
{
    if ([NSString isEmptyString:fileid] || [NSString isEmptyString:momentid]) {
        return FALSE;
    }
    
    FMResultSet *res = [db executeQuery:@"SELECT `fileid` FROM `media_queue` WHERE `fileid`=?",fileid];
    if (res && [res next]){
        if(PRINT_LOG)NSLog(@"media file exist, do update");
        return [db executeUpdate:@"UPDATE `media_queue` SET `moment_id`= ?, `is_thumbnail`= ?, `ext`= ? WHERE `fileid`=? ",momentid,isthumbnail? @"1":@"0",ext, fileid];
    }
    else{
        if(PRINT_LOG)NSLog(@"media file doesnt exist ,do insert");
        return [db executeUpdate:@"INSERT INTO `media_queue` (`fileid`,`is_thumbnail`,`moment_id`, `ext`) VALUES (?,?,?,?)",
                fileid,isthumbnail? @"1":@"0",momentid,ext];
    }
}

+(BOOL)deleteQueuedMediaFile:(NSString*)fileid forMoment:(NSString*)momentid
{
    if ([NSString isEmptyString:fileid] || [NSString isEmptyString:momentid]) {
        return FALSE;
    }
    
    BOOL rlt=FALSE;
    
    rlt=[db executeUpdate:@"DELETE FROM `media_queue` WHERE  `fileid`=?",fileid];
    return rlt;
}


+(NSMutableArray*)queuedMedias
{
    NSMutableArray* medias = [[NSMutableArray alloc] init];
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `media_queue`"];
    while(res && [res next]){
        QueuedMedia* media = [[QueuedMedia alloc] init];
        media.fileid = [res stringForColumn:@"fileid"];
        media.isThumbnail = [[res stringForColumn:@"is_thumbnail"] isEqualToString:@"1"]? TRUE: FALSE;
        media.moment_id = [res stringForColumn:@"moment_id"];
        media.ext = [res stringForColumn:@"ext"];
        [medias addObject:media];
        [media release];
    }

    if ([medias count] > 0) {
        return [medias autorelease];
    }
    else{
        [medias release];
        return nil;
    }
}

+(BOOL)isInTheQueue:(NSString*)momentid
{
    if ([NSString isEmptyString:momentid]) {
        return FALSE;
    }
    FMResultSet *res = [db executeQuery:@"SELECT `fileid` FROM `media_queue` WHERE `moment_id`=?",momentid];
    if (res && [res next]){
        return TRUE;
    }
    else{
        return FALSE;
    }
}

+ (BOOL) deleteMomentReview:(Review*) review{
    if (review==nil) {
        return FALSE;
    }
    
    BOOL rlt=FALSE;
    
    rlt=[db executeUpdate:@"DELETE FROM `moment_review` WHERE  `id`=?",review.review_id];
    
    return rlt;
    
    
}

+ (BOOL) deleteReview:(NSString*)reviewid ForMomemt:(NSString*)momentid
{
    if (reviewid==nil || momentid == nil) {
        return FALSE;
    }
    
    BOOL rlt=FALSE;
    
    rlt=[db executeUpdate:@"DELETE FROM `moment_review` WHERE  `id`=? AND `moment_id`= ? ",reviewid,momentid];
    if ([db hadError]) {
        //  NSLog(@"delete review error: %@",[db lastErrorMessage]);
    }
    
    return rlt;
}

+(void)setReviewInvisible:(NSString*)reviewid
{
    if (reviewid == nil) {
        return;
    }
    [db executeUpdate:@"UPDATE `moment_review` SET `invisible`= ? WHERE `id`=? ",
     @"1", reviewid];
    
    return;
}

+(void)setReviewRead:(NSString*)reviewid
{
    if (reviewid == nil) {
        return;
    }
    [db executeUpdate:@"UPDATE `moment_review` SET `read_status`= ? WHERE `id`=? ",
     @"1", reviewid];
    
    return;
    
}

+(void)setReviewReadByArray:(NSArray*)reviewarray
{
    for (Review* review in reviewarray) {
        [Database setReviewRead:review.review_id];
    }
}
+(void)setReviewReadByIDArray:(NSArray*)reviewidarray
{
    for (NSString* reviewid in reviewidarray) {
        [Database setReviewRead:reviewid];
    }
}


#pragma mark - school relevance

+ (BOOL)storeSchoolWithModel:(SchoolModel *)school{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    FMResultSet *res = [db executeQuery:@"SELECT `school_id` FROM `my_school` WHERE `school_id` = ?", school.corp_id];
    
    BOOL isUpdating=false;
    if (res && [res next])
    {
        isUpdating = true;
    }
    [res close];
    BOOL result = FALSE;
    
    if(isUpdating){
        result = [db executeUpdate:@"UPDATE `my_school` SET `school_name`=? WHERE `school_id`=?",
                  school.corp_name,
                  school.corp_id];
    } else {
        result = [db executeUpdate:@"INSERT INTO `my_school` (`school_id`, `school_name`) VALUES (?, ?)",
                  school.corp_id,
                  school.corp_name];
    }
    if (newTransaction) {
        [db commit];
    }
    return result;
}


+(void)deleteMySchool
{
    if(PRINT_LOG)NSLog(@"delete all my_school");
    [db executeUpdate:@"DELETE FROM `my_school`"];
}

+ (NSMutableArray *)fetchAllSchool{
    NSMutableArray * schoolArray = [[NSMutableArray alloc] init];
    NSString *strsql = [NSString stringWithFormat:@"SELECT * FROM `my_school`"];
    
    FMResultSet *res =  [db executeQuery:strsql];
    
    while (res && [res next]) {
        SchoolModel *school = [[SchoolModel alloc]init];
        school.corp_id = [res stringForColumn:@"school_id"];
        school.corp_name = [res stringForColumn:@"school_name"];
        [schoolArray addObject:school];
        [school release];
    }
    [res close];
    
    return [schoolArray autorelease];
}



+ (BOOL)storeClassWithModel:(ClassModel *)classModel{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    FMResultSet *res = [db executeQuery:@"SELECT `class_id` FROM `school_class` WHERE `class_id` = ?", classModel.group_id];
    
    BOOL isUpdating=false;
    if (res && [res next])
    {
        isUpdating = true;
    }
    BOOL result = FALSE;
    
    if(isUpdating){
        result = [db executeUpdate:@"UPDATE `school_class` SET  `class_name`=?,`name`=? ,`school_id`=? ,`introduction`=? WHERE `class_id`=?",
                  classModel.group_name,
                  classModel.name,
                  classModel.school_id,
                  classModel.introduction,
                  classModel.group_id];
    } else {
        result = [db executeUpdate:@"INSERT INTO `school_class` (`class_id`, `class_name`,`name`,`introduction`,`school_id`) VALUES (?,?,?,?,?)",
                  classModel.group_id,
                  classModel.group_name,
                  classModel.name,
                  classModel.introduction,
                  classModel.school_id];
    }
    
    
    if (newTransaction) {
        [db commit];
    }
    [res close];
    return result;
}



+ (BOOL)isClassWithGroupID:(NSString *)group_id{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `school_class` WHERE `class_id` = ?", group_id];
    
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

+(void)deleteMyClass
{
    if(PRINT_LOG)NSLog(@"delete all school_class");
    [db executeUpdate:@"DELETE FROM `school_class`"];
}

+ (NSMutableArray *)fetchClassWithSchoolID:(NSString *)school_id{
    NSMutableArray * classArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `school_class` WHERE `school_id`= ? ",school_id];
    
    while (res && [res next]) {
        ClassModel *classModel = [[ClassModel alloc]init];
        classModel.group_id = [res stringForColumn:@"class_id"];
        classModel.group_name = [res stringForColumn:@"class_name"];
        classModel.name = [res stringForColumn:@"name"];
        classModel.school_id = [res stringForColumn:@"school_id"];
        classModel.introduction = [res stringForColumn:@"introduction"];
        [classArray addObject:classModel];
        [classModel release];
    }
    [res close];
    return [classArray autorelease];
}




+ (BOOL)storeSchoolMember:(PersonModel *)personModel{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    FMResultSet *res = [db executeQuery:@"SELECT `class_id` FROM `school_members` WHERE `uid` = ? AND `class_id` = ?", personModel.uid,personModel.class_id];
    
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
        result = [db executeUpdate:@"UPDATE `school_members` SET `nickName`=? ,`upload_photo_timestamp`=?,`alias`=?,`user_type`=? WHERE `class_id`=? and `uid`=?",
                  personModel.nickName,
                  personModel.upload_photo_timestamp,
                  personModel.alias,
                  personModel.user_type,
                  personModel.class_id,
                  personModel.uid];
    } else {
        result = [db executeUpdate:@"INSERT INTO `school_members` (`class_id`, `uid`,`nickName`,`alias`,`upload_photo_timestamp`,`user_type`) VALUES (?,?,?,?,?,?)",
                  personModel.class_id,
                  personModel.uid,
                  personModel.nickName,
                  personModel.alias,
                  personModel.upload_photo_timestamp,
                  personModel.user_type];
    }
    
    if (newTransaction) {
        [db commit];
    }
   
    return result;
}

+(void)deleteMySchoolMembers
{
    if(PRINT_LOG)NSLog(@"delete all school_members");
    [db executeUpdate:@"DELETE FROM `school_members`"];
}

+ (BOOL)storeSchoolMemberSex:(PersonModel *)personModel{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    FMResultSet *res = [db executeQuery:@"SELECT `class_id` FROM `school_members` WHERE `uid` = ? ", personModel.uid];
    
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
        result = [db executeUpdate:@"UPDATE `school_members` SET `nickName`=? ,`upload_photo_timestamp`=?,`user_type`=? ,`alias`=?,`sex`=? WHERE  `uid`=? ",
                  personModel.nickName,
                  personModel.upload_photo_timestamp,
                  personModel.user_type,
                  personModel.alias,
                  personModel.sex,
                  personModel.uid];
    } else {
        result = [db executeUpdate:@"INSERT INTO `school_members` (`class_id`, `uid`,`nickName`,`upload_photo_timestamp`,`alias`,`user_type`,`sex`) VALUES (?,?,?,?,?,?,?)",
                  personModel.class_id,
                  personModel.uid,
                  personModel.nickName,
                  personModel.upload_photo_timestamp,
                  personModel.alias,
                  personModel.user_type,
                  personModel.sex];
    }
    
    if (newTransaction) {
        [db commit];
    }
    [res close];
    return result;
}

+ (NSString *)getSchoolIDWithClassID:(NSString *)classID{
    FMResultSet *res = [db executeQuery:@"SELECT `school_id` FROM `school_class` WHERE `class_id` = ? ",
                              classID];
    
    while(res && [res next]){
        NSString* school_id = [res stringForColumn:@"school_id"];
        return school_id;
    }
    return nil;
}

+ (ClassModel *)getClassWithClassID:(NSString *)classID{
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `school_class` WHERE `class_id` = ? ",
                        classID];
    
    while(res && [res next]){
        ClassModel *classModel = [[ClassModel alloc]init];
        classModel.className = [res stringForColumn:@"class_name"];
        classModel.group_id = [res stringForColumn:@"class_id"];
        classModel.group_name = [res stringForColumn:@"name"];
        classModel.school_id = [res stringForColumn:@"school_id"];
        classModel.introduction = [res stringForColumn:@"introduction"];
    
        return classModel;
    }
    return nil;
}


+ (NSMutableArray *)fetchMembersWithClassID:(NSString *)class_id{
    NSMutableArray * memberArray = [[NSMutableArray alloc] init];
    
    NSString *myself_uid = [WTUserDefaults getUid];
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `school_members` WHERE `class_id`= ? AND `uid`<> ?",class_id,myself_uid];
    
    while (res && [res next]) {
        PersonModel *personModel = [[PersonModel alloc]init];
        personModel.class_id = [res stringForColumn:@"class_id"];
        personModel.uid = [res stringForColumn:@"uid"];
        personModel.nickName = [res stringForColumn:@"nickName"];
        personModel.upload_photo_timestamp = [res stringForColumn:@"upload_photo_timestamp"];
        personModel.user_type = [res stringForColumn:@"user_type"];
        personModel.sex = [res stringForColumn:@"sex"];
        personModel.alias = [res stringForColumn:@"alias"];
        
        [memberArray addObject:personModel];
        [personModel release];
    }
    [res close];
    return [memberArray autorelease];
}


+ (NSMutableArray *)fetchStudentsWithClassID:(NSString *)class_id{
    NSMutableArray * memberArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `school_members` WHERE `class_id`= ? AND `user_type`=? ",class_id,@"1"];
    
    while (res && [res next]) {
        PersonModel *personModel = [[PersonModel alloc]init];
        personModel.class_id = [res stringForColumn:@"class_id"];
        personModel.uid = [res stringForColumn:@"uid"];
        personModel.nickName = [res stringForColumn:@"nickName"];
        personModel.upload_photo_timestamp = [res stringForColumn:@"upload_photo_timestamp"];
        personModel.user_type = [res stringForColumn:@"user_type"];
        personModel.sex = [res stringForColumn:@"sex"];
        personModel.alias = [res stringForColumn:@"alias"];
        
        [memberArray addObject:personModel];
        [personModel release];
    }
    [res close];
    return [memberArray autorelease];
}


+ (PersonModel *)fetchStudentInClassWithStudentID:(NSString *)student_id withClassID:(NSString *)class_id{
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `school_members` WHERE `class_id`= ? AND `uid`=? ",class_id,student_id];
    PersonModel *personModel = nil;
    while (res && [res next]) {
        personModel = [[PersonModel alloc]init];
        personModel.class_id = [res stringForColumn:@"class_id"];
        personModel.uid = [res stringForColumn:@"uid"];
        personModel.nickName = [res stringForColumn:@"nickName"];
        personModel.upload_photo_timestamp = [res stringForColumn:@"upload_photo_timestamp"];
        personModel.user_type = [res stringForColumn:@"user_type"];
        personModel.sex = [res stringForColumn:@"sex"];
        personModel.alias = [res stringForColumn:@"alias"];
    }
    [res close];
    return [personModel autorelease];
}


+ (BOOL)hasUpdataHeadWithSchoolMemberID:(PersonModel *)personModel{
    FMResultSet *res = [db executeQuery:@"SELECT `upload_photo_timestamp` FROM `school_members` WHERE `uid` = ? AND `upload_photo_timestamp` = ?", personModel.uid,personModel.upload_photo_timestamp];
    BOOL hasUpdata = YES;
    while (res && [res next]) {
        if ([[res stringForColumn:@"upload_photo_timestamp"] isEqualToString:@"-1"]){
            hasUpdata = NO;
        }
        else{
            hasUpdata = YES;
        }
    }
    [res close];
    return hasUpdata;
}


+ (BOOL)schoolMemberAlreadyAddBuddy:(NSString *)uid{
    
    FMResultSet *res = [db executeQuery:@"SELECT `uid` FROM `buddydetail` WHERE `uid` = ? ", uid];
    BOOL alreadyAdd = NO;
    while (res && [res next]) {
        alreadyAdd = YES;
    }
    [res close];
    
    FMResultSet *res1 = [db executeQuery:@"SELECT `buddy_flag` FROM `buddys` WHERE `uid` = ? ", uid];
    BOOL isFriend = NO;
    while (res1 && [res1 next]) {
        if ([[res1 stringForColumn:@"buddy_flag"] integerValue] == 1){
            isFriend = YES;
        }
    }
    [res1 close];
    return (alreadyAdd && isFriend);
}


+ (BOOL)isSchollMember:(NSString *)uid{
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `school_members` WHERE `uid` = ? ", uid];
    BOOL alreadyMember = NO;
    while (res && [res next]) {
        alreadyMember = YES;
    }
    [res close];
    return alreadyMember;
}


#pragma mark - ClassSchedule
+ (BOOL)deleteClassScheduleWithLessonID:(NSString *)lesson_id{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    BOOL result = [db executeUpdate:@"DELETE FROM `class_schedule` WHERE `lesson_id` = ?",lesson_id];
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


+ (BOOL)storeclassScheduleModel:(ClassScheduleModel *)classScheduleModel{
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

+ (NSMutableArray *)fetchClassScheduleWithClassID:(NSString *)class_id {
    NSMutableArray * classScheduleArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `class_schedule` WHERE `class_id`= ? ORDER BY `start_date` ASC",class_id];
    
    while (res && [res next]) {
        ClassScheduleModel *classScheduleModel = [[ClassScheduleModel alloc]init];
        classScheduleModel.class_id = [res stringForColumn:@"class_id"];
        classScheduleModel.lesson_id = [res stringForColumn:@"lesson_id"];
        classScheduleModel.title = [res stringForColumn:@"title"];
        classScheduleModel.start_date = [res stringForColumn:@"start_date"];
        classScheduleModel.end_date = [res stringForColumn:@"end_date"];
        classScheduleModel.live = [res stringForColumn:@"live"];
        
        [classScheduleArray addObject:classScheduleModel];
        [classScheduleModel release];
    }
    [res close];
    return [classScheduleArray autorelease];
}

+ (BOOL)storeLessonPerformance:(LessonPerformanceModel *)lessonPerformanceModel{
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

+ (NSMutableArray *)fetchLessonPerformanceWithStudentID:(NSString *)student_id WithLessonID:(NSString *)lesson_id{
    NSMutableArray * lessonPerformanceArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `lesson_performance` WHERE `student_id`= ? AND `lesson_id`= ? AND `property_id`<>?  ORDER BY `property_id` ASC"
                         ,student_id
                         ,lesson_id
                         ,@"10"];
    
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

+ (BOOL)storeHomework:(HomeworkModel *)homeworkModel{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `homework` WHERE `homework_id` = ? AND `lesson_id`= ? ", homeworkModel.homework_id ,homeworkModel.lesson_id];
    
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
        result = [db executeUpdate:@"UPDATE `homework` SET `homework_id`=? ,`lesson_id`=?, `title`=? WHERE  `homework_id` = ? AND `lesson_id`= ? "
                  ,homeworkModel.homework_id
                  ,homeworkModel.lesson_id
                  ,homeworkModel.title
                  ,homeworkModel.homework_id
                  ,homeworkModel.lesson_id];
    } else {
        result = [db executeUpdate:@"INSERT INTO `homework` (`homework_id`, `title`,`lesson_id`) VALUES (?,?,?)"
                  ,homeworkModel.homework_id
                  ,homeworkModel.title
                  ,homeworkModel.lesson_id];
    }
    
    if (newTransaction) {
        [db commit];
    }
    [res close];
    return result;

}

+ (NSMutableArray *)fetchHomeworkWithLessonID:(NSString *)lesson_id {
    NSMutableArray * homeworkArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `homework` WHERE `lesson_id`= ? ORDER BY `lesson_id` ASC"
                         ,lesson_id];
    
    while (res && [res next]) {
        HomeworkModel *homeworkModel = [[HomeworkModel alloc]init];
        homeworkModel.homework_id = [res stringForColumn:@"homework_id"];
        homeworkModel.lesson_id = [res stringForColumn:@"lesson_id"];
        homeworkModel.title = [res stringForColumn:@"title"];
        [homeworkArray addObject:homeworkModel];
        [homeworkModel release];
    }
    [res close];
    return [homeworkArray autorelease];
}


+ (BOOL)storeFeedBackModel:(FeedBackModel *)feedBackModel{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction) {
        [db beginTransaction];
    }
    
    FMResultSet *res = [db executeQuery:@"SELECT * FROM `feedback` WHERE `feedback_id` = ? AND `lesson_id`= ?  AND `student_id`=? "
                        ,feedBackModel.feedback_id
                        ,feedBackModel.lesson_id
                        ,feedBackModel.student_id];
    
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
        result = [db executeUpdate:@"UPDATE `feedback` SET `feedback_id`=? ,`lesson_id`=?, `moment_id`=? ,`student_id`=? WHERE  `feedback_id` = ? AND `lesson_id`= ? AND `student_id`=? "
                  ,feedBackModel.feedback_id
                  ,feedBackModel.lesson_id
                  ,feedBackModel.moment_id
                  ,feedBackModel.student_id
                  ,feedBackModel.feedback_id
                  ,feedBackModel.lesson_id
                  ,feedBackModel.student_id];
    } else {
        result = [db executeUpdate:@"INSERT INTO `feedback` (`feedback_id`, `lesson_id`,`moment_id`,`student_id`) VALUES (?,?,?,?)"
                  ,feedBackModel.feedback_id
                  ,feedBackModel.lesson_id
                  ,feedBackModel.moment_id
                  ,feedBackModel.student_id];
    }
    
    if (newTransaction) {
        [db commit];
    }
    [res close];
    return result;
}

+ (FeedBackModel *)fetchFeedBackWithLessonID:(NSString *)lesson_id withStudentID:(NSString *)student_id {
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `feedback` WHERE `lesson_id`= ? AND `student_id`= ?"
                         ,lesson_id
                         ,student_id];
    FeedBackModel *feedBackModel = [[FeedBackModel alloc]init];
    while (res && [res next]) {
        feedBackModel.feedback_id = [res stringForColumn:@"feedback_id"];
        feedBackModel.lesson_id = [res stringForColumn:@"lesson_id"];
        feedBackModel.moment_id = [res stringForColumn:@"moment_id"];
        feedBackModel.student_id = [res stringForColumn:@"student_id"];
    }
    [res close];
    return [feedBackModel autorelease];
}

+ (Moment *)fetchMomentWithMomentID:(NSString *)moment_id {
    FMResultSet *res =  [db executeQuery:@"SELECT * FROM `moment` WHERE `id`= ? "
                         ,moment_id];
    Moment* moment = nil;
    while (res && [res next]) {
        moment= [[Moment alloc] initWithMomentID:[res stringForColumn:@"id"]
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
                                             withDeadline:[res stringForColumn:@"deadline"]];
    }
    [res close];
    
    
    
    FMResultSet *res2 =  [db executeQuery:@"SELECT * FROM  `moment_media` WHERE `moment_id` = ?",moment_id];
    while (res2 && [res2 next]) {
        WTFile *file = [[WTFile alloc]init];
        file.fileid = [res2 stringForColumn:@"fileid"];
        file.thumbnailid = [res2 stringForColumn:@"thumbid"];
        file.ext = [res2 stringForColumn:@"ext"];
        file.dbid = [res2 stringForColumn:@"dbid"];
        file.duration = [[res2 stringForColumn:@"duration"] floatValue];
        [moment.multimedias addObject:file];
        [file release];
    }
    [res2 class];
    return [moment autorelease];
}



#pragma mark - nearby buddys

+(void)storeNearbyBuddy:(Buddy*)buddy
{
    
	FMResultSet *res = [db executeQuery:@"SELECT `buddy_id` FROM `nearby_buddy` WHERE `buddy_id`=?",buddy.userID];
    if (res && [res next]){
        // we already have this buddy id.
        if(PRINT_LOG)NSLog(@"uid exist, do update");
        [db executeUpdate:@"UPDATE `nearby_buddy` SET `buddy_flag`= ? WHERE `buddy_id`=? ",buddy.buddy_flag, buddy.userID];
        
	}
	else{

        if(PRINT_LOG)NSLog(@"uid doesnt exist ,do insert");
		[db executeUpdate:@"INSERT INTO `nearby_buddy` (`buddy_id`,`buddy_flag`) VALUES (?,?)",
         buddy.userID,buddy.buddy_flag];
	}
    
    [Database storeNewBuddyDetailWithUpdate:buddy];
    

}

+(void)storeNearbyBuddys:(NSArray*)buddys
{
    for (Buddy* buddy in buddys) {
        [Database storeNearbyBuddy:buddy];
    }
}

+(NSMutableArray*)getNearbyBuddyWithOffset:(int) offset
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSString* strsql=[NSString stringWithFormat:@"SELECT `buddy_id` FROM `nearby_buddy` WHERE 1 = 1"];
    
    if(PRINT_LOG) NSLog(@"%@",strsql);
    FMResultSet *res = [db executeQuery:strsql];
    while(res && [res next]){
        NSString* buddyid = [res stringForColumnIndex:0];
        Buddy* buddy = [Database nearbyBuddyWithUserID:buddyid];
        if (buddy) {
           [array addObject:buddy];  
        }
	}
    return [array autorelease];
}

+(void)deleteAllNearbyBuddys
{
    if(PRINT_LOG)NSLog(@"delete all nearby buddys called");
    [db executeUpdate:@"DELETE FROM `nearby_buddy` WHERE 1=1"];
    
}


// Fetch an nearnby Buddy by primary key
+ (Buddy *) nearbyBuddyWithUserID:(NSString*)uID {
    
	if (uID==nil) {
		return nil;
	}
	FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`buddydetail`.`uid`, `block_list`.`uid` as `block_flag`,`nickname`,`last_status`,`sex`,`device_number`,"
                        @"`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`"
                        @"FROM `buddydetail`"
                        @"LEFT JOIN `nearby_buddy` ON `buddydetail`.`uid`= `nearby_buddy`.`buddy_id`"
                        @"LEFT JOIN `block_list` ON `buddydetail`.`uid`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `buddydetail`.`uid`= `buddy_more_detail`.`uid`"
                        @"WHERE buddydetail.uid=?",uID];
    
	if (res && [res next]) {
        int i = -1;
		Buddy *ident = [[[Buddy alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:++i];
        ident.isBlocked = ([res stringForColumnIndex:++i]!=NULL);
		ident.nickName = [res stringForColumnIndex:++i];
		ident.status = [res stringForColumnIndex:++i];
		ident.sexFlag = [[res stringForColumnIndex:++i] intValue];
		ident.deviceNumber = [res stringForColumnIndex:++i];
		ident.appVer = [res stringForColumnIndex:++i];
        ident.buddy_flag = [res stringForColumnIndex:++i];
        
		ident.isFriend = [ident.buddy_flag isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:++i] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:++i];
		ident.pathOfThumbNail = [res stringForColumnIndex:++i];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:++i]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:++i]isEqualToString:@"1"];
        
        ident.wowtalkID = [res stringForColumnIndex:++i];
        ident.userType =  [[res stringForColumnIndex:++i] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:++i] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:++i] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:++i] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:++i] intValue];
		[res close];
		return ident;
	}
    
	return nil;
}


#pragma mark - 
#pragma mark biz member
// Biz members
+(void)storeBizMembers:(NSArray*)members toDepartment:(NSString *)departmentid
{
    [db beginTransaction];
    for (BizMember *member in members) {
        [Database storeBizMember:member toDepartment:departmentid];
    }
	[db commit];
}

+(void)storeBizMember:(BizMember*)member toDepartment:(NSString *)departmentid
{
    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];

    //write to group_member
	FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_member` WHERE `group_id`=? AND `member_id`=?",departmentid,member.userID];
    
    NSString* flag = @"9";
    
    if (res && [res next]) {
        if(PRINT_LOG)NSLog(@"group_member record exist ,do nothing");
    }
	else {
        if(PRINT_LOG)NSLog(@"group_member record doesnt exist ,do insert");
        [db executeUpdate:@"INSERT INTO `group_member` (`group_id`, `member_id`,`member_level`) VALUES (?, ?, ?)", departmentid, member.userID, flag];
        
	}
    
    [res close];

    [Database storeNewBuddyWithUpdate:member forGroupMember:TRUE];
    
	res = [db executeQuery:@"SELECT `uid` FROM `biz_member_info` WHERE `uid`=?",member.userID];
	
    
    if (res && [res next]) {
        if(PRINT_LOG)NSLog(@"uid exist ,do update");
        
		[db executeUpdate:@"UPDATE `biz_member_info` SET `department`=?,`position`=?,`district`=?,`employeeid`=?,`landline`=?, `email` = ?,`phonetic_name`=?,`phonetic_first_name`=?,`phonetic_middle_name`=?,`phonetic_last_name`=?, `mobile` = ? WHERE `uid`=?",
         member.department,
         member.position,
         member.district,
         member.employeeID,
         member.landline,
         member.email,
         member.phonetic_name,
         member.phonetic_firstname,
         member.phonetic_middle,
         member.phonetic_lastname,
         member.mobile,
         member.userID];
	}
	else {
        
        if(PRINT_LOG)NSLog(@"uid doesnt exist ,do insert");
        
		[db executeUpdate:@"INSERT INTO `biz_member_info` (`uid`,`department`,`position`,`district`,`employeeid`,`landline`,`email`,`phonetic_name`,`phonetic_first_name`,`phonetic_middle_name`,`phonetic_last_name`,`mobile`) VALUES (?, ?, ?, ?, ?,?,?,?,?,?,?,?)",
         member.userID,
         member.department,
         member.position,
         member.district,
         member.employeeID,
         member.landline,
         member.email,
         member.phonetic_name,
         member.phonetic_firstname,
         member.phonetic_middle,
         member.phonetic_lastname,
         member.mobile];
	}
    
    [res close];
    
    if (newTransaction)
        [db commit];
    
}
+(void)deleteBizMembersFromDepartment:(NSString *)departmentid
{
   [db executeUpdate:@"DELETE FROM `group_member` WHERE `group_id`=?", departmentid];
}

+(BizMember*)bizMemberWithUserID:(NSString*)uID
{
    if (uID==nil) {
		return nil;
	}
	FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`buddydetail`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,"
                        @"`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                        @"`buddys`.`uid` as `exist_flag`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`,"
                        @"`department`,`position`,`district`,`employeeid`,`landline`,`email`,`phonetic_name`,`phonetic_first_name`,`phonetic_middle_name`,`phonetic_last_name`,`mobile`"
                        @"FROM `buddydetail`"
                        @"LEFT JOIN `buddys` ON `buddydetail`.`uid`= `buddys`.`uid`"
                        @"LEFT JOIN `block_list` ON `buddydetail`.`uid`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `buddydetail`.`uid`= `buddy_more_detail`.`uid`"
                        @"LEFT JOIN `biz_member_info` ON `buddydetail`.`uid`= `biz_member_info`.`uid`"
                        @"WHERE buddydetail.uid=?",uID];
    
   // NSLog(@"%@",[db lastErrorMessage]);
    
	if (res && [res next]) {
		BizMember *ident = [[[BizMember alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = ([res stringForColumnIndex:1]!=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        ident.buddy_flag = [res stringForColumnIndex:8];
		ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        ident.mayNotExist = ([res stringForColumnIndex:14]==NULL);
        
        ident.wowtalkID = [res stringForColumnIndex:15];
        ident.userType =  [[res stringForColumnIndex:16] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:18] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:19] intValue];
        ident.addFriendRule = [[res stringForColumnIndex:20] intValue];
        
        ident.department = [res stringForColumnIndex:21];
        
        ident.position = [res stringForColumnIndex:22];
        ident.district = [res stringForColumnIndex:23];
        ident.employeeID = [res stringForColumnIndex:24];
        ident.landline = [res stringForColumnIndex:25];
        ident.email = [res stringForColumnIndex:26];
        ident.phonetic_name = [res stringForColumnIndex:27];
        ident.phonetic_firstname = [res stringForColumnIndex:28];
        ident.phonetic_middle = [res stringForColumnIndex:29];
        ident.phonetic_lastname = [res stringForColumnIndex:30];
        ident.mobile = [res stringForColumnIndex:31];
        
		//if(PRINT_LOG)NSLog(@"get Buddy %@,%@",ident.userName,ident.status);
		[res close];
		return ident;
	}
    
	return nil;

}

#pragma mark -
#pragma mark Buddy Handle


+(void)favoriteBuddy:(NSString*)buddyid
{
   	[db executeUpdate:@"INSERT INTO `favoritebuddy` (`buddyid`) VALUES (?)",buddyid];
}
+(void)deFavoriteBuddy:(NSString*)buddyid
{
    [db executeUpdate:@"DELETE FROM `favoritebuddy` WHERE `buddyid`=?", buddyid];
}
+(BOOL)isBuddyFavorited:(NSString*)buddyid
{
    FMResultSet *res = [db executeQuery: @"SELECT `buddyid` FROM `favoritebuddy` WHERE buddyid=?", buddyid ];
    if (res && [res next]) {
        return TRUE;
    }
    return FALSE;
}

+(NSMutableArray*)favoritedBuddies
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [db executeQuery: @"SELECT * FROM `favoritebuddy` WHERE 1 = 1" ];
    while (res && [res next]) {
        
        NSString* str = [res stringForColumn:@"buddyid"];
        if (![NSString isEmptyString:str]) {
            [arr addObject:str];
        }
    }
    
    return [arr autorelease];
}

+(void)deleteFavoritedBuddies
{
    [db executeUpdate:@"DELETE FROM `favoritebuddy`"];
    
  //  NSLog(@"%@",[db lastErrorMessage]);
}

//Store Buddys
// Store Buddy (called by storeBuddys <==called by getMatchedBuddyList and getPossibleBuddyList
//delete all matched buddylist or possiblebuddylist first (buddy_flag==0 or buddy_flag==1)
+ (void) storeBuddys:(NSArray *)idents{
    
	[db beginTransaction];
    for (Buddy *ident in idents) {
        [Database storeNewBuddyWithUpdate:ident forGroupMember:NO];
    }
	[db commit];
}


//if uid exist,
// if store a friend ( buddy_flag==1)  change it to buddy_flag=1
//  if store a possible friend( buddy_flag=0) , do nothing
//  if store a possible friend ( buddy_flag==-1)
//       if uid exist as buddy_flag==0,  change it to buddy_flag=-1
//       else do nothing
//else
//  do a insert

//finally do a buddy detail update


+ (void) storeNewBuddyWithUpdate:(Buddy *)ident forGroupMember:(BOOL)forGroupMember{
	
    if([ident.userID isEqualToString:[WTUserDefaults getUid]]){
        if(PRINT_LOG)NSLog(@"this buddy has the same userID as mine ,dont store");
        return;
    }
    
    if(PRINT_LOG)NSLog(@"storeNewBuddyWithUpdate:%@,%@,%@",ident.userID,ident.phoneNumber,ident.appVer );
    
	// We're already inside a transaction if we were called from within
	// storebuddys. If that isn't the case, make sure we start a new
	// transaction.
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction)
        [db beginTransaction];
	
    
    //if uid exist,
    // if store a friend ( buddy_flag==1)  change it to buddy_flag=1
    //  if store a possible friend for group member
    //       if uid exist as buddy_flag==0,  change it to buddy_flag=-1
    //       else do nothing
    //  if store a possible friend( buddy_flag=0) , do nothing
    
    //else
    //  do a insert
    
    //finally do a buddy detail update
    
	FMResultSet *res = [db executeQuery:@"SELECT `buddy_flag` FROM `buddys` WHERE `uid`=?",ident.userID];
    if (res && [res next]){
        if (ident.isFriend) {
            [db executeUpdate:@"UPDATE `buddys` SET `phone_number`=?, `buddy_flag`='1' WHERE `uid`=? ",
             ident.phoneNumber,
             ident.userID];
        }
        /*
        else if(forGroupMember){
            if ([[res stringForColumnIndex:0] isEqualToString:@"0"]) {
                [db executeUpdate:@"UPDATE `buddys` SET `phone_number`=?, `buddy_flag`='-1' WHERE `uid`=? ",
                 ident.phoneNumber,
                 ident.userID];
            }
            //else do nothing
        }
         */
        //else do nothing
	}
	else{
        NSString* buddy_flag= ident.buddy_flag;
        if (![buddy_flag isEqualToString:@"2"] &&![buddy_flag isEqualToString:@"1"] ) {
                if (forGroupMember) {
                    buddy_flag= @"-1";
                }
        }
      
        if(PRINT_LOG)NSLog(@"uid doesnt exist ,do insert");
		[db executeUpdate:@"INSERT INTO `buddys` (`uid`, `phone_number`, `buddy_flag`) VALUES (?, ?, ?)",
         ident.userID,
         ident.phoneNumber,
         buddy_flag];
	}
    
    [Database storeNewBuddyDetailWithUpdate:ident];
    
    if (newTransaction)
        [db commit];
}

+ (void) storeNewBuddyDetailWithUpdate:(Buddy *)ident{
    if(PRINT_LOG)NSLog(@"------------------------------------------------------");
    if(PRINT_LOG)NSLog(@"storeNewBuddyDetailWithUpdate for uid:%@",ident.userID);
    
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction)
        [db beginTransaction];
    
	FMResultSet *res = [db executeQuery:@"SELECT `photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath` FROM `buddydetail` WHERE `uid`=?",ident.userID];
	
    if(ident.photoUploadedTimeStamp==-1){
        ident.needToDownloadThumbnail=NO;
        ident.needToDownloadPhoto=NO;
        
    }
    
    if (res && [res next]) {
        if(PRINT_LOG)NSLog(@"uid exist ,do update");
        Buddy *oldIdent = [[[Buddy alloc] init] autorelease];
        oldIdent.photoUploadedTimeStamp = [[res stringForColumnIndex:0] intValue];
		oldIdent.pathOfPhoto = [res stringForColumnIndex:1];
		oldIdent.pathOfThumbNail = [res stringForColumnIndex:2];
        
        if(PRINT_LOG)NSLog(@"oldIdent:%zi,%@,%@",oldIdent.photoUploadedTimeStamp,oldIdent.pathOfPhoto,oldIdent.pathOfThumbNail);
        
        if(ident.photoUploadedTimeStamp!=-1){
            if(oldIdent.pathOfThumbNail!=nil && ![oldIdent.pathOfThumbNail isEqualToString:@""] && ident.photoUploadedTimeStamp<=oldIdent.photoUploadedTimeStamp && !oldIdent.needToDownloadThumbnail){
                ident.needToDownloadThumbnail=NO;
            }
            else{
                ident.needToDownloadThumbnail=YES;
            }
            
            
            if(oldIdent.pathOfPhoto!=nil && ![oldIdent.pathOfPhoto isEqualToString:@""] && ident.photoUploadedTimeStamp<=oldIdent.photoUploadedTimeStamp && !oldIdent.needToDownloadPhoto){
                ident.needToDownloadPhoto=NO;
            }
            else{
                ident.needToDownloadPhoto=YES;
            }
        }
        if (!ident.needToDownloadPhoto){
            ident.pathOfPhoto = oldIdent.pathOfPhoto;
        }
        
        if (!ident.needToDownloadThumbnail){
            ident.pathOfThumbNail = oldIdent.pathOfThumbNail;
        }
        
        
		[db executeUpdate:@"UPDATE `buddydetail` SET `nickname`=?,`last_status`=?,`sex`=?,`device_number`=?,`app_ver`=?, `photo_upload_timestamp`=?,`photo_filepath`=?,`thumbnail_filepath`=?,`need_to_download_photo`=?,`need_to_download_thumbnail`=?,`alias`=? WHERE `uid`=? ",
         ident.nickName,
         ident.status,
         [NSString stringWithFormat:@"%zi",ident.sexFlag],
         ident.deviceNumber,
         ident.appVer,
         
         [NSString stringWithFormat:@"%zi",ident.photoUploadedTimeStamp],
         ident.pathOfPhoto,
         ident.pathOfThumbNail,
         ident.needToDownloadPhoto?@"1":@"0",
         ident.needToDownloadThumbnail?@"1":@"0",
         ident.alias,
         ident.userID];
        
	}
	else {
        
        if(PRINT_LOG)NSLog(@"uid doesnt exist ,do insert");
		[db executeUpdate:@"INSERT INTO `buddydetail` (`uid`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,`alias`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
         ident.userID,
         ident.nickName,
         ident.status,
         [NSString stringWithFormat:@"%zi",ident.sexFlag],
         ident.deviceNumber,
         ident.appVer,
         
         [NSString stringWithFormat:@"%zi",ident.photoUploadedTimeStamp],
         ident.pathOfPhoto,
         ident.pathOfThumbNail,
         ident.needToDownloadPhoto?@"1":@"0",
         ident.needToDownloadThumbnail?@"1":@"0",
         ident.alias];
	}
    
    [Database storeNewBuddyMoreDetailWithUpdate:ident];
    
    if (newTransaction)
        [db commit];
}



+ (void) storeNewBuddyMoreDetailWithUpdate:(Buddy *)ident{
    if(PRINT_LOG)NSLog(@"------------------------------------------------------");
    if(PRINT_LOG)NSLog(@"storeNewBuddyMoreDetailWithUpdate for uid:%@",ident.userID);
    
    
	FMResultSet *res = [db executeQuery:@"SELECT `wowtalk_id` FROM `buddy_more_detail` WHERE `uid`=?",ident.userID];
	
    
    if (res && [res next]) {
        if(PRINT_LOG)NSLog(@"uid exist ,do update");
        
        if(PRINT_LOG)NSLog(@"uid:%@,wowtalkID:%@, usertype:%zi,lastLongitude:%f,lastLatitude:%f,lastLoginTimestamp:%zi",ident.userID, ident.wowtalkID,ident.userType,ident.lastLongitude,ident.lastLatitude,ident.lastLoginTimestamp);
        
		[db executeUpdate:@"UPDATE `buddy_more_detail` SET `wowtalk_id`=?,`user_type`=?,`last_longitude`=?,`last_latitude`=?,`last_login_timestamp`=?, `allowPeopleToAdd` = ? WHERE `uid`=?",
         ident.wowtalkID!=nil? ident.wowtalkID:@"unknown",
         [NSString stringWithFormat:@"%zi",ident.userType],
         [NSString stringWithFormat:@"%f",ident.lastLongitude],
         [NSString stringWithFormat:@"%f",ident.lastLatitude],
         [NSString stringWithFormat:@"%zi",ident.lastLoginTimestamp],
         [NSString stringWithFormat:@"%d",ident.addFriendRule],
         ident.userID];
        
        return;
        
	}
	else {
        
        if(PRINT_LOG)NSLog(@"uid doesnt exist ,do insert");
        if(PRINT_LOG)NSLog(@"uid:%@,wowtalkID:%@, usertype:%zi,lastLongitude:%f,lastLatitude:%f,lastLoginTimestamp:%zi",ident.userID, ident.wowtalkID,ident.userType,ident.lastLongitude,ident.lastLatitude,ident.lastLoginTimestamp);
        
        
		[db executeUpdate:@"INSERT INTO `buddy_more_detail` (`uid`,`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`) VALUES (?, ?, ?, ?, ?,?,?)",
         ident.userID,
         ident.wowtalkID!=nil? ident.wowtalkID:@"unknown",
         [NSString stringWithFormat:@"%zi",ident.userType],
         [NSString stringWithFormat:@"%f",ident.lastLongitude],
         [NSString stringWithFormat:@"%f",ident.lastLatitude],
         [NSString stringWithFormat:@"%zi",ident.lastLoginTimestamp],
         [NSString stringWithFormat:@"%d",ident.addFriendRule]];
        
        
	}
}






+(void)deleteBuddys:(NSArray*)buddys
{
    if (buddys == nil || [buddys count] == 0) {
        return;
    }
    
    for (Buddy* buddy in buddys) {
        [Database deleteBuddy:buddy];
    }
}

// Delete Buddy
+ (void) deleteBuddy:(Buddy *)ident {
    if(PRINT_LOG)NSLog(@"deleteBuddy called");
    
	[db executeUpdate:@"DELETE FROM `buddys` WHERE `uid`=?",
     ident.userID];
    
    [db executeUpdate:@"DELETE FROM `block_list` WHERE `uid`=?",
     ident.userID];
    
    [db executeUpdate:@"DELETE FROM `group_member` WHERE `member_id`=?",
     ident.userID];
    
}

+ (void) deleteBuddyByID:(NSString *)uID{
    if(PRINT_LOG)NSLog(@"deleteBuddyByID called");
    
	[db executeUpdate:@"DELETE FROM `buddys` WHERE `uid`=?",
     uID];
    
    [db executeUpdate:@"DELETE FROM `block_list` WHERE `uid`=?",
     uID];
    
    [db executeUpdate:@"DELETE FROM `group_member` WHERE `member_id`=?",
     uID];
    
}


// Delete all Buddys
+ (void) deleteAllBuddys{
    if(PRINT_LOG)NSLog(@"deleteAllBuddys called");
    
	[db executeUpdate:@"DELETE FROM `buddys` WHERE 1=1"];
}



// Fetch an Buddy by primary key
+ (Buddy *) buddyWithUserID:(NSString*)uID {
    
	if (uID==nil) {
		return nil;
	}
	FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`buddydetail`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,"
                        @"`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                        @"`buddys`.`uid` as `exist_flag`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`,`alias`"
                        @"FROM `buddydetail`"
                        @"LEFT JOIN `buddys` ON `buddydetail`.`uid`= `buddys`.`uid`"
                        @"LEFT JOIN `block_list` ON `buddydetail`.`uid`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `buddydetail`.`uid`= `buddy_more_detail`.`uid`"
                        @"WHERE buddydetail.uid=?",uID];
    
	if (res && [res next]) {
		Buddy *ident = [[[Buddy alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = ([res stringForColumnIndex:1]!=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
        ident.showName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        ident.buddy_flag = [res stringForColumnIndex:8]?[res stringForColumnIndex:8]:@"3";
		ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        ident.mayNotExist = ([res stringForColumnIndex:14]==NULL);
        
        ident.wowtalkID = [res stringForColumnIndex:15];
        ident.userType =  [[res stringForColumnIndex:16] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:18] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:19] intValue];
        ident.addFriendRule = [[res stringForColumnIndex:20] intValue];
        ident.alias = [res stringForColumnIndex:21];
		//if(PRINT_LOG)NSLog(@"get Buddy %@,%@",ident.userName,ident.status);
        if (ident.alias) {
            ident.nickName = ident.alias;
        }
        else
        {
            ident.nickName = ident.showName;
        }
		[res close];
		return ident;
	}
    
	return nil;
}

// Fetch an Buddy by phone_number
+ (Buddy *) buddyWithPhoneNumber:(NSString*)phoneNumber {
    
	if (phoneNumber==nil) {
		return nil;
	}
	FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`buddydetail`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,"
                        @"`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                        @"`buddys`.`uid` as `exist_flag`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`,`alias`"
                        @"FROM `buddydetail`"
                        @"LEFT JOIN `buddys` ON `buddydetail`.`uid`= `buddys`.`uid`"
                        @"LEFT JOIN `block_list` ON `buddydetail`.`uid`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `buddydetail`.`uid`= `buddy_more_detail`.`uid`"
                        @"WHERE buddys.phone_number=?",phoneNumber];
    
	if (res && [res next]) {
		Buddy *ident = [[[Buddy alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = ([res stringForColumnIndex:1]!=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
         ident.buddy_flag = [res stringForColumnIndex:8];
		ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        ident.mayNotExist = ([res stringForColumnIndex:14]==NULL);
        
        ident.wowtalkID = [res stringForColumnIndex:15];
        ident.userType =  [[res stringForColumnIndex:16] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:18] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:19] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:20] intValue];
        ident.alias = [res stringForColumnIndex:21];
		//if(PRINT_LOG)NSLog(@"get Buddy %@,%@",ident.userName,ident.status);
		[res close];
		return ident;
	}
    
	return nil;
}






+ (NSMutableArray *) fetchAllBuddys{
    if(PRINT_LOG)NSLog(@"fetchAlBuddies called");
    NSMutableArray *idents = [[NSMutableArray alloc] init];
	FMResultSet *res = [db executeQuery:
                        @"SELECT "
                        @"`buddys`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`,`alias`"
                        
                        @"FROM `buddys`"
                        @"LEFT JOIN `buddydetail` ON `buddys`.`uid`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `buddys`.`uid`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `buddys`.`uid`= `buddy_more_detail`.`uid`"];
    
    
	while ([res next]) {
        Buddy *ident = [[[Buddy alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = ([res stringForColumnIndex:1]!=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
         ident.buddy_flag = [res stringForColumnIndex:8];
		ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        
        ident.wowtalkID = [res stringForColumnIndex:14];
        ident.userType =  [[res stringForColumnIndex:15] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:16] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:18] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:19] intValue];
        ident.alias = [res stringForColumnIndex:21];
        
		[idents addObject:ident];
	}
	[res close];
	return [idents autorelease];
    
    
}

+(NSMutableArray *)getContactList
{
    if(PRINT_LOG)NSLog(@"DB: getcontactlist called");
    NSMutableArray *idents = [[NSMutableArray alloc] init];
	FMResultSet *res = [db executeQuery:
                        @"SELECT "
                        @"`buddys`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`,`alias`"
                        
                        @"FROM `buddys`"
                        @"LEFT JOIN `buddydetail` ON `buddys`.`uid`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `buddys`.`uid`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `buddys`.`uid`= `buddy_more_detail`.`uid`"
                        @"WHERE `buddy_flag`= 1 OR `buddy_flag` = 2 "];
    
    
	while ([res next]) {
        Buddy *ident = [[[Buddy alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = ([res stringForColumnIndex:1]!=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        
        ident.buddy_flag = [res stringForColumnIndex:8];
        ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
            
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        
        ident.wowtalkID = [res stringForColumnIndex:14];
        ident.userType =  [[res stringForColumnIndex:15] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:16] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:18] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:19] intValue];
        ident.alias = [res stringForColumnIndex:20];
		[idents addObject:ident];
	}
	[res close];
    
	return [idents autorelease];
}


+(NSMutableArray*) getContactListWithoutOfficialAccounts
{
    if(PRINT_LOG)NSLog(@"DB::getContactListWithoutOfficialAccounts called");
    NSMutableArray *idents = [[NSMutableArray alloc] init];
	FMResultSet *res = [db executeQuery:
                        @"SELECT "
                        @"`buddys`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`,`alias`"
                        
                        @"FROM `buddys`"
                        @"LEFT JOIN `buddydetail` ON `buddys`.`uid`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `buddys`.`uid`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `buddys`.`uid`= `buddy_more_detail`.`uid`"
                        @"WHERE `buddy_flag`= 1 OR `buddy_flag` = 2 "];
    
    
	while ([res next]) {
        Buddy *ident = [[[Buddy alloc] init] autorelease];
        
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = ([res stringForColumnIndex:1]!=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
        ident.showName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];

        ident.buddy_flag = [res stringForColumnIndex:8];
        ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        
        ident.wowtalkID = [res stringForColumnIndex:14];
        ident.userType =  [[res stringForColumnIndex:15] intValue];
        if (ident.userType == 0) {
            continue;
        }
        ident.lastLongitude = [[res stringForColumnIndex:16] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:18] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:19] intValue];
        ident.alias = [res stringForColumnIndex:20];
        if (ident.alias) {
            ident.nickName = ident.alias;
        }
        else
        {
            ident.nickName = ident.showName;
        }
		[idents addObject:ident];
	}
	[res close];
    
	return [idents autorelease];
    
}


+ (NSMutableArray *) fetchAllMatchedBuddies{
    if(PRINT_LOG)NSLog(@"DB:fetchAllMatchedBuddies called");
    NSMutableArray *idents = [[NSMutableArray alloc] init];
	FMResultSet *res = [db executeQuery:
                        @"SELECT "
                        @"`buddys`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`,`alias`"
                        
                        @"FROM `buddys`"
                        @"LEFT JOIN `buddydetail` ON `buddys`.`uid`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `buddys`.`uid`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `buddys`.`uid`= `buddy_more_detail`.`uid`"
                        @"WHERE `buddy_flag`='1'"];
    
    
	while ([res next]) {
        Buddy *ident = [[[Buddy alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = ([res stringForColumnIndex:1]!=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        ident.buddy_flag = [res stringForColumnIndex:8];
        ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        
        ident.wowtalkID = [res stringForColumnIndex:14];
        ident.userType =  [[res stringForColumnIndex:15] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:16] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:18] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:19] intValue];
        ident.alias = [res stringForColumnIndex:20];
        
		[idents addObject:ident];
	}
	[res close];
	return [idents autorelease];
}



+ (void) deleteAllMatchedBuddies{
    if(PRINT_LOG)NSLog(@"deleteAllMatchedBuddies called");
    [db executeUpdate:@"DELETE FROM `buddys` WHERE `buddy_flag`='1'"];
    
}

+ (NSMutableArray *) fetchAllPossibleBuddies{
    NSMutableArray *idents = [[NSMutableArray alloc] init];
    FMResultSet *res = [db executeQuery:
                        @"SELECT "
                        @"`buddys`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`,`alias`"
                        
                        @"FROM `buddys`"
                        @"LEFT JOIN `buddydetail` ON `buddys`.`uid`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `buddys`.`uid`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `buddys`.`uid`= `buddy_more_detail`.`uid`"
                        
                        @"WHERE `buddy_flag`<>'1'"];
    
	while ([res next]) {
        Buddy *ident = [[[Buddy alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = ([res stringForColumnIndex:1]!=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        ident.buddy_flag = [res stringForColumnIndex:8];
        ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        
        ident.wowtalkID = [res stringForColumnIndex:14];
        ident.userType =  [[res stringForColumnIndex:15] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:16] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:18] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:19] intValue];
        ident.alias = [res stringForColumnIndex:20];
        
		[idents addObject:ident];
	}
	[res close];
	return [idents autorelease];
    
}

+ (void) deleteAllPossibleBuddies{
    [db executeUpdate:@"DELETE FROM `buddys` WHERE `buddy_flag`='0'"];
}

+ (void) setBuddyThumbnailFilePath:(NSString*)filepath forUID:(NSString*)uID {
	[db executeUpdate:@"UPDATE `buddydetail` SET `thumbnail_filepath`=?,`need_to_download_thumbnail`='0' WHERE `uid`=?",
     filepath,uID];
}

+ (void) setBuddyPhotoFilePath:(NSString*)filepath forUID:(NSString*)uID {
	[db executeUpdate:@"UPDATE `buddydetail` SET `photo_filepath`=?,`need_to_download_photo`='0' WHERE `uid`=?",
     filepath,uID];
}

//  by yangbin
+ (BOOL)isFriendWithUID:(NSString *)uid{
    FMResultSet *res = [db executeQuery:@"SELECT `uid` FROM `buddydetail` WHERE `uid` = ? ", uid];
    BOOL alreadyAdd = NO;
    while (res && [res next]) {
        alreadyAdd = YES;
    }
    [res close];
    
    FMResultSet *res1 = [db executeQuery:@"SELECT `buddy_flag` FROM `buddys` WHERE `uid` = ? ", uid];
    BOOL isFriend = NO;
    while (res1 && [res1 next]) {
        if ([[res1 stringForColumn:@"buddy_flag"] integerValue] == 1){
            isFriend = YES;
        }
    }
    [res1 close];
    return (alreadyAdd && isFriend);
}

#pragma mark -
#pragma mark - Exsiting numbers.
+(void)storeContactNumbers:(NSArray*)numberList
{
    if (numberList == nil) {
        return;
    }
    NSSet* numberset = [[[NSSet alloc] initWithArray:numberList] autorelease];
    for (NSString *number in numberset) {
        [Database storeContactNumber:number];
    }
    
    
}

+(void)storeContactNumber:(NSString*)number
{
    BOOL newTransaction = ![db inTransaction];
	if (newTransaction)
		[db beginTransaction];
    
	[db executeUpdate:@"INSERT INTO `numbers_in_contact` (`number`) VALUES (?)",number];
    
	if (newTransaction)
		[db commit];
    
}

+(void)deleteContactNumbers:(NSArray*)numberList
{
    if (numberList == nil) {
        return;
    }
    
    NSSet* numberset = [[[NSSet alloc] initWithArray:numberList] autorelease];
    
    for (NSString *number in numberset) {
        [Database deleteContactNumber:number];
    }
    
}

+(void)deleteContactNumber:(NSString*)number
{
    BOOL newTransaction = ![db inTransaction];
	if (newTransaction)
		[db beginTransaction];
    
   	[db executeUpdate:@"DELETE FROM `numbers_in_contact` WHERE `number`=?", number];
    if (PRINT_LOG) {
        NSLog(@"delete number %@",number);
    }
    
    if (newTransaction)
		[db commit];
}

+(void)deleteAllContactNumbers
{
    [db executeUpdate:@"DELETE FROM `numbers_in_contact` WHERE 1=1"];
    
}

+(NSMutableArray*)fetchAllSavedContactNumbers
{
    NSMutableArray *idents = [[NSMutableArray alloc] init];
    FMResultSet * res = [db executeQuery:@"SELECT * FROM `numbers_in_contact`"];
    
	while ([res next]) {
        NSString *ident = [res stringForColumn:@"number"];
		[idents addObject:ident];
	}
	[res close];
	return [idents autorelease];
    
}

#pragma mark -
#pragma mark Chat Message Handle


+ (NSString*) chatMessage_dateToUTCString:(NSDate*) localDate{
	
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    [dateFormatter release];
    return dateString;
	
}

+ (NSDate*) chatMessage_UTCStringToDate:(NSString*) string{
	
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
	NSDate* date = [dateFormatter dateFromString:string];
    [dateFormatter release];
	return date;
}

+ (NSString*) chatMessage_UTCStringToLocalString:(NSString*) utcString{
	
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
	NSDate* date = [dateFormatter dateFromString:utcString];
	
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	NSString *dateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dateString;
    
}



+ (BOOL) isChatMessageInDB:(ChatMessage *)msg{
    
    if(msg==NULL)return NO;
    
    FMResultSet *res;
    //select id from chatmessages where chattarget = ? and (is_group_chat = 0 or group_chat_sender_id = ?) and remote_key = ?;
    if (msg.isGroupChatMessage) {
        res= [db executeQuery:@"SELECT `id` FROM `chatmessages` WHERE `chattarget`=? AND `msgcontent`=? AND `sentdate`=? AND `msgtype`=? AND `group_chat_sender_id`=?",
              msg.chatUserName,
              msg.messageContent, msg.sentDate, msg.msgType,msg.groupChatSenderID];
    }
    else{
        res= [db executeQuery:@"SELECT `id` FROM `chatmessages` WHERE `chattarget`=? AND `msgcontent`=? AND `sentdate`=? ",
              msg.chatUserName,
              msg.messageContent, msg.sentDate];
    }
    
    
	if (res && [res next]) {
        return YES;
    }
    
    return NO;
}


+ (NSInteger) storeNewChatMessage:(ChatMessage *)msg{
	// We're already inside a transaction if we were called from within
	// storeBuddys. If that isn't the case, make sure we start a new
	// transaction.
	BOOL newTransaction = ![db inTransaction];
	if (newTransaction)
		[db beginTransaction];
    
	[db executeUpdate:@"INSERT INTO `chatmessages` (`chattarget`,`display_name`, `msgtype`,`sentdate`,`iotype`, `sentstatus`,`is_group_chat`,`group_chat_sender_id`,`read_count`,`path_thumbnail`,`path_multimedia`,`msgcontent`,`remote_key` ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
	 msg.chatUserName,
     msg.displayName,
     msg.msgType,
     msg.sentDate,
     msg.ioType,
     msg.sentStatus,
     msg.isGroupChatMessage?@"1":@"0",
     msg.groupChatSenderID,
     [NSString stringWithFormat:@"%zi",msg.readCount],
     msg.pathOfThumbNail,
     msg.pathOfMultimedia,
	 msg.messageContent,
     [NSString stringWithFormat:@"%zi", msg.remoteKey]];
	
	if (newTransaction)
		[db commit];
	
    NSInteger insertKey=[db lastInsertRowId];
    
    if(PRINT_LOG)NSLog(@"storeNewChatMessage for msdID:%zi",insertKey);
    
	return insertKey;
}


+ (void) deleteAllChatMessages{
	[db executeUpdate:@"DELETE FROM `chatmessages` WHERE 1=1"];
}


+ (void) deleteChatMessagesWithBuddyID:(NSString *)buddy_id{
    [db executeUpdate:@"DELETE FROM `chatmessages` WHERE `chattarget`= ? AND `is_group_chat`=?",buddy_id,@"0"];
}
+ (NSMutableArray *) fetchAllBuddysAndGroup:(BOOL)isDistinctByUserName{
    NSMutableArray *msgs = [[NSMutableArray alloc] init];
    FMResultSet *res;
    
    if (isDistinctByUserName) {
        res = [db executeQuery:@"SELECT `id`,`chattarget`,`display_name`, `msgtype`,MAX(`sentdate`) AS `sentdate`,`iotype`, `sentstatus`,`is_group_chat`,`group_chat_sender_id`,`read_count`,`path_thumbnail`,`path_multimedia`,`msgcontent`,`remote_key` FROM `chatmessages` WHERE `msgtype`<>'g' AND `chattarget`<> '10000' GROUP BY `chattarget` ORDER BY MAX(`sentdate`)"];
        
    }
    else {
        res = [db executeQuery:@"SELECT `id`,`chattarget`,`display_name`, `msgtype`,`sentdate`,`iotype`, `sentstatus`,`is_group_chat`,`group_chat_sender_id`,`read_count`,`path_thumbnail`,`path_multimedia`,`msgcontent`,`remote_key` FROM `chatmessages` WHERE `msgtype`<>'g' AND `chattarget`<> '10000'"];
        
    }
    
    while ([res next]) {
        ChatMessage *msg = [[[ChatMessage alloc] init] autorelease];
        msg.primaryKey =  [res intForColumnIndex:0];
        msg.chatUserName = [res stringForColumnIndex:1];
        msg.displayName = [res stringForColumnIndex:2];
        msg.msgType = [res stringForColumnIndex:3];
        msg.sentDate = [res stringForColumnIndex:4];
        msg.ioType = [res stringForColumnIndex:5];
        msg.sentStatus = [res stringForColumnIndex:6];
        msg.isGroupChatMessage = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        msg.groupChatSenderID = [res stringForColumnIndex:8];
        msg.readCount = [[res stringForColumnIndex:9] intValue];
        msg.pathOfThumbNail =[res stringForColumnIndex:10];
        msg.pathOfMultimedia = [res stringForColumnIndex:11];
        msg.messageContent = [res stringForColumnIndex:12];
        msg.remoteKey = [[res stringForColumnIndex:13] intValue];
        
        [msgs addObject:msg];
    }
    [res close];
    return [msgs autorelease];
}


+ (NSMutableArray *) fetchAllChatMessages:(BOOL)isDistinctByUserName{
	NSMutableArray *msgs = [[NSMutableArray alloc] init];
	FMResultSet *res;
	
	if (isDistinctByUserName) {
		res = [db executeQuery:@"SELECT `id`,`chattarget`,`display_name`, `msgtype`,MAX(`sentdate`) AS `sentdate`,`iotype`, `sentstatus`,`is_group_chat`,`group_chat_sender_id`,`read_count`,`path_thumbnail`,`path_multimedia`,`msgcontent`,`remote_key` FROM `chatmessages` WHERE `msgtype`<>'g'  GROUP BY `chattarget` ORDER BY MAX(`sentdate`)"];
        
	}
	else {
		res = [db executeQuery:@"SELECT `id`,`chattarget`,`display_name`, `msgtype`,`sentdate`,`iotype`, `sentstatus`,`is_group_chat`,`group_chat_sender_id`,`read_count`,`path_thumbnail`,`path_multimedia`,`msgcontent`,`remote_key` FROM `chatmessages` WHERE `msgtype`<>'g'"];  
        
	}
    
	while ([res next]) {
		ChatMessage *msg = [[[ChatMessage alloc] init] autorelease];
		msg.primaryKey =  [res intForColumnIndex:0];
		msg.chatUserName = [res stringForColumnIndex:1];
        msg.displayName = [res stringForColumnIndex:2];
        msg.msgType = [res stringForColumnIndex:3];
		msg.sentDate = [res stringForColumnIndex:4];
		msg.ioType = [res stringForColumnIndex:5];
		msg.sentStatus = [res stringForColumnIndex:6];
        msg.isGroupChatMessage = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        msg.groupChatSenderID = [res stringForColumnIndex:8];
        msg.readCount = [[res stringForColumnIndex:9] intValue];
        msg.pathOfThumbNail =[res stringForColumnIndex:10];
        msg.pathOfMultimedia = [res stringForColumnIndex:11];
		msg.messageContent = [res stringForColumnIndex:12];
        msg.remoteKey = [[res stringForColumnIndex:13] intValue];
        
		[msgs addObject:msg];
	}
	[res close];
	return [msgs autorelease];
}

//TODO:add fetchAllGroupChatInvitaion

+ (NSMutableArray *) searchChatMessagesByContent:(NSString*)searchMsgText{
	NSMutableArray *msgs = [[NSMutableArray alloc] init];
	NSString* strsql=[NSString stringWithFormat:@"SELECT `id`,`chattarget`,`display_name`, `msgtype`,`sentdate`,`iotype`, `sentstatus`,`is_group_chat`,`group_chat_sender_id`,`read_count`,`path_thumbnail`,`path_multimedia`,`msgcontent`,`remote_key` FROM `chatmessages` WHERE `msgcontent` LIKE '%%%@%%' AND `msgtype`<>'g'  GROUP BY `chattarget`",searchMsgText];
	if(PRINT_LOG)NSLog(@"%@",strsql);
	FMResultSet *res= [db executeQuery:strsql];
	
	
	while ([res next]) {
        ChatMessage *msg = [[[ChatMessage alloc] init] autorelease];
		msg.primaryKey =  [res intForColumnIndex:0];
		msg.chatUserName = [res stringForColumnIndex:1];
        msg.displayName = [res stringForColumnIndex:2];
        msg.msgType = [res stringForColumnIndex:3];
		msg.sentDate = [res stringForColumnIndex:4];
		msg.ioType = [res stringForColumnIndex:5];
		msg.sentStatus = [res stringForColumnIndex:6];
        msg.isGroupChatMessage = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        msg.groupChatSenderID = [res stringForColumnIndex:8];
        msg.readCount = [[res stringForColumnIndex:9] intValue];
        msg.pathOfThumbNail =[res stringForColumnIndex:10];
        msg.pathOfMultimedia = [res stringForColumnIndex:11];
		msg.messageContent = [res stringForColumnIndex:12];
        msg.remoteKey = [[res stringForColumnIndex:13] intValue];
        
		[msgs addObject:msg];
	}
	[res close];
	return [msgs autorelease];
	
}


+ (NSMutableArray *) fetchChatMessagesWithUser:(NSString*)userName withLimit:(NSInteger)limit fromOffset:(NSInteger)offset{
	//if(PRINT_LOG)NSLog(@"fetchChatMessagesWithUser for %@,and limit %d ,and offset=%d",userName,limit,offset);
    
	NSMutableArray *msgs = [[NSMutableArray alloc] init];
    
	NSString* strsql=[NSString stringWithFormat:@"SELECT `id`,`chattarget`,`display_name`, `msgtype`,`sentdate`,`iotype`, `sentstatus`,`is_group_chat`,`group_chat_sender_id`,`read_count`,`path_thumbnail`,`path_multimedia`,`msgcontent`,`remote_key` FROM `chatmessages` WHERE `chattarget`='%@' AND `msgtype`<>'g' ORDER BY `sentdate`,`id`  LIMIT %zi,%zi",userName,offset,limit];
	
	if(PRINT_LOG)NSLog(@"%@",strsql);
	FMResultSet *res =  [db executeQuery: strsql];
	
	while ([res next]) {
		ChatMessage *msg = [[[ChatMessage alloc] init] autorelease];
		msg.primaryKey =  [res intForColumnIndex:0];
		msg.chatUserName = [res stringForColumnIndex:1];
        msg.displayName = [res stringForColumnIndex:2];
        msg.msgType = [res stringForColumnIndex:3];
		msg.sentDate = [res stringForColumnIndex:4];
		msg.ioType = [res stringForColumnIndex:5];
		msg.sentStatus = [res stringForColumnIndex:6];
        msg.isGroupChatMessage = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        msg.groupChatSenderID = [res stringForColumnIndex:8];
        msg.readCount = [[res stringForColumnIndex:9] intValue];
        msg.pathOfThumbNail =[res stringForColumnIndex:10];
        msg.pathOfMultimedia = [res stringForColumnIndex:11];
		msg.messageContent = [res stringForColumnIndex:12];
        msg.remoteKey = [[res stringForColumnIndex:13] intValue];
        
		[msgs addObject:msg];
        
	}
	[res close];
	return [msgs autorelease];
}

+ (NSMutableArray *) fetchChatMessagesWithUser:(NSString*)userName{
	NSMutableArray *msgs = [[NSMutableArray alloc] init];
	FMResultSet *res = [db executeQuery:@"SELECT `id`,`chattarget`,`display_name`, `msgtype`,`sentdate`,`iotype`, `sentstatus`,`is_group_chat`,`group_chat_sender_id`,`read_count`,`path_thumbnail`,`path_multimedia`,`msgcontent`,`remote_key` FROM `chatmessages` WHERE `chattarget`=? AND `msgtype`<>'g' ORDER BY `id`",userName];
    
	while ([res next]) {
		ChatMessage *msg = [[[ChatMessage alloc] init] autorelease];
		msg.primaryKey =  [res intForColumnIndex:0];
		msg.chatUserName = [res stringForColumnIndex:1];
        msg.displayName = [res stringForColumnIndex:2];
        msg.msgType = [res stringForColumnIndex:3];
		msg.sentDate = [res stringForColumnIndex:4];
		msg.ioType = [res stringForColumnIndex:5];
		msg.sentStatus = [res stringForColumnIndex:6];
        msg.isGroupChatMessage = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        msg.groupChatSenderID = [res stringForColumnIndex:8];
        msg.readCount = [[res stringForColumnIndex:9] intValue];
        msg.pathOfThumbNail =[res stringForColumnIndex:10];
        msg.pathOfMultimedia = [res stringForColumnIndex:11];
		msg.messageContent = [res stringForColumnIndex:12];
        msg.remoteKey = [[res stringForColumnIndex:13] intValue];
        
		[msgs addObject:msg];
        
	}
	[res close];
	return [msgs autorelease];
}

+ (NSMutableArray *) fetchUnreadChatMessagesWithUser:(NSString*)userName{
    NSMutableArray *msgs = [[NSMutableArray alloc] init];
	FMResultSet *res = [db executeQuery:@"SELECT `id`,`chattarget`,`display_name`, `msgtype`,`sentdate`,`iotype`, `sentstatus`,`is_group_chat`,`group_chat_sender_id`,`read_count`,`path_thumbnail`,`path_multimedia`,`msgcontent`,`remote_key` FROM `chatmessages` WHERE `chattarget`=? AND `msgtype`<>'g' AND `iotype`=? ORDER BY `id`",userName,[ChatMessage IOTYPE_INPUT_UNREAD]];
    
	while ([res next]) {
		ChatMessage *msg = [[[ChatMessage alloc] init] autorelease];
		msg.primaryKey =  [res intForColumnIndex:0];
		msg.chatUserName = [res stringForColumnIndex:1];
        msg.displayName = [res stringForColumnIndex:2];
        msg.msgType = [res stringForColumnIndex:3];
		msg.sentDate = [res stringForColumnIndex:4];
		msg.ioType = [res stringForColumnIndex:5];
		msg.sentStatus = [res stringForColumnIndex:6];
        msg.isGroupChatMessage = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        msg.groupChatSenderID = [res stringForColumnIndex:8];
        msg.readCount = [[res stringForColumnIndex:9] intValue];
        msg.pathOfThumbNail =[res stringForColumnIndex:10];
        msg.pathOfMultimedia = [res stringForColumnIndex:11];
		msg.messageContent = [res stringForColumnIndex:12];
        msg.remoteKey = [[res stringForColumnIndex:13] intValue];
        
		[msgs addObject:msg];
        
	}
	[res close];
	return [msgs autorelease];
    
    
}

//TODO:fetchChatMessageByPrimaryKey

+ (NSInteger) countChatMessagesWithUser:(NSString*)userName{
	FMResultSet *res = [db executeQuery:@"SELECT COUNT(`id`) FROM `chatmessages` WHERE `chattarget`=? AND `msgtype`<>'g'",userName];
	NSInteger recordNumber= 0;
	if (res && [res next]) {
		recordNumber =  [res intForColumnIndex:0];
		[res close];
	}
	
	return recordNumber;
	
}

+ (NSInteger) countUnreadChatMessagesWithUser:(NSString*)userName{
    FMResultSet *res = [db executeQuery:@"SELECT COUNT(`id`) FROM `chatmessages` WHERE `chattarget`=? AND `msgtype`<>'g' AND `msgtype`<>'h' AND `msgtype`<>'i' AND `iotype`=?",userName,[ChatMessage IOTYPE_INPUT_UNREAD]];
	NSInteger recordNumber= 0;
	if (res && [res next]) {
		recordNumber =  [res intForColumnIndex:0];
		[res close];
	}
	
	return recordNumber;
}



+ (void) setChatMessageAllReaded:(NSString*)userName{
	[db executeUpdate:@"UPDATE `chatmessages` SET `iotype`=? WHERE `iotype`=? AND `chattarget`=?", [ChatMessage IOTYPE_INPUT_READED],[ChatMessage IOTYPE_INPUT_UNREAD],
	 userName];
}

+ (void) setChatMessageReaded:(ChatMessage *)msg{
	[db executeUpdate:@"UPDATE `chatmessages` SET `iotype`=? WHERE `id`=?", [ChatMessage IOTYPE_INPUT_READED],
	 [NSNumber numberWithInteger:[msg primaryKey]]];
}


+ (void)setChatMessage:(ChatMessage *)msg   withNewSentStatus:(NSString*)newSentStatus{
    FMResultSet *res = [db executeQuery:@"SELECT `sentstatus` FROM `chatmessages` WHERE `id`=?",[NSNumber numberWithInteger:[msg primaryKey]]];
	if (res && [res next]) {
        NSString* oldSentStatus = [res stringForColumnIndex:0];
        if ([oldSentStatus intValue]<[newSentStatus intValue]) {
            
            if([newSentStatus isEqualToString:[ChatMessage SENTSTATUS_SENT]]){
                [db executeUpdate:@"UPDATE `chatmessages` SET `sentstatus`=?,`sentdate`=? WHERE `id`=?",
                 newSentStatus,
                 msg.sentDate,
                 [NSNumber numberWithInteger:[msg primaryKey]]];

            }
            else{
                [db executeUpdate:@"UPDATE `chatmessages` SET `sentstatus`=? WHERE `id`=?",
                 newSentStatus,
                 [NSNumber numberWithInteger:[msg primaryKey]]];

            }
        }
    }
}


+ (void) setChatMessageInProcess:(ChatMessage *)msg{
  //  NSLog(@"set in process msg sent date: %@", msg.sentDate);
    [Database setChatMessage:msg withNewSentStatus:[ChatMessage SENTSTATUS_IN_PROCESS]];
}

+ (void) setChatMessageCannotSent:(ChatMessage *)msg{
    //   NSLog(@"set can not sent msg sent date: %@", msg.sentDate);
    [Database setChatMessage:msg withNewSentStatus:[ChatMessage SENTSTATUS_NOTSENT]];
}


+ (void) setChatMessageSent:(ChatMessage *)msg{
    //   NSLog(@"set sent msg sent date: %@", msg.sentDate);
    [Database setChatMessage:msg withNewSentStatus:[ChatMessage SENTSTATUS_SENT]];
    //TODO: update the sentdate
}

+ (void) setChatMessageReachedContact:(ChatMessage *)msg{
  //   NSLog(@"set sent msg reached date: %@", msg.sentDate);
    [Database setChatMessage:msg withNewSentStatus:[ChatMessage SENTSTATUS_REACHED_CONTACT]];
}

+ (void) setChatMessageReadedByContact:(ChatMessage *)msg{
    FMResultSet *res = [db executeQuery:@"SELECT `read_count` FROM `chatmessages`WHERE `id`=?",[NSNumber numberWithInteger:[msg primaryKey]]];
	if (res && [res next]) {
		NSString* readCount =  [res stringForColumnIndex:0];
		[res close];
        
        int cnt = [readCount intValue];
        cnt++;
        [db executeUpdate:@"UPDATE `chatmessages` SET `sentstatus`=?,`read_count`=? WHERE `id`=?",[ChatMessage SENTSTATUS_READED_BY_CONTACT],
         [NSString stringWithFormat:@"%d",cnt],
         [NSNumber numberWithInteger:[msg primaryKey]]];
        
	}
    
	
}

+ (void) deleteChatMessage:(ChatMessage *)msg{
	NSAssert([msg hasPrimaryKey], @"Can only delete objects originated from database");
	[db executeUpdate:@"DELETE FROM `chatmessages` WHERE `id`=?",
	 [NSNumber numberWithInteger:[msg primaryKey]]];
}

+(void)deleteChatMessageByID:(int)primarykey
{
    [db executeUpdate:@"DELETE FROM `chatmessages` WHERE `id`=?",
	 [NSNumber numberWithInt:primarykey]];
}

// return the number of unreaded messages which is going to be deleted
+ (NSInteger) deleteChatMessageWithUser:(NSString*)userName{
	FMResultSet *res = [db executeQuery:@"SELECT COUNT(*) FROM `chatmessages` WHERE `iotype`=? AND `chattarget`=?", [ChatMessage IOTYPE_INPUT_UNREAD], userName];
	NSInteger unReadedRecordNumber= 0;
	if (res && [res next]) {
		unReadedRecordNumber =  [res intForColumnIndex:0];
		[res close];
	}
	
    
	[db executeUpdate:@"DELETE FROM `chatmessages` WHERE `chattarget`=?",userName];
	
	return unReadedRecordNumber;
}


/**
 * Update ChatMessage after file(multimedia) transfered with server
 * @param msg
 * @return
 */
+(void) updateChatMessage:(ChatMessage*) msg{
 //   NSLog(@"update chatmessage sent date: %@",msg.sentDate);
    [db executeUpdate:@"UPDATE `chatmessages` SET `chattarget`=?,`display_name`=?, `msgtype`=?,`sentdate`=?,`iotype`=?, `sentstatus`=?,`is_group_chat`=?,`group_chat_sender_id`=?,`read_count`=?,`path_thumbnail`=?,`path_multimedia`=?,`msgcontent`=?,`remote_key`=? WHERE `id`=?",
     msg.chatUserName,
     msg.displayName,
     msg.msgType,
     msg.sentDate,
     msg.ioType,
     msg.sentStatus,
     msg.isGroupChatMessage?@"1":@"0",
     msg.groupChatSenderID,
     [NSString stringWithFormat:@"%zi",msg.readCount],
     msg.pathOfThumbNail,
     msg.pathOfMultimedia,
	 msg.messageContent,
     [NSString stringWithFormat:@"%zi",msg.remoteKey],
	 [NSNumber numberWithInteger:[msg primaryKey]]];
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Chat Message Unsent Receipt (for reached or readed notice)
+ (NSInteger) storeUnsentReceipt:(ChatMessage *)msg{
    FMResultSet *res;
    res= [db executeQuery:@"SELECT `id` FROM `unsent_receipts` WHERE `chattarget`=? AND `messagebody`=? ",
          msg.chatUserName,
          msg.messageContent];
    
	if (res && [res next]) {
        return -1;
        
    }

    
    
    
	BOOL newTransaction = ![db inTransaction];
	if (newTransaction)
		[db beginTransaction];
    
	[db executeUpdate:@"INSERT INTO `unsent_receipts` (`chattarget`,`messagebody`) VALUES (?, ?)",
	 msg.chatUserName,
     msg.msgType,
	 msg.messageContent];
	
	if (newTransaction)
		[db commit];
	    
	return [db lastInsertRowId];
}

+ (void) deleteUnsentReceipt:(ChatMessage *)msg{
    [db executeUpdate:@"DELETE FROM `unsent_receipts` WHERE `chattarget`=? AND  `messagebody`=?",msg.chatUserName,msg.messageContent];
}
+ (NSMutableArray *) fetchAllUnsentReceipt{
    NSMutableArray *msgs = [[NSMutableArray alloc] init];
	FMResultSet *res = [db executeQuery:@"SELECT `id`,`chattarget`,`messagebody` FROM `unsent_receipts`"];
    
	while ([res next]) {
        int i =-1;
		ChatMessage *msg = [[[ChatMessage alloc] init] autorelease];
        msg.primaryKey = [res intForColumnIndex:++i];
		msg.chatUserName = [res stringForColumnIndex:++i];
        msg.messageContent = [res stringForColumnIndex:++i];
        
		[msgs addObject:msg];
        
	}
	[res close];
	return [msgs autorelease];

}



#pragma mark -
#pragma mark Call Logs Handle
+ (NSString*) callLog_dateToUTCString:(NSDate*) localDate{
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    [dateFormatter release];
    return dateString;
	
}

+ (NSDate*) callLog_UTCStringToDate:(NSString*) string{
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
	NSDate* date = [dateFormatter dateFromString:string];
    [dateFormatter release];
	return date;
}



+ (void) storeNewCallLog:(CallLog *)log{
	// We're already inside a transaction if we were called from within
	// storeBuddys. If that isn't the case, make sure we start a new
	// transaction.
	BOOL newTransaction = ![db inTransaction];
	if (newTransaction)
		[db beginTransaction];
	
	[db executeUpdate:@"INSERT INTO `calllogs` (`contact`,`display_name`, `callstatus`,`direction`, `startdate`,`duration`,`quality`) VALUES (?, ?, ?, ?, ?, ?, ?)",
	 log.contact, log.displayName,
	 [NSString stringWithFormat:@"%d",log.status] ,log.direction, log.startDate, [NSString stringWithFormat:@"%zi",log.duration], [NSString stringWithFormat:@"%zi",log.quality]  ];
	
	if (newTransaction)
		[db commit];
	
}

+ (void) deleteAllCallLogs{
	[db executeUpdate:@"DELETE FROM `calllogs` WHERE 1=1"];
}



+ (NSArray *) fetchAllCallLogs{
	NSMutableArray *logs = [[NSMutableArray alloc] init];
	FMResultSet *res;
	
	res = [db executeQuery:@"SELECT `id`,`contact`,`display_name`, `callstatus`, `direction`, `startdate`, `duration`, `quality` FROM `calllogs` ORDER BY `startdate` DESC"];
	
	while ([res next]) {
		CallLog *log = [[[CallLog alloc] init] autorelease];
		log.primaryKey =  [res intForColumnIndex:0];
		log.contact = [res stringForColumnIndex:1];
        log.displayName = [res stringForColumnIndex:2];
		log.status = [[res stringForColumnIndex:3] intValue];
		log.direction = [res stringForColumnIndex:4];
		log.startDate = [res stringForColumnIndex:5];
		log.duration = [[res stringForColumnIndex:6] intValue];
		log.quality = [[res stringForColumnIndex:7] intValue];
		[logs addObject:log];
	}
	[res close];
	return [logs autorelease];
}

+ (void) deleteCallLog:(CallLog *)log{
	NSAssert([log hasPrimaryKey], @"Can only delete objects originated from database");
	[db executeUpdate:@"DELETE FROM `calllogs` WHERE `id`=?",
	 [NSNumber numberWithInteger:[log primaryKey]]];
}




#pragma mark -
#pragma mark GroupChat
+ (void)storeGroupChatRoom:(GroupChatRoom*)groupChatRoom{
    if(PRINT_LOG)NSLog(@"storeGroupChatRoom:%@,%@",groupChatRoom.groupID,groupChatRoom.groupNameOriginal);
	
	// We're already inside a transaction if we were called from within
	// storebuddys. If that isn't the case, make sure we start a new
	// transaction.
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction)
        [db beginTransaction];
	
	FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_chatroom` WHERE `group_id`=?",groupChatRoom.groupID];
	
    
    
    if (res && [res next]) {
        if(PRINT_LOG)NSLog(@"groupID exist ,do update");
        
		[db executeUpdate:@"UPDATE `group_chatroom` SET `group_name_original`=?, `group_name_local`=?, `group_status`=?, `max_number`=?, `member_count`=?, `temp_group_flag`=?,`isinvisible` = ? WHERE `group_id` = ? ",
         groupChatRoom.groupNameOriginal,
         groupChatRoom.groupNameLocal,
         groupChatRoom.groupStatus,
         [NSString stringWithFormat:@"%zi", groupChatRoom.maxNumber],
         [NSString stringWithFormat:@"%zi", groupChatRoom.memberCount],
         groupChatRoom.isTemporaryGroup?@"1":@"0",
         groupChatRoom.isInvisibile?@"1":@"0",
         groupChatRoom.groupID];
        
	}
	else {
        
        if(PRINT_LOG)NSLog(@"groupID doesnt exist ,do insert");
		[db executeUpdate:@"INSERT INTO `group_chatroom` (`group_id`, `group_name_original`,`group_name_local`,`group_status`,`max_number`,`member_count`,`temp_group_flag`,`isinvisible`) VALUES (?, ?, ?, ?, ?, ?, ?,?)",
         groupChatRoom.groupID,
         groupChatRoom.groupNameOriginal,
         groupChatRoom.groupNameLocal,
         groupChatRoom.groupStatus,
         [NSString stringWithFormat:@"%zi", groupChatRoom.maxNumber],
         [NSString stringWithFormat:@"%zi", groupChatRoom.memberCount],
         groupChatRoom.isTemporaryGroup?@"1":@"0",
         groupChatRoom.isInvisibile?@"1":@"0"];
        
	}
    
  //  NSLog(@"error:%@",[db lastErrorMessage]);
    if (newTransaction)
        [db commit];
    
}

+ (GroupChatRoom *)getGroupChatRoomByGroupid:(NSString *)groupid
{
   	if (groupid==nil) {
		return nil;
	}
	FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`group_id`, `group_name_original`,`group_name_local`,`group_status`,`max_number`,`member_count`,`temp_group_flag`,`isinvisible`"
                        @"FROM `group_chatroom`"
                        @"WHERE group_id=?",groupid];
    
	if (res && [res next]) {
		GroupChatRoom *ident = [[[GroupChatRoom alloc] init] autorelease];
		ident.groupID = [res stringForColumnIndex:0];
        ident.groupNameOriginal = [res stringForColumnIndex:1];
        ident.groupNameLocal = [res stringForColumnIndex:2];
		ident.groupStatus = [res stringForColumnIndex:3];
		ident.maxNumber = [[res stringForColumnIndex:4] intValue] ;
		ident.memberCount = [[res stringForColumnIndex:5] intValue];
		ident.isTemporaryGroup = [[res stringForColumnIndex:6] isEqualToString:@"1"];
		ident.isInvisibile = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        
		[res close];
		return ident;
	}
    
	return nil;
    
}

+ (void)deleteGroupChatRoom:(GroupChatRoom*)groupChatRoom{
    [db executeUpdate:@"DELETE FROM `group_chatroom` WHERE `group_id`=?",
     groupChatRoom.groupID];
}

+ (void)deleteGroupChatRoomWithID:(NSString*)groupID{
    [db executeUpdate:@"DELETE FROM `group_chatroom` WHERE `group_id`=?",
     groupID];
}

+ (void)addBuddys:(NSArray *)buddys toGroupChatRoomByID:(NSString*)groupID{
    
    [db beginTransaction];
    for (Buddy *buddy in buddys) {
        [Database addNewBuddy:buddy toGroupChatRoomByID:groupID];
    }
	[db commit];
}

+(void)storeMembers:(NSArray*)buddys ToChatRoom:(NSString*)groupid
{
    for (Buddy* buddy in buddys) {
        [Database storeMember:buddy ToChatRoom:(NSString*)groupid];
    }
}

+(void)storeMember:(Buddy*)buddy ToChatRoom:(NSString*)groupid
{
    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];
    
    
    //write to group_member
	FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_member` WHERE `group_id`=? AND `member_id`=?",groupid,buddy.userID];
    
    NSString* flag = @"9";
    if ([buddy.userID isEqualToString:[WTUserDefaults getUid]]){
        flag = @"0";
    }
    
    if (res && [res next]) {
        if(PRINT_LOG)NSLog(@"group_member record exist ,do nothing");
    }
	else {
        if(PRINT_LOG)NSLog(@"group_member record doesnt exist ,do insert");
        [db executeUpdate:@"INSERT INTO `group_member` (`group_id`, `member_id`,`member_level`) VALUES (?, ?, ?)", groupid, buddy.userID, flag];

	}
    
  //  NSLog(@"%@",[db lastErrorMessage]);
    //TODO: check here. store the buddy info to db
    
    [Database storeNewBuddyWithUpdate:buddy forGroupMember:YES];
    
    if (newTransaction)
        [db commit];

}


+ (void)addNewBuddy:(Buddy*)ident toGroupChatRoomByID:(NSString*)groupID{
   if([ident.userID isEqualToString:[WTUserDefaults getUid]]){
        if(PRINT_LOG)NSLog(@"this buddy has the same userID as mine ,dont store, we handle myself in the code");
        return;
    }

    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];
	
    //write to group_member
	FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_member` WHERE `group_id`=? AND `member_id`=?",groupID,ident.userID];
	
    
    
    if (res && [res next]) {
        if(PRINT_LOG)NSLog(@"group_member record exist ,do nothing");
    }
	else {
        if(PRINT_LOG)NSLog(@"group_member record doesnt exist ,do insert");
		[db executeUpdate:@"INSERT INTO `group_member` (`group_id`, `member_id`,`member_level`) VALUES (?, ?,?)",
         groupID,
         ident.userID,ident.level];
        
	}
    
    //TODO: think it here, add possible buddy to buddylist
    [Database storeNewBuddyWithUpdate:ident forGroupMember:YES];
    
    if (newTransaction)
        [db commit];
}



+ (NSMutableArray *) getAllGroupChatRooms{
    NSMutableArray *list = [[NSMutableArray alloc] init];
	FMResultSet *res;
    
	res = [db executeQuery:@"SELECT `group_id`,`group_name_original`, `group_name_local`, `group_status`, `max_number`, `member_count`,`temp_group_flag`,`isinvisible` FROM `group_chatroom` "];
	
	while ([res next]) {
        GroupChatRoom* room = [[[GroupChatRoom alloc] init] autorelease];
        room.groupID = [res stringForColumnIndex:0];
        room.groupNameOriginal = [res stringForColumnIndex:1];
        room.groupNameLocal = [res stringForColumnIndex:2];
        room.groupStatus = [res stringForColumnIndex:3];
        room.maxNumber = [[res stringForColumnIndex:4] intValue];
        room.memberCount = [[res stringForColumnIndex:5] intValue];
        room.isTemporaryGroup = [[res stringForColumnIndex:6] isEqualToString:@"1"];
        room.isInvisibile = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        
		[list addObject:room];
	}
	[res close];
	return [list autorelease];
    
}


+(NSMutableArray*) getAllTemporaryGroupChatrooms
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
	FMResultSet *res;
    
	res = [db executeQuery:@"SELECT `group_id`,`group_name_original`, `group_name_local`, `group_status`, `max_number`, `member_count`,`temp_group_flag`,`isinvisible` FROM `group_chatroom` WHERE `temp_group_flag` = 1 "];
	
	while ([res next]) {
        GroupChatRoom* room = [[[GroupChatRoom alloc] init] autorelease];
        room.groupID = [res stringForColumnIndex:0];
        room.groupNameOriginal = [res stringForColumnIndex:1];
        room.groupNameLocal = [res stringForColumnIndex:2];
        room.groupStatus = [res stringForColumnIndex:3];
        room.maxNumber = [[res stringForColumnIndex:4] intValue];
        room.memberCount = [[res stringForColumnIndex:5] intValue];
        room.isTemporaryGroup = [[res stringForColumnIndex:6] isEqualToString:@"1"];
        room.isInvisibile = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        
		[list addObject:room];
	}
	[res close];
	return [list autorelease];

    
}


+ (NSMutableArray *)fetchAllBuddysInGroupChatRoom:(NSString*)groupID{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`buddydetail`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`"
                        @"FROM `group_member`"
                        @"LEFT JOIN `buddys` ON `group_member`.`member_id`= `buddys`.`uid`"
                        @"LEFT JOIN `buddydetail` ON `group_member`.`member_id`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `group_member`.`member_id`= `block_list`.`uid`"
                        @"WHERE `group_id`=?",groupID];
    
    
	while ([res next]) {
        Buddy *ident = [[[Buddy alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = ([res stringForColumnIndex:1] !=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        ident.buddy_flag = [res stringForColumnIndex:8];
        ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        
		[list addObject:ident];
	}
    [res close];
	return [list autorelease];

}

+ (void)deleteAllBuddysInGroupChatRoomByID:(NSString*) groupID{
    [db executeUpdate:@"DELETE FROM `group_member` WHERE `group_id`=?", groupID];
    
}

+ (void)updateGroupChatRoom:(GroupChatRoom*)groupChatRoom{
    
    [db executeUpdate:@"UPDATE `group_chatroom` SET `group_name_original`=?, `group_name_local`=?,`group_status`=?,`max_number`=?,`member_count`=?,`temp_group_flag`=?, `isinvisible`=? WHERE `group_id`=? ",
     groupChatRoom.groupNameOriginal,
     groupChatRoom.groupNameLocal,
     groupChatRoom.groupStatus,
     [NSString stringWithFormat:@"%zi", groupChatRoom.maxNumber],
     [NSString stringWithFormat:@"%zi", groupChatRoom.memberCount],
     groupChatRoom.isTemporaryGroup?@"1":@"0",
     groupChatRoom.isInvisibile?@"1":@"0",
     groupChatRoom.groupID];
    
}

+ (void)changeGroupChatRoomLocalName:(NSString*)newName forGroupID:(NSString*) groupID{
    if(newName==NULL || groupID == NULL) return;
    
    [db executeUpdate:@"UPDATE `group_chatroom` SET `group_name_local`=? WHERE `group_id`=? ",
     newName, groupID];
    
}
+ (void)changeGroupChatRoomMemberCount:(int)newCount forGroupID:(NSString*) groupID{
    if(groupID == NULL) return;
    
    [db executeUpdate:@"UPDATE `group_chatroom` SET `member_count`=? WHERE `group_id`=? ",
     [NSString stringWithFormat:@"%d", newCount], groupID];
    
}

+(void)setGroupInvisibleByID:(NSString*)groupid
{
    if (groupid == nil) {
        return;
    }
    [db executeUpdate:@"UPDATE `group_chatroom` SET `isinvisible`= ? WHERE `group_id`=? ",
     @"1",groupid];
}


+(void)setGroupInvisible:(GroupChatRoom*)group
{
    if (group == nil) {
        return;
    }
    [db executeUpdate:@"UPDATE `group_chatroom` SET `isinvisible`= ? WHERE `group_id`=? ",
     @"1", group.groupID];
}

+(void)updateLevel:(NSString*)level forMember:(NSString*)memberid forGroup:(NSString*)groupid
{
    [db executeUpdate:@"UPDATE `group_member` SET `member_level`= ? WHERE `group_id`=? AND `member_id` = ? ",level,groupid,memberid];
   // NSLog(@"error:%@",[db lastErrorMessage]);

}

+(void)deleteMembers:(NSArray*)memberlist InGroup:(NSString*)groupid
{
    for (GroupMember* member in memberlist) {
        [Database deleteMember:member.userID InGroup:groupid];
    }
}

+(void)deleteMember:(NSString*)memberid InGroup:(NSString*)groupid
{
    //delete the member in the group.
    [db executeUpdate:@"DELETE FROM `group_member` WHERE `group_id`=? AND `member_id`=? ", groupid, memberid];
    
    // decrease the membercount by 1.
    FMResultSet *res = [db executeQuery:@"SELECT `member_count` FROM `group_chatroom` WHERE `group_id`=?",groupid];
    
    NSInteger membercount = 0;
    
    if (res && [res next]) {
        
        membercount = [[res stringForColumnIndex:0] integerValue];
        membercount --;
    }
    
    [db executeUpdate:@"UPDATE `group_chatroom` SET `member_count`= ? WHERE `group_id`=? ",
     [NSString stringWithFormat:@"%zi",membercount], groupid];
    
    
}

+(void)setGroupVisible:(GroupChatRoom*)group
{
    if (group == nil) {
        return;
    }
    [db executeUpdate:@"UPDATE `group_chatroom` SET `isinvisible`= ? WHERE `group_id`=? ",
     @"0", group.groupID];
}

+(void)setGroupVisibleByID:(NSString*)groupid
{
    if (groupid == nil) {
        return;
    }
    [db executeUpdate:@"UPDATE `group_chatroom` SET `isinvisible`= ? WHERE `group_id`=? ",
     @"0", groupid];
}

#pragma mark -
#pragma mark Fixed Group / User Group
+(void)storeFixedGroup:(UserGroup*)userGroup
{
    if (userGroup == nil) {
        return;
    }
    
    if(PRINT_LOG)NSLog(@"store user group:%@,%@",userGroup.groupID,userGroup.groupNameOriginal);
	
	// We're already inside a transaction if we were called from within
	// storebuddys. If that isn't the case, make sure we start a new
	// transaction.
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction)
        [db beginTransaction];
	
	FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_chatroom` WHERE `group_id`=?",userGroup.groupID];
	
    if (res && [res next]) {
        
        if(PRINT_LOG)NSLog(@"groupID exist ,do update");
        
		[db executeUpdate:@"UPDATE `group_chatroom` SET `group_name_original`=?, `group_name_local`=?,`group_status`=?,`max_number`=?,`member_count`=?,`temp_group_flag`=?, `createdplace`=?,`latitude`=?,`lonitude`=?,`grouptype`=?, `avatartimestamp`=?,`introduction`=?,`needtodownloadthumbnail`=?,`needtodownloadphoto`=?,`isinvisible` = ?,`shortid` = ?  WHERE `group_id`=? ",
         userGroup.groupNameOriginal,
         userGroup.groupNameLocal,
         userGroup.groupStatus,
         [NSString stringWithFormat:@"%zi", userGroup.maxNumber],
         [NSString stringWithFormat:@"%zi", userGroup.memberCount],
         userGroup.isTemporaryGroup?@"1":@"0",
         userGroup.createdPlace,
         [NSString stringWithFormat:@"%f", userGroup.latitude],
         [NSString stringWithFormat:@"%f", userGroup.longitude],
         userGroup.groupType,
         userGroup.thumbnail_timestamp,
         userGroup.introduction,
         userGroup.needToDownloadThumbnail?@"1":@"0",
         userGroup.needToDownloadPhoto?@"1":@"0",
         userGroup.isInvisibile?@"1":@"0",    // TODO: check here.
         userGroup.shortid,
         userGroup.groupID
         ];
        
	}
	else {
        if(PRINT_LOG)NSLog(@"groupID doesnt exist ,do insert");
		[db executeUpdate:@"INSERT INTO `group_chatroom` (`group_id`, `group_name_original`,`group_name_local`,`group_status`,`max_number`,`member_count`,`temp_group_flag`,`createdplace`,`latitude`,`lonitude`,`grouptype`, `avatartimestamp`,`introduction`,`needtodownloadthumbnail`,`needtodownloadphoto`,`isinvisible`,`shortid`) VALUES (?, ?, ?, ?, ?, ?, ?,?,?,?,?,?, ?, ?, ?, ?, ?)",
         userGroup.groupID,
         userGroup.groupNameOriginal,
         userGroup.groupNameLocal,
         userGroup.groupStatus,
         [NSString stringWithFormat:@"%zi", userGroup.maxNumber],
         [NSString stringWithFormat:@"%zi", userGroup.memberCount],
         userGroup.isTemporaryGroup?@"1":@"0",
         userGroup.createdPlace,
         [NSString stringWithFormat:@"%f", userGroup.latitude],
         [NSString stringWithFormat:@"%f", userGroup.longitude],
          userGroup.groupType,
         userGroup.thumbnail_timestamp,
         userGroup.introduction,
         userGroup.needToDownloadThumbnail?@"1":@"0",
         userGroup.needToDownloadPhoto?@"1":@"0",
         userGroup.isInvisibile?@"1":@"0",
         userGroup.shortid];
	}
    
    if (newTransaction)
        [db commit];
}



+(void)deleteFixedGroup:(UserGroup*)userGroup
{
    [db executeUpdate:@"DELETE FROM `group_chatroom` WHERE `group_id`=?", userGroup.groupID];
    [self deleteGroupMembers:userGroup.groupID];
}

+(void)deleteGroupMembers:(NSString*)groupID
{
    [db executeUpdate:@"DELETE FROM `group_member` WHERE `group_id`=?", groupID];
}

+(void)deleteAllFixedGroup
{
    FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_chatroom` WHERE `temp_group_flag` = 0 " ];
    
    while (res && [res next]) {
        NSString* groupid = [res stringForColumnIndex:0];
       
        [Database deleteFixedGroupByID:groupid];
    }
}

+(void)deleteFixedGroupByID:(NSString*)groupID
{
   // NSLog(@"deleted groupid: %@", groupID);
    
    [db executeUpdate:@"DELETE FROM `group_chatroom` WHERE `group_id`=?",groupID];
   
    [Database deleteGroupMembers:groupID];
}

+(void)addMember:(GroupMember*)member ToUserGroup:(NSString*)groupid
{
    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];
	
    NSString* flag;
    if (member.isManager) {
        flag = @"1";
    }
    else if (member.isCreator) {
        flag = @"0";
    }
    else
        flag = @"9";
    
    //write to group_member
	FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_member` WHERE `group_id`=? AND `member_id`=?",groupid,member.userID];
    
    
    if (res && [res next]) {
        if(PRINT_LOG)NSLog(@"group_member record exist , update the level .");
        [db executeUpdate:@"UPDATE `group_member` SET `member_level`=?  WHERE `group_id`=? AND `member_id`=?", flag, groupid,member.userID];
    }
	else {
        if(PRINT_LOG)NSLog(@"group_member record doesnt exist ,do insert");
		[db executeUpdate:@"INSERT INTO `group_member` (`group_id`, `member_id`,`member_level`) VALUES (?, ?,?)",
         groupid,
         member.userID,flag];
	}
    
    //TODO: check here. add possible buddy to buddylist
    Buddy* buddy = [Buddy buddyFromGroupMember:member];
    [Database storeNewBuddyWithUpdate:buddy forGroupMember:YES];
    
    if (newTransaction)
        [db commit];
    
}

+(void)addMembers:(NSArray*)members ToUserGroup:(NSString*)groupid
{
    for(GroupMember* member in members)
        [Database addMember:member ToUserGroup:groupid];
}

+(void)storeMembers:(NSArray*)members ToUserGroup:(NSString*)groupid
{
    for (GroupMember* member in members) {
        [Database storeMember:member ToUserGroup:groupid];
    }
}


+(void)storeMember:(GroupMember*)member ToUserGroup:(NSString*)groupid
{
    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];
	  
     NSString* flag;
        if (member.isManager) {
            flag = @"1";
        }
        else if (member.isCreator) {
            flag = @"0";
        }
        else
            flag = @"9";

    //write to group_member
	FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_member` WHERE `group_id`=? AND `member_id`=?",groupid,member.userID];
    
    
    if (res && [res next]) {
        if(PRINT_LOG)NSLog(@"group_member record exist ,update the member level");
        [db executeUpdate:@"UPDATE `group_member` SET `member_level`=?  WHERE `group_id`=? AND `member_id`=?",flag, groupid,member.userID]; 
    }
	else {
        if(PRINT_LOG)NSLog(@"group_member record doesnt exist ,do insert");
        
     //   NSString* str = [NSString stringWithFormat:@"INSERT INTO `group_member` (`group_id`, `member_id`,`member_level`) VALUES (%@, %@, %@)",groupid,member.userID,flag ];
		[db executeUpdate:@"INSERT INTO `group_member` (`group_id`, `member_id`,`member_level`) VALUES (?, ?, ?)", groupid, member.userID, flag];
   //     [db executeUpdate:str];
	}

  //  NSLog(@"%@",[db lastErrorMessage]);
    //TODO: check here. store the buddy info to db
    Buddy* buddy = [Buddy buddyFromGroupMember:member];
    [Database storeNewBuddyWithUpdate:buddy forGroupMember:YES];
    
    if (newTransaction)
        [db commit];
}

+(void)updateFixedGroup:(UserGroup*)userGroup   // it is useless. we could use store group to do update and insert.
{
    [db executeUpdate:@"UPDATE `group_chatroom` SET `group_name_original`=?, `group_status`=?,`max_number`=?,`member_count`=?,`temp_group_flag`=?, `createdplace`=?,`latitude`=?,`lonitude`=?,`grouptype`=?, `avatartimestamp`=?,`introduction`=?,`needtodownloadthumbnail`=?,`needtodownloadphoto`=?,`isinvisible`= ?,`shortid` = ?  WHERE `group_id`=? ",
     userGroup.groupNameOriginal,
     userGroup.groupStatus,
     [NSString stringWithFormat:@"%zi", userGroup.maxNumber],
     [NSString stringWithFormat:@"%zi", userGroup.memberCount],
     userGroup.isTemporaryGroup?@"1":@"0",
     userGroup.createdPlace,
     userGroup.latitude,
     userGroup.longitude,
    userGroup.groupType,
     userGroup.thumbnail_timestamp,
     userGroup.introduction,
     userGroup.needToDownloadThumbnail?@"1":@"0",
     userGroup.needToDownloadPhoto?@"1":@"0",
     userGroup.isInvisibile?@"1":@"0",
     userGroup.shortid,
     userGroup.groupID];
}

+(NSMutableArray*) getAllMembersButMeInFixedGroup:(NSString*)groupid
{
    NSMutableArray *list = [[NSMutableArray alloc] init];    
    
    FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`group_member`.`member_id`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,`member_level`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`"

                        @"FROM `group_member`"
                        @"LEFT JOIN `buddys` ON `group_member`.`member_id`= `buddys`.`uid`"
                        @"LEFT JOIN `buddydetail` ON `group_member`.`member_id`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `group_member`.`member_id`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `group_member`.`member_id`= `buddy_more_detail`.`uid`"

                        @"WHERE `group_id`=?",groupid];
    
    
    //  NSLog(@"%@",[db lastErrorMessage]);
    
	while (res && [res next]) {
        GroupMember *ident = [[[GroupMember alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        if ([ident.userID isEqualToString:[WTUserDefaults getUid]]) {
            continue;
        }
        
        ident.isBlocked = ([res stringForColumnIndex:1] !=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        ident.buddy_flag = [res stringForColumnIndex:8];
        ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12] isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13] isEqualToString:@"1"];
        
        ident.isManager = [[res stringForColumnIndex:14] isEqualToString:@"1"];
        ident.isCreator = [[res stringForColumnIndex:14] isEqualToString:@"0"];
        
        ident.wowtalkID = [res stringForColumnIndex:15];
        ident.userType =  [[res stringForColumnIndex:16] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:18] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:19] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:20] intValue];
        
		[list addObject:ident];
	}
    
    // sort here
    NSSortDescriptor* sorter = [[NSSortDescriptor alloc] initWithKey:@"nickName" ascending:FALSE];
    NSMutableArray* array = [NSMutableArray arrayWithArray:[list sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]]];
    
    [sorter release];
    [list release];
    
    [res close];
	return array;
    

}

+(NSMutableArray*) getAllMembersInFixedGroup:(NSString*)groupid
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`group_member`.`member_id`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,`member_level`,"
                        @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`"

                        @"FROM `group_member`"
                        @"LEFT JOIN `buddys` ON `group_member`.`member_id`= `buddys`.`uid`"
                        @"LEFT JOIN `buddydetail` ON `group_member`.`member_id`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `group_member`.`member_id`= `block_list`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `group_member`.`member_id`= `buddy_more_detail`.`uid`"

                        @"WHERE `group_id`= ? ",groupid];
    
    
   // NSLog(@"%@",[db lastErrorMessage]);
    
	while (res && [res next]) {
        
        GroupMember *ident = [[[GroupMember alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        

        
        ident.isBlocked = ([res stringForColumnIndex:1] !=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        ident.buddy_flag = [res stringForColumnIndex:8];
        ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13]isEqualToString:@"1"];
        
        ident.isManager = [[res stringForColumnIndex:14] isEqualToString:@"1"];
        ident.isCreator = [[res stringForColumnIndex:14] isEqualToString:@"0"];
    
        ident.wowtalkID = [res stringForColumnIndex:15];
        ident.userType =  [[res stringForColumnIndex:16] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:17] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:18] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:19] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:20] intValue];

    
		[list addObject:ident];
	}
    
    [res close];
	return [list autorelease];
    
    
}

+(NSMutableArray*)getAllFixedGroup
{
    //TODO:start from here
    FMResultSet *res = [db executeQuery:
                        @"SELECT `group_id`, `group_name_original`,`group_name_local`,`group_status`,`max_number`,`member_count`,`temp_group_flag`,`createdplace`,`latitude`,`lonitude`,`grouptype`, `avatartimestamp`,`introduction`,`needtodownloadthumbnail`,`needtodownloadphoto`,`isinvisible`,`shortid` FROM `group_chatroom` WHERE `temp_group_flag`= ?", @"0"];
    
    
  //  NSLog(@"%@", [db lastErrorMessage] );
    NSMutableArray* arrgroups = [[NSMutableArray alloc] init];
    
    while (res && [res next]) {
        
		UserGroup *ident = [[[UserGroup alloc] init] autorelease];
        
		ident.groupID = [res stringForColumnIndex:0];
        ident.groupNameOriginal = [res stringForColumnIndex:1];
        ident.groupNameLocal = [res stringForColumnIndex:2];
		ident.groupStatus = [res stringForColumnIndex:3];
		ident.maxNumber = [[res stringForColumnIndex:4] intValue] ;
		ident.memberCount = [[res stringForColumnIndex:5] intValue];
		ident.isTemporaryGroup = FALSE;
        ident.createdPlace = [res stringForColumnIndex:7];
        ident.latitude = [[res stringForColumnIndex:8] doubleValue];
        ident.longitude = [[res stringForColumnIndex:9] doubleValue];
        ident.groupType = [res stringForColumnIndex:10];
        ident.thumbnail_timestamp = [res stringForColumnIndex:11] ;
        ident.introduction = [res stringForColumnIndex:12];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13] isEqualToString:@"1"];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:14] isEqualToString:@"1"];
        
        
		ident.isInvisibile = [[res stringForColumnIndex:15] isEqualToString:@"1"];
        ident.shortid = [res stringForColumnIndex:16];
        
        [arrgroups addObject:ident];
	}
    
    return [arrgroups autorelease];
    
}

+(UserGroup*)getFixedGroupByID:(NSString*)groupid
{
  //  NSLog(@"to get the fixed group by groupid");
   	if (groupid==nil) {
		return nil;
	}
	FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`group_id`, `group_name_original`,`group_name_local`,`group_status`,`max_number`,`member_count`,`temp_group_flag`,`createdplace`,`latitude`,`lonitude`,`grouptype`, `avatartimestamp`,`introduction`,`needtodownloadthumbnail`,`needtodownloadphoto`,`isinvisible`,`shortid`"
                        @"FROM `group_chatroom`"
                        @"WHERE group_id=? AND `temp_group_flag` = 0",groupid];
    
	if (res && [res next]) {
		UserGroup *ident = [[[UserGroup alloc] init] autorelease];
		ident.groupID = [res stringForColumnIndex:0];
        ident.groupNameOriginal = [res stringForColumnIndex:1];
        ident.groupNameLocal = [res stringForColumnIndex:2];
		ident.groupStatus = [res stringForColumnIndex:3];
		ident.maxNumber = [[res stringForColumnIndex:4] intValue] ;
		ident.memberCount = [[res stringForColumnIndex:5] intValue];
		ident.isTemporaryGroup = [[res stringForColumnIndex:6] isEqualToString:@"1"];
        ident.createdPlace = [res stringForColumnIndex:7];
        ident.latitude = [[res stringForColumnIndex:8] doubleValue];
        ident.longitude = [[res stringForColumnIndex:9] doubleValue];
        ident.groupType = [res stringForColumnIndex:10];
        ident.thumbnail_timestamp = [res stringForColumnIndex:11];
        ident.introduction = [res stringForColumnIndex:12];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13] isEqualToString:@"1"];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:14] isEqualToString:@"1"];
        
        
		ident.isInvisibile = [[res stringForColumnIndex:15] isEqualToString:@"1"];
        ident.shortid = [res stringForColumnIndex:16] ;
		
        
		[res close];
		return ident;
	}
    
    return nil;
    
}

#pragma mark -- biz group

+(void)deleteFavoritedGroups
{
    [db executeUpdate:@"DELETE FROM `favoritegroup` WHERE 1 = 1"];
   //  NSLog(@"%@",[db lastErrorMessage]);
}


+(void)favoriteDepartment:(NSString*)departmentid
{
    NSInteger order = [[Database favoritedDepartments] count] + 1;

    [db executeUpdate:@"INSERT INTO `favoritegroup` (`groupid`, `order`) VALUES (?,?)",departmentid, [NSString stringWithFormat:@"%ld",(long)order]];

}

+(void)deFavoriteDepartment:(NSString*)departmentid
{
     FMResultSet* res = [db executeQuery:@"SELECT `order` FROM `favoritegroup` WHERE groupid =? ", departmentid];
    int order = -1;
    if (res && [res next]) {
        order = [[res stringForColumn:@"order"] intValue];
    }
    else
        return;
    
    if (order == -1 ) {
        return;
    }

    [db executeUpdate:@"DELETE FROM `favoritegroup` WHERE `groupid`=?", departmentid];
    
    // decrease the order larger than passed order
    res = [db executeQuery:@"SELECT `order`, `groupid` FROM `favoritegroup` WHERE order >?", [NSString stringWithFormat:@"%d",order]];
    while(res && [res next]) {
        NSString* departmentid = [res stringForColumn:@"groupid"];
        int order = [[res stringForColumn:@"order"] intValue] - 1;
        [self updateFavoriteDepartment:departmentid withOrder:order];
    }
    
    [res close];
}

+(void)updateFavoriteDepartment:(NSString*)departmentid withOrder:(int)order
{
    [db executeUpdate:@"UPDATE `favoritegroup` SET `order`=? WHERE `groupid`=? ",[NSString stringWithFormat:@"%d", order], departmentid];
}


+(BOOL)isDepartmentFavorited:(NSString*)departmentid
{
    
    FMResultSet *res = [db executeQuery: @"SELECT `groupid` FROM `favoritegroup` WHERE groupid=?", departmentid ];
    if (res && [res next]) {
        return TRUE;
    }
    
    [res close];
    
    return FALSE;
}

+(NSMutableArray*)favoritedDepartments
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [db executeQuery: @"SELECT * FROM `favoritegroup` WHERE 1 = 1 ORDER BY `order`" ];
    while (res && [res next]) {
        
        NSString* str = [res stringForColumn:@"groupid"];
        if (![NSString isEmptyString:str]) {
            [arr addObject:str]; 
        }
    }
    
    [res close];
    
    return [arr autorelease];
}


+(void)deleteAllDepartments
{
    FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_chatroom` WHERE `temp_group_flag` = 0 " ];
    
    while (res && [res next]) {
        NSString* groupid = [res stringForColumnIndex:0];
        [Database deleteDepartmentByID:groupid];
    }
    
    [res close];
}

+(void)deleteDepartmentByID:(NSString*)departmentID
{
    // NSLog(@"deleted groupid: %@", groupID);
    
    [db executeUpdate:@"DELETE FROM `group_chatroom` WHERE `group_id`=?",departmentID];
    
   //[Database deleteGroupMembers:groupID];
}

+(void)storeDepartment:(Department*)department
{
    if (department == nil) {
        return;
    }
    
    if(PRINT_LOG)NSLog(@"store department:%@,%@",department.groupID, department.groupNameOriginal);
	
	// We're already inside a transaction if we were called from within
	// storebuddys. If that isn't the case, make sure we start a new
	// transaction.
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction)
        [db beginTransaction];
	
	FMResultSet *res = [db executeQuery:@"SELECT `group_id` FROM `group_chatroom` WHERE `group_id`=?",department.groupID];
	
    if (res && [res next]) {
        
        if(PRINT_LOG)NSLog(@"department exist ,do update");
        
		[db executeUpdate:@"UPDATE `group_chatroom` SET `group_name_original`=?, `group_name_local`=?,`group_status`=?,`max_number`=?,`member_count`=?,`temp_group_flag`=?, `createdplace`=?,`latitude`=?,`lonitude`=?,`grouptype`=?, `avatartimestamp`=?,`introduction`=?,`needtodownloadthumbnail`=?,`needtodownloadphoto`=?,`isinvisible` = ?,`shortid` = ?,`parent_id` = ?,`editable` = ?,`level` = ?,`is_group_name_changed` = ?, `group_weight` = ?  WHERE `group_id`=? ",
         department.groupNameOriginal,
         department.groupNameLocal,
         department.groupStatus,
         [NSString stringWithFormat:@"%zi", department.maxNumber],
         [NSString stringWithFormat:@"%zi", department.memberCount],
         department.isTemporaryGroup?@"1":@"0",
         department.createdPlace,
         [NSString stringWithFormat:@"%f", department.latitude],
         [NSString stringWithFormat:@"%f", department.longitude],
         department.groupType,
         department.thumbnail_timestamp,
         department.introduction,
         department.needToDownloadThumbnail?@"1":@"0",
         department.needToDownloadPhoto?@"1":@"0",
         department.isInvisibile?@"1":@"0",    // TODO: check here.
         department.shortid,
         department.parent_id,
         department.isHeadNode?@"1":@"0",
         [NSString stringWithFormat:@"%d", department.level],
         department.isGroupnameChanged? @"1":@"0",
         [NSString stringWithFormat:@"%f", department.weight],
         department.groupID
         ];
        
	}
	else {
        if(PRINT_LOG)NSLog(@"groupID doesnt exist ,do insert");
		[db executeUpdate:@"INSERT INTO `group_chatroom` (`group_id`, `group_name_original`,`group_name_local`,`group_status`,`max_number`,`member_count`,`temp_group_flag`,`createdplace`,`latitude`,`lonitude`,`grouptype`, `avatartimestamp`,`introduction`,`needtodownloadthumbnail`,`needtodownloadphoto`,`isinvisible`,`shortid`,`parent_id` ,`editable`,`level`,`is_group_name_changed`,`group_weight`) VALUES (?, ?, ?, ?, ?, ?, ?,?,?,?,?,?, ?, ?, ?, ?, ?,?,?,?,?,?)",
         department.groupID,
         department.groupNameOriginal,
         department.groupNameLocal,
         department.groupStatus,
         [NSString stringWithFormat:@"%zi", department.maxNumber],
         [NSString stringWithFormat:@"%zi", department.memberCount],
         department.isTemporaryGroup?@"1":@"0",
         department.createdPlace,
         [NSString stringWithFormat:@"%f", department.latitude],
         [NSString stringWithFormat:@"%f", department.longitude],
         department.groupType,
         department.thumbnail_timestamp,
         department.introduction,
         department.needToDownloadThumbnail?@"1":@"0",
         department.needToDownloadPhoto?@"1":@"0",
         department.isInvisibile?@"1":@"0",
         department.shortid,
         department.parent_id,
         department.isHeadNode? @"1":@"0",
         [NSString stringWithFormat:@"%d",department.level],
         department.isGroupnameChanged?@"1":@"0",
         [NSString stringWithFormat:@"%f",department.weight]];
	}
    
    [res close];
    
    if (newTransaction)
        [db commit];
    
}

+(Department*)getDepartement:(NSString*)departmentid
{
    FMResultSet *res = [db executeQuery:
                        @"SELECT `group_id`, `group_name_original`,`group_name_local`,`group_status`,`max_number`,`member_count`,`temp_group_flag`,`createdplace`,`latitude`,`lonitude`,`grouptype`, `avatartimestamp`,`introduction`,`needtodownloadthumbnail`,`needtodownloadphoto`,`isinvisible`,`shortid`,`parent_id`,`editable`,`level`,`is_group_name_changed`,`group_weight` FROM `group_chatroom` WHERE `temp_group_flag` = ? AND `group_id` =? ", @"0", departmentid];
    
    if (res && [res next]) {
        
		Department *ident = [[Department alloc] init];
        
		ident.groupID = [res stringForColumnIndex:0];
        ident.groupNameOriginal = [res stringForColumnIndex:1];
        ident.groupNameLocal = [res stringForColumnIndex:2];
		ident.groupStatus = [res stringForColumnIndex:3];
		ident.maxNumber = [[res stringForColumnIndex:4] intValue] ;
		ident.memberCount = [[res stringForColumnIndex:5] intValue];
		ident.isTemporaryGroup = FALSE;
        ident.createdPlace = [res stringForColumnIndex:7];
        ident.latitude = [[res stringForColumnIndex:8] doubleValue];
        ident.longitude = [[res stringForColumnIndex:9] doubleValue];
        ident.groupType = [res stringForColumnIndex:10];
        ident.thumbnail_timestamp = [res stringForColumnIndex:11] ;
        ident.introduction = [res stringForColumnIndex:12];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13] isEqualToString:@"1"];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:14] isEqualToString:@"1"];
        
        
		ident.isInvisibile = [[res stringForColumnIndex:15] isEqualToString:@"1"];
        ident.shortid = [res stringForColumnIndex:16];
        
        ident.parent_id = [res stringForColumnIndex:17];
        ident.isHeadNode = [[res stringForColumnIndex:18] isEqualToString:@"1"]? TRUE:FALSE;
        ident.level = [res intForColumnIndex:19];
        ident.isGroupnameChanged = [[res stringForColumnIndex:20] isEqualToString:@"1"]? TRUE:FALSE;
        ident.weight = [[res stringForColumnIndex:21] doubleValue];
        
        [res close];

        return [ident autorelease];
	}
    
            
    return nil;
}

+(NSMutableArray*)getDepartmentsForBuddy:(NSString*)buddyid
{
    NSMutableArray* arr_departments = [[NSMutableArray alloc] init];
    
    NSMutableArray* arr_departmentid = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [db executeQuery:
                        @"SELECT `group_id` FROM `group_member` WHERE `member_id` = ? ",buddyid];
    
    while(res && [res next]) {
        
        NSString* did = [res stringForColumnIndex:0];
        if (![NSString isEmptyString:did]) {
            [arr_departmentid addObject:did];
        }
    }
    
    for (NSString* str in arr_departmentid) {
        Department* department = [Database getDepartement:str];
        if (department) {
            [arr_departments addObject:department];
        }
    }
    
    [res close];
    
    if ([arr_departments count] > 0) {
        return arr_departments; 
    }
    return nil;
}


+(BOOL)isMember:(NSString*)memberid inDepartment:(NSString*)departmentid
{
    
    FMResultSet *res = [db executeQuery:
                        @"SELECT `group_id` FROM `group_member` WHERE `member_id` = ? AND `group_id` = ?",memberid, departmentid];
    
    if(res && [res next]) {
        return TRUE;
    }
    return FALSE;
}

+(NSMutableArray*)getChildrenDepartmentsForDeparment:(NSString*)departmentid
{
    FMResultSet *res = [db executeQuery:
                        @"SELECT `group_id`, `group_name_original`,`group_name_local`,`group_status`,`max_number`,`member_count`,`temp_group_flag`,`createdplace`,`latitude`,`lonitude`,`grouptype`, `avatartimestamp`,`introduction`,`needtodownloadthumbnail`,`needtodownloadphoto`,`isinvisible`,`shortid`,`parent_id`,`editable`,`level`,`is_group_name_changed`,`group_weight` FROM `group_chatroom` WHERE `temp_group_flag` = ? AND `parent_id` =?  ORDER BY `group_weight` ", @"0", departmentid];
    
    
    //  NSLog(@"%@", [db lastErrorMessage] );
    NSMutableArray* arrgroups = [[NSMutableArray alloc] init];
    
    while (res && [res next]) {
        
		Department *ident = [[[Department alloc] init] autorelease];
        
		ident.groupID = [res stringForColumnIndex:0];
        ident.groupNameOriginal = [res stringForColumnIndex:1];
        ident.groupNameLocal = [res stringForColumnIndex:2];
		ident.groupStatus = [res stringForColumnIndex:3];
		ident.maxNumber = [[res stringForColumnIndex:4] intValue] ;
		ident.memberCount = [[res stringForColumnIndex:5] intValue];
		ident.isTemporaryGroup = FALSE;
        ident.createdPlace = [res stringForColumnIndex:7];
        ident.latitude = [[res stringForColumnIndex:8] doubleValue];
        ident.longitude = [[res stringForColumnIndex:9] doubleValue];
        ident.groupType = [res stringForColumnIndex:10];
        ident.thumbnail_timestamp = [res stringForColumnIndex:11] ;
        ident.introduction = [res stringForColumnIndex:12];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13] isEqualToString:@"1"];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:14] isEqualToString:@"1"];
        
        
		ident.isInvisibile = [[res stringForColumnIndex:15] isEqualToString:@"1"];
        ident.shortid = [res stringForColumnIndex:16];
        
        ident.parent_id = [res stringForColumnIndex:17];
        ident.isHeadNode = [[res stringForColumnIndex:18] isEqualToString:@"1"]? TRUE:FALSE;
        ident.level = [res intForColumnIndex:19];
        ident.isGroupnameChanged = [[res stringForColumnIndex:20] isEqualToString:@"1"]? TRUE:FALSE;
        ident.weight = [[res stringForColumnIndex:21] doubleValue];
        
        [arrgroups addObject:ident];
	}
    [res close];
    return [arrgroups autorelease];
}

+(NSMutableArray*)getFirstLevelDepartments
{
    FMResultSet *res = [db executeQuery:
                        @"SELECT `group_id`, `group_name_original`,`group_name_local`,`group_status`,`max_number`,`member_count`,`temp_group_flag`,`createdplace`,`latitude`,`lonitude`,`grouptype`, `avatartimestamp`,`introduction`,`needtodownloadthumbnail`,`needtodownloadphoto`,`isinvisible`,`shortid`,`parent_id`,`editable`,`level`,`is_group_name_changed`,`group_weight` FROM `group_chatroom` WHERE `temp_group_flag` = ? AND `parent_id` is NULL AND `editable` =?  ORDER BY `group_weight` ", @"0", @"0" ];
    
    
  //   NSLog(@"%@", [db lastErrorMessage] );
    NSMutableArray* arrgroups = [[NSMutableArray alloc] init];
    
    while (res && [res next]) {
        
		Department *ident = [[[Department alloc] init] autorelease];
        
		ident.groupID = [res stringForColumnIndex:0];
        ident.groupNameOriginal = [res stringForColumnIndex:1];
        ident.groupNameLocal = [res stringForColumnIndex:2];
		ident.groupStatus = [res stringForColumnIndex:3];
		ident.maxNumber = [[res stringForColumnIndex:4] intValue] ;
		ident.memberCount = [[res stringForColumnIndex:5] intValue];
		ident.isTemporaryGroup = FALSE;
        ident.createdPlace = [res stringForColumnIndex:7];
        ident.latitude = [[res stringForColumnIndex:8] doubleValue];
        ident.longitude = [[res stringForColumnIndex:9] doubleValue];
        ident.groupType = [res stringForColumnIndex:10];
        ident.thumbnail_timestamp = [res stringForColumnIndex:11] ;
        ident.introduction = [res stringForColumnIndex:12];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13] isEqualToString:@"1"];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:14] isEqualToString:@"1"];
        
        
		ident.isInvisibile = [[res stringForColumnIndex:15] isEqualToString:@"1"];
        ident.shortid = [res stringForColumnIndex:16];
        
        ident.parent_id = [res stringForColumnIndex:17];
        ident.isHeadNode = [[res stringForColumnIndex:18] isEqualToString:@"1"]? TRUE:FALSE;
        ident.level = [res intForColumnIndex:19];
        ident.isGroupnameChanged = [[res stringForColumnIndex:20] isEqualToString:@"1"]? TRUE:FALSE;
        ident.weight = [[res stringForColumnIndex:21] doubleValue];
        
        [arrgroups addObject:ident];
	}
    
    [res close];
    
    return [arrgroups autorelease];
}


+(NSMutableArray*) getAllMembersButMeInDepartment:(NSString*)departmentid
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`group_member`.`member_id`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,`department`,`position`,`district`,`employeeid`,`landline`,`email`,`phonetic_name`,`phonetic_first_name`,`phonetic_middle_name`,`phonetic_last_name`,`mobile`, `wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`"
                        @"FROM `group_member`"
                        @"LEFT JOIN `buddys` ON `group_member`.`member_id`= `buddys`.`uid`"
                        @"LEFT JOIN `buddydetail` ON `group_member`.`member_id`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `group_member`.`member_id`= `block_list`.`uid`"
                        @"LEFT JOIN `biz_member_info` ON `group_member`.`member_id`= `biz_member_info`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `group_member`.`member_id`= `buddy_more_detail`.`uid`"
                        @"WHERE `group_id`=?",departmentid];
    
    
    
   //  NSLog(@"%@",[db lastErrorMessage]);
    
	while (res && [res next]) {
        BizMember *ident = [[[BizMember alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        if ([ident.userID isEqualToString:[WTUserDefaults getUid]]) {
            continue;
        }
        
        ident.isBlocked = ([res stringForColumnIndex:1] !=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        ident.buddy_flag = [res stringForColumnIndex:8];
        ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12] isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13] isEqualToString:@"1"];
        
        ident.department = [res stringForColumnIndex:14];
        ident.position = [res stringForColumnIndex:15];
        ident.district = [res stringForColumnIndex:16];
        ident.employeeID = [res stringForColumnIndex:17];
        ident.landline = [res stringForColumnIndex:18];
        ident.email = [res stringForColumnIndex:19];
        ident.phonetic_name = [res stringForColumnIndex:20];
        ident.phonetic_firstname = [res stringForColumnIndex:21];
        ident.phonetic_middle = [res stringForColumnIndex:22];
        ident.phonetic_lastname = [res stringForColumnIndex:23];
        ident.mobile = [res stringForColumnIndex:24];
        
        ident.wowtalkID = [res stringForColumnIndex:25];
        ident.userType =  [[res stringForColumnIndex:26] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:27] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:28] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:29] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:30] intValue];

		[list addObject:ident];
	}
    [res close];

	return [list autorelease];
    

}

+(NSMutableArray*) getAllMembersInDepartment:(NSString*)departmentid
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [db executeQuery:
                        @"SELECT"
                        @"`group_member`.`member_id`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,`department`,`position`,`district`,`employeeid`,`landline`,`email`,`phonetic_name`,`phonetic_first_name`,`phonetic_middle_name`,`phonetic_last_name`,`mobile`, `wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`"
                        @"FROM `group_member`"
                        @"LEFT JOIN `buddys` ON `group_member`.`member_id`= `buddys`.`uid`"
                        @"LEFT JOIN `buddydetail` ON `group_member`.`member_id`= `buddydetail`.`uid`"
                        @"LEFT JOIN `block_list` ON `group_member`.`member_id`= `block_list`.`uid`"
                        @"LEFT JOIN `biz_member_info` ON `group_member`.`member_id`= `biz_member_info`.`uid`"
                        @"LEFT JOIN `buddy_more_detail` ON `group_member`.`member_id`= `buddy_more_detail`.`uid`"
                        @"WHERE `group_id`=?",departmentid];
    
    
    //  NSLog(@"%@",[db lastErrorMessage]);
    
	while (res && [res next]) {
        BizMember *ident = [[[BizMember alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];

        ident.isBlocked = ([res stringForColumnIndex:1] !=NULL);
        ident.phoneNumber = [res stringForColumnIndex:2];
		ident.nickName = [res stringForColumnIndex:3];
		ident.status = [res stringForColumnIndex:4];
		ident.sexFlag = [[res stringForColumnIndex:5] intValue];
		ident.deviceNumber = [res stringForColumnIndex:6];
		ident.appVer = [res stringForColumnIndex:7];
        ident.buddy_flag = [res stringForColumnIndex:8];
        ident.isFriend = [[res stringForColumnIndex:8] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:9] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:10];
		ident.pathOfThumbNail = [res stringForColumnIndex:11];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:12] isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:13] isEqualToString:@"1"];
        
        ident.department = [res stringForColumnIndex:14];
        ident.position = [res stringForColumnIndex:15];
        ident.district = [res stringForColumnIndex:16];
        ident.employeeID = [res stringForColumnIndex:17];
        ident.landline = [res stringForColumnIndex:18];
        ident.email = [res stringForColumnIndex:19];
        ident.phonetic_name = [res stringForColumnIndex:20];
        ident.phonetic_firstname = [res stringForColumnIndex:21];
        ident.phonetic_middle = [res stringForColumnIndex:22];
        ident.phonetic_lastname = [res stringForColumnIndex:23];
        ident.mobile = [res stringForColumnIndex:24];
        
        ident.wowtalkID = [res stringForColumnIndex:25];
        ident.userType =  [[res stringForColumnIndex:26] intValue];
        ident.lastLongitude = [[res stringForColumnIndex:27] floatValue];
        ident.lastLatitude = [[res stringForColumnIndex:28] floatValue];
        ident.lastLoginTimestamp = [[res stringForColumnIndex:29] intValue];
        
        ident.addFriendRule = [[res stringForColumnIndex:30] intValue];
        
		[list addObject:ident];
	}
    [res close];
    
	return [list autorelease];
    
}


#pragma mark -
#pragma mark BlockList
+ (void)storeBlockList:(NSMutableArray*)blockBuddyList{
    if(blockBuddyList==NULL)return;
    
    [db beginTransaction];
    for (Buddy *buddy in blockBuddyList) {
        [Database storeBuddyToBlockList:buddy];
    }
	[db commit];
}

+ (void)storeBuddyToBlockList:(Buddy*)ident{
    [Database blockBuddy:ident.userID];
    [Database storeNewBuddyDetailWithUpdate:ident];
}


// Fetch all buddys
+ (NSMutableArray *) fetchAllBlockedBuddies {
	NSMutableArray *idents = [[NSMutableArray alloc] init];
	FMResultSet *res = [db executeQuery:
                        @"SELECT "
                        @"`block_list`.`uid`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`"
                        @"FROM `block_list`"
                        @"LEFT JOIN `buddys` ON `block_list`.`uid`= `buddys`.`uid`"
                        @"LEFT JOIN `buddydetail` ON `block_list`.`uid`= `buddydetail`.`uid`"];
    
	while ([res next]) {
		Buddy *ident = [[[Buddy alloc] init] autorelease];
		ident.userID = [res stringForColumnIndex:0];
        ident.isBlocked = YES;
        ident.phoneNumber = [res stringForColumnIndex:1]?[res stringForColumnIndex:1]:@"";
		ident.nickName = [res stringForColumnIndex:2];
		ident.status = [res stringForColumnIndex:3];
		ident.sexFlag = [[res stringForColumnIndex:4] intValue];
		ident.deviceNumber = [res stringForColumnIndex:5];
		ident.appVer = [res stringForColumnIndex:6];
        ident.buddy_flag = [res stringForColumnIndex:7];
        ident.isFriend = [[res stringForColumnIndex:7] isEqualToString:@"1"];
        
        ident.photoUploadedTimeStamp = [[res stringForColumnIndex:8] intValue];
		ident.pathOfPhoto = [res stringForColumnIndex:9];
		ident.pathOfThumbNail = [res stringForColumnIndex:10];
        ident.needToDownloadPhoto = [[res stringForColumnIndex:11]isEqualToString:@"1"];
        ident.needToDownloadThumbnail = [[res stringForColumnIndex:12]isEqualToString:@"1"];
        
        
		//if(PRINT_LOG)NSLog(@"fetch ident,%@,%@",ident.userName,ident.status);
		[idents addObject:ident];
	}
	[res close];
	return [idents autorelease];
}

// Fetch all official accounts
+ (NSMutableArray *)fetchOfficialAccount
{
    NSMutableArray *officialAccount = [[NSMutableArray alloc] init];
    FMResultSet *result = [db executeQuery:@"SELECT "
                           @"`buddys`.`uid`, `block_list`.`uid` as `block_flag`,`phone_number`,`nickname`,`last_status`,`sex`,`device_number`,`app_ver`,`buddy_flag`,`photo_upload_timestamp`,`photo_filepath`,`thumbnail_filepath`,`need_to_download_photo`,`need_to_download_thumbnail`,"
                           @"`wowtalk_id`,`user_type`,`last_longitude`,`last_latitude`,`last_login_timestamp`,`allowPeopleToAdd`"
                           
                           @"FROM `buddys`"
                           @"LEFT JOIN `buddydetail` ON `buddys`.`uid`= `buddydetail`.`uid`"
                           @"LEFT JOIN `block_list` ON `buddys`.`uid`= `block_list`.`uid`"
                           @"LEFT JOIN `buddy_more_detail` ON `buddys`.`uid`= `buddy_more_detail`.`uid`"
                           @"WHERE `user_type`= 0"];
    while (result && [result next]) {
        Buddy *buddy = [[[Buddy alloc] init] autorelease];
        buddy.userID = [result stringForColumn:@"uid"];
        buddy.isBlocked = ([result stringForColumnIndex:1] !=NULL);
        buddy.phoneNumber = [result stringForColumn:@"phone_number"];
        buddy.nickName = [result stringForColumn:@"nickname"];
        buddy.status = [result stringForColumn:@"last_status"];
        buddy.userType = [[result stringForColumn:@"user_type"] intValue];
        buddy.sexFlag = [[result stringForColumn:@"sex"] intValue];
        buddy.deviceNumber = [result stringForColumn:@"device_number"];
        buddy.appVer = [result stringForColumn:@"app_ver"];
        buddy.wowtalkID = [result stringForColumn:@"wowtalk_id"];
        buddy.buddy_flag = [result stringForColumn:@"buddy_flag"];
        buddy.photoUploadedTimeStamp = [result stringForColumn:@"photo_upload_timestamp"];
        buddy.pathOfPhoto = [result stringForColumn:@"photo_filepath"];
        buddy.pathOfThumbNail = [result stringForColumn:@"thumbnail_filepath"];
        buddy.needToDownloadPhoto = [[result stringForColumn:@"need_to_download_photo"] isEqualToString:@"1"];
        buddy.needToDownloadThumbnail = [result stringForColumn:@"need_to_download_thumbnail"];
        if ([buddy.buddy_flag isEqualToString:@"2"]) {
            buddy.isFriend = NO;
        } else {
            buddy.isFriend = YES;
        }
        [officialAccount addObject:buddy];
    }
    [result close];
    return [officialAccount autorelease];
}

+ (BOOL)isBuddyBlocked:(NSString*)userID{
    FMResultSet *res = [db executeQuery:@"SELECT `uid` FROM `block_list` WHERE `uid`=?",userID];
    return (res && [res next]) ;
}



+ (void)blockBuddy:(NSString*)userID{
    BOOL newTransaction = ![db inTransaction];
    if (newTransaction)
        [db beginTransaction];
    
    FMResultSet *res = [db executeQuery:@"SELECT `uid` FROM `block_list` WHERE `uid`=?",userID];
    
    
    if (res && [res next]) {
        //do nothing
	}
	else {
        
		[db executeUpdate:@"INSERT INTO `block_list` (`uid`) VALUES (?)",
         userID];
	}
    
    if (newTransaction)
        [db commit];
    
}


+ (void)unblockBuddy:(NSString*)userID{
    [db executeUpdate:@"DELETE FROM `block_list` WHERE `uid`=?",userID];
    
}

+ (void)deleteAllBlockList{
    [db executeUpdate:@"DELETE FROM `block_list` WHERE 1=1"];
    
}

#pragma mark -
#pragma mark device compability

+ (void)deleteAllVideoCallUnsupportedDevices{
    [db executeUpdate:@"DELETE FROM `videocall_unsupported_device_list` WHERE 1=1"];
}

+ (void)storeVideoCallUnsupportedDevices:(NSArray*)deviceNumberList{
    BOOL newTransaction = ![db inTransaction];
    
    if (newTransaction)
        [db beginTransaction];
	
    for (NSString* deviceNumber in deviceNumberList) {
		[db executeUpdate:@"INSERT INTO `videocall_unsupported_device_list` (`device_number`) VALUES (?)",
         deviceNumber];
    }
    
    if (newTransaction)
        [db commit];
    
}

+(BOOL)isDeviceNumberSupportedForVideoCall:(NSString*)deviceNumber{
    if(deviceNumber==NULL){
        return NO;
    }
    
    FMResultSet *res = [db executeQuery:@"SELECT `device_number` FROM `videocall_unsupported_device_list` WHERE `device_number`=?",deviceNumber];
    
    
    if (res && [res next]) {
        return NO;
	}
    
    return YES;
}



#pragma mark -
#pragma mark This is use for WowTalk v1 Compatability only
+ (NSString*) chatMessage_dateToUTCString_oldversion:(NSDate*) localDate{
	
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    [dateFormatter release];
    return dateString;
	
}

+ (NSDate*) chatMessage_UTCStringToDate_oldversion:(NSString*) string{
	
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
	NSDate* date = [dateFormatter dateFromString:string];
    [dateFormatter release];
	return date;
}

+ (NSString*) chatMessage_UTCStringToLocalString_oldversion:(NSString*) utcString{
	
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
	NSDate* date = [dateFormatter dateFromString:utcString];
	
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	NSString *dateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dateString;
    
}

+ (NSString*) callLog_dateToUTCString_oldvesrion:(NSDate*) localDate{
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    [dateFormatter release];
    return dateString;
	
}

+ (NSDate*) callLog_UTCStringToDate_oldvesrion:(NSString*) string{
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	NSDate* date = [dateFormatter dateFromString:string];
    [dateFormatter release];
	return date;
}



#pragma mark - export functions

+ (BOOL)runUpdate:(NSString *)query, ...
{
    va_list args;
    va_start(args, query);
    
    BOOL result = [db executeUpdate:query error:nil withArgumentsInArray:nil orVAList:args];
    
  //  NSLog(@"error: %@",[db lastErrorMessage]);
    
    va_end(args);
    return result;
}

+ (FMResultSet *)runQueryForResult:(NSString *)query, ...
{
    va_list args;
    va_start(args, query);
    
    id result = [db executeQuery:query withArgumentsInArray:nil orVAList:args];
    
    va_end(args);
    return result;
}
@end
