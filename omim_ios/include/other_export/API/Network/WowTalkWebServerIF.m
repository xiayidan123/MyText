//
//  WTNetworkFunction.m
//  omim
//
//  Created by coca on 2013/03/31.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "WowTalkWebServerIF.h"
#import "WowTalkVoipIF.h"
#import "NetworkConnector.h"

#import "Communicator_GetSingleMoment.h"
#import "UIDevice+IdentifierAddition.h"
#import "Communicator_ValidateAccessCode.h"
#import "Communicator_RequireAccessCode.h"
#import "Communicator_RequireAccessCodeAfterIVR.h"
#import "Communicator_GetMyProfile.h"
#import "Communicator_UpdateMyProfile.h"
#import "Communicator_GetMatchedBuddyList.h"
#import "Communicator_GetPossibleBuddyList.h"
#import "Communicator_UploadFile.h"
#import "Communicator_GetFile.h"
#import "Communicator_BlockUser.h"
#import "Communicator_CreateGroupChatRoom.h"
#import "Communicator_GetGroupMembers.h"
#import "Communicator_JoinOrLeaveOrAddGroup.h"
#import "Communicator_GetPrivacySetting.h"
#import "Communicator_GetBlockedBuddyList.h"
#import "Communicator_SendGroupMessage.h"
#import "Communicator_AccountDeactive.h"
#import "Communicator_AddBuddy.h"
#import "Communicator_GetBuddyList.h"
#import "Communicator_GetBuddy.h"
#import "Communicator_UploadFileS3.h"
#import "Communicator_GetFileS3.h"
#import "Communicator_GetVideoCallUnsupportedDeviceList.h"
#import "Communicator_ReportUnreadMessageCount.h"
#import "Communicator_AdjustUTCTimeWithServer.h"
#import "Communicator_ScanPhoneNumberForBuddy.h"
#import "Communicator_GetActiveAppType.h"
#import "Communicator_NoDataFeedback.h"
#import "Communicator_Register.h"
#import "Communicator_Login.h"
#import "Communicator_GetEventInfo.h"
#import "Communicator_GetJoinableEventList.h"
#import "Communicator_GetJoinedEventList.h"
#import "Communicator_Logout.h"
#import "Communicator_ChangeWowtalkID.h"
#import "Communicator_ChangePassword.h"
#import "Communicator_GetUserByID.h"
#import "Communicator_BindEmail.h"
#import "Communicator_BindPhoneNumber.h"
#import "Communicator_VerifyEmail.h"
#import "Communicator_VerifyPhoneNumber.h"
#import "Communicator_SendAccessCode.h"
#import "Communicator_ResetPassword.h"
#import "Communicator_AddMoment.h"
#import "Communicator_UploadMomentMultimedia.h"
#import "Communicator_DeleteMoment.h"
#import "Communicator_ReviewMoment.h"
#import "Communicator_DeleteMomentReview.h"
#import "Communicator_GetMomentForBuddy.h"
#import "Communicator_GetMomentForAll.h"
#import "Communicator_GetReviewForMoment.h"
#import "Communicator_UserBecomeActive.h"
#import "Communicator_SendMsgToOfficialUser.h"
#import "Communicator_GetLatestReviewsForMe.h"
#import "Communicator_SetReviewStatusRead.h"
#import "Communicator_UploadContactBook.h"
#import "Communicator_GetFriendRequests.h"
#import "Communicator_RemoveBuddy.h"
#import "Communicator_RejectFriendRequest.h"
#import "Communicator_Unlink.h"
#import "Communicator_SearchBuddy.h"
#import "Communicator_LoginWithEmail.h"
#import "Communicator_BlidingEmail.h"
#import "Communicator_VerifyCode.h"
#import "Communicator_FindPass.h"
#import "Communicator_UnbindEmail.h"
//events
#import "Communicator_JoinEvent.h"
#import "Communicator_GetAllEvents.h"
#import "Communicator_GetLatestEvents.h"
#import "Communicator_GetPreviousEvents.h"
#import "Communicator_JoinEventWithDetail.h"
#import "Communicator_CancelJoinTheEvent.h"
#import "Communicator_GetEventMedia.h"
#import "Communicator_AddEvent.h"
#import "Communicator_ApplyEvent.h"
#import "Communicator_CancelEvent.h"
#import "Communicator_GetEventInfoNew.h"
#import "Communicator_GetEventmediaAliyun.h"
#import "Communicator_uploadEventMultimedia.h"
#import "Communicator_GetEventMembers.h"

// user group
#import "Communicator_UploadGroupAvatar.h"
#import "Communicator_CreateFixedGroup.h"
#import "Communicator_SetMemberAuthority.h"
#import "Communicator_EditGroupInfo.h"
#import "Communicator_DismissGroup.h"
#import "Communicator_RequestToJoinGroup.h"
#import "Communicator_GetPendingRequests.h"
#import "Communicator_GetGroupByGroupID.h"
#import "Communicator_UpdateGroupAvatarTimestamp.h"
#import "Communicator_RemoveMemberFromGroup.h"
#import "Communicator_RejectCandidateForGroup.h"
#import "Communicator_GetGroupAvater.h"
#import "Communicator_GetUserGroupInfo.h"
#import "Communicator_LeaveUserGroup.h"
#import "Communicator_SearchUserGroup.h"
#import "Communicator_GetAllJoinRequests.h"
#import "Communicator_GetMyGroups.h"
#import "Communicator_GetAllPendingRequests.h"
#import "Communicator_AcceptJoinGroupApplication.h"
#import "Communicator_GetAllGroupsInCompany.h"

//favorite related
#import "Communicator_FavoriteABuddy.h"
#import "Communicator_FavoriteAGroup.h"
#import "Communicator_FavoriteBuddies.h"
#import "Communicator_FavoriteGroups.h"
#import "Communicator_GetAllFavoriteItems.h"
#import "Communicator_DefavoriteBuddy.h"
#import "Communicator_DefavoriteGroup.h"

//biz group
#import "Communicator_GetCompanyStructure.h"
#import "Communicator_GetAllMembersInDepartment.h"

// emergency message
#import "Communicator_SendEmergencyMessage.h"

// schoolmembers
#import "Communicator_GetSchoolMembers.h"
#import "Communicator_GetSchoolList.h"
#import "Communicator_GetClassList.h"

//Moment
#import "Communicator_GetMomentMedia.h"
#import "Communicator_UpdateCover.h"
#import "Communicator_GetCover.h"
#import "Communicator_RemoveCover.h"
#import "Communicator_DownloadCover.h"
#import "Communicator_AddSurveyMoment.h"
#import "Communicator_VoteSurveyMoment.h"
#import "Communicator_GetMomentsForGroup.h"


//searchBuddy ---yangbin
#import "Communicator_SearchBuddywithType.h"

//nearby
#import "Communicator_GetNearbyBuddys.h"
#import "Communicator_GetNearbyGroups.h"

#import "Communicator_GetVersion.h"
#import "Communicator_OptBuddy.h"
//Chat relate
#import "Communicator_GetChatHistory.h"
#import "Communicator_GetHistoryCount.h"

#import "Communicator_GetLatestContactList.h"
#import "Communicator_GetOfflineMessage.h"
#import "MD5Extensions.h"
#import "GlobalSetting.h"

#import "WTHelper.h"

#import "WTUserDefaults.h"
#import "WTNetworkTask.h"
#import "CoverImage.h"

#import "Communicator_SearchOfficialAccount.h"
#import "Communicator_GetFileAliyun.h"
#import "Communicator_UploadFileAliyun.h"
#import "Communicator_GetMomentmediaAliyun.h"
#import "Communicator_LoginWithInvitationCode.h"

// classScheduleList
#import "Communicator_GetClassScheduleList.h"
#import "Communicator_GetLessonPerformance.h"
#import "Communicator_UploadLessonPerformance.h"
#import "Communicator_GetLessonHomework.h"
#import "Communicator_UploadHomework.h"
#import "Communicator_GetLessonParentFeedBack.h"
#import "Communicator_GetMomentByMomentID.h"
#import "Communicator_UploadLessonParentFeedback.h"



#import "LessonPerformanceModel.h"

//#define USE_S3 FALSE
//#define S3_BUCKET @"om-im-product"
//#define S3_EVENT_FILE_DIR @"eventfile/"
#define UP_EVENT_MULTIMEDEA @"upload_event_multimedia"
#define GET_SCHOOL_USER_IN  @"get_school_user_in"
#define GET_CLASSROOM_USER_IN @"get_classroom_user_in"
#define GET_SCHOOL_MEMBERS @"get_school_members"
#define GET_EVENT_MEMBERS @"get_event_members"



#define GET_CLASS_LESSON    @"get_lesson"
#define ADD_CLASS_LESSON    @"add_lesson"
#define DELETE_CLASS_LESSON @"del_lesson"
#define MODIFY_CLASS_LESSON   @"modify_lesson"

#define GET_LESSON_PERFORMANCE @"get_lesson_performance"
#define UPLOAD_LESSON_PERFORMANCE @"add_lesson_performance"
#define GET_LESSON_HOMEWORK @"get_lesson_homework"
#define ADD_LESSON_HOMEWORK @"add_lesson_homework"
#define GET_LESSON_PARENT_FEEDBACK  @"get_lesson_parent_feedback"
#define GET_MOMENT_BY_ID   @"get_moment_by_id"

#define UPLOAD_LESSON_PARENT_FEEDBACK  @"add_lesson_parent_feedback"


#import "MomentVoteCellModel.h"


@implementation WowTalkWebServerIF

#pragma mark - helper
+(NSMutableArray*)basicValueArrayWithAction:(NSString*)actioType
{
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    /*
     //TODO: remove in the future.
     if (strPwd == nil) {
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"password is nil" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [alert show];
     [alert release];
     return nil ;
     
     }
     if (strUID == nil) {
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"uuid is nil" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [alert show];
     [alert release];
     return nil;
     }
     */
    
    NSMutableArray* postValues =[[NSMutableArray alloc] init];
    [postValues addObject:actioType];
    [postValues addObject:strUID];
    [postValues addObject:strPwd];
    return postValues;
}

+(NSMutableArray*)basicKeyArray
{
    NSMutableArray* postKeys =[[NSMutableArray alloc] init] ;
    [postKeys addObject:@"action"];
    [postKeys addObject:@"uid"];
    [postKeys addObject:@"password"];
    return postKeys;
    
}

#pragma mark -
#pragma mark Setup Handler

+(void)requireAccessCodeForUserName:(NSString *)strUserName andCountryCode:(NSString *)strCountryCode andCarrierName:(NSString *)strCarrierName withCallback:(SEL)selector withObserver:(id)observer
{
    if([NSString isEmptyString:strUserName]|| [NSString isEmptyString:strCountryCode]){
        
        if(PRINT_LOG)NSLog(@"fRequireAccessCodeForUserName parametar cannot be null");
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REQUIRE_ACCESS_CODE taskInfo:nil taskType:WT_REQUIRE_ACCESS_CODE notificationName:WT_REQUIRE_ACCESS_CODE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    [WTUserDefaults setCountryCode:strCountryCode];
    [WTUserDefaults setUsername:strUserName];
    
	int applyTimes = [WTUserDefaults getApplyTime];
    
	NSArray *languages = [NSLocale preferredLanguages];
	NSString *currentLanguage = [languages objectAtIndex:0];
	
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_REQUIRE_ACCESS_CODE];
    [postKeys addObject:@"phone_number"]; [postValues addObject:[WTUserDefaults getUsername]];
    [postKeys addObject:@"apply_times"]; [postValues addObject:[NSString stringWithFormat:@"%d",applyTimes]];
    [postKeys addObject:@"lang"]; [postValues addObject:currentLanguage];
    
    if ([strUserName rangeOfString:@"1980121619801216"].location != NSNotFound) {
        [postKeys addObject:@"demoaccount"]; [postValues addObject:@"1"];
        
    }
    
	if (strCarrierName) {
        [postKeys addObject:@"carrier"]; [postValues addObject:strCarrierName];
	}
    
    Communicator_RequireAccessCode* netIFCommunicator = [[Communicator_RequireAccessCode alloc] init];
    netIFCommunicator.delegate = task;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    
}

+(void)requireAccessCodeAfterIVRForUserName:(NSString *)strUserName andCountryCode:(NSString *)strCountryCode withCallback:(SEL)selector withObserver:(id)observer
{
    if([NSString isEmptyString:strUserName]|| [NSString isEmptyString:strCountryCode]){
        if(PRINT_LOG)NSLog(@"fRequireAccessCodeAfterIVRForUserName parametar cannot be null");
        return;
    }
    
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REQUIRE_IVR_ACCESS_CODE taskInfo:nil taskType:WT_REQUIRE_IVR_ACCESS_CODE notificationName:WT_REQUIRE_IVR_ACCESS_CODE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    
    [WTUserDefaults setCountryCode:strCountryCode];
    [WTUserDefaults setUsername:strUserName];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_REQUIRE_IVR_ACCESS_CODE];
    [postKeys addObject:@"phone_number"]; [postValues addObject:[WTUserDefaults getUsername]];
    
    Communicator_RequireAccessCodeAfterIVR* netIFCommunicator = [[Communicator_RequireAccessCodeAfterIVR alloc] init];
    netIFCommunicator.delegate = task;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+(void) validateAccessCode:(NSString*) strAccessCode withCallback:(SEL)selector withObserver:(id)observer
{
    [WowTalkWebServerIF validateAccessCode:strAccessCode withAppType:nil withCallback:selector withObserver:observer];
}

+(void) validateAccessCode:(NSString*) strAccessCode withAppType:(NSString*) strAppType withCallback:(SEL)selector withObserver:(id)observer
{
    if([NSString isEmptyString:strAccessCode]){
        [WTHelper WTLog:@"The access code is empty"];
        return;
    }
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_VALIDATE_ACCESS_CODE taskInfo:nil taskType:WT_VALIDATE_ACCESS_CODE notificationName:WT_VALIDATE_ACCESS_CODE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
	NSString* strCountryCode = [WTUserDefaults getCountryCode];
	NSString* strUserName= [WTUserDefaults getUsername];
	
    Communicator_ValidateAccessCode* netIFCommunicator = [[Communicator_ValidateAccessCode alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_VALIDATE_ACCESS_CODE];
    [postKeys addObject:@"countrycode"]; [postValues addObject:strCountryCode];
    //[postKeys addObject:@"phone_number"]; [postValues addObject:[strUserName md5AndSalt]];//ringit
    [postKeys addObject:@"phone_number"]; [postValues addObject:strUserName];//wowtalk & ringit newserver
    [postKeys addObject:@"access_code"]; [postValues addObject:strAccessCode];
    
    if(strAppType){
        [postKeys addObject:@"app_type"]; [postValues addObject:strAppType];
        
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}

+(void)reportInfoWithPushToken:(NSData *)deviceToken withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [WTHelper WTLog:@"engine is not set up"];
        return;
    }
    
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    NSString *push_token = @"not_implemented";
    
    WTNetworkTask* task ;
    if(deviceToken!=NULL){
        push_token=[NSString stringWithFormat:@"%@",deviceToken];
        push_token = [push_token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        push_token = [push_token stringByReplacingOccurrencesOfString:@">" withString:@""];
        if(PRINT_LOG)NSLog(@"strUID=%@, strToken=%@",strUID,push_token);
        task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REPORT_PUSH_TOKEN_TO_SERVER taskInfo:nil taskType:WT_REPORT_PUSH_TOKEN_TO_SERVER notificationName:WT_REPORT_PUSH_TOKEN_TO_SERVER notificationObserver:observer userInfo:nil selector:selector];
    }
    else{
        task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REPORT_EMPTY_TOKEN_TO_SERVER taskInfo:nil taskType:WT_REPORT_EMPTY_TOKEN_TO_SERVER notificationName:WT_REPORT_EMPTY_TOKEN_TO_SERVER notificationObserver:observer userInfo:nil selector:selector];
    }
    
    if (![task start]) {
        return;
    }
    
    
    NSString* device_number = [NSString stringWithFormat:@"%@%@",[[UIDevice currentDevice] systemName] , [[UIDevice currentDevice] systemVersion]];
    if(device_number==NULL) device_number =@"";
    
    NSString* device_type = @"iphone";
    
    NSArray *languages = [NSLocale preferredLanguages];
	NSString *currentLanguage = [languages objectAtIndex:0];
    
    Communicator_NoDataFeedback* netIFCommunicator = [[Communicator_NoDataFeedback alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"report_info"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    [postKeys addObject:@"device_number"]; [postValues addObject:device_number];
    [postKeys addObject:@"app_ver"]; [postValues addObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]];
    [postKeys addObject:@"language"]; [postValues addObject:currentLanguage];
    [postKeys addObject:@"device_type"]; [postValues addObject:device_type];
    [postKeys addObject:@"push_token"]; [postValues addObject:push_token];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    
    
}


#pragma mark -
#pragma mark Profile Handler



+(void) getLatestVersionInfoWithCallback:(SEL)selector withObserver:(id)observer{
    
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [WTHelper WTLog:@"engine is not set up"];
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_VERSION taskInfo:nil taskType:WT_GET_VERSION notificationName:WT_GET_VERSION notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    if (strUID==nil || strPwd==nil) {
        return;
    }
    Communicator_GetVersion* netIFCommunicator = [[Communicator_GetVersion alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:WT_GET_VERSION];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    
    [postKeys addObject:@"lang"];
    [postValues addObject:[countryCode lowercaseString]];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
}



+(void) reportUnreadMessageCount:(int)unreadCnt withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [WTHelper WTLog:@"engine is not set up"];
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REPORT_UNREAD_MESSAGES taskInfo:nil taskType:WT_REPORT_UNREAD_MESSAGES notificationName:WT_REPORT_UNREAD_MESSAGES notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_ReportUnreadMessageCount* netIFCommunicator = [[Communicator_ReportUnreadMessageCount alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"action"]; [postValues addObject:@"report_unread_count"];
    [postKeys addObject:@"unread_count"]; [postValues addObject:[NSString stringWithFormat:@"%d",unreadCnt]];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}

+(void) getMyProfileWithCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_MY_PROFILE taskInfo:nil taskType:WT_GET_MY_PROFILE notificationName:WT_GET_MY_PROFILE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
	NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_GetMyProfile* netIFCommunicator = [[Communicator_GetMyProfile alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.isBiz = FALSE;
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_my_profile"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}


+(void) getMyBizProfileWithCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_MY_PROFILE taskInfo:nil taskType:WT_GET_MY_PROFILE notificationName:WT_GET_MY_PROFILE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
	NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_GetMyProfile* netIFCommunicator = [[Communicator_GetMyProfile alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.isBiz = TRUE;
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_my_profile"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    
}

+(void) updateMyProfileWithNickName:(NSString*)strNickname
                         withStatus:(NSString*)strStatus
                       withBirthday:(NSString*)strBirthday
                            withSex:(NSString*)sexFlag
                           withArea:(NSString*)strArea
                       withCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPDATE_PROFILE taskInfo:nil taskType:WT_UPDATE_PROFILE notificationName:WT_UPDATE_PROFILE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"update_my_profile"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    
    if (strNickname) {
        [postKeys addObject:@"nickname"]; [postValues addObject:strNickname];
        
    }
    if (strStatus) {
        [postKeys addObject:@"last_status"]; [postValues addObject:strStatus];
        
    }
    if (strBirthday) {
        [postKeys addObject:@"birthday"]; [postValues addObject:strBirthday];
        
    }
    if (sexFlag) {
        
        [postKeys addObject:@"sex"]; [postValues addObject:sexFlag];
        
    }
    if (strArea) {
        [postKeys addObject:@"area"]; [postValues addObject:strArea];
        
    }
    
    Communicator_UpdateMyProfile* netIFCommunicator = [[Communicator_UpdateMyProfile alloc] init];
    netIFCommunicator.delegate = task;
    
    [netIFCommunicator fSetNickName:strNickname withStatus:strStatus withBirthday:strBirthday withSex:sexFlag withArea:strArea];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}


+(void) updateMyProfileWithNickName:(NSString*)strNickname
                         withStatus:(NSString*)strStatus
                       withBirthday:(NSString*)strBirthday
                            withSex:(NSString*)sexFlag
                           withArea:(NSString*)strArea
                  withMobile_number:(NSString*)strMobile
                          withEmail:(NSString*)stremail
                  withPronunciation:(NSString*)strpronunciation
                          withTitle:(NSString*)strtitle
                     withInterphone:(NSString*)strinterphone
                       withCallback:(SEL)selector
                       withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPDATE_PROFILE taskInfo:nil taskType:WT_UPDATE_PROFILE notificationName:WT_UPDATE_PROFILE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"update_my_profile"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    
    if (strNickname) {
        [postKeys addObject:@"nickname"]; [postValues addObject:strNickname];
        
    }
    if (strStatus) {
        [postKeys addObject:@"last_status"]; [postValues addObject:strStatus];
        
    }
    if (strBirthday) {
        [postKeys addObject:@"birthday"]; [postValues addObject:strBirthday];
        
    }
    if (sexFlag) {
        
        [postKeys addObject:@"sex"]; [postValues addObject:sexFlag];
        
    }
    if (strArea) {
        [postKeys addObject:@"area"]; [postValues addObject:strArea];
        
    }
    if (strMobile) {
        [postKeys addObject:@"mobile_number"]; [postValues addObject:strMobile];
    }
    if (stremail) {
        [postKeys addObject:@"email_address"]; [postValues addObject:stremail];
    }
    if (strpronunciation) {
        [postKeys addObject:@"pronunciation"]; [postValues addObject:strpronunciation];
    }
    if (strtitle) {
        [postKeys addObject:@"title"]; [postValues addObject:strtitle];
    }
    if (strinterphone) {
        [postKeys addObject:@"interphone"]; [postValues addObject:strinterphone];
    }
    
    Communicator_UpdateMyProfile* netIFCommunicator = [[Communicator_UpdateMyProfile alloc] init];
    netIFCommunicator.delegate = task;
    
    [netIFCommunicator fSetNickName:strNickname withStatus:strStatus withBirthday:strBirthday withSex:sexFlag withArea:strArea withMobile:strMobile withEmail:stremail withPronunciation:strpronunciation withInterphone:strinterphone];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}


#pragma mark -
#pragma mark Buddy List Handler

+(void) uploadContactBook:(NSArray*) phoneNumberList withCallback:(SEL)selector withObserver:(id)observer{
    
    if (phoneNumberList == nil || [phoneNumberList count] == 0) {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPLOAD_CONTACT_BOOK taskInfo:nil taskType:WT_UPLOAD_CONTACT_BOOK notificationName:WT_UPLOAD_CONTACT_BOOK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_UploadContactBook* netIFCommunicator = [[Communicator_UploadContactBook alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"upload_contact_book"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
	for (NSString* aNumber in phoneNumberList) {
		NSString* phoneNumber = [WTHelper encryptPhoneNumber:aNumber];
        if (phoneNumber==nil) {
            continue;
        }
        [postKeys addObject:@"phone_number[]"]; [postValues addObject:phoneNumber];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}

+(void) increaseContactBook:(NSArray*) phoneNumberList withCallback:(SEL)selector withObserver:(id)observer{
    
    if (phoneNumberList == nil || [phoneNumberList count] == 0) {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_INCREASE_CONTACT_BOOK_IN_SERVER taskInfo:nil taskType:WT_INCREASE_CONTACT_BOOK_IN_SERVER notificationName:WT_INCREASE_CONTACT_BOOK_IN_SERVER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_ScanPhoneNumberForBuddy* netIFCommunicator = [[Communicator_ScanPhoneNumberForBuddy alloc] init];
    netIFCommunicator.delegate = task;
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"increase_contact_book"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
	for (NSString* aNumber in phoneNumberList) {
		NSString* phoneNumber = [WTHelper encryptPhoneNumber:aNumber];
        if (phoneNumber==nil) {
            continue;
        }
        [postKeys addObject:@"phone_number[]"]; [postValues addObject:phoneNumber];
        
    }
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
    
    
}


+(void) decreaseContactBook:(NSArray*) phoneNumberList withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (phoneNumberList == nil || [phoneNumberList count] == 0) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_DECREASE_CONTACT_BOOK_IN_SERVER taskInfo:nil taskType:WT_DECREASE_CONTACT_BOOK_IN_SERVER notificationName:WT_DECREASE_CONTACT_BOOK_IN_SERVER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_NoDataFeedback* netIFCommunicator = [[Communicator_NoDataFeedback alloc] init];
    netIFCommunicator.delegate = task;
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"decrease_contact_book"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
	for (NSString* aNumber in phoneNumberList) {
		NSString* phoneNumber = [WTHelper encryptPhoneNumber:aNumber];
        if (phoneNumber==nil) {
            continue;
        }
        [postKeys addObject:@"phone_number[]"]; [postValues addObject:phoneNumber];
        
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}




+(void) scanPhoneNumber:(NSArray *)phoneNumberList ForBuddyID:(NSString *)buddyid withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (phoneNumberList == nil || [phoneNumberList count] == 0) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* uniquestr = [WT_SCAN_NUMBER_FOR_BUDDY stringByAppendingString:buddyid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_SCAN_NUMBER_FOR_BUDDY notificationName:WT_SCAN_NUMBER_FOR_BUDDY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_ScanPhoneNumberForBuddy* netIFCommunicator = [[Communicator_ScanPhoneNumberForBuddy alloc] init];
    netIFCommunicator.delegate = task;
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"scan_phone_numbers"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
	for (NSString* aNumber in phoneNumberList) {
		NSString* phoneNumber = [WTHelper encryptPhoneNumber:aNumber];
        if (phoneNumber==nil) {
            continue;
        }
        [postKeys addObject:@"phone_number[]"]; [postValues addObject:phoneNumber];
        
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
    
}

+(void) getMatchedBuddyListWithCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_MATCHED_BUDDYS taskInfo:nil taskType:WT_GET_MATCHED_BUDDYS notificationName:WT_GET_MATCHED_BUDDYS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_GetMatchedBuddyList* netIFCommunicator = [[Communicator_GetMatchedBuddyList alloc] init];
    netIFCommunicator.delegate = task;
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_matched_buddy_list"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    
}


+(void) getPossibleBuddyListWithCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_POSSIBLE_BUDDYS taskInfo:nil taskType:WT_GET_POSSIBLE_BUDDYS notificationName:WT_GET_POSSIBLE_BUDDYS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
	NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    NSString* strPhoneNumber = [WTUserDefaults getUsername];
    
    Communicator_GetPossibleBuddyList* netIFCommunicator = [[Communicator_GetPossibleBuddyList alloc] init];
    netIFCommunicator.delegate = task;
    
    // [netIFCommunicator fPost:[NSString stringWithFormat:@"action=get_possible_buddy_list&uid=%@&password=%@&phone_number=%@",strUID,strPwd,[strPhoneNumber md5AndSalt] ]];
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_possible_buddy_list"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"phone_number"]; [postValues addObject:[strPhoneNumber md5AndSalt]];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
}


+(void) getBlockedBuddyListWithCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_BLOCKED_BUDDYS taskInfo:nil taskType:WT_GET_BLOCKED_BUDDYS notificationName:WT_GET_BLOCKED_BUDDYS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_GetBlockedBuddyList* netIFCommunicator = [[Communicator_GetBlockedBuddyList alloc] init];
    netIFCommunicator.delegate = task;
    
    //[netIFCommunicator fPost:[NSString stringWithFormat:@"action=get_block_list&uid=%@&password=%@",strUID,strPwd]];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_block_list"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}



+(void) addBuddy:(NSString*) buddyID withMsg:(NSString*)msg  withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    if(strUID==NULL ||buddyID==NULL || [strUID isEqualToString:buddyID]){
        return;
        
    }
    
    NSString* uniquestr = [WT_ADD_BUDDY stringByAppendingString:buddyID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_ADD_BUDDY notificationName:WT_ADD_BUDDY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_AddBuddy* netIFCommunicator = [[Communicator_AddBuddy alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"add_buddy"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"buddy_id"]; [postValues addObject:buddyID];
    if (![NSString isEmptyString:msg]) {
        [postKeys addObject:@"msg"]; [postValues addObject:msg];
    }
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues forBuddyID:buddyID];
    
    [postKeys release];
    [postValues release];
}


+(void) blockBuddy:(NSString*) buddyID
      withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    if(strUID==NULL ||buddyID==NULL || [strUID isEqualToString:buddyID]){
        return;
    }
    
    NSString* uniquestr = [WT_BLOCK_BUDDY stringByAppendingString:buddyID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_BLOCK_BUDDY notificationName:WT_BLOCK_BUDDY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    // NSString* strPost=[NSString stringWithFormat:@"action=block_buddy&uid=%@&password=%@&buddy_id=%@",strUID,strPwd,buddyID];
    
    
    Communicator_BlockUser* netIFCommunicator = [[Communicator_BlockUser alloc] init];
    netIFCommunicator.delegate = task;
    
    netIFCommunicator.block_flag = TRUE;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"block_buddy"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"buddy_id"]; [postValues addObject:buddyID];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues forBuddyID:buddyID];
    [postKeys release];
    [postValues release];
}


+(void)  unlockBuddy:(NSString*) buddyID withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    if(strUID==NULL ||buddyID==NULL || [strUID isEqualToString:buddyID]){
        return;
    }
    
    NSString* uniquestr = [WT_UNBLOCK_BUDDY stringByAppendingString:buddyID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_UNBLOCK_BUDDY notificationName:WT_UNBLOCK_BUDDY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    //NSString* strPost=[NSString stringWithFormat:@"action=unblock_buddy&uid=%@&password=%@&buddy_id=%@",strUID,strPwd,buddyID];
    
    Communicator_BlockUser* netIFCommunicator = [[Communicator_BlockUser alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.block_flag = FALSE;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"unblock_buddy"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"buddy_id"]; [postValues addObject:buddyID];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues forBuddyID:buddyID];
    [postKeys release];
    [postValues release];
    
}



+(void) getBuddyListWithCallback:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_BUDDY_LIST taskInfo:nil taskType:WT_GET_BUDDY_LIST notificationName:WT_GET_BUDDY_LIST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
	NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    NSString* strPhoneNumber = [WTUserDefaults getUsername];
    
    Communicator_GetBuddyList* netIFCommunicator = [[Communicator_GetBuddyList alloc] init];
    netIFCommunicator.delegate = task;
    
    //[netIFCommunicator fPost:[NSString stringWithFormat:@"action=get_buddy_list&uid=%@&password=%@&phone_number=%@",strUID,strPwd,[strPhoneNumber md5AndSalt] ]];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_buddy_list"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"phone_number"]; [postValues addObject:[strPhoneNumber md5AndSalt]];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}



+(void) getBuddyWithUID:(NSString*)buddyUID
           withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(buddyUID==NULL){
        return;
    }
    
    NSString* uniquestr = [WT_GET_USER_BY_UID stringByAppendingString:buddyUID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_USER_BY_UID notificationName:WT_GET_USER_BY_UID notificationObserver:observer userInfo:nil selector:selector];
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
    [postKeys addObject:@"buddy_id"]; [postValues addObject:buddyUID];

    [netIFCommunicator fPost:postKeys withPostValue:postValues forBuddyID:buddyUID];
    
    [postKeys release];
    [postValues release];
    
}


//Dont mess up with getUserWithUID
+ (void)getBuddyByWowTalkID:(NSString *)wowtalkid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if (wowtalkid == nil)
        return;
    
    NSString* uniquestr = [WT_GET_USER_BY_WOWTALKID stringByAppendingString:wowtalkid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_USER_BY_WOWTALKID notificationName:WT_GET_USER_BY_WOWTALKID notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetUserByID *netIFCommunicator = [[Communicator_GetUserByID alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, WT_ID, nil];
    NSMutableArray *postValues = [[NSMutableArray alloc] initWithObjects:WT_GET_USER_BY_WOWTALKID, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], wowtalkid, nil];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}




+(void)rejectFriendRequest:(NSString*)buddyid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* unistr = [WT_REJECT_FRIEND_REQUEST stringByAppendingString:buddyid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unistr taskInfo:nil taskType:WT_REJECT_FRIEND_REQUEST notificationName:WT_REJECT_FRIEND_REQUEST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_RejectFriendRequest* netIFCommunicator = [[Communicator_RejectFriendRequest alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_REJECT_FRIEND_REQUEST];
    
    [postKeys addObject:@"buddy_id"];
    [postValues addObject:buddyid];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+(void)removeBuddy:(NSString*)buddyid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if ([NSString isEmptyString:buddyid]) {
        return;
    }
    
    NSString* unistr = [WT_REMOVE_BUDDY stringByAppendingString:buddyid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unistr taskInfo:nil taskType:WT_REMOVE_BUDDY notificationName:WT_REMOVE_BUDDY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_RemoveBuddy* netIFCommunicator = [[Communicator_RemoveBuddy alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.buddy_id = buddyid;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_REMOVE_BUDDY];
    
    [postKeys addObject:@"buddy_id"];
    [postValues addObject:buddyid];
    
    [postKeys addObject:@"two_way"];
    [postValues addObject:@"1"];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}


+(void)searchUserByKey:(NSString*)key withType:(NSString*)account_type withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:key] || [NSString isEmptyString:account_type]) {
        return;
    }
    
    NSString* uniquestr = [WT_SEARCH_BUDDY stringByAppendingString:key];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_SEARCH_BUDDY notificationName:WT_SEARCH_BUDDY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_SearchBuddy* netIFCommunicator = [[Communicator_SearchBuddy alloc] init];
    netIFCommunicator.isFuzzySearch = NO;
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_SEARCH_BUDDY];
    
    [postKeys addObject:@"id"];
    [postValues addObject:key];
    
    [postKeys addObject:@"acc_type"];
    [postValues addObject:account_type];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+ (void)searchOfficialByKey:(NSString *)key withPriority:(NSString *)priority withInfo:(NSDictionary *)info withDelegate:(id)delegate withCallBack:(SEL)selector withObserver:(id)observer
{
    NSLog(@"wowtalkwebserverif searchOfficialByKey called , do nothing for no api now!");
    return;
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:priority]) {
        return;
    }
    
    NSString *uniqueKey = @"search_official_account";
    if (key) {
    } else {
        uniqueKey = @"search_official_account";
    }
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueKey taskInfo:nil taskType:@"search_official_account" notificationName:uniqueKey notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_SearchOfficialAccount *netCommunicator = [[Communicator_SearchOfficialAccount alloc] init];
    netCommunicator.fuzzySearch = YES;
    netCommunicator.searchDelegate = delegate;
    netCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [WowTalkWebServerIF basicKeyArray];
    NSMutableArray *postValues = [WowTalkWebServerIF basicValueArrayWithAction:@"search_official_account"];
    
    if (![NSString isEmptyString:key]) {
        [postKeys addObject:@"q"];
        [postValues addObject:key];
    }
    
    [postKeys addObject:@"priority"];
    [postValues addObject:priority];
    
    if ([priority isEqualToString:@"distance"]) {
        [postKeys addObjectsFromArray:[info allKeys]];
        [postValues addObjectsFromArray:[info allValues]];
    }
    
    [netCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}

+ (void)fuzzySearchUserByKey:(NSString *)key withType:(NSArray *)types withDelegate:(id)delegate withCallBack:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:key] || (types == nil && [types count]==0) ) {
        return;
    }
    NSString *uniqueKey = [WT_SEARCH_BUDDY stringByAppendingString:key];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueKey taskInfo:nil taskType:WT_SEARCH_BUDDY notificationName:uniqueKey notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_SearchBuddy *netCommunicator = [[Communicator_SearchBuddy alloc] init];
    netCommunicator.isFuzzySearch = YES;
    netCommunicator.fuzzySearchDelegate = delegate;
    netCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [WowTalkWebServerIF basicKeyArray];
    NSMutableArray *postValues = [WowTalkWebServerIF basicValueArrayWithAction:WT_SEARCH_BUDDY];
    
    [postKeys addObject:@"id"];
    [postValues addObject:key];
    
    
    for (NSNumber* type in types) {
        [postKeys addObject:@"type[]"];
        [postValues addObject:type];
    }
    
    
    [netCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}


+ (void)searchUserByKey:(NSString *)key byKeyType:(BOOL)isID withType:(NSArray *)types withCallBack:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:key] || (types == nil && [types count]==0) ) {
        return;
    }
    NSString *uniqueKey = [WT_SEARCH_BUDDY stringByAppendingString:key];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueKey taskInfo:nil taskType:WT_SEARCH_BUDDY notificationName:uniqueKey notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_SearchBuddywithType *netCommunicator = [[Communicator_SearchBuddywithType alloc] init];
    netCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [WowTalkWebServerIF basicKeyArray];
    NSMutableArray *postValues = [WowTalkWebServerIF basicValueArrayWithAction:WT_SEARCH_BUDDY];
    
    if (isID){
        [postKeys addObject:@"id"];
    }else{
        [postKeys addObject:@"q"];
    }
    
    [postValues addObject:key];
    
    
    for (NSNumber* type in types) {
        [postKeys addObject:@"type[]"];
        [postValues addObject:type];
    }
    
    
    [netCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}


+(void) getPendingFriendRequestWithCallback:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_FRIEND_REQUEST taskInfo:nil taskType:WT_GET_FRIEND_REQUEST notificationName:WT_GET_FRIEND_REQUEST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetFriendRequests* netIFCommunicator = [[Communicator_GetFriendRequests alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_GET_FRIEND_REQUEST];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}

#pragma mark - Buddy by yangbin


+(void) getSchoolMemberThumbnailWithUID:(NSString*)buddyUID withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(buddyUID==NULL){
        return;
    }
    
    if([NSString isEmptyString:buddyUID])
    {
        return;
    }
    
    if(USE_S3){
        NSString* uniquestr = [WT_GET_SCHOOL_MEMBER_PHOTO_THUMBNAIL stringByAppendingString:buddyUID];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:buddyUID forKey:WT_BUDDY_ID] taskType:WT_GET_BUDDY_PHOTO_THUMBNAIL notificationName:WT_GET_SCHOOL_MEMBER_PHOTO_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetFileS3* netIFCommunicator = [[Communicator_GetFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_THUMBNAIL_DIR,buddyUID] FromBucket:S3_BUCKET];
    }
    else{
        NSString* uniquestr = [WT_GET_SCHOOL_MEMBER_PHOTO_THUMBNAIL stringByAppendingString:buddyUID];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:buddyUID forKey:WT_BUDDY_ID] taskType:WT_GET_BUDDY_PHOTO_THUMBNAIL notificationName:WT_GET_SCHOOL_MEMBER_PHOTO_THUMBNAIL notificationObserver:observer userInfo:[NSDictionary dictionaryWithObject:buddyUID forKey:WT_BUDDY_ID] selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_THUMBNAIL_DIR,buddyUID] FromBucket:S3_BUCKET];
    }
}

// 获取学校头像
+(void) getSchoolAvatarWithFileName:(NSString*)file_name withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(file_name==NULL){
        return;
    }
    
    if([NSString isEmptyString:file_name])
    {
        return;
    }
    
    if(USE_S3){
        NSString* uniquestr = [WT_GET_SCHOOL_MEMBER_PHOTO_THUMBNAIL stringByAppendingString:file_name];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:file_name forKey:WT_BUDDY_ID] taskType:WT_GET_BUDDY_PHOTO_THUMBNAIL notificationName:WT_GET_SCHOOL_MEMBER_PHOTO_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetFileS3* netIFCommunicator = [[Communicator_GetFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_THUMBNAIL_DIR,file_name] FromBucket:S3_BUCKET];
    }
    else{
        NSString* uniquestr = [WT_GET_SCHOOL_MEMBER_PHOTO_THUMBNAIL stringByAppendingString:file_name];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:file_name forKey:WT_BUDDY_ID] taskType:WT_GET_BUDDY_PHOTO_THUMBNAIL notificationName:WT_GET_SCHOOL_MEMBER_PHOTO_THUMBNAIL notificationObserver:observer userInfo:[NSDictionary dictionaryWithObject:file_name forKey:WT_BUDDY_ID] selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:file_name FromBucket:S3_BUCKET];
    }
}



#pragma mark - School and Class Member
+ (void)getSchoolMembersWithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_SCHOOL_MEMBERS taskInfo:nil taskType:WT_GET_SCHOOL_MEMBERS notificationName:WT_GET_SCHOOL_MEMBERS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetSchoolMembers *netIFCommunitor = [[Communicator_GetSchoolMembers alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_SCHOOL_MEMBERS, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}

+ (void)getSchoolListWithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:GET_SCHOOL_USER_IN taskInfo:nil taskType:GET_SCHOOL_USER_IN notificationName:GET_SCHOOL_USER_IN notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetSchoolList *netIFCommunitor = [[Communicator_GetSchoolList alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:GET_SCHOOL_USER_IN, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],nil] autorelease];
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
    
    NSString *unqstr = [GET_CLASSROOM_USER_IN stringByAppendingString:school_id];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:nil taskType:unqstr notificationName:unqstr notificationObserver:observer userInfo:[[NSDictionary alloc] initWithObjects:@[school_id] forKeys:@[@"school_id"]] selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetClassList *netIFCommunitor = [[Communicator_GetClassList alloc]init];
    netIFCommunitor.delegate = task;
    netIFCommunitor.school_id = school_id;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"corp_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:GET_CLASSROOM_USER_IN, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],school_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}



#pragma mark - ClassScheduleVC
+ (void)getclassScheduleListWithClassID:(NSString *)class_id WithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:GET_CLASS_LESSON taskInfo:nil taskType:GET_CLASS_LESSON notificationName:GET_CLASS_LESSON notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetClassScheduleList *netIFCommunitor = [[Communicator_GetClassScheduleList alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"class_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:GET_CLASS_LESSON, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],class_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}





+ (void)getLessonPerformanceWithLessonID:(NSString *)lesson_id withStudentID:(NSString *)student_id WithCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:GET_LESSON_PERFORMANCE taskInfo:nil taskType:GET_LESSON_PERFORMANCE notificationName:GET_LESSON_PERFORMANCE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetLessonPerformance *netIFCommunitor = [[Communicator_GetLessonPerformance alloc]init];
    netIFCommunitor.delegate = task;
    netIFCommunitor.lesson_id = lesson_id;
    netIFCommunitor.student_id = student_id;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"lesson_id",@"student_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:GET_LESSON_PERFORMANCE, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],lesson_id,student_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}

+ (void)uploadLessonPerformanceWithLessonID:(NSString *)lesson_id withStudentID:(NSString *)student_id withPerFormanceArray:(NSMutableArray *)perFormanceArray WithCallBack:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:UPLOAD_LESSON_PERFORMANCE taskInfo:nil taskType:UPLOAD_LESSON_PERFORMANCE notificationName:UPLOAD_LESSON_PERFORMANCE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_UploadLessonPerformance* netIFCommunicator = [[Communicator_UploadLessonPerformance alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:UPLOAD_LESSON_PERFORMANCE];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [postKeys addObject:@"student_id"];[postValues addObject:student_id];
    
    for (LessonPerformanceModel *lessonPerformanceModel in perFormanceArray) {
        [postKeys addObject:@"property_id[]"]; [postValues addObject:lessonPerformanceModel.property_id];
    }
    for (LessonPerformanceModel *lessonPerformanceModel in perFormanceArray) {
        [postKeys addObject:@"property_value[]"]; [postValues addObject:lessonPerformanceModel.property_value];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}


+ (void)getLessonHomeworkWithLessonId:(NSString *)lesson_id withCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:GET_LESSON_HOMEWORK taskInfo:nil taskType:GET_LESSON_HOMEWORK notificationName:GET_LESSON_HOMEWORK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetLessonHomework *netIFCommunitor = [[Communicator_GetLessonHomework alloc]init];
    netIFCommunitor.delegate = task;

    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"lesson_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:GET_LESSON_HOMEWORK, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],lesson_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}

+ (void)uploadLessonHomeworkWithLessonID:(NSString *)lesson_id withTitle:(NSString *)title WithCallBack:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:ADD_LESSON_HOMEWORK taskInfo:nil taskType:ADD_LESSON_HOMEWORK notificationName:ADD_LESSON_HOMEWORK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_UploadHomework* netIFCommunicator = [[Communicator_UploadHomework alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.title = title;
    netIFCommunicator.lesson_id = lesson_id;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:ADD_LESSON_HOMEWORK];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [postKeys addObject:@"title"];[postValues addObject:title];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+ (void)getLessonParentFeedbackWithLessonId:(NSString *)lesson_id withStudentID:(NSString *)student_id withCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:GET_LESSON_PARENT_FEEDBACK taskInfo:nil taskType:GET_LESSON_PARENT_FEEDBACK notificationName:GET_LESSON_PARENT_FEEDBACK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetLessonParentFeedBack *netIFCommunitor = [[Communicator_GetLessonParentFeedBack alloc]init];
    netIFCommunitor.delegate = task;
    
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"lesson_id",@"student_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:GET_LESSON_PARENT_FEEDBACK, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],lesson_id,student_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}

+ (void)getMomentByMomentID:(NSString *)moment_id withCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:GET_MOMENT_BY_ID taskInfo:nil taskType:GET_MOMENT_BY_ID notificationName:GET_MOMENT_BY_ID notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetMomentByMomentID *netIFCommunitor = [[Communicator_GetMomentByMomentID alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"moment_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:GET_MOMENT_BY_ID, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],moment_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}


//add_lesson_parent_feedback
//lesson_id, student_id, moment_id
+ (void)uploadLessonParentFeedBackWithLessonID:(NSString *)lesson_id withStudentId:(NSString *)student_id  withMoment_id:(NSString *)moment_id WithCallBack:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:UPLOAD_LESSON_PARENT_FEEDBACK taskInfo:nil taskType:UPLOAD_LESSON_PARENT_FEEDBACK notificationName:UPLOAD_LESSON_PARENT_FEEDBACK notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_UploadLessonParentFeedback * netIFCommunicator = [[Communicator_UploadLessonParentFeedback alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:UPLOAD_LESSON_PARENT_FEEDBACK];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"lesson_id"]; [postValues addObject:lesson_id];
    [postKeys addObject:@"student_id"];[postValues addObject:student_id];
    [postKeys addObject:@"moment_id"];[postValues addObject:moment_id];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

#pragma mark file handler

+(void) uploadMyPhoto:(NSString*)filePath withCallback:(SEL)selector withObserver:(id)observer{
    
    if(![NSFileManager hasFileAtPath:filePath]) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return ;
    }
    
    if(USE_S3){
     
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPDATE_MY_PHOTO_ORIGINAL taskInfo:[NSDictionary dictionaryWithObject:filePath forKey:WT_FILE_PATH_LOCAL] taskType:WT_UPDATE_MY_PHOTO_ORIGINAL notificationName:WT_UPDATE_MY_PHOTO_ORIGINAL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        
        NSString* strUID =	[WTUserDefaults getUid];
        NSString* strPwd =	[WTUserDefaults getHashedPassword];
        
        Communicator_NoDataFeedback* netIFCommunicator2 = [[Communicator_NoDataFeedback alloc] init];
        NSMutableArray* postKeys =[[NSMutableArray alloc]init];
        NSMutableArray* postValues =[[NSMutableArray alloc]init];
        [postKeys addObject:@"action"]; [postValues addObject:@"update_my_upload_photo_timestamp"];
        [postKeys addObject:@"uid"]; [postValues addObject:strUID];
        [postKeys addObject:@"password"]; [postValues addObject:strPwd];
        [netIFCommunicator2 fPost:postKeys withPostValue:postValues];
        
        [postKeys release];
        [postValues release];
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =  [netIFCommunicator fUploadProfilePhoto:filePath toDir:S3_PROFILE_PHOTO_DIR forBucket:S3_BUCKET];
        
    }
    else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];

        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPDATE_MY_PHOTO_ORIGINAL taskInfo:[NSDictionary dictionaryWithObject:filePath forKey:WT_FILE_PATH_LOCAL] taskType:WT_UPDATE_MY_PHOTO_ORIGINAL notificationName:WT_UPDATE_MY_PHOTO_ORIGINAL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];

            return;
        }
        
        NSString* strUID =	[WTUserDefaults getUid];
        NSString* strPwd =	[WTUserDefaults getHashedPassword];
        
        
        Communicator_NoDataFeedback* netIFCommunicator2 = [[Communicator_NoDataFeedback alloc] init];
        NSMutableArray* postKeys =[[NSMutableArray alloc]init];
        NSMutableArray* postValues =[[NSMutableArray alloc]init];
        [postKeys addObject:@"action"]; [postValues addObject:@"update_my_upload_photo_timestamp"];
        [postKeys addObject:@"uid"]; [postValues addObject:strUID];
        [postKeys addObject:@"password"]; [postValues addObject:strPwd];
        [netIFCommunicator2 fPost:postKeys withPostValue:postValues];
        
        [postKeys release];
        [postValues release];

        
        
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fInit];
        task.request =  [netIFCommunicator fUploadProfilePhoto:filePath toDir:S3_PROFILE_PHOTO_DIR forBucket:S3_BUCKET];
        

    }
    
}


+(void) uploadMyThumbnail:(NSString*)filePath withCallback:(SEL)selector withObserver:(id)observer
{
    if(![NSFileManager hasFileAtPath:filePath]) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(USE_S3){
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPDATE_MT_PHOTO_THUMBNAIL taskInfo:[NSDictionary dictionaryWithObject:filePath forKey:WT_FILE_PATH_LOCAL] taskType:WT_UPDATE_MT_PHOTO_THUMBNAIL notificationName:WT_UPDATE_MT_PHOTO_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        NSString* strUID =	[WTUserDefaults getUid];
        NSString* strPwd =	[WTUserDefaults getHashedPassword];
        
        Communicator_NoDataFeedback* netIFCommunicator2 = [[Communicator_NoDataFeedback alloc] init];
        NSMutableArray* postKeys =[[NSMutableArray alloc]init];
        NSMutableArray* postValues =[[NSMutableArray alloc]init];
        [postKeys addObject:@"action"]; [postValues addObject:@"update_my_upload_photo_timestamp"];
        [postKeys addObject:@"uid"]; [postValues addObject:strUID];
        [postKeys addObject:@"password"]; [postValues addObject:strPwd];
        
        [netIFCommunicator2 fPost:postKeys withPostValue:postValues];
        
        [postKeys release];
        [postValues release];
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request = [netIFCommunicator fUploadProfilePhoto:filePath toDir:S3_PROFILE_THUMBNAIL_DIR forBucket:S3_BUCKET];
    }
    else{
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPDATE_MT_PHOTO_THUMBNAIL taskInfo:[NSDictionary dictionaryWithObject:filePath forKey:WT_FILE_PATH_LOCAL] taskType:WT_UPDATE_MT_PHOTO_THUMBNAIL notificationName:WT_UPDATE_MT_PHOTO_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        NSString* strUID =	[WTUserDefaults getUid];
        NSString* strPwd =	[WTUserDefaults getHashedPassword];
        
        Communicator_NoDataFeedback* netIFCommunicator2 = [[Communicator_NoDataFeedback alloc] init];
        NSMutableArray* postKeys =[[NSMutableArray alloc]init];
        NSMutableArray* postValues =[[NSMutableArray alloc]init];
        [postKeys addObject:@"action"]; [postValues addObject:@"update_my_upload_photo_timestamp"];
        [postKeys addObject:@"uid"]; [postValues addObject:strUID];
        [postKeys addObject:@"password"]; [postValues addObject:strPwd];
        
        [netIFCommunicator2 fPost:postKeys withPostValue:postValues];
        
        [postKeys release];
        [postValues release];
        
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fInit];
        task.request = [netIFCommunicator fUploadProfilePhoto:filePath toDir:S3_PROFILE_THUMBNAIL_DIR forBucket:S3_BUCKET];
    }
    
}

+(void) getPhotoForUserID:(NSString*)userID withCallback:(SEL)selector withObserver:(id)observer {
    if([NSString isEmptyString:userID] )
    {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    Buddy* buddy = [Database buddyWithUserID:userID];
    if (buddy.needToDownloadPhoto == FALSE) {
        return;
    }
    
    if(USE_S3){
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        
        NSString* uniquestr = [WT_GET_BUDDY_PHOTO_ORIGINAL stringByAppendingString:userID];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:userID forKey:WT_BUDDY_ID] taskType:WT_GET_BUDDY_PHOTO_ORIGINAL notificationName:WT_GET_BUDDY_PHOTO_ORIGINAL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetFileS3* netIFCommunicator = [[Communicator_GetFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request = [netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_PHOTO_DIR,userID] FromBucket:S3_BUCKET];
        
    }
    else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        
        NSString* uniquestr = [WT_GET_BUDDY_PHOTO_ORIGINAL stringByAppendingString:userID];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:userID forKey:WT_BUDDY_ID] taskType:WT_GET_BUDDY_PHOTO_ORIGINAL notificationName:WT_GET_BUDDY_PHOTO_ORIGINAL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request = [netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_PHOTO_DIR,userID] FromBucket:S3_BUCKET];
    }
}


+(void) getThumbnailForUserID:(NSString*)userID withCallback:(SEL)selector withObserver:(id)observer {
    if([NSString isEmptyString:userID])
    {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    Buddy* buddy = [Database buddyWithUserID:userID];
    
    if (buddy.needToDownloadThumbnail == FALSE ) {
        return;
    }
    
    if(USE_S3){
        NSString* uniquestr = [WT_GET_BUDDY_PHOTO_THUMBNAIL stringByAppendingString:userID];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:userID forKey:WT_BUDDY_ID] taskType:WT_GET_BUDDY_PHOTO_THUMBNAIL notificationName:WT_GET_BUDDY_PHOTO_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetFileS3* netIFCommunicator = [[Communicator_GetFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_THUMBNAIL_DIR,userID] FromBucket:S3_BUCKET];
    }
    else{
        NSString* uniquestr = [WT_GET_BUDDY_PHOTO_THUMBNAIL stringByAppendingString:userID];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:userID forKey:WT_BUDDY_ID] taskType:WT_GET_BUDDY_PHOTO_THUMBNAIL notificationName:WT_GET_BUDDY_PHOTO_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_THUMBNAIL_DIR,userID] FromBucket:S3_BUCKET];
    }
}

+(void) getFileFromServer:(NSString*) fileID withCallback:(SEL)selector withObserver:(id)observer{
    if([NSString isEmptyString:fileID])
    {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    
    if(USE_S3){
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        NSString* uniquestr = fileID;
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_FILE_FROM_SERVER notificationName:WT_GET_FILE_FROM_SERVER notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetFileS3* netIFCommunicator = [[Communicator_GetFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_UPLOAD_FILE_DIR,fileID] FromBucket:S3_BUCKET];
        
    }
    else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        NSString* uniquestr = fileID;
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_FILE_FROM_SERVER notificationName:WT_GET_FILE_FROM_SERVER notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_UPLOAD_FILE_DIR,fileID] FromBucket:S3_BUCKET];
    }
}

+(void) uploadFilelToServer:(NSString*)filePath withCallback:(SEL)selector withObserver:(id)observer
{
    NSLog(@"not in use now");
    
    
    
    
}

+(void) getFileFromShop:(NSString*) fileID withCallback:(SEL)selector withObserver:(id)observer{
    if([NSString isEmptyString:fileID])
    {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(USE_S3){
        
        NSString* uniquestr = [WT_GET_STAMP_FILE_FROM_SERVER stringByAppendingString:fileID];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_STAMP_FILE_FROM_SERVER notificationName:WT_GET_STAMP_FILE_FROM_SERVER notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetFileS3* netIFCommunicator = [[Communicator_GetFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_SHOP_DIR,fileID] FromBucket:S3_BUCKET];
    }
    else{
        
        NSString* uniquestr = [WT_GET_STAMP_FILE_FROM_SERVER stringByAppendingString:fileID];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_STAMP_FILE_FROM_SERVER notificationName:WT_GET_STAMP_FILE_FROM_SERVER notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_SHOP_DIR,fileID] FromBucket:S3_BUCKET];
    }
    
}



#pragma mark -
#pragma mark GroupChat

+(void)  createTemporaryChatRoom:(NSString*) strGroupName withCallback:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_CREATE_CHAT_GROUP taskInfo:nil taskType:WT_CREATE_CHAT_GROUP notificationName:WT_CREATE_CHAT_GROUP notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    
    NSMutableArray* postKeys = [WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_CREATE_CHAT_GROUP];
    
    [postKeys addObject:@"group_name"]; [postValues addObject:strGroupName];
    
    Communicator_CreateGroupChatRoom* netIFCommunicator = [[Communicator_CreateGroupChatRoom alloc] init];
    netIFCommunicator.delegate = task;
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}


+(void)  groupChat_JoinGroup:(NSString*) groupID withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* uniquestr = [WT_JOIN_CHAT_GROUP stringByAppendingString:groupID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_JOIN_CHAT_GROUP notificationName:WT_JOIN_CHAT_GROUP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    // NSString* strPost=[NSString stringWithFormat:@"action=join_group_chat_room&uid=%@&password=%@&group_id=%@",
    //                  strUID,strPwd,groupID];
    
    
    Communicator_JoinOrLeaveOrAddGroup* netIFCommunicator = [[Communicator_JoinOrLeaveOrAddGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    // [netIFCommunicator fPost:strPost forGroupID:groupID addGroupToDB:YES];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"join_group_chat_room"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"group_id"]; [postValues addObject:groupID];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues forGroupID:groupID addGroupToDB:YES];
    
    [postKeys release];
    [postValues release];
}


+(void) groupChat_LeaveGroup:(NSString*) groupID withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* uniquestr = [WT_LEAVE_CHAT_GROUP stringByAppendingString:groupID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_LEAVE_CHAT_GROUP notificationName:WT_LEAVE_CHAT_GROUP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    
    Communicator_JoinOrLeaveOrAddGroup* netIFCommunicator = [[Communicator_JoinOrLeaveOrAddGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    //[netIFCommunicator fPost:strPost forGroupID:groupID addGroupToDB:NO];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"leave_group_chat_room"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"group_id"]; [postValues addObject:groupID];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues forGroupID:groupID addGroupToDB:NO];
    [postKeys release];
    [postValues release];
    
}



+(void) groupChat_GetGroupMembers:(NSString*) groupID withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    NSString* uniquestr = [WT_GET_GROUP_MEMBERS stringByAppendingString:groupID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_GROUP_MEMBERS notificationName:WT_GET_GROUP_MEMBERS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    Communicator_GetGroupMembers* netIFCommunicator = [[Communicator_GetGroupMembers alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues = [WowTalkWebServerIF basicValueArrayWithAction:WT_GET_GROUP_MEMBERS];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupID];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues forGroupID:groupID];
    
    [postKeys release];
    [postValues release];
    
    
}

+(void) groupChat_AddMembers:(NSString*) groupID
                 withMembers:(NSArray*) buddyList
                withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    if (buddyList==NULL|| [buddyList count] == 0) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    NSString* uniquestr = [WT_ADD_GROUP_MEMBERS stringByAppendingString:groupID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_ADD_GROUP_MEMBERS notificationName:WT_ADD_GROUP_MEMBERS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    Communicator_JoinOrLeaveOrAddGroup* netIFCommunicator = [[Communicator_JoinOrLeaveOrAddGroup alloc] init];
    
    netIFCommunicator.delegate = task;
    netIFCommunicator.addedMembers = buddyList;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_ADD_GROUP_MEMBERS];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupID];
    
    
    
    for (int i=0; i<[buddyList count]; i++) {
        Buddy* buddy=(Buddy*)[buddyList objectAtIndex:i];
        if(buddy!=NULL){
            if([NSString isEmptyString:buddy.userID] || [[WTUserDefaults getUid] isEqualToString:buddy.userID]) continue;
            
            [postKeys addObject:@"buddy_id[]"]; [postValues addObject:buddy.userID];
        }
    }
    [netIFCommunicator fPost:postKeys withPostValue:postValues forGroupID:groupID addGroupToDB:YES];
    [postKeys release];
    [postValues release];
}



+(void) groupChat_GetGroupDetail:(NSString*) groupID withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* uniquestr = [WT_GET_GROUP_INFO stringByAppendingString:groupID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:groupID forKey:@"group_id"] taskType:WT_GET_GROUP_INFO notificationName:WT_GET_GROUP_INFO notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_JoinOrLeaveOrAddGroup* netIFCommunicator = [[Communicator_JoinOrLeaveOrAddGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    //  [netIFCommunicator fPost:strPost forGroupID:groupID addGroupToDB:YES];
    
    netIFCommunicator.mode = 2;
    netIFCommunicator.addGroupToDB = TRUE;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_group_info"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"group_id"]; [postValues addObject:groupID];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues forGroupID:groupID addGroupToDB:YES];
    [postKeys release];
    [postValues release];
    
}


+(void) groupChat_SendMessage:(ChatMessage*) msg
                      toGroup:(NSString*)groupID
                 withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if (msg.chatUserName == NULL || msg.msgType ==NULL || msg.messageContent ==NULL) {
        if(PRINT_LOG)NSLog(@"chatUserName/msgType/messageContent cannot be null in fGroupChat_SendMessage, do nothing" );
        return;
    }
    
    if(PRINT_LOG)NSLog(@"fGroupChat_SendMessage:%@ to:%@",msg.messageContent,msg.chatUserName);
    
    
    if (!([msg.msgType isEqualToString:[ChatMessage MSGTYPE_ENCRIPTED_TXT_MESSAGE ]] ||
          [msg.msgType isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]] ||
          [msg.msgType isEqualToString:[ChatMessage MSGTYPE_LOCATION]] ||
          [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_STAMP]] ||
          [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]] ||
          [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]] ||
          [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]] ||
          [msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]] ||
          [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VCF]]||
          [msg.msgType isEqualToString:[ChatMessage MSGTYPE_THIRDPARTY_MSG]])){
        if(PRINT_LOG)NSLog(@"not support usage of fGroupChat_SendMessage, do nothing" );
        return;
    }
    
    
    msg.sentDate = [TimeHelper getCurrentTime]; //redefine the sentdate
	msg.ioType =    [ChatMessage IOTYPE_OUTPUT];
    msg.sentStatus = [ChatMessage SENTSTATUS_IN_PROCESS];
    
    if (![msg hasPrimaryKey] ) {
        msg.primaryKey = [Database storeNewChatMessage:msg];
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    NSString* myUID = [WTUserDefaults getUid];
    NSString* strOutput = [NSString stringWithFormat:@"%@%@|{%ld}{%@}%@",msg.msgType,msg.sentDate,(long)msg.primaryKey,myUID,msg.messageContent];

    
    NSString* uniquestr = [WT_SEND_GROUP_MESSAGES stringByAppendingFormat:@"%ld",(long)msg.primaryKey];

    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:msg forKey:WT_MESSAGE] taskType:WT_SEND_GROUP_MESSAGES notificationName:WT_SEND_GROUP_MESSAGES notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_SendGroupMessage* netIFCommunicator = [[Communicator_SendGroupMessage alloc] init];
    netIFCommunicator.chatMessage = msg;
    netIFCommunicator.delegate = task;
    
    //[netIFCommunicator fPost:strPost];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"transfer_group_message"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"group_id"]; [postValues addObject:groupID];
    [postKeys addObject:@"message"]; [postValues addObject:strOutput];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
}


#pragma mark fixed group

+ (void)getAllGroupsInCompanyWithCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_ALL_GROUPS_IN_COMPANY taskInfo:nil taskType:WT_GET_ALL_GROUPS_IN_COMPANY notificationName:WT_GET_ALL_GROUPS_IN_COMPANY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetAllGroupsInCompany* netIFCommunicator = [[Communicator_GetAllGroupsInCompany alloc] init];
    netIFCommunicator.delegate = task;
    
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_GET_ALL_GROUPS_IN_COMPANY];
    
    [postKeys addObject:@"company_id"]; [postValues addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"companyid"]];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}

+(void) createGroup:(NSString*)groupname withStatus:(NSString*)status withPlacename:(NSString*)place withLongitude:(double)longitude withLatitude:(double)latitude withBreifIntroduction:(NSString*)briefintro  withGroupType:(NSString*)type withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if ([NSString isEmptyString:groupname]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Group name can't be empty", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_CREATE_FIXED_GROUP taskInfo:nil taskType:WT_CREATE_FIXED_GROUP notificationName:WT_CREATE_FIXED_GROUP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_CreateFixedGroup* netIFCommunicator = [[Communicator_CreateFixedGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    //[netIFCommunicator fPost:strPost];
    
    NSMutableArray* postValues = [WowTalkWebServerIF basicValueArrayWithAction:WT_CREATE_FIXED_GROUP];
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    
    [postValues addObject:groupname];
    [postKeys addObject:@"group_name"];
    
    if (![NSString isEmptyString:status]) {
        [postKeys addObject:@"group_status"];
        [postValues addObject:status];
    }
    if (![NSString isEmptyString:place]) {
        [postValues addObject:place];
        [postKeys addObject:@"place"];
    }
    
    [postValues addObject:[NSNumber numberWithDouble:longitude]];
    [postKeys addObject:@"create_longitude"];
    [postValues addObject:[NSNumber numberWithDouble:latitude]];
    [postKeys addObject:@"create_latitude"];
    
    if (![NSString isEmptyString:type]) {
        [postValues addObject:type];
        [postKeys addObject:@"type"];
    }
    if (![NSString isEmptyString:briefintro]) {
        [postValues addObject:briefintro];
        [postKeys addObject:@"group_brief_introduction"];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}

+(void) getUserGroupDetail:(NSString*) groupID isCreator:(BOOL)isCreator withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* uniquestr = [WT_GET_GROUP_INFO stringByAppendingString:groupID];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:groupID forKey:@"group_id"] taskType:WT_GET_GROUP_INFO notificationName:WT_GET_GROUP_INFO notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_GetUserGroupInfo* netIFCommunicator = [[Communicator_GetUserGroupInfo alloc] init];
    netIFCommunicator.delegate = task;
    
    //  [netIFCommunicator fPost:strPost forGroupID:groupID addGroupToDB:YES];
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_group_info"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"group_id"]; [postValues addObject:groupID];
    
    netIFCommunicator.groupid = groupID;
    netIFCommunicator.isCreator = isCreator;
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
}

+(void) uploadGroupAvatarThumbnail:(NSString*)filepath forGroup:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if(![NSFileManager hasFileAtPath:filepath]) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return ;
    }
    
    if(USE_S3){
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPLOAD_GROUP_AVATAR_THUMBNAIL taskInfo:nil taskType:WT_UPLOAD_GROUP_AVATAR_THUMBNAIL notificationName:WT_UPLOAD_GROUP_AVATAR_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadGroupAvatar* netIFCommunicator = [[Communicator_UploadGroupAvatar alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =  [netIFCommunicator uploadGroupAvatarThumbnail:filepath forGroup:groupid toDir:S3_PROFILE_THUMBNAIL_DIR forBucket:S3_BUCKET];
        
    }
    else{
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPLOAD_GROUP_AVATAR_THUMBNAIL taskInfo:nil taskType:WT_UPLOAD_GROUP_AVATAR_THUMBNAIL notificationName:WT_UPLOAD_GROUP_AVATAR_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fInit];
        task.request =  [netIFCommunicator uploadGroupAvatar:filepath forGroup:groupid toDir:S3_PROFILE_THUMBNAIL_DIR forBucket:S3_BUCKET];


    }
    
    
}

+(void) uploadGroupAvatar:(NSString*)filepath forGroup:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if(![NSFileManager hasFileAtPath:filepath]) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return ;
    }
    
    if(USE_S3){
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPLOAD_GROUP_AVATAR taskInfo:nil taskType:WT_UPLOAD_GROUP_AVATAR notificationName:WT_UPLOAD_GROUP_AVATAR notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_UploadGroupAvatar* netIFCommunicator = [[Communicator_UploadGroupAvatar alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =  [netIFCommunicator uploadGroupAvatar:filepath forGroup:groupid toDir:S3_PROFILE_PHOTO_DIR forBucket:S3_BUCKET];
        
    }
    else{
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPLOAD_GROUP_AVATAR taskInfo:nil taskType:WT_UPLOAD_GROUP_AVATAR notificationName:WT_UPLOAD_GROUP_AVATAR notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        [netIFCommunicator fInit];
        task.request =  [netIFCommunicator uploadGroupAvatar:filepath forGroup:groupid toDir:S3_PROFILE_PHOTO_DIR forBucket:S3_BUCKET];


    }
    
}

+(void) setLevel:(NSString*) level forUser:(NSString*)userid forGroup:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:groupid]|| [NSString isEmptyString:userid]|| [NSString isEmptyString:level]) {
        return;
    }
    
    //  NSString* uniquestr = [WT_SET_USER_LEVEL stringByAppendingString:userid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_SET_USER_LEVEL taskInfo:nil taskType:WT_SET_USER_LEVEL notificationName:WT_SET_USER_LEVEL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_SetMemberAuthority* netIFCommunicator = [[Communicator_SetMemberAuthority alloc] init];
    netIFCommunicator.delegate = task;
    
    netIFCommunicator.groupid = groupid;
    netIFCommunicator.memberid = userid;
    netIFCommunicator.level = level;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_SET_USER_LEVEL];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    [postKeys addObject:@"member_id"]; [postValues addObject:userid];
    [postKeys addObject:@"level"]; [postValues addObject:level];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
}

+(void) getGroupByKey:(NSString*) searchKey withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:searchKey]) {
        return;
    }
    
    NSString* uniquestr = [WT_SEARCH_GROUP_BY_KEY stringByAppendingString:searchKey];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_SEARCH_GROUP_BY_KEY notificationName:WT_SEARCH_GROUP_BY_KEY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_SearchUserGroup* netIFCommunicator = [[Communicator_SearchUserGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_SEARCH_GROUP_BY_KEY];
    
    [postKeys addObject:@"q"]; [postValues addObject:searchKey];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}


+(void) editGroup:(NSString*)groupid withName:(NSString*)groupname withStatus:(NSString*)status withPlacename:(NSString*)name withLongitude:(double)longitude withLatitude:(double)latitude withBreifIntroduction:(NSString*)briefintro withGroupType:(NSString*) type NeedUpdateTimeStamp:(BOOL)flag withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:groupid]) {
        return;
    }
    
    NSString* str = [WT_EDIT_GROUP_INFO stringByAppendingString:groupid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:str taskInfo:nil taskType:WT_EDIT_GROUP_INFO notificationName:WT_EDIT_GROUP_INFO notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Communicator_EditGroupInfo* netIFCommunicator = [[Communicator_EditGroupInfo alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postValues = [WowTalkWebServerIF basicValueArrayWithAction:WT_EDIT_GROUP_INFO];
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    
    
    [postValues addObject:groupid];
    [postKeys addObject:@"group_id"];
    
    
    if (![NSString isEmptyString:groupname]){
        [postValues addObject:groupname];
        [postKeys addObject:@"name"];
    }
    
    if (![NSString isEmptyString:status]) {
        [postKeys addObject:@"status"];
        [postValues addObject:status];
    }
    
    if (![NSString isEmptyString:name]) {
        [postValues addObject:name];
        [postKeys addObject:@"place"];
    }
    
    if (longitude != -1) {
        [postValues addObject:[NSNumber numberWithDouble:longitude]];
        [postKeys addObject:@"lon"];
    }
    
    if (latitude != -1) {
        [postValues addObject:[NSNumber numberWithDouble:latitude]];
        [postKeys addObject:@"lat"];
    }
    
    if (flag == TRUE) {
        [postValues addObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];
        [postKeys addObject:@"upload_photo_timestamp"];
    }
    
    if (type != nil) {
        [postValues addObject:type];
        [postKeys addObject:@"type"];
    }
    
    
    if (![NSString isEmptyString:briefintro]) {
        [postValues addObject:briefintro];
        [postKeys addObject:@"intro"];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
}

+(void)dismissGroup:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if (groupid == nil) {
        return;
    }
    
    NSString* uniquestr = [WT_DISMISS_GROUP stringByAppendingString:groupid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_DISMISS_GROUP notificationName:WT_DISMISS_GROUP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_DismissGroup* netIFCommunicator = [[Communicator_DismissGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    netIFCommunicator.groupid = groupid;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_DISMISS_GROUP];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
}

+(void)askToJoinThegroup:(NSString*)groupid withMessage:(NSString*)msg withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if (groupid == nil) {
        return;
    }
    
    NSString* uniquestr = [WT_REQUEST_TO_JOIN_GROUP stringByAppendingString:groupid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_REQUEST_TO_JOIN_GROUP notificationName:WT_REQUEST_TO_JOIN_GROUP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_RequestToJoinGroup* netIFCommunicator = [[Communicator_RequestToJoinGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    netIFCommunicator.group_id = groupid;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_REQUEST_TO_JOIN_GROUP];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    [postKeys addObject:@"msg"]; [postValues addObject:msg];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
}

+(void)getPendingMembers:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if (groupid == nil) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_GROUP_PENDING_MEMBERS taskInfo:nil taskType:WT_GET_GROUP_PENDING_MEMBERS notificationName:WT_GET_GROUP_PENDING_MEMBERS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetPendingRequests* netIFCommunicator = [[Communicator_GetPendingRequests alloc] init];
    netIFCommunicator.delegate = task;
    
    netIFCommunicator.group_id = groupid;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_GET_GROUP_PENDING_MEMBERS];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
}

+(void)getGroupByGroupID:(NSString*) groupid withCallback:(SEL)selector withObserver:(id)observer
{
    
}

+(void)updateThumbnailTimestamp:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if (groupid == nil) {
        return;
    }
    
    NSString* uniquestr = [WT_UPDATE_GROUP_AVATAR_TIMESTAMP stringByAppendingString:groupid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_UPDATE_GROUP_AVATAR_TIMESTAMP notificationName:WT_UPDATE_GROUP_AVATAR_TIMESTAMP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_UpdateGroupAvatarTimestamp* netIFCommunicator = [[Communicator_UpdateGroupAvatarTimestamp alloc] init];
    netIFCommunicator.delegate = task;
    
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_UPDATE_GROUP_AVATAR_TIMESTAMP];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}

+(void)removeMemeber:(NSArray*)memberlist fromGroup:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if (groupid == nil || memberlist == nil || [memberlist count] == 0) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REMOVE_GROUP_MEMBERS taskInfo:nil taskType:WT_REMOVE_GROUP_MEMBERS notificationName:WT_REMOVE_GROUP_MEMBERS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_RemoveMemberFromGroup* netIFCommunicator = [[Communicator_RemoveMemberFromGroup alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.memberlist = memberlist;
    netIFCommunicator.groupid = groupid;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_REMOVE_GROUP_MEMBERS];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    
    for (int i=0; i<[memberlist count]; i++) {
        GroupMember* buddy=(GroupMember*)[memberlist objectAtIndex:i];
        if(buddy!=NULL){
            if(buddy.userID==NULL) continue;
            [postKeys addObject:@"member_id[]"]; [postValues addObject:buddy.userID];
        }
    }
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}

+(void)rejectCandidate:(NSString*)buddyid toJoinGroup:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if ([NSString isEmptyString:groupid] || [NSString isEmptyString:buddyid]) {
        return;
    }
    
    NSString* uniquestr = [WT_REJECT_GROUP_APPLICATION stringByAppendingFormat:@"%@%@",buddyid,groupid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_REJECT_GROUP_APPLICATION notificationName:WT_REJECT_GROUP_APPLICATION notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_RejectCandidateForGroup* netIFCommunicator = [[Communicator_RejectCandidateForGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_REJECT_GROUP_APPLICATION];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    [postKeys addObject:@"member_ids[]"]; [postValues addObject:buddyid];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+(void)getGroupAvatar:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if([NSString isEmptyString:groupid])
    {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(USE_S3){
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        NSString* uniquestr = [WT_GET_GROUP_AVATAR stringByAppendingString:groupid];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:groupid forKey:WT_GROUP_ID] taskType:WT_GET_GROUP_AVATAR notificationName:WT_GET_GROUP_AVATAR notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetGroupAvater* netIFCommunicator = [[Communicator_GetGroupAvater alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_PHOTO_DIR,groupid] FromBucket:S3_BUCKET];
    }
    else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        NSString* uniquestr = [WT_GET_GROUP_AVATAR stringByAppendingString:groupid];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:groupid forKey:WT_GROUP_ID] taskType:WT_GET_GROUP_AVATAR notificationName:WT_GET_GROUP_AVATAR notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_PHOTO_DIR,groupid] FromBucket:S3_BUCKET];
    }
    
}

+(void)getGroupAvatarThumbnail:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if([NSString isEmptyString:groupid])
    {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    // don't have a thumbnail.
    UserGroup* group = [Database getFixedGroupByID:groupid];
    if ([group.thumbnail_timestamp isEqualToString:@"-1"] || group.needToDownloadThumbnail == FALSE) {
        return;
    }
    
    
    if(USE_S3){
        NSString* uniquestr = [WT_GET_GROUP_AVATAR_THUMBNAIL stringByAppendingString:groupid];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:groupid forKey:WT_GROUP_ID] taskType:WT_GET_GROUP_AVATAR_THUMBNAIL notificationName:WT_GET_GROUP_AVATAR_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetGroupAvater* netIFCommunicator = [[Communicator_GetGroupAvater alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_THUMBNAIL_DIR,groupid] FromBucket:S3_BUCKET];
    }
    else{
        NSString* uniquestr = [WT_GET_GROUP_AVATAR_THUMBNAIL stringByAppendingString:groupid];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:groupid forKey:WT_GROUP_ID] taskType:WT_GET_GROUP_AVATAR_THUMBNAIL notificationName:WT_GET_GROUP_AVATAR_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_PROFILE_THUMBNAIL_DIR,groupid] FromBucket:S3_BUCKET];
    }
}


+(void)leaveGroup:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if ([NSString isEmptyString:groupid]) {
        return;
    }
    
    NSString* uniquestr = [WT_LEAVE_CHAT_GROUP stringByAppendingString:groupid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_LEAVE_CHAT_GROUP notificationName:WT_LEAVE_CHAT_GROUP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_LeaveUserGroup* netIFCommunicator = [[Communicator_LeaveUserGroup alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.groupid = groupid;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_LEAVE_CHAT_GROUP];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}

+(void)acceptJoinApplicationFor:(NSString*)groupid FromUser:(NSString*)userid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:userid]) {
        return;
    }
    
    NSString* uniquestr = [WT_ADD_GROUP_MEMBERS stringByAppendingString:userid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_ADD_GROUP_MEMBERS notificationName:WT_ADD_GROUP_MEMBERS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_AcceptJoinGroupApplication* netIFCommunicator = [[Communicator_AcceptJoinGroupApplication alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.groupid = groupid;
    netIFCommunicator.buddyid = userid;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_ADD_GROUP_MEMBERS];
    
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    [postKeys addObject:@"buddy_id[]"]; [postValues addObject:userid];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    
}

+(void)getAllPendingRequest:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_ALL_PENDING_REQUEST taskInfo:nil taskType:WT_GET_ALL_PENDING_REQUEST notificationName:WT_GET_ALL_PENDING_REQUEST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetAllPendingRequests* netIFCommunicator = [[Communicator_GetAllPendingRequests alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_GET_ALL_PENDING_REQUEST];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}


+(void)acceptGroupInvitation:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    
}
+(void)refuseJoinTheGroup:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    
}




+(void)getMyGroupsWithCallback:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_MY_GROUPS taskInfo:nil taskType:WT_GET_MY_GROUPS notificationName:WT_GET_MY_GROUPS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetMyGroups* netIFCommunicator = [[Communicator_GetMyGroups alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_GET_MY_GROUPS];
    
    [postKeys addObject:@"with_temp"]; [postValues addObject:@"0"];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}

#pragma mark -
#pragma mark - Class group

+(void) editClassGroup:(NSString*)groupid withBreifIntroduction:(NSString*)briefintro withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:groupid]) {
        return;
    }
    
    NSString* str = [WT_EDIT_GROUP_INFO stringByAppendingString:groupid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:str taskInfo:nil taskType:WT_EDIT_GROUP_INFO notificationName:WT_EDIT_GROUP_INFO notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Communicator_EditGroupInfo* netIFCommunicator = [[Communicator_EditGroupInfo alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postValues = [WowTalkWebServerIF basicValueArrayWithAction:WT_EDIT_GROUP_INFO];
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    
    
    [postValues addObject:groupid];
    [postKeys addObject:@"group_id"];
    
    
    if (![NSString isEmptyString:briefintro]) {
        [postValues addObject:briefintro];
        [postKeys addObject:@"intro"];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
}




#pragma mark -
#pragma mark - send emergency message
+(void)sendEmergencyMessage:(NSString*)status withMessage:(NSString*)message withLatitude:(NSString*)latitude withLongitude:(NSString*)longitude withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_SEND_ENMERGENCY_MESSAGE taskInfo:nil taskType:WT_SEND_ENMERGENCY_MESSAGE notificationName:WT_SEND_ENMERGENCY_MESSAGE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_SendEmergencyMessage* netIFCommunicator = [[Communicator_SendEmergencyMessage alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_SEND_ENMERGENCY_MESSAGE];
    
    [postKeys addObject:@"corp_id"]; [postValues addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"companyid"]];
    [postKeys addObject:@"emergency_status"]; [postValues addObject:status];
    if (![NSString isEmptyString:message]) {
        [postKeys addObject:@"message"]; [postValues addObject:message];
    }
    if (![NSString isEmptyString:latitude]) {
        [postKeys addObject:@"latitude"]; [postValues addObject:latitude];
    }
    
    if (![NSString isEmptyString:longitude]) {
        [postKeys addObject:@"longitude"]; [postValues addObject:longitude];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

#pragma mark -
#pragma mark - Biz group

+(void)getCompanyStructure:(NSString*)companyid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_COMPANY_STRUCTURE taskInfo:nil taskType:WT_GET_COMPANY_STRUCTURE notificationName:WT_GET_COMPANY_STRUCTURE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetCompanyStructure* netIFCommunicator = [[Communicator_GetCompanyStructure alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_GET_COMPANY_STRUCTURE];
    
    [postKeys addObject:@"corp_id"]; [postValues addObject:companyid];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}
+(void)getMembersInDepartment:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    NSString* uniquestr = [WT_GET_MEMBERS_IN_DEPARTMENT stringByAppendingString:groupid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_MEMBERS_IN_DEPARTMENT notificationName:WT_GET_MEMBERS_IN_DEPARTMENT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    Communicator_GetAllMembersInDepartment* netIFCommunicator = [[Communicator_GetAllMembersInDepartment alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.departmentid = groupid;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_GET_MEMBERS_IN_DEPARTMENT];
    
    [postKeys addObject:@"group_id"]; [postValues addObject:groupid];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}

#pragma mark -
#pragma mark Favorite related
+(void)favoriteBuddy:(NSString*)buddyid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:[WT_FAVORITE_A_BUDDY stringByAppendingString:buddyid] taskInfo:nil taskType:WT_FAVORITE_A_BUDDY notificationName:WT_FAVORITE_A_BUDDY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_FavoriteABuddy* netIFCommunicator = [[Communicator_FavoriteABuddy alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_FAVORITE_A_BUDDY];
    
    [postKeys addObject:@"item"];
    [postValues addObject:buddyid];
    
    [postKeys addObject:@"is_favorite"];
    [postValues addObject:@"1"];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}
+(void)favoriteBuddies:(NSArray*)buddylist withCallback:(SEL)selector withObserver:(id)observer
{
    
}
+(void)favoriteGroup:(NSString*)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:[WT_FAVORITE_A_GROUP stringByAppendingString:groupid] taskInfo:nil taskType:WT_FAVORITE_A_GROUP notificationName:WT_FAVORITE_A_GROUP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_FavoriteAGroup* netIFCommunicator = [[Communicator_FavoriteAGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_FAVORITE_A_GROUP];
    
    [postKeys addObject:@"item"];
    [postValues addObject:groupid];
    
    [postKeys addObject:@"is_favorite"];
    [postValues addObject:@"1"];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}
+(void)favoriteGroups:(NSArray*)grouplist withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_FAVORITE_GROUPS taskInfo:nil taskType:WT_FAVORITE_GROUPS notificationName:WT_FAVORITE_GROUPS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_FavoriteGroups* netIFCommunicator = [[Communicator_FavoriteGroups alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_FAVORITE_GROUPS];
    for (NSString* groupid in grouplist) {
        [postKeys addObject:@"item[]"]; [postValues addObject:groupid];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
    
    
}

+(void)defavoriteBuddy:(NSString*)buddyid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:[WT_DEFAVORITE_BUDDY stringByAppendingString:buddyid] taskInfo:nil taskType:WT_DEFAVORITE_BUDDY notificationName:WT_DEFAVORITE_BUDDY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_DefavoriteBuddy* netIFCommunicator = [[Communicator_DefavoriteBuddy alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_FAVORITE_A_BUDDY];
    
    [postKeys addObject:@"item"];
    [postValues addObject:buddyid];
    
    [postKeys addObject:@"is_favorite"];
    [postValues addObject:@"0"];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}
+(void)defavoriteGroup:(NSString *)groupid withCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:[WT_DEFAVORITE_GROUP stringByAppendingString:groupid] taskInfo:nil taskType:WT_DEFAVORITE_GROUP notificationName:WT_DEFAVORITE_GROUP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_DefavoriteGroup* netIFCommunicator = [[Communicator_DefavoriteGroup alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_FAVORITE_A_GROUP];
    
    [postKeys addObject:@"item"];
    [postValues addObject:groupid];
    
    [postKeys addObject:@"is_favorite"];
    [postValues addObject:@"0"];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

+(void)getFavoritedItemsWithCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_FAVORITE_ITEMS taskInfo:nil taskType:WT_GET_FAVORITE_ITEMS notificationName:WT_GET_FAVORITE_ITEMS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetAllFavoriteItems* netIFCommunicator = [[Communicator_GetAllFavoriteItems alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postValues =[WowTalkWebServerIF basicValueArrayWithAction:WT_GET_FAVORITE_ITEMS];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}


#pragma mark -
#pragma mark Privacy Setting



+(void)   setPrivacy_peopleCanAddMe:(int) peopleCanAddMe
              unknowPeopleCanCallMe:(int) unknowPeopleCanCallMe
           unknowPeopleCanMessageMe:(int) unknowPeopleCanMessageMe
          shouldShowMsgDetailInPush:(int) shouldShowMsgDetailInPush
                       ListMeNearBy:  (int)listMeNearby
                       withCallback:(SEL)selector
                       withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_SET_PRIVACY taskInfo:nil taskType:WT_SET_PRIVACY notificationName:WT_SET_PRIVACY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_NoDataFeedback* netIFCommunicator = [[Communicator_NoDataFeedback alloc] init];
    netIFCommunicator.delegate = task;
    
    // [netIFCommunicator fPost:strPost];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"update_privacy_setting"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    if (peopleCanAddMe > -1) {
        [postKeys addObject:@"people_can_add_me"]; [postValues addObject:[NSString stringWithFormat:@"%d",peopleCanAddMe]];
    }
    if (unknowPeopleCanCallMe > -1) {
        [postKeys addObject:@"unknown_buddy_can_call_me"]; [postValues addObject:[NSString stringWithFormat:@"%d",unknowPeopleCanCallMe]];
    }
    if (unknowPeopleCanMessageMe > -1) {
        [postKeys addObject:@"unknown_buddy_can_message_me"]; [postValues addObject:[NSString stringWithFormat:@"%d",unknowPeopleCanMessageMe]];
    }
    if (shouldShowMsgDetailInPush > -1) {
        [postKeys addObject:@"push_show_detail_flag"]; [postValues addObject:[NSString stringWithFormat:@"%d",shouldShowMsgDetailInPush]];
    }
    if (listMeNearby > -1) {
        [postKeys addObject:@"list_me_in_nearby_result"]; [postValues addObject:[NSString stringWithFormat:@"%d",listMeNearby]];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
    
}

+(void)  getPrivacySettingWithCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_PRIVACY_SETTING taskInfo:nil taskType:WT_GET_PRIVACY_SETTING notificationName:WT_GET_PRIVACY_SETTING notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetPrivacySetting* netIFCommunicator = [[Communicator_GetPrivacySetting alloc] init];
    netIFCommunicator.delegate = task;
    
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_privacy_setting"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
}


#pragma mark -
#pragma mark account deactive

+(void) accountDeactiveWithCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    // NSString* strPost=[NSString stringWithFormat:@"action=account_deactive&uid=%@&password=%@",
    //                    strUID,strPwd];
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_DEACTIVE_ACCOUNT taskInfo:nil taskType:WT_DEACTIVE_ACCOUNT notificationName:WT_DEACTIVE_ACCOUNT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_AccountDeactive* netIFCommunicator = [[Communicator_AccountDeactive alloc] init];
    netIFCommunicator.delegate = task;
    
    //[netIFCommunicator fPost:strPost];
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"account_deactive"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
    
}


#pragma mark - Device compatibility
+(void)  getUnsupportedDeviceListWithCallback:(SEL)selector withObserver:(id)observer
{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_UNSUPPORTED_DEVICE taskInfo:nil taskType:WT_GET_UNSUPPORTED_DEVICE notificationName:WT_GET_UNSUPPORTED_DEVICE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_GetVideoCallUnsupportedDeviceList* netIFCommunicator = [[Communicator_GetVideoCallUnsupportedDeviceList alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_videocall_unsupported_device_list"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
}

#pragma mark - Time compatibility
+(void)  adjustUTCTimeWithCallback:(SEL)selector withObserver:(id)observer{
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_ADJUST_UTC_TIME_WITH_SERVER taskInfo:nil taskType:WT_ADJUST_UTC_TIME_WITH_SERVER notificationName:WT_ADJUST_UTC_TIME_WITH_SERVER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    if ([NSString isEmptyString:strUID] || [NSString isEmptyString:strPwd]) {
        return;
    }
    
    Communicator_AdjustUTCTimeWithServer* netIFCommunicator = [[Communicator_AdjustUTCTimeWithServer alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_server_utc_timestamp"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
    
}

#pragma mark - App type relate
+(void)  setActiveAppType:(NSString*) strAppType withCallback:(SEL)selector withObserver:(id)observer
{
    if(strAppType==nil) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_SET_ACTIVE_APP_TYPE taskInfo:nil taskType:WT_SET_ACTIVE_APP_TYPE notificationName:WT_SET_ACTIVE_APP_TYPE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_NoDataFeedback* netIFCommunicator = [[Communicator_NoDataFeedback alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"set_active_app_type"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    [postKeys addObject:@"app_type"]; [postValues addObject:strAppType];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
    
}


+(void)  getActiveAppTypeWithCallback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_ACTIVE_APP_TYPE taskInfo:nil taskType:WT_GET_ACTIVE_APP_TYPE notificationName:WT_GET_ACTIVE_APP_TYPE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    NSString* strUID =	[WTUserDefaults getUid];
    NSString* strPwd =	[WTUserDefaults getHashedPassword];
    
    Communicator_GetActiveAppType* netIFCommunicator = [[Communicator_GetActiveAppType alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postKeys =[[NSMutableArray alloc]init];
    NSMutableArray* postValues =[[NSMutableArray alloc]init];
    [postKeys addObject:@"action"]; [postValues addObject:@"get_active_app_type"];
    [postKeys addObject:@"uid"]; [postValues addObject:strUID];
    [postKeys addObject:@"password"]; [postValues addObject:strPwd];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
}

#pragma mark - Register and login
+ (void)autoRegisterWithCallback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_AUTO_REGISTER taskInfo:nil taskType:WT_AUTO_REGISTER notificationName:WT_AUTO_REGISTER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_Register *netIFCommunicator = [[Communicator_Register alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_AUTO_REGISTER, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}

+ (void)registerWithMail:(NSString *)mailAddress password:(NSString *)password withCallback:(SEL)selector withObserver:(id)observer
{
    if(mailAddress == nil){
        return;
    }
    
    if (password == nil){
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REGISTER_WITH_MAIL taskInfo:nil taskType:WT_REGISTER_WITH_MAIL notificationName:WT_REGISTER_WITH_MAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_Register *netIFCommunicator = [[Communicator_Register alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, MAIL_ADDRESS, PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_REGISTER_WITH_MAIL, mailAddress, password, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)registerWithUserid:(NSString *)userid password:(NSString *)password withCallback:(SEL)selector withObserver:(id)observer
{
    if(userid == nil || password ==nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REGISTER_WITH_USERID taskInfo:nil taskType:WT_REGISTER_WITH_USERID notificationName:WT_REGISTER_WITH_USERID notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_Register *netIFCommunicator = [[Communicator_Register alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, @"user", PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_REGISTER_WITH_USERID, userid, password, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+ (void)registerWithUserid:(NSString *)userid password:(NSString *)password withUserType:(NSString*)user_type withCallback:(SEL)selector withObserver:(id)observer
{
    if(userid == nil || password ==nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REGISTER_WITH_USERID taskInfo:nil taskType:WT_REGISTER_WITH_USERID notificationName:WT_REGISTER_WITH_USERID notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    if (user_type==nil) {
        user_type=@"1";
    }
    
    Communicator_Register *netIFCommunicator = [[Communicator_Register alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, @"user", PASSWORD,@"user_type", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_REGISTER_WITH_USERID, userid, password,user_type, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+ (void)loginWithUserinfo:(NSString *)userinfo password:(NSString *)password withLatitude:(CLLocationDegrees)lati withLongti:(CLLocationDegrees)longtitude withCallback:(SEL)selector withObserver:(id)observer
{
    if(userinfo == nil || password==nil){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_LOGIN_WITH_USER taskInfo:nil taskType:WT_LOGIN_WITH_USER notificationName:WT_LOGIN_WITH_USER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    Communicator_Login *netIFCommunicator = [[Communicator_Login alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, @"user", @"plain_password", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_LOGIN_WITH_USER, userinfo, password, nil] autorelease];
    if (0 != lati && 0 != longtitude) {
        [postKeys addObject:@"latitude"];
        [postKeys addObject:@"longitude"];
        
        [postValues addObject:[NSString stringWithFormat:@"%f",lati]];
        [postValues addObject:[NSString stringWithFormat:@"%f",longtitude]];
    }
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)loginWithEmail:(NSString *)email password:(NSString *)password withLatitude:(CLLocationDegrees)lati withLongti:(CLLocationDegrees)longtitude withCallBack:(SEL)selector withObserver:(id)observer
{
    if(email == nil){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    if (password == nil){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:@"login_by_email" taskInfo:nil taskType:@"login_by_email" notificationName:@"login_by_email" notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    Communicator_LoginWithEmail *netIFCommunicator = [[Communicator_LoginWithEmail alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, @"email", @"plain_password", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:@"login_by_email", email, password, nil] autorelease];
    
    if (0 != lati && 0 != longtitude) {
        [postKeys addObject:@"latitude"];
        [postKeys addObject:@"longitude"];
        
        [postValues addObject:[NSString stringWithFormat:@"%f",lati]];
        [postValues addObject:[NSString stringWithFormat:@"%f",longtitude]];
    }
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)logoutWithCallback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_LOGOUT taskInfo:nil taskType:WT_LOGOUT notificationName:WT_LOGOUT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_Logout *netIFCommunicator = [[Communicator_Logout alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_LOGOUT, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)changeWowtalkID:(NSString *)wowtalkid withCallback:(SEL)selector withObserver:(id)observer
{
    if (wowtalkid == nil)
        return;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:wowtalkid,@"wowtalkid",nil];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_CHANGE_WOWTALK_ID taskInfo:nil taskType:WT_CHANGE_WOWTALK_ID notificationName:WT_CHANGE_WOWTALK_ID notificationObserver:observer userInfo:userInfo selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_ChangeWowtalkID *netIFCommunicator = [[Communicator_ChangeWowtalkID alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"new_wowtalk_id", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_CHANGE_WOWTALK_ID, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], wowtalkid, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)changePassword:(NSString *)password  withOldPassword:(NSString*)oldpassword withCallback:(SEL)selector withObserver:(id)observer
{
    if (password == nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_CHANGE_PASSWORD taskInfo:nil taskType:WT_CHANGE_PASSWORD notificationName:WT_CHANGE_PASSWORD notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_ChangePassword *netIFCommunicator = [[Communicator_ChangePassword alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, NEW_PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_CHANGE_PASSWORD, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], password, nil] autorelease];
    
    if (oldpassword != nil) {
        [postKeys addObject:@"old_plain_password"];
        [postValues addObject:oldpassword];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}



+ (void)bindEmail:(NSString *)email withCallback:(SEL)selector withObserver:(id)observer
{
    if (email == nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_BIND_EMAIL taskInfo:nil taskType:WT_BIND_EMAIL notificationName:WT_BIND_EMAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_BindEmail *netIFCommunicator = [[Communicator_BindEmail alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, EMAIL_ADDRESS, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_BIND_EMAIL, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], email, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)bindPhoneNumber:(NSString *)phoneNumber withCallback:(SEL)selector withObserver:(id)observer
{
    if (phoneNumber == nil)
    {
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_BIND_PHONE_NUMBER taskInfo:nil taskType:WT_BIND_PHONE_NUMBER notificationName:WT_BIND_PHONE_NUMBER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_BindPhoneNumber *netIFCommunicator = [[Communicator_BindPhoneNumber alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, PHONE_NUMBER, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_BIND_PHONE_NUMBER, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], phoneNumber, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)verifyEmail:(NSString *)accessCode withCallback:(SEL)selector withObserver:(id)observer
{
    if (accessCode == nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_VERIFY_EMAIL taskInfo:nil taskType:WT_VERIFY_EMAIL notificationName:WT_VERIFY_EMAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_VerifyEmail *netIFCommunicator = [[Communicator_VerifyEmail alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, ACCESS_CODE, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_VERIFY_EMAIL, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], accessCode, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)verifyPhoneNumber:(NSString *)accessCode withCallback:(SEL)selector withObserver:(id)observer
{
    if (accessCode == nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_VERIFY_PHONE_NUMBER taskInfo:nil taskType:WT_VERIFY_PHONE_NUMBER notificationName:WT_VERIFY_PHONE_NUMBER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_VerifyPhoneNumber *netIFCommunicator = [[Communicator_VerifyPhoneNumber alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, ACCESS_CODE, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_VERIFY_PHONE_NUMBER, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], accessCode, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+(void)unLinkEmail:(NSString*)password withCallback:(SEL)selector withObserver:(id)observer
{
    if (password == nil || [password isEqualToString:@""]) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UNLINK_EMAIL taskInfo:nil taskType:WT_UNLINK_EMAIL notificationName:WT_UNLINK_EMAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_Unlink *netIFCommunicator = [[Communicator_Unlink alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.unlinkEmail = TRUE;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_UNLINK_EMAIL, [WTUserDefaults getUid], password, nil] autorelease];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+(void)unLinkMobile:(NSString*)password withCallback:(SEL)selector withObserver:(id)observer
{
    if (password == nil || [password isEqualToString:@""]) {
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UNLINK_PHONE_NUMBER taskInfo:nil taskType:WT_UNLINK_PHONE_NUMBER notificationName:WT_UNLINK_PHONE_NUMBER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_Unlink *netIFCommunicator = [[Communicator_Unlink alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.unlinkEmail = FALSE;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_UNLINK_PHONE_NUMBER, [WTUserDefaults getUid], password, nil] autorelease];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)sendAccessCodeForUid:(NSString *)userid toDes:(NSString *)des withCallback:(SEL)selector withObserver:(id)observer
{
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_SEND_ACCESS_CODE taskInfo:nil taskType:WT_SEND_ACCESS_CODE notificationName:WT_SEND_ACCESS_CODE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_SendAccessCode * netIFCommunicator = [[Communicator_SendAccessCode alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, WT_ID, METHOD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_SEND_ACCESS_CODE, userid, des, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)resetPasswordForID:(NSString *)userid pwd:(NSString *)password accessCode:(NSString *)accessCode withCallback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_RESET_PASSWORD taskInfo:nil taskType:WT_RESET_PASSWORD notificationName:WT_RESET_PASSWORD notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_ResetPassword *netIFCommunicator = [[Communicator_ResetPassword alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, WT_ID, PASSWORD, VERIFY_CODE, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_RESET_PASSWORD, userid, password, accessCode, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

// add by liuhuan
+ (void)BlidingEmail:(NSString *)Email WithCallback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_EMAIL_ADDRESS taskInfo:nil taskType:WT_EMAIL_ADDRESS notificationName:WT_EMAIL_ADDRESS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_BlidingEmail *netIFCommunicator = [[Communicator_BlidingEmail alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,EMAIL_ADDRESS, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:@"bind_email", [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],Email, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}
+ (void)GetBindEmailStatusWithCallback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_BIND_EMAIL_STATUS taskInfo:nil taskType:WT_BIND_EMAIL_STATUS notificationName:WT_BIND_EMAIL_STATUS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_BlidingEmail *netIFCommunicator = [[Communicator_BlidingEmail alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_BIND_EMAIL_STATUS, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}
+ (void)GetVerifyCodeWithAccessCode:(NSString *)accessCode andEmail:(NSString *)email Callback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_VERIFY_EMAIL taskInfo:nil taskType:WT_VERIFY_EMAIL notificationName:WT_VERIFY_EMAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_VerifyCode *netIFCommunicator = [[Communicator_VerifyCode alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"access_code",@"email_address",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_VERIFY_EMAIL, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],accessCode,email, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}
+ (void)unBindEmail:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UNBIND_EMAIL taskInfo:nil taskType:WT_UNBIND_EMAIL notificationName:WT_UNBIND_EMAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_UnbindEmail *netIFCommunicator = [[Communicator_UnbindEmail alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_UNBIND_EMAIL, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}
+ (void)retrievePasswordWithWowtalkID:(NSString *)wowtalkID andEmail:(NSString *)email Callback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_SEND_CODEFOR_RETRPASS taskInfo:nil taskType:WT_SEND_CODEFOR_RETRPASS notificationName:WT_SEND_CODEFOR_RETRPASS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_FindPass *netIFCommunicator = [[Communicator_FindPass alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, WT_ID, EMAIL_ADDRESS, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_SEND_CODEFOR_RETRPASS, wowtalkID, email, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}
+ (void)checkCodeForRetrievePassword:(NSString *)wowtalk_id andAccessCode:(NSString *)accessCode Callback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_CHECK_CODEFOR_RETPASS taskInfo:nil taskType:WT_CHECK_CODEFOR_RETPASS notificationName:WT_CHECK_CODEFOR_RETPASS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start])return;
    
    Communicator_FindPass *netIFCommunicator = [[Communicator_FindPass alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, WT_ID, ACCESS_CODE, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_CHECK_CODEFOR_RETPASS, wowtalk_id, accessCode, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}
+ (void)retrievePasswordWithWowtalkID:(NSString *)wowtalkID andNewPassword:(NSString *)Password Callback:(SEL)selector withObserver:(id)observer
{
    if (wowtalkID.length == 0
        || Password.length == 0){
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_RETRIVE_PASS taskInfo:nil taskType:WT_RETRIVE_PASS notificationName:WT_RETRIVE_PASS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_FindPass *netIFCommunicator = [[Communicator_FindPass alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, WT_ID, HASHED_PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_RETRIVE_PASS, wowtalkID, Password, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}
#pragma mark - Event

+ (void)getEventInfoWithEventId:(NSString *)event_id WihtCallBack:(SEL)selector withObserver:(id)observer{
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:@"get_event_info" taskInfo:nil taskType:@"get_event_info" notificationName:@"get_event_info" notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetEventInfoNew *netIFCommunitor = [[Communicator_GetEventInfoNew alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects: UUID, HASHED_PASSWORD,ACTION,@"event_id", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:[WTUserDefaults getUid], [WTUserDefaults getHashedPassword],@"get_event_info", event_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}

+ (void)applyEventWithEventId:(NSString *)event_id withApplyMessage:(NSString *)apply_message withMemberInfo:(NSMutableDictionary *)member_info withCallBack:(SEL)selector withObserver:(id)observer{
    
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:@"join_event" taskInfo:nil taskType:@"join_event" notificationName:@"join_event" notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_ApplyEvent *netIFCommunitor = [[Communicator_ApplyEvent alloc]init];
    netIFCommunitor.delegate = task;
    
    if (member_info[@"real_name"] && member_info[@"telephone_number"]){
        NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects: UUID, HASHED_PASSWORD,ACTION,@"event_id" , @"apply_message", @"real_name",@"telephone_number",nil] autorelease];
        NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:[WTUserDefaults getUid], [WTUserDefaults getHashedPassword],@"join_event", event_id,apply_message,member_info[@"real_name"],member_info[@"telephone_number"],nil] autorelease];
        [netIFCommunitor fPost:postKeys withPostValue:postValues];

    }else{
        NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects: UUID, HASHED_PASSWORD,ACTION,@"event_id" , @"apply_message",nil] autorelease];
        NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:[WTUserDefaults getUid], [WTUserDefaults getHashedPassword],@"join_event", event_id,apply_message,nil] autorelease];
        [netIFCommunitor fPost:postKeys withPostValue:postValues];
    }
    
}


+ (void)cancelEventWithEventId:(NSString *)event_id withCallBack:(SEL)selector withObserver:(id)observer{
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:@"cancel_join_event" taskInfo:nil taskType:@"cancel_join_event" notificationName:@"cancel_join_event" notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_CancelEvent *netIFCommunitor = [[Communicator_CancelEvent alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects: UUID, HASHED_PASSWORD,ACTION,@"event_id", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:[WTUserDefaults getUid], [WTUserDefaults getHashedPassword],@"cancel_join_event", event_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}




+ (void)uploadEventWithCallBack:(SEL)selector withType:(NSString *)type withTextTitle:(NSString *)textTitle withTextContent:(NSString *)textContent andClassifition:(NSString *)classifition withDateInfo:(NSString *)dateInfo withArea:(NSString *)area withMaxMember:(NSString *)maxMember withCoin:(NSString *)coin withIsGetMemberInfo:(NSString *)isGetMemberInfo withIsOpen:(NSString *)isOpen withStartDate:(NSString *)startDate withEndDate:(NSString * )endDate withObserver:(id)observer{
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:@"add_event" taskInfo:nil taskType:@"add_event" notificationName:@"add_event" notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_AddEvent *netIFCommunitor = [[Communicator_AddEvent alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"type" , @"text_title", @"text_content", @"date_info", @"area", @"max_member", @"coin", @"is_get_member_info", @"is_open",@"startdate",@"enddate", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:@"add_event", [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],type,textTitle,textContent,dateInfo,area,maxMember,coin,isGetMemberInfo,isOpen,startDate,endDate,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
    
    
    
    
}

+ (void)getAllEventswithMaxStartTime:(NSString *)MaxStartTime withFinishedState:(NSString *)finishedState withCallback:(SEL)selector withObserver:(id)observer;
{
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:@"get_all_events" taskInfo:nil taskType:@"get_all_events" notificationName:@"get_all_events" notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetAllEvents *netIFCommunitor = [[Communicator_GetAllEvents alloc] init];
    netIFCommunitor.delegate = task;
    NSMutableArray *postKeys = nil;
    NSMutableArray *postValues = nil;
    if (MaxStartTime == nil){
        postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, nil] autorelease];
        postValues = [[[NSMutableArray alloc] initWithObjects:@"get_all_events", [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],nil] autorelease];
    }else {
        postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"max_startdate",nil] autorelease];
        postValues = [[[NSMutableArray alloc] initWithObjects:@"get_all_events", [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],MaxStartTime,nil] autorelease];
    }
    if (finishedState != nil){
        [postKeys addObject:@"get_finished_event_only"];
        [postValues addObject:finishedState];
    }
    netIFCommunitor.isFirstPage = YES;
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}

+ (void)getLatestEventswithNumber:(int)number withStartTime:(NSString *)startTime withInsertTime:(NSString *)insertTime withCallback:(SEL)selector withObserver:(id)observer
{
    if (number == 0) {
        number = 20;
    }
    
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_LATEST_EVENTS taskInfo:nil taskType:WT_GET_LATEST_EVENTS notificationName:WT_GET_LATEST_EVENTS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetLatestEvents *netIFCommunitor = [[Communicator_GetLatestEvents alloc] init];
    netIFCommunitor.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"event_number", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_LATEST_EVENTS, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], [NSNumber numberWithInt:number], nil] autorelease];
    if (![NSString isEmptyString:startTime] && ![NSString isEmptyString:insertTime]) {
        [postKeys addObject:@"start_time"];
        [postValues addObject:startTime];
        
        [postKeys addObject:@"insert_time"];
        [postValues addObject:insertTime];
        netIFCommunitor.isFirstPage = NO;
    } else {
        netIFCommunitor.isFirstPage = YES;
    }
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}


+ (void)getLatestEvents:(int)num withCallback:(SEL)selector withObserver:(id)observer
{
    if (num == 0) {
        num = 20;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_LATEST_EVENTS taskInfo:nil taskType:WT_GET_LATEST_EVENTS notificationName:WT_GET_LATEST_EVENTS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetLatestEvents *netIFCommunicator = [[Communicator_GetLatestEvents alloc] init];
    netIFCommunicator.isFirstPage = YES;
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"event_number", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_LATEST_EVENTS, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], [NSNumber numberWithInt:num], nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}

+ (void)getPreviousEventsWithTimestamp:(int)timestamp WithNumber:(int)num withCallback:(SEL)selector withObserver:(id)observer
{
    if (num == 0) {
        num = 20;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_PREVIOUS_EVENTS taskInfo:nil taskType:WT_GET_PREVIOUS_EVENTS notificationName:WT_GET_PREVIOUS_EVENTS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetPreviousEvents *netIFCommunicator = [[Communicator_GetPreviousEvents alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"timestamp", @"event_number", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_PREVIOUS_EVENTS, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],[NSNumber numberWithInt:timestamp], [NSNumber numberWithInt:num], nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}

+ (void)joinEvent:(NSString *)eventId eventDate:(NSString *)date withCallback:(SEL)selector withObserver:(id)observer
{
    if ([NSString isEmptyString:eventId]) {
        return;
    }
    
    NSString *uniqueString = [WT_JOIN_EVENT stringByAppendingString:eventId];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueString taskInfo:nil taskType:WT_JOIN_EVENT notificationName:WT_JOIN_EVENT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_JoinEvent *netIFCommunitor = [[Communicator_JoinEvent alloc] init];
    netIFCommunitor.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, EVENT_ID, @"event_date", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_JOIN_EVENT, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], eventId, date, nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}

+ (void)joinEvent:(NSString *)eventId eventDate:(NSString *)date detail:(NSString *)detail withCallbacl:(SEL)selector withObserver:(id)observer
{
    if ([NSString isEmptyString:eventId]) {
        return;
    }
    
    NSString *uniqueKey = [WT_JOIN_EVENT_WITH_DETAIL stringByAppendingString:eventId];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueKey taskInfo:nil taskType:WT_JOIN_EVENT_WITH_DETAIL notificationName:WT_JOIN_EVENT_WITH_DETAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_JoinEventWithDetail *netIFCommunitor = [[Communicator_JoinEventWithDetail alloc] init];
    netIFCommunitor.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, EVENT_ID, EVENT_DATE, EVENT_DETAIL, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_JOIN_EVENT_WITH_DETAIL, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], eventId, date, detail, nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}


+ (void)cancelJoinTheEvent:(NSString *)eventid withCallback:(SEL)selector withObserver:(id)observer
{
    if ([NSString isEmptyString:eventid])
        return;
    
    NSString* uniquestr = [WT_CANCEL_THE_EVENT stringByAppendingString:eventid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_CANCEL_THE_EVENT notificationName:WT_CANCEL_THE_EVENT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_CancelJoinTheEvent *netIFCommunicator = [[Communicator_CancelJoinTheEvent alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, EVENT_ID, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_CANCEL_THE_EVENT, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], eventid, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)getJoinedEventsWithNumber:(int)number withInsertTime:(NSString *)insertTime withCallback:(SEL)selector withObserver:(id)observer
{
    if (number == 0) {
        number = 20;
    }
    NSString *uniqueKey = [WT_GET_JOINED_EVENTS stringByAppendingString:insertTime];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueKey taskInfo:nil taskType:WT_GET_JOINED_EVENTS notificationName:WT_GET_JOINED_EVENTS notificationObserver:self userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetJoinedEventList *netIFCommunicator = [[Communicator_GetJoinedEventList alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"event_number", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_JOINED_EVENTS, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], [NSNumber numberWithInt:number], nil] autorelease];
    
    if ([NSString isEmptyString:insertTime]) {
        [postKeys addObject:@"insert_time"];
        [postValues addObject:insertTime];
    }
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+ (void)uploadEventMedia:(WTFile *)file withIndex:(NSInteger)index withCallback:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(USE_S3){
        NSString* unqstr = [WT_UPLOAD_EVENT_MEDIA_ORIGINAL stringByAppendingString:file.thumbnailid];
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:[NSDictionary dictionaryWithObjects:@[file,@(index)] forKeys:@[@"file",@"index"]] taskType:WT_UPLOAD_EVENT_MEDIA_ORIGINAL notificationName:WT_UPLOAD_EVENT_MEDIA_ORIGINAL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.isMediaThumbnail = NO;
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request = [netIFCommunicator uploadMomentMedia:file toDir:S3_EVENT_FILE_DIR forBucket:S3_BUCKET withExt:NO];
        
    }
    else{
        NSString* unqstr = [WT_UPLOAD_EVENT_MEDIA_ORIGINAL stringByAppendingString:file.thumbnailid];
        NSString *notificationName = [NSString stringWithFormat:@"%@%zi",WT_UPLOAD_EVENT_MEDIA_ORIGINAL,index];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:[NSDictionary dictionaryWithObjects:@[file,@(index)] forKeys:@[@"file",@"index"]] taskType:WT_UPLOAD_EVENT_MEDIA_ORIGINAL notificationName:notificationName notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.isMediaThumbnail = NO;
        
        [netIFCommunicator fInit];
        task.request = [netIFCommunicator uploadEventMedia:file toDir:S3_EVENT_FILE_DIR forBucket:S3_BUCKET];
    }
}
+ (void)uploadEventThumbnail:(WTFile *)file withIndex:(NSInteger)index withCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(USE_S3){
        
        NSString* unqstr = [WT_UPLOAD_EVENT_MEDIA_THUMBNAIL stringByAppendingString:file.thumbnailid];
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:[NSDictionary dictionaryWithObjects:@[file,@(index)] forKeys:@[@"file",@"index"]] taskType:WT_UPLOAD_EVENT_MEDIA_THUMBNAIL notificationName:WT_UPLOAD_EVENT_MEDIA_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.isMediaThumbnail = TRUE;
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request = [netIFCommunicator uploadMomentMedia:file toDir:S3_EVENT_FILE_DIR forBucket:S3_BUCKET withExt:NO];
        
    }
    else{
        NSString* unqstr = [WT_UPLOAD_EVENT_MEDIA_THUMBNAIL stringByAppendingString:file.thumbnailid];
        NSString *notificationName = [NSString stringWithFormat:@"%@%zi",WT_UPLOAD_EVENT_MEDIA_THUMBNAIL,index];
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:[NSDictionary dictionaryWithObjects:@[file,@(index)] forKeys:@[@"file",@"index"]] taskType:WT_UPLOAD_EVENT_MEDIA_THUMBNAIL notificationName:notificationName notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.isMediaThumbnail = TRUE;
        
        [netIFCommunicator fInit];
        task.request = [netIFCommunicator uploadEventMedia:file toDir:S3_EVENT_FILE_DIR forBucket:S3_BUCKET];
    }
}

+ (void)uploadEventFileId:(WTFile *)file withEventId:(NSString *)eventid withCallback:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:[NSString stringWithFormat:@"%@%@",UP_EVENT_MULTIMEDEA,file.fileid] taskInfo:nil taskType:UP_EVENT_MULTIMEDEA notificationName:[NSString stringWithFormat:@"%@%@",UP_EVENT_MULTIMEDEA,file.fileid] notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_uploadEventMultimedia *netIFCommunitor = [[Communicator_uploadEventMultimedia alloc]init];
    netIFCommunitor.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"event_id",@"multimedia_content_type",@"multimedia_content_path",@"multimedia_thumbnail_path",@"duration", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:@"upload_event_multimedia", [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],eventid,file.ext,file.fileid,file.thumbnailid,[NSString stringWithFormat:@"%f",file.duration],nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
    
}


+ (void)getEventMedia:(WTFile *)file isThumb:(BOOL)thumb showingOrder:(int)order withCallback:(SEL)selector withObserver:(id)observer
{
    if (file == nil) {
        return;
    }
    if (file.fileid == nil && file.thumbnailid == nil) {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:(thumb ?file.thumbnailid :file.fileid) forKey:@"fileName"];
    NSString *uniqueKey = nil;
    if (thumb){
        uniqueKey = [NSString stringWithFormat:@"%@%@",WT_DOWNLOAD_EVENT_MEDIA,file.thumbnailid];
    }else{
        uniqueKey = [NSString stringWithFormat:@"%@%@",WT_DOWNLOAD_EVENT_MEDIA,file.fileid];
    }
    
    if (USE_S3) {
        WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueKey taskInfo:dic taskType:WT_DOWNLOAD_EVENT_MEDIA notificationName:uniqueKey notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return  ;
        }
        Communicator_GetEventMedia *netCommunicator = [[Communicator_GetEventMedia alloc] init];
        netCommunicator.didFinishDelegate = task;
        netCommunicator.file = file;
        netCommunicator.isThumbnail = thumb;
        [netCommunicator setS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        if (thumb) {
            task.request = [netCommunicator getFileWithPath:[NSString stringWithFormat:@"%@%@", S3_EVENT_FILE_DIR, file.thumbnailid] fromBucket:S3_BUCKET];
        } else {
            task.request = [netCommunicator getFileWithPath:[NSString stringWithFormat:@"%@%@", S3_EVENT_FILE_DIR, file.fileid] fromBucket:S3_BUCKET];
        }
    }
    else{
        WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueKey taskInfo:dic taskType:WT_DOWNLOAD_EVENT_MEDIA notificationName:WT_DOWNLOAD_EVENT_MEDIA notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetEventmediaAliyun* netIFCommunicator = [[Communicator_GetEventmediaAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.file = file;
        netIFCommunicator.isThumb = thumb;
        
        [netIFCommunicator fInit];
        
        if (thumb) {
            task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_EVENT_FILE_DIR,file.thumbnailid] FromBucket:S3_BUCKET];
            
        }
        else{
            task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_EVENT_FILE_DIR,file.fileid] FromBucket:S3_BUCKET];
        }
    }
}

+ (void)getEventMediaWithID:(NSString *)fileId fileExt:(NSString *)fileExt showingOrder:(int)order withCallbacl:(SEL)selector withObserver:(id)observer
{
    if (fileId == nil) {
        return;
    }
    if ([NSString isEmptyString:fileExt]) {
        fileExt = @".jpg";
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    if (USE_S3) {
        WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:fileId taskInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:order] forKey:@"showingorder"] taskType:WT_DOWNLOAD_ALBUM_COVER notificationName:fileId notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return  ;
        }
        Communicator_GetEventMedia *netCommunicator = [[Communicator_GetEventMedia alloc] init];
        netCommunicator.didFinishDelegate = task;
        netCommunicator.fileId = fileId;
        [netCommunicator setS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request = [netCommunicator getFileWithPath:fileId fromBucket:S3_BUCKET];
        
    }
}
// get_event_members
// event_id
+ (void)getEventMembersListWithEventID:(NSString *)event_id withCallBack:(SEL)selector withObserver:(id)observer{
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if (event_id==nil) {
        NSLog(@"getEventMembersListWithEventID: event_id is nil");
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:GET_EVENT_MEMBERS taskInfo:nil taskType:GET_EVENT_MEMBERS notificationName:GET_EVENT_MEMBERS notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetEventMembers *netIFCommunitor = [[Communicator_GetEventMembers alloc]init];
    netIFCommunitor.delegate = task;
    netIFCommunitor.event_id = event_id;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD,@"event_id",nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:GET_EVENT_MEMBERS, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword],event_id,nil] autorelease];
    [netIFCommunitor fPost:postKeys withPostValue:postValues];
}


/*
 + (void)getEventDetail:(NSString *)eventID withCallback:(SEL)selector withObserver:(id)observer
 {
 if (eventID == nil)
 {
 return;
 }
 
 NSString* uniquestr = [WT_GET_EVENT_INFO stringByAppendingString:eventID];
 WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_EVENT_INFO notificationName:WT_GET_EVENT_INFO notificationObserver:observer userInfo:nil selector:selector];
 if (![task start]) {
 return;
 }
 
 Communicator_GetEventInfo *netIFCommunicator = [[Communicator_GetEventInfo alloc] init];
 netIFCommunicator.delegate = task;
 NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, EVENT_ID, nil] autorelease];
 NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_EVENT_INFO, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], eventID, nil] autorelease];
 [netIFCommunicator fPost:postKeys withPostValue:postValues];
 }
 
 + (void)getJoinableEventsWithCallback:(SEL)selector withObserver:(id)observer
 {
 WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_JOINABLE_EVENTS taskInfo:nil taskType:WT_GET_JOINABLE_EVENTS notificationName:WT_GET_JOINABLE_EVENTS notificationObserver:observer userInfo:nil selector:selector];
 if (![task start]) {
 return;
 }
 
 Communicator_GetJoinableEventList *netIFCommunicator = [[Communicator_GetJoinableEventList alloc] init];
 netIFCommunicator.delegate = task;
 NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, nil] autorelease];
 NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_JOINABLE_EVENTS, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], nil] autorelease];
 [netIFCommunicator fPost:postKeys withPostValue:postValues];
 }
 
 + (void)getJoinedEventsWithCallback:(SEL)selector withObserver:(id)observer
 {
 WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_JOINED_EVENTS taskInfo:nil taskType:WT_GET_JOINED_EVENTS notificationName:WT_GET_JOINED_EVENTS notificationObserver:observer userInfo:nil selector:selector];
 if (![task start]) {
 return;
 }
 
 Communicator_GetJoinedEventList *netIFCommunicator = [[Communicator_GetJoinedEventList alloc] init];
 netIFCommunicator.delegate = task;
 NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, nil] autorelease];
 NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_JOINED_EVENTS,  [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], nil] autorelease];
 [netIFCommunicator fPost:postKeys withPostValue:postValues];
 }
 */


#pragma mark - Moment



+ (void)addMoment:(NSString *)content isPublic:(BOOL)ispublic allowReview:(BOOL)allowReview Latitude:(NSString*)latitude Longitutde:(NSString*)longitude withPlace:(NSString*)place withMomentType:(NSString*)type  withSharerange:(NSArray*)groups withCallback:(SEL)selector withObserver:(id)observer
{
    if (content == nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_ADD_MOMENT taskInfo:nil taskType:WT_ADD_MOMENT notificationName:WT_ADD_MOMENT notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    NSString* publicstr = @"0";
    if (ispublic) {
        publicstr = @"1";
    }
    
    NSString* allowReviewstr = @"0";
    if (allowReview) {
        allowReviewstr = @"1";
    }
    
    Moment* moment = [[Moment alloc] initWithMomentID:nil withText:content withOwerID:[WTUserDefaults getUid] withUserType:[WTUserDefaults getUsertype] withNickname:[WTUserDefaults getNickname] withTimestamp:nil withLongitude:longitude withLatitude:latitude withPrivacyLevel:publicstr withAllowReview:allowReviewstr withLikedByMe:nil withPlacename:place withMomentType:type withDeadline:Nil];
    
    moment.viewableGroups = [NSMutableArray arrayWithArray:groups];
    
    Communicator_AddMoment *netIFCommunicator = [[Communicator_AddMoment alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.moment = moment;
    
    [moment release];
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, INSERT_LATITUDE, INSERT_LONGITUDE, TEXT_CONTENT, PRIVACY_LEVEL, ALLOW_REVIEW, @"tag", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_ADD_MOMENT,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],latitude,longitude,content,publicstr,allowReviewstr,type, nil] autorelease];
    
    if (place) {
        [postKeys addObject:MOMENT_PLACE];
        [postValues addObject:place];
    }
    
    
    if (groups != Nil && [groups count] >0 ) {
        for (NSString* groupid in groups) {
            [postKeys addObject:@"sharerange[]"];
            [postValues addObject:groupid];
        }
    }
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}



+ (void)addMomentToUploadParentsOpinion:(NSString *)content isPublic:(BOOL)ispublic allowReview:(BOOL)allowReview Latitude:(NSString*)latitude Longitutde:(NSString*)longitude withPlace:(NSString*)place withMomentType:(NSString*)type  withSharerange:(NSArray*)groups  withCallback:(SEL)selector withObserver:(id)observer
{
    if (content == nil)
        content = @"";
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_ADD_MOMENT taskInfo:nil taskType:WT_ADD_MOMENT notificationName:WT_ADD_MOMENT notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    NSString* publicstr = @"0";
    if (ispublic) {
        publicstr = @"1";
    }
    
    NSString* allowReviewstr = @"0";
    if (allowReview) {
        allowReviewstr = @"1";
    }
    
    Moment* moment = [[Moment alloc] initWithMomentID:nil withText:content withOwerID:[WTUserDefaults getUid] withUserType:[WTUserDefaults getUsertype] withNickname:[WTUserDefaults getNickname] withTimestamp:nil withLongitude:longitude withLatitude:latitude withPrivacyLevel:publicstr withAllowReview:allowReviewstr withLikedByMe:nil withPlacename:place withMomentType:type withDeadline:Nil];
    
    moment.viewableGroups = [NSMutableArray arrayWithArray:groups];
    
    Communicator_AddMoment *netIFCommunicator = [[Communicator_AddMoment alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.moment = moment;
    netIFCommunicator.isAnonymous = YES;
    
    [moment release];
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, INSERT_LATITUDE, INSERT_LONGITUDE, TEXT_CONTENT, PRIVACY_LEVEL, ALLOW_REVIEW,@"anonymous", @"tag", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_ADD_MOMENT,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],latitude,longitude,content,publicstr,allowReviewstr,@"1",type, nil] autorelease];
    
    if (place) {
        [postKeys addObject:MOMENT_PLACE];
        [postValues addObject:place];
    }
    
    
    if (groups != Nil && [groups count] >0 ) {
        for (NSString* groupid in groups) {
            [postKeys addObject:@"sharerange[]"];
            [postValues addObject:groupid];
        }
    }
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}




+ (void)addSurveyMoment:(NSString *)content isPublic:(BOOL)ispublic allowReview:(BOOL)allowReview Latitude:(NSString*)latitude Longitutde:(NSString*)longitude withPlace:(NSString*)place withDeadline:(NSString*)deadline isMultiSelection:(BOOL)multi_selection withOptions:(NSArray*)options  withSharerange:(NSArray*)groups withCallback:(SEL)selector withObserver:(id)observer
{
    if (content == nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_ADD_MOMENT_SURVEY taskInfo:nil taskType:WT_ADD_MOMENT_SURVEY notificationName:WT_ADD_MOMENT_SURVEY notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    NSString* publicstr = @"0";
    if (ispublic) {
        publicstr = @"1";
    }
    
    NSString* allowReviewstr = @"0";
    if (allowReview) {
        allowReviewstr = @"1";
    }
    
    NSString* type = nil;
    if (multi_selection) {
        type = @"4";
    }
    else{
        type = @"3";
    }
    
    Moment* moment = [[Moment alloc] initWithMomentID:nil withText:content withOwerID:[WTUserDefaults getUid] withUserType:[WTUserDefaults getUsertype] withNickname:[WTUserDefaults getNickname] withTimestamp:nil withLongitude:longitude withLatitude:latitude withPrivacyLevel:publicstr withAllowReview:allowReviewstr withLikedByMe:nil withPlacename:place withMomentType:type withDeadline:deadline];
    
    moment.viewableGroups = [NSMutableArray arrayWithArray:groups];
    
    Communicator_AddSurveyMoment *netIFCommunicator = [[Communicator_AddSurveyMoment alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.moment = moment;
    
    [moment release];
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, INSERT_LATITUDE, INSERT_LONGITUDE, TEXT_CONTENT, PRIVACY_LEVEL, ALLOW_REVIEW, @"allow_multichoice",@"deadline",@"with_detail_back", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_ADD_MOMENT_SURVEY,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],latitude,longitude,content,publicstr,allowReviewstr,[NSString stringWithFormat:@"%d",multi_selection], deadline,@"1", nil] autorelease];
    
    
    for (Option* option in options) {
        NSString* optionstr = option.desc;
        if ([NSString isEmptyString:optionstr]) {
            continue;
        }
        [postKeys addObject:@"option[]"]; [postValues addObject:optionstr];
    }
    
    
    if (place) {
        [postKeys addObject:MOMENT_PLACE];
        [postValues addObject:place];
    }
    
    
    if (groups != Nil && [groups count] >0 ) {
        for (NSString* groupid in groups) {
            [postKeys addObject:@"sharerange[]"];
            [postValues addObject:groupid];
        }
    }
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+(void)voteSurveryMoment:(NSString*)moment_id withOptions:(NSArray*)optionids withCallback:(SEL)selector withObserver:(id)observer
{
    if ([NSString isEmptyString:moment_id]) {
        return;
    }
    if (optionids == nil || [optionids count] == 0) {
        return;
    }
    
    NSString* uniquestr = [WT_VOTE_MOMENT_SURVEY stringByAppendingString:moment_id];
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_VOTE_MOMENT_SURVEY notificationName:WT_VOTE_MOMENT_SURVEY notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Communicator_VoteSurveyMoment* netIFCommunicator = [[Communicator_VoteSurveyMoment alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray* postkeys = [WowTalkWebServerIF basicKeyArray];
    NSMutableArray* postvalues = [WowTalkWebServerIF basicValueArrayWithAction:WT_VOTE_MOMENT_SURVEY];
    
    [postkeys addObject:@"moment_id"];
    [postvalues addObject:moment_id];
    
    if ([[optionids firstObject] isKindOfClass:[Option class]]){
        for (Option* option in optionids) {
            [postkeys addObject:@"option_id[]"];
            [postvalues addObject:[NSString stringWithFormat:@"%d", option.option_id]];
        }
    }else{
        for (MomentVoteCellModel *model in optionids){
            if (model.option.is_voted ){
                [postkeys addObject:@"option_id[]"];
                [postvalues addObject:[NSString stringWithFormat:@"%d", model.option.option_id]];
            }
        }
    }
    
    
    
    [postkeys addObject:@"with_detail_back"];
    [postvalues addObject:@"1"];
    
    [netIFCommunicator fPost:postkeys withPostValue:postvalues];
    
}

+ (void)uploadMomentMultimedia:(WTFile*)file  ForMoment:(NSString*)momentid  withCallback:(SEL)selector withObserver:(id)observer
{
    if (file == nil || momentid == nil)
        return;
    
    
    NSString* uniquestr= [WT_UPLOAD_MOMENT_MULTIMEDIA stringByAppendingString:file.fileid];
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:file forKey:@"file"] taskType:WT_UPLOAD_MOMENT_MULTIMEDIA notificationName:WT_UPLOAD_MOMENT_MULTIMEDIA notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_UploadMomentMultimedia *netIFCommunicator = [[Communicator_UploadMomentMultimedia alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, MOMENT_ID, MULTIMEDIA_CONTENT_TYPE, MULTIMEDIA_CONTENT_PATH,MULTIMEDIA_CONTENT_THUMB,@"duration", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_UPLOAD_MOMENT_MULTIMEDIA,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword], momentid,file.ext?file.ext:@"",file.fileid?file.fileid:@"", file.thumbnailid?file.thumbnailid:@"",[NSString stringWithFormat:@"%f",file.duration], nil] autorelease];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}



+ (void)deleteMoment:(NSString *)momentid withCallback:(SEL)selector withObserver:(id)observer
{
    if (momentid == nil)
        return;
    
    NSString* uniquestr = [WT_DELETE_MOMENT stringByAppendingString:momentid];
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_DELETE_MOMENT notificationName:WT_DELETE_MOMENT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_DeleteMoment *netIFCommunicator = [[Communicator_DeleteMoment alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.momentid = momentid;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, MOMENT_ID, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_DELETE_MOMENT,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],momentid, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+ (void)reviewMoment:(NSString *)momentid withType:(NSString *)type content:(NSString *)reviewContent withCallback:(SEL)selector withObserver:(id)observer
{
    if (momentid == nil)
        return;
    
    NSString* uniquestr = [WT_REVIEW_MOMENT stringByAppendingString:momentid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:momentid forKey:MOMENT_ID] taskType:WT_REVIEW_MOMENT notificationName:WT_REVIEW_MOMENT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_ReviewMoment *netIFCommunicator = [[Communicator_ReviewMoment alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.momentid = momentid;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, MOMENT_ID, COMMENT_TYPE, COMMENT, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_REVIEW_MOMENT,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],momentid,type,reviewContent?reviewContent:@"", nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)replyToReview:(NSString *)reviewid inMoment:(NSString*)momentid withType:(NSString *)type content:(NSString *)reviewContent withCallback:(SEL)selector withObserver:(id)observer
{
    if (momentid == nil || type == nil || reviewContent == nil)
        return;
    
    NSString* uniquestr = [WT_REPLY_TO_REVIEW stringByAppendingString:momentid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:momentid forKey:MOMENT_ID] taskType:WT_REPLY_TO_REVIEW notificationName:WT_REPLY_TO_REVIEW notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Communicator_ReviewMoment *netIFCommunicator = [[Communicator_ReviewMoment alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.momentid = momentid;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, MOMENT_ID, COMMENT_TYPE, COMMENT,REPLY_TO_REVIEW_ID, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_REPLY_TO_REVIEW,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],momentid,type,reviewContent,reviewid, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}

+ (void)deleteMomentReview:(NSString *)momentid reviewid:(NSString *)reviewid withCallback:(SEL)selector withObserver:(id)observer
{
    if (momentid == nil || reviewid == nil)
        return;
    
    NSString* uniquestr = [WT_DELETE_MOMENT_REVIEW stringByAppendingString:momentid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_DELETE_MOMENT_REVIEW notificationName:WT_DELETE_MOMENT_REVIEW notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    
    Communicator_DeleteMomentReview *netIFCommunicator = [[Communicator_DeleteMomentReview alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.momentid = momentid;
    netIFCommunicator.reviewid = reviewid;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, REVIEW_ID, MOMENT_ID, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_DELETE_MOMENT_REVIEW,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],reviewid,momentid, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)getMomentsOfGroup:(NSString*)groupid withMaxTimeStamp:(NSInteger)maxTimeStamp withTags:(NSArray*)tags withReview:(BOOL)needReview withCallback:(SEL)selector withObserver:(id)observer{
    
    if(groupid==nil){
        if(PRINT_LOG)NSLog(@"getMomentsOfGroup failed: groupid cannot be null");
        return;
    }
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_MOMENTS_FOR_GROUP taskInfo:nil taskType:WT_GET_MOMENTS_FOR_GROUP notificationName:WT_GET_MOMENTS_FOR_GROUP notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetMomentsForGroup *netIFCommunicator = [[Communicator_GetMomentsForGroup alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.maxTimestamp=maxTimeStamp;
    netIFCommunicator.gid=groupid;
    netIFCommunicator.momentTags=tags;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"with_review",@"group_id", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_MOMENTS_FOR_GROUP,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],needReview?@"1":@"0",groupid, nil] autorelease];
    
    if(maxTimeStamp>0){
        [postKeys addObject:MAX_TIMESTAMP];
        [postValues addObject:[NSString stringWithFormat:@"%zi",maxTimeStamp]];
    }
    
    for (NSNumber* number in tags) {
        [postKeys addObject:@"tag[]"];
        [postValues addObject:[NSString stringWithFormat:@"%zi",number.integerValue]];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}


+ (void)getMomentsOfAll:(NSInteger)maxTimeStamp withTags:(NSArray*)tags withReview:(BOOL)needReview withCallback:(SEL)selector withObserver:(id)observer{
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_MOMENTS_FOR_ALL_BUDDIES taskInfo:nil taskType:WT_GET_MOMENTS_FOR_ALL_BUDDIES notificationName:WT_GET_MOMENTS_FOR_ALL_BUDDIES notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetMomentForAll *netIFCommunicator = [[Communicator_GetMomentForAll alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"with_review", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_MOMENTS_FOR_ALL_BUDDIES,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],needReview?@"1":@"0", nil] autorelease];
    
    if(maxTimeStamp>0){
        [postKeys addObject:MAX_TIMESTAMP];
        [postValues addObject:[NSString stringWithFormat:@"%zi",maxTimeStamp]];
    }
    
    for (NSNumber* number in tags) {
        [postKeys addObject:@"tag[]"];
        [postValues addObject:[NSString stringWithFormat:@"%zi",number.integerValue]];
    }
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}
+ (void)getMomentForBuddy:(NSString *)buddyid withTags:(NSArray*)tags isWithReview:(BOOL)withReview beforeTimeStamp:(NSInteger)maxTimeStamp withCallback:(SEL)selector withObserver:(id)observer{
    if (buddyid == nil)
        return;
    
    NSString* uniquestr = [WT_GET_LATEST_MOMENT_FOR_BUDDY stringByAppendingString:buddyid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_LATEST_MOMENT_FOR_BUDDY notificationName:WT_GET_LATEST_MOMENT_FOR_BUDDY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetMomentForBuddy *netIFCommunicator = [[Communicator_GetMomentForBuddy alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.maxTimestamp=maxTimeStamp;
    netIFCommunicator.uid=buddyid;
    netIFCommunicator.momentTags=tags;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, OWNER_ID, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_LATEST_MOMENT_FOR_BUDDY,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],buddyid, nil] autorelease];
    
    if(withReview){
        [postKeys addObject:WITH_REVIEW];
        [postValues addObject:@"1"];
    }
    
    if(maxTimeStamp>0){
        [postKeys addObject:MAX_TIMESTAMP];
        [postValues addObject:[NSNumber numberWithInteger:maxTimeStamp]];
    }
    
    for (NSNumber* number in tags) {
        [postKeys addObject:@"tag[]"];
        [postValues addObject:[NSString stringWithFormat:@"%zi",number.integerValue]];
    }
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}


+ (void)getMomentMedia:(WTFile*)file isThumb:(BOOL)isthumb inShowingOrder:(int)order forMoment:(NSString*)momentid withCallback:(SEL)selector withObserver:(id)observer
{
    if (file == nil) {
        return;
    }
    if([NSString isEmptyString:file.fileid])
    {
        return;
    }
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if ([NSString isEmptyString:momentid]) {
        return;
    }
    
    if (isthumb) {
        [WTHelper WTLog: [NSString stringWithFormat:(@"%@, thumbnail: %@, showing order:%d"),file,file.thumbnailid, order]];
    }
    else
        [WTHelper WTLog: [NSString stringWithFormat:(@"%@, fileid: %@, showing order:%d"),file,file.fileid, order]];
    
    if(USE_S3){
        
        NSString* uniquestr;
        if (isthumb) {
            uniquestr = [WT_DOWNLOAD_MOMENT_MULTIMEDIA stringByAppendingString:file.thumbnailid];
        }
        else{
            uniquestr = [WT_DOWNLOAD_MOMENT_MULTIMEDIA stringByAppendingString:file.fileid];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        }
        
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:order],@"showingorder",momentid,@"momentid",Nil] taskType:WT_DOWNLOAD_MOMENT_MULTIMEDIA notificationName:uniquestr notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetMomentMedia* netIFCommunicator = [[Communicator_GetMomentMedia alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.file = file;
        netIFCommunicator.isThumb = isthumb;
        
        [netIFCommunicator fInitS3Setting];
        if (isthumb) {
            task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_MOMENT_FILE_DIR,file.thumbnailid] ];
        }
        else
            task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_MOMENT_FILE_DIR,file.fileid] ];
    }
    else{
        NSString* uniquestr;
        if (isthumb) {
            uniquestr = [WT_DOWNLOAD_MOMENT_MULTIMEDIA stringByAppendingString:file.thumbnailid];
        }
        else{
            uniquestr = [WT_DOWNLOAD_MOMENT_MULTIMEDIA stringByAppendingString:file.fileid];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        }
        
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:order],@"showingorder",momentid,@"momentid",Nil] taskType:WT_DOWNLOAD_MOMENT_MULTIMEDIA notificationName:uniquestr notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetMomentmediaAliyun* netIFCommunicator = [[Communicator_GetMomentmediaAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.file = file;
        netIFCommunicator.isThumb = isthumb;
        
        [netIFCommunicator fInit];
        
        if (isthumb) {
            task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_MOMENT_FILE_DIR,file.thumbnailid] FromBucket:S3_BUCKET];

        }        
        else{
            task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_MOMENT_FILE_DIR,file.fileid] FromBucket:S3_BUCKET];
        }
    }
}

//relative path.
+ (void)uploadMomentMedia:(WTFile *)file withCallback:(SEL)selector withObserver:(id)observer withExt:(BOOL)withExt
{
//    if(![NSFileManager hasFileAtPath:[NSFileManager absoluteFilePathForMediaThumb:file]]) {
//        return;
//    }
    if(![NSFileManager hasFileAtPath:[NSFileManager absoluteFilePathForMedia:file]]) {
        NSLog(@"%@ not exist",[NSFileManager absoluteFilePathForMedia:file]);
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(USE_S3){
        NSString* unqstr = [WT_UPLOAD_MOMENT_MEDIA_ORIGINAL stringByAppendingString:file.fileid];
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:[NSDictionary dictionaryWithObject:file forKey:@"file" ] taskType:WT_UPLOAD_MOMENT_MEDIA_ORIGINAL notificationName:WT_UPLOAD_MOMENT_MEDIA_ORIGINAL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request = [netIFCommunicator uploadMomentMedia:file toDir:S3_MOMENT_FILE_DIR forBucket:S3_BUCKET withExt:withExt];
    }
    else{
        NSString* unqstr = [WT_UPLOAD_MOMENT_MEDIA_ORIGINAL stringByAppendingString:file.fileid];
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:[NSDictionary dictionaryWithObject:file forKey:@"file" ] taskType:WT_UPLOAD_MOMENT_MEDIA_ORIGINAL notificationName:WT_UPLOAD_MOMENT_MEDIA_ORIGINAL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        
        
        [netIFCommunicator fInit];
        task.request = [netIFCommunicator uploadMomentMedia:file toDir:S3_MOMENT_FILE_DIR forBucket:S3_BUCKET withExt:withExt];
    }
    
}

+ (void)uploadMomentMediaThumbnail:(WTFile *)file withCallback:(SEL)selector withObserver:(id)observer
{
    if(![NSFileManager hasFileAtPath:[NSFileManager absoluteFilePathForMediaThumb:file]]) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(USE_S3){
        
        NSString* unqstr = [WT_UPLOAD_MOMENT_MEDIA_THUMBNAIL stringByAppendingString:file.thumbnailid];
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:[NSDictionary dictionaryWithObject:file forKey:@"file" ] taskType:WT_UPLOAD_MOMENT_MEDIA_THUMBNAIL notificationName:WT_UPLOAD_MOMENT_MEDIA_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.isMediaThumbnail = TRUE;
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request = [netIFCommunicator uploadMomentMedia:file toDir:S3_MOMENT_FILE_DIR forBucket:S3_BUCKET withExt:NO];
        
    }
    else{
        NSString* unqstr = [WT_UPLOAD_MOMENT_MEDIA_THUMBNAIL stringByAppendingString:file.thumbnailid];
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:unqstr taskInfo:[NSDictionary dictionaryWithObject:file forKey:@"file" ] taskType:WT_UPLOAD_MOMENT_MEDIA_THUMBNAIL notificationName:WT_UPLOAD_MOMENT_MEDIA_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            return;
        }
        
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.isMediaThumbnail = TRUE;
        
        [netIFCommunicator fInit];
        task.request = [netIFCommunicator uploadMomentMedia:file toDir:S3_MOMENT_FILE_DIR forBucket:S3_BUCKET withExt:NO];
    }
}

+(void)removeCoverImage:(CoverImage *)image withCallback:(SEL)selector withObserver:(id)observer
{
    
    if (image == nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_REMOVE_ALBUM_COVER taskInfo:nil taskType:WT_REMOVE_ALBUM_COVER notificationName:WT_REMOVE_ALBUM_COVER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_RemoveCover *netIFCommunicator = [[Communicator_RemoveCover alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.image = image;
    
    NSMutableArray *postKeys = [WowTalkWebServerIF basicKeyArray];
    NSMutableArray *postValues = [WowTalkWebServerIF basicValueArrayWithAction:WT_REMOVE_ALBUM_COVER];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}


+(void)uploadCoverImage:(CoverImage *)image withCallback:(SEL)selector withObserver:(id)observer
{
    if (image == nil)
        return;
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_SET_ALBUM_COVER taskInfo:nil taskType:WT_SET_ALBUM_COVER notificationName:WT_SET_ALBUM_COVER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_UpdateCover *netIFCommunicator = [[Communicator_UpdateCover alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.image = image;
    
    NSMutableArray *postKeys = [WowTalkWebServerIF basicKeyArray];
    NSMutableArray *postValues = [WowTalkWebServerIF basicValueArrayWithAction:WT_SET_ALBUM_COVER];
    
    [postKeys addObject:@"file_id"]; [postValues addObject:image.file_id];
    [postKeys addObject:@"ext"]; [postValues addObject:image.ext];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}


+(void)getCoverImage:(NSString *)buddyid withCallback:(SEL)selector withObserver:(id)observer
{
    if (buddyid == nil)
        return;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
    
    NSString* uniquestr = [WT_GET_ALBUM_COVER stringByAppendingString:buddyid];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_ALBUM_COVER notificationName:WT_GET_ALBUM_COVER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    Communicator_GetCover *netIFCommunicator = [[Communicator_GetCover alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [WowTalkWebServerIF basicKeyArray];
    NSMutableArray *postValues = [WowTalkWebServerIF basicValueArrayWithAction:WT_GET_ALBUM_COVER];
    
    netIFCommunicator.buddyid = buddyid;
    
    if (![buddyid isEqualToString:[WTUserDefaults getUid]]) {
        [postKeys addObject:@"owner_uid"]; [postValues addObject:buddyid];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postValues release];
    [postKeys release];
}


+ (void)getMomentForBuddy:(NSString *)buddyid withTags:(NSArray*)tags isWithReview:(BOOL)withReview withCallback:(SEL)selector withObserver:(id)observer
{
    [WowTalkWebServerIF getMomentForBuddy:buddyid withTags:(NSArray*)tags isWithReview:withReview beforeTimeStamp:-1 withCallback:selector withObserver:observer];
}



+ (void)getReviewForMoment:(NSString *)momentid withCallback:(SEL)selector withObserver:(id)observer
{
    if (momentid == nil)
        return;
    
    NSString* uniquestr = [WT_GET_REVIEW_FOR_MOMENT stringByAppendingString:momentid];
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_REVIEW_FOR_MOMENT notificationName:WT_GET_REVIEW_FOR_MOMENT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetReviewForMoment *netIFCommunicator = [[Communicator_GetReviewForMoment alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, MOMENT_ID, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_REVIEW_FOR_MOMENT,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],momentid, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)getReviewForMoment:(NSString *)momentid beforeReview:(NSString *)reviewid withCallback:(SEL)selector withObserver:(id)observer
{
    if (momentid == nil || reviewid == nil)
        return;
    
    NSString* uniquestr = [WT_GET_PREVIOUS_REVIEW_FOR_MOMENT stringByAppendingString:momentid];
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_GET_PREVIOUS_REVIEW_FOR_MOMENT notificationName:WT_GET_PREVIOUS_REVIEW_FOR_MOMENT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetReviewForMoment *netIFCommunicator = [[Communicator_GetReviewForMoment alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, MOMENT_ID,REVIEW_ID, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_PREVIOUS_REVIEW_FOR_MOMENT,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword],momentid,reviewid, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)getLatestReplyForMeWithCallback:(SEL)selector withObserver:(id)observer
{
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_LATEST_REVIEWS_FOR_ME taskInfo:nil taskType:WT_GET_LATEST_REVIEWS_FOR_ME notificationName:WT_GET_LATEST_REVIEWS_FOR_ME notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    Communicator_GetLatestReviewsForMe *netIFCommunicator = [[Communicator_GetLatestReviewsForMe alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_LATEST_REVIEWS_FOR_ME,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword], nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}

+ (void)setReviewAsRead:(NSArray *)reviewidarray withCallback:(SEL)selector withObserver:(id)observer
{
    if (reviewidarray == nil || [reviewidarray count] == 0) {
        return;
    }
    
    NSString* uniquestr = [WT_SET_REVIEW_STATUS_READ stringByAppendingString:[reviewidarray objectAtIndex:0]];
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_SET_REVIEW_STATUS_READ notificationName:WT_SET_REVIEW_STATUS_READ notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_SetReviewStatusRead *netIFCommunicator = [[Communicator_SetReviewStatusRead alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.reviews = reviewidarray;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_SET_REVIEW_STATUS_READ,[WTUserDefaults getUid],[WTUserDefaults getHashedPassword], nil] autorelease];
    
    for (NSString* reviewid in reviewidarray) {
        if (reviewid==nil) {
            continue;
        }
        [postKeys addObject:@"review_id_array[]"]; [postValues addObject:reviewid];
        
    }
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}


+(void)uploadCoverToServer:(CoverImage*)cover withCallback:(SEL)selector withObserver:(id)observer
{
    if (cover == nil)
        return;
    
    if(![NSFileManager mediafileExistedAtPath:[NSFileManager relativePathToDocumentFolderForFile:cover.file_id WithSubFolder:SDK_MOMENT_COVER_DIR]])
        return;
    
    if (![WowTalkVoipIF fIsSetupCompleted])
        return;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
    
    
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:WT_UPLOAD_ALBUM_COVER taskInfo:nil taskType:WT_UPLOAD_ALBUM_COVER notificationName:WT_UPLOAD_ALBUM_COVER notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    if(USE_S3){
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];   // autorelease when it is done.
        netIFCommunicator.didFinishDelegate = task;
     
        
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request = [netIFCommunicator uploadCover:cover toDir:S3_MOMENT_FILE_DIR forBucket:S3_BUCKET];
    }
    else{
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];   // autorelease when it is done.
        netIFCommunicator.didFinishDelegate = task;
        
        
        [netIFCommunicator fInit];
        task.request = [netIFCommunicator uploadCover:cover toDir:S3_MOMENT_FILE_DIR forBucket:S3_BUCKET];

    }
    
}

+(void)getCoverFromServer:(CoverImage*)cover withCallback:(SEL)selector withObserver:(id)observer
{
    if (cover == nil) {
        return;
    }
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(USE_S3){
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        NSString* uniquestr = [WT_DOWNLOAD_ALBUM_COVER stringByAppendingString:cover.file_id];
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_DOWNLOAD_ALBUM_COVER notificationName:WT_DOWNLOAD_ALBUM_COVER notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_DownloadCover* netIFCommunicator = [[Communicator_DownloadCover alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.image = cover;
        [netIFCommunicator fInitS3Setting];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_MOMENT_FILE_DIR,cover.file_id]];
    }
    else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        NSString* uniquestr = [WT_DOWNLOAD_ALBUM_COVER stringByAppendingString:cover.file_id];
        
        WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_DOWNLOAD_ALBUM_COVER notificationName:WT_DOWNLOAD_ALBUM_COVER notificationObserver:observer userInfo:nil selector:selector];
        if (![task start]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            return;
        }
        
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        netIFCommunicator.isMomentCoverImageDownLoad = YES;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_MOMENT_FILE_DIR,cover.file_id] FromBucket:S3_BUCKET];
    }
    
    
}


#pragma mark - Nearby infos
+(void)getNearbyBuddysWithOffset:(int)offset withLatitude:(double)latitude withLongitude:(double)longitude withCallback:(SEL)selector withObserver:(id)observer
{
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_NEARBY_BUDDYS taskInfo:nil taskType:WT_GET_NEARBY_BUDDYS notificationName:WT_GET_NEARBY_BUDDYS notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Communicator_GetNearbyBuddys *netIFCommunicator = [[Communicator_GetNearbyBuddys alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID,HASHED_PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_GET_NEARBY_BUDDYS, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], nil] autorelease];
    
    [postKeys addObject:@"count"];
    [postValues addObject:[NSNumber numberWithInt:offset]];
    
    if (0 != latitude && 0 != longitude) {
        [postKeys addObject:@"latitude"];
        [postKeys addObject:@"longitude"];
        
        [postValues addObject:[NSString stringWithFormat:@"%f",latitude]];
        [postValues addObject:[NSString stringWithFormat:@"%f",longitude]];
    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    
}

+(void)getNearbyGroupsWithOffset:(int)offset withCallback:(SEL)selector withObserver:(id)observer
{
    
}

#pragma mark - GPS
/**
 * Tell server I become active  : use to record user activity
 *
 * @param NetworkIFDidFinishDelegate
 */
+(void) userBecomeActiveWithLastLongitude:(float)lastLongitude withLastLatitude:(float)lastLatitude withCallback:(SEL)selector withObserver:(id)observer{
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_USER_BECOME_ACTIVE taskInfo:nil taskType:WT_USER_BECOME_ACTIVE notificationName:WT_USER_BECOME_ACTIVE notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    Communicator_UserBecomeActive *netIFCommunicator = [[Communicator_UserBecomeActive alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID,HASHED_PASSWORD, @"last_longitude", @"last_latitude", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_USER_BECOME_ACTIVE, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], [NSString stringWithFormat:@"%f",lastLongitude],[NSString stringWithFormat:@"%f",lastLatitude], nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
}



#pragma mark - Official Account Message
+(NSString*)translateMsgTypeForOfficialUserReadable:(NSString*)input{
    if(input==nil)return nil;
    NSString* rlt=nil;
    
    if([input isEqualToString:[ChatMessage MSGTYPE_ENCRIPTED_TXT_MESSAGE]] || [input isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]]){
        rlt=@"text";
    }
    else if ([input isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]]){
        rlt=@"voice";
    }
    else if ([input isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]]){
        rlt=@"video";
    }
    else if ([input isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]){
        rlt=@"image";
    }
    else if ([input isEqualToString:[ChatMessage MSGTYPE_LOCATION]]){
        rlt=@"location";
    }
    
    return rlt;
    
    
}

+(BOOL)sendBuddyMessage:(ChatMessage*)msg
{
    
    NSString* buddyid  = msg.chatUserName;
    Buddy* buddy = [Database buddyWithUserID:buddyid];
    if (buddy.userType == 0) {
        msg.ioType = [ChatMessage IOTYPE_OUTPUT];
        msg.primaryKey = [Database storeNewChatMessage:msg];
        msg.sentStatus = [ChatMessage SENTSTATUS_IN_PROCESS];
        [WowTalkWebServerIF sendMsgToOfficialAccount:msg withCallback:@selector(didSendChatByWebIF:) withObserver:nil];
        return TRUE;
    }
    else
    {
        return [WowTalkVoipIF fSendChatMessage:msg];
    }
    
    
}

+(void) sendMsgToOfficialAccount:(ChatMessage*)msg withCallback:(SEL)selector withObserver:(id)observer{
    
    NSString* strOfficialUID = msg.chatUserName;
    NSString* msgType = [WowTalkWebServerIF translateMsgTypeForOfficialUserReadable: msg.msgType];
    NSString* msgContent = msg.messageContent;
    
    if (strOfficialUID == nil || msgType==nil ||  msgContent==nil)
        return;
    NSString* uniquestr = [WT_SEND_MSG_TO_OFFICIAL_USER stringByAppendingString:[NSString stringWithFormat:@"%zi", msg.primaryKey]];
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:msg forKey:WT_MESSAGE] taskType:WT_SEND_MSG_TO_OFFICIAL_USER notificationName:WT_SEND_MSG_TO_OFFICIAL_USER notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_SendMsgToOfficialUser *netIFCommunicator = [[Communicator_SendMsgToOfficialUser alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, @"official_uid",@"message_type",@"message_content", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_SEND_MSG_TO_OFFICIAL_USER, [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], strOfficialUID,msgType,msgContent, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

#pragma mark -  message's media file related.
+(void) uploadMediaFile:(NSString*)pathOfFile withCallback:(SEL)selector withObserver:(id)observer
{
    if (pathOfFile == nil)
        return;
    
    if(![NSFileManager mediafileExistedAtPath:pathOfFile])
        return;
    if (![WowTalkVoipIF fIsSetupCompleted])
        return;
    
    NSString* uniquestr = [WT_UPLOAD_MEDIAFILE stringByAppendingFormat:@"%@",pathOfFile];
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:nil taskType:WT_UPLOAD_MEDIAFILE notificationName:WT_UPLOAD_MEDIAFILE notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    NSString* absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:pathOfFile];
    if(USE_S3){
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];   // autorelease when it is done.
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =  [netIFCommunicator fUploadFile:absolutepath toDir:S3_UPLOAD_FILE_DIR forBucket:S3_BUCKET];
        
    }
    else{
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];   // autorelease when it is done.
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =  [netIFCommunicator fUploadFile:absolutepath toDir:S3_UPLOAD_FILE_DIR forBucket:S3_BUCKET];
        
    }
}



+(void) uploadMediaMessageOriginalFile:(ChatMessage*)msg withCallback:(SEL)selector withObserver:(id)observer
{
    if (msg == nil)
        return;
    
    if(![NSFileManager mediafileExistedAtPath:msg.pathOfMultimedia])
        return;
    if (![WowTalkVoipIF fIsSetupCompleted])
        return;
    
    NSString* uniquestr = [WT_UPLOAD_MEDIAMESSAGE_ORIGINAL stringByAppendingFormat:@"%zi",msg.primaryKey];
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:msg forKey:WT_MESSAGE] taskType:WT_UPLOAD_MEDIAMESSAGE_ORIGINAL notificationName:WT_UPLOAD_MEDIAMESSAGE_ORIGINAL notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    NSString* absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:msg.pathOfMultimedia];
    if(USE_S3){
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];   // autorelease when it is done.
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =  [netIFCommunicator fUploadFile:absolutepath toDir:S3_UPLOAD_FILE_DIR forBucket:S3_BUCKET];
        
    }
    else{
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];   // autorelease when it is done.
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =  [netIFCommunicator fUploadFile:absolutepath toDir:S3_UPLOAD_FILE_DIR forBucket:S3_BUCKET];
        
    }
}


+(void) uploadMediaMessageThumbnail:(ChatMessage*)msg withCallback:(SEL)selector withObserver:(id)observer
{
    if (msg == nil)
        return;
    
    if(![NSFileManager mediafileExistedAtPath:msg.pathOfThumbNail])
        return;
    if (![WowTalkVoipIF fIsSetupCompleted])
        return;

    NSString* uniquestr = [WT_UPLOAD_MEDIAMESSAGE_THUMBNAIL stringByAppendingFormat:@"%zi",msg.primaryKey];
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:msg forKey:WT_MESSAGE] taskType:WT_UPLOAD_MEDIAMESSAGE_THUMBNAIL notificationName:WT_UPLOAD_MEDIAMESSAGE_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    NSString* absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:msg.pathOfThumbNail];
    if(USE_S3){
        
        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];   // autorelease when it is done.
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =  [netIFCommunicator fUploadFile:absolutepath toDir:S3_UPLOAD_FILE_DIR forBucket:S3_BUCKET];
        
    }
    else{
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];   // autorelease when it is done.
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =  [netIFCommunicator fUploadFile:absolutepath toDir:S3_UPLOAD_FILE_DIR forBucket:S3_BUCKET];
        
    }
    
}

+(void) downloadMediaMessageOriginalFile:(ChatMessage*)msg withCallback:(SEL)selector withObserver:(id)observer
{
    if (msg == nil) return;
    
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    NSString* filename = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:WT_PATH_OF_THE_ORIGINAL_FILE_IN_SERVER];
    
    if([NSString isEmptyString:filename]) return;
    
    if (![WowTalkVoipIF fIsSetupCompleted]) return;
    
    NSString* uniquestr = [WT_DOWNLOAD_MEDIAMESSAGE_ORIGINAL stringByAppendingFormat:@"%zi",msg.primaryKey];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:msg forKey:WT_MESSAGE] taskType:WT_DOWNLOAD_MEDIAMESSAGE_ORIGINAL notificationName:WT_DOWNLOAD_MEDIAMESSAGE_ORIGINAL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    if(USE_S3){
        Communicator_GetFileS3* netIFCommunicator = [[Communicator_GetFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_UPLOAD_FILE_DIR,filename] FromBucket:S3_BUCKET];
    }
    
    else{
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_UPLOAD_FILE_DIR,filename] FromBucket:S3_BUCKET];
    }
    
    
}
+(void) downloadMediaMessageThumbnail:(ChatMessage*)msg withCallback:(SEL)selector withObserver:(id)observer
{
    if (msg == nil) return;
    
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    NSString* filename = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:WT_PATH_OF_THE_THUMBNAIL_IN_SERVER];
    
    if([NSString isEmptyString:filename]) return;
    
    if (![WowTalkVoipIF fIsSetupCompleted]) return;
    
    NSString* uniquestr = [WT_DOWNLOAD_MEDIAMESSAGE_THUMBNAIL stringByAppendingFormat:@"%zi",msg.primaryKey];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:msg forKey:WT_MESSAGE] taskType:WT_DOWNLOAD_MEDIAMESSAGE_THUMBNAIL notificationName:WT_DOWNLOAD_MEDIAMESSAGE_THUMBNAIL notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    if(USE_S3){
        Communicator_GetFileS3* netIFCommunicator = [[Communicator_GetFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_UPLOAD_FILE_DIR,filename] FromBucket:S3_BUCKET];
    }
    
    else{
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_UPLOAD_FILE_DIR,filename] FromBucket:S3_BUCKET];
    }
    
}

#pragma mark - Opt Buddy
+ (void)optBuddy:(NSString *)userId withInfo:(NSDictionary *)dic withCallback:(SEL)selector withObserver:(id)observer
{
    if (userId == nil) {
        return;
    }
    
    NSString *uniqueStr = [@"opt_buddy" stringByAppendingString:userId];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueStr taskInfo:nil taskType:@"opt_buddy" notificationName:@"opt_buddy" notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_OptBuddy *netIFCommunicator = [[Communicator_OptBuddy alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, UUID, HASHED_PASSWORD, nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:@"opt_buddy", [WTUserDefaults getUid], [WTUserDefaults getHashedPassword], nil] autorelease];
    [postKeys addObject:@"buddy_id"];
    [postValues addObject:userId];
    for (NSString *key in [dic keyEnumerator]) {
        [postKeys addObject:key];
        [postValues addObject:[dic objectForKey:key]];
    }
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

#pragma mark -
#pragma mark Chat related

+ (void)getChatHistoryCountWithBuddy:(NSString *)userId observer:(id)observer selector:(SEL)selector
{
    NSString *uniqueString = [@"get_chat_history_count" stringByAppendingString:userId];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueString taskInfo:[NSDictionary dictionaryWithObject:userId forKey:WT_MESSAGE] taskType:WT_GET_CHAT_HISTORY_COUNT notificationName:WT_GET_CHAT_HISTORY_COUNT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetHistoryCount *netIFCommunicator = [[Communicator_GetHistoryCount alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[NSMutableArray alloc] init];
    NSMutableArray *postValues = [[NSMutableArray alloc] init];
    [postKeys addObject:@"uid"];
    [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"];
    [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"action"];
    [postValues addObject:@"get_chat_history_count"];
    [postKeys addObject:@"chat_target"];
    [postValues addObject:userId];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    [postKeys release];
    [postValues release];
}

+ (void)getChatHistoryWithBuddyStore:(NSString *)userId  offset:(NSInteger)offset limit:(NSInteger)limit observer:(id)observer selector:(SEL)selector
{
    [WowTalkWebServerIF getChatHistoryWithBuddyInner:userId withStore:TRUE offset:offset limit:limit observer:observer selector:selector];
}

+ (void)getChatHistoryWithBuddy:(NSString *)userId  offset:(NSInteger)offset limit:(NSInteger)limit observer:(id)observer selector:(SEL)selector
{
    [WowTalkWebServerIF getChatHistoryWithBuddyInner:userId withStore:FALSE offset:offset limit:limit observer:observer selector:selector];
}

+ (void)getChatHistoryWithBuddyInner:(NSString *)userId  withStore:(BOOL)store offset:(NSInteger)offset limit:(NSInteger)limit observer:(id)observer selector:(SEL)selector
{
    NSString *uniqueString = [NSString stringWithFormat:@"%@%@%zi", WT_GET_CHAT_HISTORY, userId, offset];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueString taskInfo:[NSDictionary dictionaryWithObject:userId forKey:WT_MESSAGE] taskType:WT_GET_CHAT_HISTORY notificationName:WT_GET_CHAT_HISTORY notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetChatHistory *netIFCommunicator = [[Communicator_GetChatHistory alloc] init];
    netIFCommunicator.withStore=store;
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] init] autorelease];
    [postKeys addObject:@"uid"];
    [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"];
    [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"action"];
    [postValues addObject:@"get_chat_history"];
    [postKeys addObject:@"offset"];
    [postValues addObject:[NSString stringWithFormat:@"%zi", offset]];
    [postKeys addObject:@"limit"];
    [postValues addObject:[NSString stringWithFormat:@"%zi", limit]];
    [postKeys addObject:@"chat_target"];
    [postValues addObject:userId];
    [postKeys addObject:@"asc"];
    [postValues addObject:@"1"];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+ (void)getLatestContactListWithOffset:(NSInteger)offset limit:(NSInteger)limit observer:(id)observer selector:(SEL)selector
{
    NSString *uniqueString = [NSString stringWithFormat:@"%@%zi%zi", WT_GET_LATEST_CONTACT_LIST, offset,limit];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueString taskInfo:nil taskType:WT_GET_LATEST_CONTACT_LIST notificationName:WT_GET_LATEST_CONTACT_LIST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetLatestContactList *netIFCommunicator = [[Communicator_GetLatestContactList alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] init] autorelease];
    [postKeys addObject:@"uid"];
    [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"];
    [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"action"];
    [postValues addObject:@"get_latest_chat_target"];
    [postKeys addObject:@"limit"];
    [postValues addObject:[NSString stringWithFormat:@"%zi,%zi",offset, limit]];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+ (void)getLatestContactList:(id)observer selector:(SEL)selector
{
    NSString *uniqueString = [NSString stringWithFormat:@"%@", WT_GET_LATEST_CONTACT_LIST];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueString taskInfo:nil taskType:WT_GET_LATEST_CONTACT_LIST notificationName:WT_GET_LATEST_CONTACT_LIST notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetLatestContactList *netIFCommunicator = [[Communicator_GetLatestContactList alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] init] autorelease];
    [postKeys addObject:@"uid"];
    [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"];
    [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"action"];
    [postValues addObject:@"get_latest_chat_target"];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}



+ (void)getOfflineMessageFromTimestamp:(NSString*)timestamp withObserver:(id)observer selector:(SEL)selector
{

    NSString *uniqueString = [NSString stringWithFormat:@"%@", WT_GET_OFFLINE_MESSAGE];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueString taskInfo:nil taskType:WT_GET_OFFLINE_MESSAGE notificationName:WT_GET_OFFLINE_MESSAGE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        [WTUserDefaults setOfflineMsgLastSyncStatus:FALSE];
        return;
    }
    
    Communicator_GetOfflineMessage *netIFCommunicator = [[Communicator_GetOfflineMessage alloc] init];
    netIFCommunicator.delegate = task;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] init] autorelease];
    [postKeys addObject:@"uid"];
    [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"];
    [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"action"];
    [postValues addObject:@"get_offline_message"];
    [postKeys addObject:@"mac"]; [postValues addObject:[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
    
    if(timestamp!=nil){
        [postKeys addObject:@"timestamp"];
        [postValues addObject:timestamp];

    }
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];}


#pragma mark - new
+(void)getSingleMoment:(NSString *)momentId withCallback:(SEL)selector withObserver:(id)observer
{
    NSString *uniqueString = [NSString stringWithFormat:@"%@", WT_GET_SINGLE_MOMENT];
    WTNetworkTask *task = [[WTNetworkTask alloc] initWithUniqueKey:uniqueString taskInfo:nil taskType:WT_GET_SINGLE_MOMENT notificationName:WT_GET_SINGLE_MOMENT notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    Communicator_GetSingleMoment *netIFCommunicator = [[Communicator_GetSingleMoment alloc] init];
    netIFCommunicator.delegate = task;
    netIFCommunicator.momentId=momentId;
    
    NSMutableArray *postKeys = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] init] autorelease];
    [postKeys addObject:@"uid"];
    [postValues addObject:[WTUserDefaults getUid]];
    [postKeys addObject:@"password"];
    [postValues addObject:[WTUserDefaults getHashedPassword]];
    [postKeys addObject:@"action"];
    [postValues addObject:WT_GET_SINGLE_MOMENT];
    [postKeys addObject:@"moment_id"];
    [postValues addObject:momentId];
    [postKeys addObject:@"with_review"];
    [postValues addObject:@"1"];
    
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}

+(void) bindInvitationCode:(NSString *)invitationCode withCallback:(SEL)selector withObserver:(id)observer
{
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
    
    Communicator_NoDataFeedback* netIFCommunicator = [[Communicator_NoDataFeedback alloc] init];
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

+ (void)loginWithInvitaionCode:(NSString *)invitationCode withCallback:(SEL)selector withObserver:(id)observer
{
    if (invitationCode==nil) {
        return;
    }
    
    
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_LOGIN_WITH_INVITATION_CODE taskInfo:nil taskType:WT_LOGIN_WITH_INVITATION_CODE notificationName:WT_LOGIN_WITH_INVITATION_CODE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        return;
    }
    
    Communicator_LoginWithInvitationCode *netIFCommunicator = [[Communicator_LoginWithInvitationCode alloc] init];
    netIFCommunicator.delegate = task;
    NSMutableArray *postKeys = [[[NSMutableArray alloc] initWithObjects:ACTION, @"invitation_code", nil] autorelease];
    NSMutableArray *postValues = [[[NSMutableArray alloc] initWithObjects:WT_LOGIN_WITH_INVITATION_CODE, invitationCode, nil] autorelease];
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
}


+(void) getSchoolStructurWithCallback:(SEL)selector withObserver:(id)observer
{
      
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        [WTHelper WTLog:@"engine is not set up"];
        return;
    }
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:WT_GET_SCHOOL_STRUCTURE taskInfo:nil taskType:WT_GET_SCHOOL_STRUCTURE notificationName:WT_GET_SCHOOL_STRUCTURE notificationObserver:observer userInfo:nil selector:selector];
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
    [postKeys addObject:@"action"]; [postValues addObject:WT_GET_SCHOOL_STRUCTURE];
    
    [netIFCommunicator fPost:postKeys withPostValue:postValues];
    
    [postKeys release];
    [postValues release];
    
}

+ (void)uploadMsgFile:(WTFile *)file withCallback:(SEL)selector withObserver:(id)observer{
    
    if (![WowTalkVoipIF fIsSetupCompleted]) {
        return;
    }
    
    if(file==nil){
        return;
    }
    
    NSString* uniquestr = [WT_UPLOAD_MSGFILE stringByAppendingFormat:@"%@",file.fileid];
    WTNetworkTask* task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:file.fileid forKey:@"fileid"] taskType:WT_UPLOAD_MSGFILE notificationName:WT_UPLOAD_MSGFILE notificationObserver:observer userInfo:nil selector:selector];
    
    if (![task start]) {
        return;
    }
    
    if(USE_S3){
//        
//        Communicator_UploadFileS3* netIFCommunicator = [[Communicator_UploadFileS3 alloc] init];   // autorelease when it is done.
//        netIFCommunicator.didFinishDelegate = task;
//        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
//        task.request =  [netIFCommunicator fUploadFile:absolutepath toDir:S3_UPLOAD_FILE_DIR forBucket:S3_BUCKET];
//        
    }
    else{
        Communicator_UploadFileAliyun* netIFCommunicator = [[Communicator_UploadFileAliyun alloc] init];   // autorelease when it is done.
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =  [netIFCommunicator uploadFile:file toDir:S3_UPLOAD_FILE_DIR forBucket:S3_BUCKET];
        
    }
}

+(void) downloadPicVoiceFile:(ChatMessage*)msg withCallback:(SEL)selector withObserver:(id)observer
{
    if (msg == nil) return;
    
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    NSString* filename = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:@"audio_pathoffileincloud"];
    
    if([NSString isEmptyString:filename]) return;
    
    
    
    if (![WowTalkVoipIF fIsSetupCompleted]) return;
    
    NSString* uniquestr = [WT_DOWNLOAD_MSGFILE stringByAppendingFormat:@"%zi",msg.primaryKey];
    WTNetworkTask * task = [[WTNetworkTask alloc] initWithUniqueKey:uniquestr taskInfo:[NSDictionary dictionaryWithObject:msg forKey:WT_MESSAGE] taskType:WT_DOWNLOAD_MSGFILE notificationName:WT_DOWNLOAD_MSGFILE notificationObserver:observer userInfo:nil selector:selector];
    if (![task start]) {
        return;
    }
    
    if(USE_S3){
        Communicator_GetFileS3* netIFCommunicator = [[Communicator_GetFileS3 alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fSetS3SecretAccessKey:S3_SECRET_ACCESS_KEY andAccessKey:S3_ACCESS_KEY];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_UPLOAD_FILE_DIR,filename] FromBucket:S3_BUCKET];
    }
    
    else{
        Communicator_GetFileAliyun* netIFCommunicator = [[Communicator_GetFileAliyun alloc] init];
        netIFCommunicator.didFinishDelegate = task;
        [netIFCommunicator fInit];
        task.request =[netIFCommunicator fGetFileWithPath:[NSString stringWithFormat:@"%@%@",S3_UPLOAD_FILE_DIR,filename] FromBucket:S3_BUCKET];
    }
    
    
}


@end
