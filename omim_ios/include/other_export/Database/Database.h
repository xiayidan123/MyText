
@class Buddy;
@class ChatMessage;
@class CallLog;
@class GroupChatRoom;
@class FMResultSet;
@class Activity;
@class Moment;
@class Review;
@class WTFile;
@class UserGroup;
@class GroupMember;
@class  CoverImage;
@class Activity;
@class  Department;
@class QueuedMedia;
@class BizMember;
@class OMTimelineViewController;
#import "ActivityModel.h"
#import "SchoolModel.h"
#import "ClassModel.h"
#import "PersonModel.h"
#import "ClassScheduleModel.h"
#import "LessonPerformanceModel.h"
#import "HomeworkModel.h"
#import "FeedBackModel.h"
#import "EventApplyMemberModel.h"

#import "FMDatabase.h"


@interface Database : NSObject

+ (void) initializeDatabase;
+ (void) teardown;
+ (void) dropAllTables:(BOOL)keepUserInfo;

+(FMDatabase *)shareDatabase;

////////////////////////////////////////////////////////////////////////

#pragma mark - Wowtalk Buddy


+(void)favoriteBuddy:(NSString*)buddyid;
+(void)deFavoriteBuddy:(NSString*)buddyid;
+(BOOL)isBuddyFavorited:(NSString*)buddyid;
+(NSMutableArray*)favoritedBuddies;
+(void)deleteFavoritedBuddies;


+(NSMutableArray *)getContactList;

+(NSMutableArray*) getContactListWithoutOfficialAccounts;

+ (void) storeBuddys:(NSArray *)idents;
+ (void) storeNewBuddyWithUpdate:(Buddy *)ident forGroupMember:(BOOL)forGroupMember;
+ (void) storeNewBuddyDetailWithUpdate:(Buddy *)ident;
+ (void) deleteBuddy:(Buddy *)ident;
+ (void) deleteBuddyByID:(NSString*)uID;

+ (NSString *)getWowtalkidForUser:(NSString *)uid;

+ (void) deleteAllBuddys;

+ (Buddy *) buddyWithUserID:(NSString*)uID;
+ (Buddy *) buddyWithPhoneNumber:(NSString*)phoneNumber;
+ (NSMutableArray *) fetchAllBuddys;
+ (NSMutableArray *) fetchAllBuddysAndGroup:(BOOL)isDistinctByUserName;

+ (NSMutableArray *) fetchAllMatchedBuddies;
+ (void) deleteAllMatchedBuddies;

+ (NSMutableArray *) fetchAllPossibleBuddies;
+ (void) deleteAllPossibleBuddies;



+ (void) setBuddyThumbnailFilePath:(NSString*)filepath forUID:(NSString*)uID ;
+ (void) setBuddyPhotoFilePath:(NSString*)filepath forUID:(NSString*)uID;

+(void)deleteBuddys:(NSArray*)buddys;

// 是否是好友 by yangbin
+ (BOOL)isFriendWithUID:(NSString *)uid;

//Nearby buddys

+(void)storeNearbyBuddy:(Buddy*)buddy;
+(void)storeNearbyBuddys:(NSArray*)buddys;
+(NSMutableArray*)getNearbyBuddyWithOffset:(int) offset;
+(void)deleteAllNearbyBuddys;


// Biz members
+(void)storeBizMembers:(NSArray*)members toDepartment:(NSString*)departmentid;      // add the relationship
+(void)storeBizMember:(BizMember*)member toDepartment:(NSString*)departmentid;
+(void)deleteBizMembersFromDepartment:(NSString *)departmentid;
+(BizMember*)bizMemberWithUserID:(NSString*)uID;


////////////////////////////////////////////////////////////////////////
#pragma mark - Chat Messages
+ (BOOL) isChatMessageInDB:(ChatMessage *)msg;
+ (NSInteger) storeNewChatMessage:(ChatMessage *)msg;
   // for messages vc
+ (NSMutableArray *) fetchAllChatMessages:(BOOL)isDistinctByUserName;
+ (NSMutableArray *) searchChatMessagesByContent:(NSString*)searchMsgText;


   // for message composer
+ (NSMutableArray *) fetchChatMessagesWithUser:(NSString*)userName withLimit:(NSInteger)limit fromOffset:(NSInteger)offset;
+ (NSMutableArray *) fetchChatMessagesWithUser:(NSString*)userName;
+ (NSInteger) countChatMessagesWithUser:(NSString*)userName;

+ (NSMutableArray *) fetchUnreadChatMessagesWithUser:(NSString*)userName;

+ (NSInteger) countUnreadChatMessagesWithUser:(NSString*)userName;


//io
+ (void) setChatMessageAllReaded:(NSString*)userName;
+ (void) setChatMessageReaded:(ChatMessage *)msg;

//sent status
+ (void) setChatMessage:(ChatMessage *)msg withNewSentStatus:(NSString*)newSentStatus;
+ (void) setChatMessageInProcess:(ChatMessage *)msg;
+ (void) setChatMessageCannotSent:(ChatMessage *)msg;
+ (void) setChatMessageSent:(ChatMessage *)msg;
+ (void) setChatMessageReachedContact:(ChatMessage *)msg;
+ (void) setChatMessageReadedByContact:(ChatMessage *)msg;

/**
 * Update ChatMessage after file(multimedia) transfered with server
 * @param msg
 * @return
 */
+(void) updateChatMessage:(ChatMessage*) msg;

+ (void) deleteChatMessage:(ChatMessage *)msg;
+(void)deleteChatMessageByID:(int)primarykey;

// return the number of unreaded messages which is going to be deleted 
+ (NSInteger) deleteChatMessageWithUser:(NSString*)userName;
+ (void) deleteAllChatMessages;
+ (void) deleteChatMessagesWithBuddyID:(NSString *)buddy_id;

+ (NSString*) chatMessage_dateToUTCString:(NSDate*) localDate;
+ (NSDate*) chatMessage_UTCStringToDate:(NSString*) string;
+ (NSString*) chatMessage_UTCStringToLocalString:(NSString*) utcString;


////////////////////////////////////////////////////////////////////////
#pragma mark - Chat Message Unsent Receipt (for reached or readed notice)
+ (NSInteger) storeUnsentReceipt:(ChatMessage *)msg;
+ (void) deleteUnsentReceipt:(ChatMessage *)msg;
+ (NSMutableArray *) fetchAllUnsentReceipt;


////////////////////////////////////////////////////////////////////////
#pragma mark - Call Logs
+ (NSString*) callLog_dateToUTCString:(NSDate*) localDate;
+ (NSDate*) callLog_UTCStringToDate:(NSString*) string;

+ (void) storeNewCallLog:(CallLog *)log;
+ (void) deleteAllCallLogs;
+ (NSArray *) fetchAllCallLogs;
+ (void) deleteCallLog:(CallLog *)log;

///////////////////////////////////////////////////////
#pragma mark - GroupChat
+ (void)storeGroupChatRoom:(GroupChatRoom*)groupChatRoom;
+ (void)deleteGroupChatRoom:(GroupChatRoom*)groupChatRoom;
+ (void)deleteGroupChatRoomWithID:(NSString*)groupID;

+ (void)addNewBuddy:(Buddy*)buddy toGroupChatRoomByID:(NSString*)groupID;
+ (void)addBuddys:(NSArray *)buddys toGroupChatRoomByID:(NSString*)groupID;

+(void)storeMembers:(NSArray*)buddys ToChatRoom:(NSString*)groupid;
+(void)storeMember:(Buddy*)buddy ToChatRoom:(NSString*)groupid;

+ (NSMutableArray *) getAllGroupChatRooms;

+(NSMutableArray*) getAllTemporaryGroupChatrooms;
+ (NSMutableArray *)fetchAllBuddysInGroupChatRoom:(NSString*)groupID;


+ (void)deleteAllBuddysInGroupChatRoomByID:(NSString*) groupID;

+ (void)updateGroupChatRoom:(GroupChatRoom*)groupChatRoom;
+ (void)changeGroupChatRoomLocalName:(NSString*)newName forGroupID:(NSString*) groupID;
+ (void)changeGroupChatRoomMemberCount:(int)newCount forGroupID:(NSString*) groupID;

+ (GroupChatRoom *)getGroupChatRoomByGroupid:(NSString *)groupid;



///////////////////////////////////////////////////////
#pragma mark - fixed group
+(void)storeFixedGroup:(UserGroup*)userGroup;
+(void)deleteFixedGroup:(UserGroup*)userGroup;
+(void)deleteFixedGroupByID:(NSString*)groupID;
+(void)deleteGroupMembers:(NSString*)groupID;
+(void)deleteAllFixedGroup;

+(void)addMembers:(NSArray*)members ToUserGroup:(NSString*)groupid;
+(void)addMember:(GroupMember*)member ToUserGroup:(NSString*)groupid;

+(void)storeMembers:(NSArray*)members ToUserGroup:(NSString*)groupid;
+(void)storeMember:(GroupMember*)member ToUserGroup:(NSString*)groupid;

+(void)updateFixedGroup:(UserGroup*)userGroup;
+(NSMutableArray*)getAllFixedGroup;
+(UserGroup*)getFixedGroupByID:(NSString*)groupid;

+(void)setGroupInvisible:(GroupChatRoom*)group;
+(void)setGroupVisible:(GroupChatRoom*)group;
+(void)setGroupInvisibleByID:(NSString*)groupid;
+(void)setGroupVisibleByID:(NSString*)groupid;

+(void)updateLevel:(NSString*)level forMember:(NSString*)memberid forGroup:(NSString*)groupid;

+(void)deleteMember:(NSString*)memberid InGroup:(NSString*)groupid;
+(void)deleteMembers:(NSArray*)memberlist InGroup:(NSString*)groupid;


+(NSMutableArray*) getAllMembersInFixedGroup:(NSString*)groupid;
+(NSMutableArray*) getAllMembersButMeInFixedGroup:(NSString*)groupid;

#pragma mark -- biz group
+(void)deleteFavoritedGroups;
+(void)favoriteDepartment:(NSString*)departmentid;
+(void)deFavoriteDepartment:(NSString*)departmentid;
+(void)updateFavoriteDepartment:(NSString*)departmentid withOrder:(int)order;

+(BOOL)isDepartmentFavorited:(NSString*)departmentid;
+(NSMutableArray*)favoritedDepartments;

+(void)deleteAllDepartments;
+(void)deleteDepartmentByID:(NSString*)departmentID;

+(void)storeDepartment:(Department*)department;
+(Department*)getDepartement:(NSString*)departmentid;
+(NSMutableArray*)getChildrenDepartmentsForDeparment:(NSString*)departmentid;
+(NSMutableArray*)getFirstLevelDepartments;

+(NSMutableArray*) getAllMembersInDepartment:(NSString*)departmentid;
+(NSMutableArray*) getAllMembersButMeInDepartment:(NSString*)departmentid;

+(NSMutableArray*)getDepartmentsForBuddy:(NSString*)buddyid;

+(BOOL)isMember:(NSString*)memberid inDepartment:(NSString*)departmentid;

///////////////////////////////////////////////////////
#pragma mark - BlockList
+ (void)storeBlockList:(NSMutableArray*)blockBuddyList;
+ (void)storeBuddyToBlockList:(Buddy*)ident;
+ (void)deleteAllBlockList;
+ (void)blockBuddy:(NSString*)userName;
+ (void)unblockBuddy:(NSString*)userName;
+ (BOOL)isBuddyBlocked:(NSString*)userID;
+ (NSMutableArray *) fetchAllBlockedBuddies;
+ (NSMutableArray *)fetchOfficialAccount;


#pragma mark - Exsiting numbers.
+(void)storeContactNumbers:(NSArray*)numberList;
+(void)storeContactNumber:(NSString*)number;
+(void)deleteContactNumbers:(NSArray*)numberList;
+(void)deleteContactNumber:(NSString*)number;
+(void)deleteAllContactNumbers;
+(NSMutableArray*)fetchAllSavedContactNumbers;

#pragma mark - Activities
+ (NSMutableArray *) fetchALLEventsDetail;
+ (NSMutableArray *) fetchEventsDetailWithOffset:(int)offset WithLimit:(int)limit;
+ (BOOL)storeEventWithModel:(ActivityModel *)activityModel;

+ (NSMutableArray *) fetchEventsWithOffset:(int)offset WithLimit:(int)limit;

+ (void)storeEvents:(NSMutableArray*)events;
+ (BOOL)updateEvent:(Activity *)activity;
+ (BOOL)storeEvent:(Activity*)event;

+ (NSMutableArray *)fetchMyEvents;
+ (BOOL)deleteAllEvents;
+ (BOOL)updateEvent:(Activity *)activity withJoined:(BOOL)joined andMemberInfo:(NSString *)memberInfo;
+ (WTFile *)getThumbnailForEvent:(Activity *)aActivity;


// below is not used now.

+ (ActivityModel *) fetchEventsWithEventID:(NSString *)event_id;
+ (NSMutableArray *) fetchAllEventsByApplyState:(ApplyStateOfEvent)applyState ByEventState:(EventState)eventState withOffset:(NSInteger)offset WithLimit:(int)limit;
+ (NSMutableArray *)fetchAllEvents;

+ (NSMutableArray *)fetchOfficialEvents;
+ (NSMutableArray *)fetchJoinedEvents;
+ (NSMutableArray *)fetchJoinableEvents;

+ (NSMutableArray *)fetchAppliedEvents;
+ (NSMutableArray *)fetchInvitedEvents;
+ (NSMutableArray *)_fetchEvents:(NSString*)selectionArgs;  //internal use


+ (BOOL)updateEvent:(NSString*)eventID withDBidInServer:(NSString*)dbid;

+ (BOOL) storeEventReview:(Review*) review  forEventID:(NSString*)event_id;

+ (Activity *)getEventDetailWithID:(NSString *)event_id;

+ (BOOL)storeEventApplyMembersWithModel:(EventApplyMemberModel *)eventApplyMemberModel;

+ (BOOL)deleteEventApplyMembersWithEventID:(NSString *)event_id;

/** 删除本地数据库中所有活动 */
+ (BOOL)deleteAllEventDetail;

+ (NSMutableArray *)fetchMembersWithEventID:(NSString *)event_id;



#pragma mark - Moment

+(BOOL)storeMomentPrivacy:(Moment*)moment;

+(BOOL)storeMomentOptions:(Moment*)moment;

+ (BOOL)storeMoment:(Moment*)moment;

+(Moment*)getMomentWithID:(NSString*)moment_id;

+ (BOOL)updateMoment:(NSString*)momentID withDBidInServer:(NSString*)dbid;

/**
 * Fetch the Moments of a Buddy, ordered by timestamp desc.
 *
 * @param limit Limits the number of rows returned by the query,
 * @param offset the offset of row from where to start the query,
 */
+ (NSMutableArray*) fetchMomentsForBuddy:(NSString*)uID withLimit:(int)limit andOffset:(int)offset;
+ (NSMutableArray*) fetchMomentsForBuddy:(NSString*)uID  withLimit:(int)limit andOffset:(int)offset withtags:(NSArray*)tags withOwnerType:(NSInteger)momentOwnerType;
/**
 * Fetch the Moments of all buddies, ordered by timestamp desc.
 *
 * @param limit Limits the number of rows returned by the query,
 * @param offset the offset of row from where to start the query,
 */
+ (NSMutableArray*) fetchMomentsForAllBuddiesWithLimit:(int)limit andOffset:(int)offset;
+ (NSMutableArray*) fetchMomentsForAllBuddiesWithLimit:(int)limit andOffset:(int)offset withtags:(NSArray*)tags withOwnerType:(NSInteger )momentOwnerType;


+(NSMutableArray*)fetchMomentsForAllBuddiesInGroup:(NSString*)groupid WithLimit:(int)limit andOffset:(int)offset;

// method to fecth moments in a category for a given group.
+(NSMutableArray*)fetchStatusMomentsInGroup:(NSString*)groupid withLimit:(int)limit andOffset:(int)offset;
+(NSMutableArray*)fetchQAMomentsInGroup:(NSString*)groupid withLimit:(int)limit andOffset:(int)offset;
+(NSMutableArray*)fetchSurveyMomentsInGroup:(NSString*)groupid withLimit:(int)limit andOffset:(int)offset;
+(NSMutableArray*)fetchReportMomentsInGroup:(NSString*)groupid withLimit:(int)limit andOffset:(int)offset;




+ (BOOL) deleteMomentWithMomentID:(NSString*) moment_id;

+ (NSMutableArray*) fetchMomentReviewListWithLimit:(int)limit andOffset:(int)offset;
+ (NSMutableArray*) getUnreadReviews;

+ (BOOL) storeMomentReview:(Review*) review  forMomentID:(NSString*)moment_id;

+ (BOOL) deleteMomentReview:(Review*) review;

+ (BOOL) deleteReview:(NSString*)reviewid ForMomemt:(NSString*)momentid;
+ (Review*) getMyLikedReviewForMoment:(NSString*)moment_id;


+(BOOL)storeQueuedMediaFile:(NSString*)fileid withExt:(NSString*)ext forMoment:(NSString*)momentid isThumbnail:(BOOL)isthumbnail;

+(BOOL)deleteQueuedMediaFile:(NSString*)fileid forMoment:(NSString*)momentid;

+(NSMutableArray*)queuedMedias;

+(BOOL)isInTheQueue:(NSString*)momentid;


+(CoverImage*) getCoverImageByUid:(NSString*)uid;
+(BOOL) storeCoverImage:(CoverImage*)coverimage;


+(void)setReviewInvisible:(NSString*)reviewid;
+(void)setReviewRead:(NSString*)reviewid;
+(void)setReviewReadByArray:(NSArray*)reviewarray;
+(void)setReviewReadByIDArray:(NSArray*)reviewidarray;


#pragma mark -
#pragma mark - school relevance
+ (BOOL)storeSchoolWithModel:(SchoolModel *)school;
+ (void)deleteMySchool;
+ (NSMutableArray *)fetchAllSchool;

+ (BOOL)storeClassWithModel:(ClassModel *)classModel;
+ (BOOL)isClassWithGroupID:(NSString *)group_id;
+ (void)deleteMyClass;
+ (NSMutableArray *)fetchClassWithSchoolID:(NSString *)school_id;

+ (BOOL)storeSchoolMember:(PersonModel *)personModel;
+ (void)deleteMySchoolMembers;
+ (BOOL)storeSchoolMemberSex:(PersonModel *)personModel;
+ (NSMutableArray *)fetchMembersWithClassID:(NSString *)class_id;
+ (NSMutableArray *)fetchStudentsWithClassID:(NSString *)class_id;
+ (PersonModel *)fetchStudentInClassWithStudentID:(NSString *)student_id withClassID:(NSString *)class_id;
+ (BOOL)hasUpdataHeadWithSchoolMemberID:(PersonModel *)personModel;
+ (BOOL)schoolMemberAlreadyAddBuddy:(NSString *)uid;
+ (BOOL)isSchollMember:(NSString *)uid;

#pragma mark -
#pragma mark - ClassSchedule
+ (BOOL)deleteClassScheduleWithLessonID:(NSString *)lesson_id;
+ (BOOL)storeclassScheduleModel:(ClassScheduleModel *)classScheduleModel;
+ (NSMutableArray *)fetchClassScheduleWithClassID:(NSString *)class_id;
+ (BOOL)storeLessonPerformance:(LessonPerformanceModel *)lessonPerformanceModel;
+ (NSMutableArray *)fetchLessonPerformanceWithStudentID:(NSString *)student_id WithLessonID:(NSString *)lesson_id;
+ (BOOL)storeHomework:(HomeworkModel *)homeworkModel;
+ (NSMutableArray *)fetchHomeworkWithLessonID:(NSString *)lesson_id;
+ (NSString *)getSchoolIDWithClassID:(NSString *)classID;
+ (ClassModel *)getClassWithClassID:(NSString *)classID;
+ (BOOL)storeFeedBackModel:(FeedBackModel *)feedBackModel;
+ (FeedBackModel *)fetchFeedBackWithLessonID:(NSString *)lesson_id withStudentID:(NSString *)student_id ;
+ (Moment *)fetchMomentWithMomentID:(NSString *)moment_id;

#pragma mark -
#pragma mark device compability

+ (void)deleteAllVideoCallUnsupportedDevices;
+ (void)storeVideoCallUnsupportedDevices:(NSArray*)deviceNumberList;
+ (BOOL)isDeviceNumberSupportedForVideoCall:(NSString*)deviceNumber;





#pragma mark -
#pragma mark This is use for WowTalk v1 Compatability only
+ (NSString*) chatMessage_dateToUTCString_oldversion:(NSDate*) localDate;
+ (NSDate*) chatMessage_UTCStringToDate_oldversion:(NSString*) string;
+ (NSString*) chatMessage_UTCStringToLocalString_oldversion:(NSString*) utcString;
+ (NSString*) callLog_dateToUTCString_oldvesrion:(NSDate*) localDate;
+ (NSDate*) callLog_UTCStringToDate_oldvesrion:(NSString*) string;

#pragma mark -
#pragma mark function for other files to call sql querys
+ (BOOL)runUpdate:(NSString *)query, ...;
+ (FMResultSet *)runQueryForResult:(NSString *)query, ...;

@end
