//
//  WTNetworkTaskConstant.m
//  omimIOSAPI
//
//  Created by coca on 2012/12/13.
//  Copyright (c) 2012年 coca. All rights reserved.
//

#import "WTNetworkTaskConstant.h"

@implementation WTNetworkTaskConstant
#pragma mark - Network type
NSString* const WT_UPLOAD_MEDIAFILE =       @"uploadmediafile";
NSString* const WT_UPLOAD_MSGFILE =       @"uploadmsgfile";
NSString* const WT_DOWNLOAD_MSGFILE =       @"downloadmsgfile";


NSString* const WT_UPLOAD_MEDIAMESSAGE_ORIGINAL =       @"uploadmediamessageoriginal";
NSString* const WT_UPLOAD_MEDIAMESSAGE_THUMBNAIL =      @"uploadmediamessagethumbnail";
NSString* const WT_DOWNLOAD_MEDIAMESSAGE_ORIGINAL =     @"downloadmediamesageoriginal";
NSString* const WT_DOWNLOAD_MEDIAMESSAGE_THUMBNAIL =    @"downloadmediamesagethumbnail";

NSString* const WT_REPORT_UNREAD_MESSAGES =         @"reportunreadmessage";
NSString* const WT_REPORT_PUSH_TOKEN_TO_SERVER =    @"reportpushtoken";
NSString* const WT_REPORT_EMPTY_TOKEN_TO_SERVER =   @"reportemptytoken";

NSString* const WT_GET_LATEST_VERSION_INFO = @"get_latest_version_info";

NSString* const WT_REQUIRE_IVR_ACCESS_CODE =    @"require_ivr_access_code";
NSString* const WT_REQUIRE_ACCESS_CODE  =       @"require_access_code";
NSString* const WT_VALIDATE_ACCESS_CODE =       @"validate_access_code";

NSString* const WT_GET_MY_PROFILE = @"get_my_profile";
NSString* const WT_UPDATE_PROFILE = @"updateprofile";

NSString* const WT_UPLOAD_CONTACT_BOOK =                @"uploadcontactbook";
NSString* const WT_INCREASE_CONTACT_BOOK_IN_SERVER =    @"increasecontactbook";
NSString* const WT_DECREASE_CONTACT_BOOK_IN_SERVER =    @"decreasecontactbook";

NSString* const WT_GET_A_BUDDY =            @"getabuddy";
NSString* const WT_GET_BUDDY_LIST =         @"getbuddylist";
NSString* const WT_GET_MATCHED_BUDDYS =     @"getmatchedbuddy";
NSString* const WT_GET_POSSIBLE_BUDDYS =    @"getpossiblebuddys";
NSString* const WT_GET_BLOCKED_BUDDYS =     @"getblockedbuddys";
NSString* const WT_SCAN_NUMBER_FOR_BUDDY =  @"scannumberforbuddy";

NSString* const WT_UPDATE_MY_PHOTO_ORIGINAL =   @"updatemyphotooriginal";
NSString* const WT_UPDATE_MT_PHOTO_THUMBNAIL =  @"updatemyphotothumbnail";

NSString* const WT_GET_PRIVACY_SETTING =       @"getprivacysetting";
NSString* const WT_SET_PRIVACY =               @"setprivacy";

NSString* const WT_DEACTIVE_ACCOUNT =               @"deactiveaccount";

NSString* const WT_ADJUST_UTC_TIME_WITH_SERVER=     @"adjustutctimewithserver";

NSString* const WT_ADD_BUDDY =                      @"addbuddy";
NSString* const WT_BLOCK_BUDDY =                    @"blockbuddy";
NSString* const WT_UNBLOCK_BUDDY=                   @"unblockbuddy";

NSString* const WT_GET_BUDDY_PHOTO_ORIGINAL=        @"getbuddyphotooriginal";
NSString* const WT_GET_BUDDY_PHOTO_THUMBNAIL =      @"getbuddyphotothumbnail";

NSString* const WT_GET_FILE_FROM_SERVER =           @"getfilefromserver";

NSString* const WT_CREATE_CHAT_GROUP =              @"create_temp_group_chat_room";
NSString* const WT_JOIN_CHAT_GROUP =                @"joinchatgroup";
NSString* const WT_LEAVE_CHAT_GROUP=                @"leave_group_chat_room";
NSString* const WT_GET_GROUP_MEMBERS =              @"get_group_members";
NSString* const WT_ADD_GROUP_MEMBERS =              @"add_group_member";
NSString* const WT_GET_GROUP_INFO =                 @"get_group_info";
NSString* const WT_GET_ALL_PENDING_REQUEST =        @"get_my_pending_requests";

NSString* const WT_SEND_GROUP_MESSAGES =            @"sendgroupmessage";

NSString* const WT_GET_UNSUPPORTED_DEVICE =         @"getunsupporteddevice";

NSString* const WT_GET_STAMP_FILE_FROM_SERVER =     @"getstampfilefromserver";

NSString* const WT_SET_ACTIVE_APP_TYPE =            @"setactiveapptype";
NSString* const WT_GET_ACTIVE_APP_TYPE =            @"getactiveapptype";

NSString* const WT_AUTO_REGISTER =                  @"login_with_auto_create_user";
NSString* const WT_REGISTER_WITH_MAIL =             @"register_with_mail";
NSString* const WT_REGISTER_WITH_USERID =           @"register";
NSString* const WT_LOGIN_WITH_USER  =               @"login";

NSString* const WT_GET_EVENT_INFO =                 @"get_event_info";
NSString* const WT_GET_JOINABLE_EVENTS =            @"get_can_join_event_list";

NSString* const WT_LOGOUT =                         @"logout";
NSString* const WT_CHANGE_WOWTALK_ID =              @"change_wowtalk_id";
NSString* const WT_CHANGE_PASSWORD =                @"change_password";
NSString* const WT_GET_USER_BY_UID =                @"get_buddy";
NSString* const WT_GET_USER_BY_WOWTALKID =          @"get_buddy_by_wowtalk_id";


NSString* const WT_JOIN_EVENT =                     @"join_the_event";
NSString* const WT_JOIN_EVENT_WITH_DETAIL =         @"join_the_event_with_details";
NSString* const WT_GET_PREVIOUS_EVENTS =            @"get_previous_events";
NSString* const WT_GET_LATEST_EVENTS      =         @"get_latest_events";
NSString* const WT_CANCEL_THE_EVENT      =          @"cancle_join_the_event";
NSString* const WT_GET_JOINED_EVENTS      =         @"get_joined_events";
NSString* const WT_LIKE_THE_EVENT       =           @"like_the_event";
NSString* const WT_UNLIKE_THE_EVENT     =           @"unlike_the_event";
NSString* const WT_SEARCH_EVENT_BY_CATEGORY    =    @"search_event_by_category";
NSString* const WT_SEARCH_EVENT_BY_TAG         =    @"search_event_by_tag";
NSString* const WT_SEARCH_EVENT_BY_LOCATION    =    @"search_event_by_location";
NSString* const WT_DOWNLOAD_EVENT_MEDIA        =    @"download_event_multimedia";

NSString* const WT_UPLOAD_EVENT_MEDIA_ORIGINAL =   @"upload_event_media";
NSString* const WT_UPLOAD_EVENT_MEDIA_THUMBNAIL =  @"upload_event_media_thumb";

NSString* const WT_BIND_EMAIL =                     @"bind_email";
NSString* const WT_BIND_PHONE_NUMBER =              @"bind_phone_number";
NSString* const WT_VERIFY_EMAIL =                   @"verify_email";
NSString* const WT_VERIFY_PHONE_NUMBER =            @"verify_phone_number";
NSString* const WT_UNLINK_EMAIL =                   @"unbind_email";
NSString* const WT_UNLINK_PHONE_NUMBER =            @"unbind_phone_number";

NSString* const WT_SEND_ACCESS_CODE =               @"send_access_code";
NSString* const WT_RESET_PASSWORD =                 @"reset_password";
NSString* const WT_BIND_EMAIL_STATUS =              @"email_binding_status";
NSString* const WT_UNBIND_EMAIL =                   @"unbind_email";
NSString* const WT_RETRIVE_PASS =                   @"retrieve_password";
NSString* const WT_SEND_CODEFOR_RETRPASS =          @"send_code_for_retrieve_password";
NSString* const WT_CHECK_CODEFOR_RETPASS =          @"check_code_for_retrieve_password";
NSString* const WT_VERIYF_EMAIL =                   @"verify_email";
NSString* const WT_EMAIL_ADDRESS =                  @"email_address";
NSString* const WT_ADD_MOMENT =                     @"add_moment";
NSString* const WT_ADD_MOMENT_SURVEY =              @"add_moment_survey";
NSString* const WT_VOTE_MOMENT_SURVEY =             @"vote_moment_survey";
NSString* const WT_UPLOAD_MOMENT_MULTIMEDIA =       @"upload_moment_multimedia";
NSString* const WT_DELETE_MOMENT =                  @"delete_moment";
NSString* const WT_GET_REVIEW_FOR_MOMENT =          @"get_review_for_moment";
NSString* const WT_REVIEW_MOMENT =                  @"review_moment";
NSString* const WT_REPLY_TO_REVIEW =                @"review_moment";
NSString* const WT_DELETE_MOMENT_REVIEW =           @"delete_moment_review";
NSString* const WT_DOWNLOAD_MOMENT_MULTIMEDIA =     @"download_moment_multimedia";
NSString* const WT_GET_MOMENTS_FOR_ALL_BUDDIES =    @"get_moments_for_all_buddys";
NSString* const WT_GET_MOMENTS_FOR_GROUP =          @"get_moment_for_group";
NSString* const WT_SET_ALBUM_COVER =                @"set_album_cover";
NSString* const WT_GET_ALBUM_COVER =                @"get_album_cover";
NSString* const WT_REMOVE_ALBUM_COVER =                @"remove_album_cover";

NSString* const WT_UPLOAD_ALBUM_COVER =             @"upload_album_cover_to_server";
NSString* const WT_DOWNLOAD_ALBUM_COVER =           @"download_album_cover_from_server";

NSString* const WT_UPLOAD_MOMENT_MEDIA_ORIGINAL =   @"upload_moment_media";
NSString* const WT_UPLOAD_MOMENT_MEDIA_THUMBNAIL =  @"upload_moment_media_thumb";


NSString* const WT_GET_LATEST_MOMENT_FOR_BUDDY =    @"get_moment_for_buddy";
NSString* const WT_GET_PREVIOUS_REVIEW_FOR_MOMENT = @"get_review_for_moment";
NSString* const WT_GET_LATEST_REVIEWS_FOR_ME  =     @"get_latest_reviews_for_me";
NSString* const WT_SET_REVIEW_STATUS_READ =         @"set_review_read";

NSString* const WT_USER_BECOME_ACTIVE =             @"user_become_active";
NSString* const WT_SEND_MSG_TO_OFFICIAL_USER =      @"send_msg_to_official_user";
NSString* const WT_GET_FRIEND_REQUEST =             @"get_pending_buddy_requests";
NSString* const WT_REJECT_FRIEND_REQUEST =          @"reject_buddy";
NSString* const WT_REMOVE_BUDDY =                   @"remove_buddy";
NSString* const WT_KICKOUT_GROUP =                  @"kickout_group";
NSString* const WT_ACTIVATE_NUMBER_AS_BUDDY =       @"add_mobile_numbers_as_buddy";
NSString* const WT_GET_NEARBY_BUDDYS        =       @"get_nearby_buddies";
NSString* const WT_GET_ACCOUNTS_UNREAD_COUNT=       @"get_accounts_unread_counts";
NSString* const WT_GET_NEARBY_GROUPS        =       @"get_nearby_groups";
NSString* const WT_SEARCH_BUDDY             =       @"search_buddy";

NSString* const WT_GET_VERSION          =           @"check_for_updates";
//fixed group
NSString* const WT_UPLOAD_GROUP_AVATAR = @"upload_group_avatar";
NSString* const WT_UPLOAD_GROUP_AVATAR_THUMBNAIL = @"upload_group_avatar_thumbnail";
NSString* const WT_GET_GROUP_AVATAR = @"get_group_avatar";
NSString* const WT_GET_GROUP_AVATAR_THUMBNAIL = @"get_group_avatar_thumbnail";
NSString* const WT_CREATE_FIXED_GROUP = @"create_group_chat_room";
NSString* const WT_EDIT_GROUP_INFO = @"update_group_info";
NSString* const WT_UPDATE_GROUP_AVATAR_TIMESTAMP = @"update_group_thumbnail_timestamp";
NSString* const WT_DISMISS_GROUP = @"disband_group";
NSString* const WT_REQUEST_TO_JOIN_GROUP  = @"ask_for_join_group";
NSString* const WT_GET_GROUP_PENDING_MEMBERS = @"get_group_pending_members";
NSString* const WT_REMOVE_GROUP_MEMBERS = @"remove_group_member";
NSString* const WT_GET_GROUP_BY_GROUPID = @"get_group_by_short_group_id";
NSString* const WT_SET_USER_LEVEL = @"set_group_user_level";
NSString* const WT_GET_MY_GROUPS = @"get_my_groups";
NSString* const WT_REJECT_GROUP_APPLICATION = @"reject_pending_members";
NSString* const WT_SEARCH_GROUP_BY_KEY = @"search_group";
NSString* const WT_GET_ALL_JOIN_GROUP_REQUEST = @"get_pending_group_requests";
NSString* const WT_GET_ALL_GROUPS_IN_COMPANY = @"get_all_groups_in_company";

NSString* const WT_FAVORITE_A_GROUP = @"set_user_favorite_group";
NSString* const WT_FAVORITE_GROUPS = @"set_user_favorite_group_list";
NSString* const WT_FAVORITE_A_BUDDY = @"set_user_favorite_buddy";
NSString* const WT_FAVORITE_BUDDIES = @"set_user_favorite_buddy_list";
NSString* const WT_GET_FAVORITE_ITEMS = @"get_user_favorite_item_list";

NSString* const WT_DEFAVORITE_BUDDY = @"defavorite_buddy";
NSString* const WT_DEFAVORITE_GROUP = @"defavorite_group";

NSString* const WT_GET_COMPANY_STRUCTURE = @"get_company_structure";
NSString* const WT_GET_COMPANY_STRUCTURE_UPDATES = @"get_company_structure_updates";
NSString* const WT_GET_GROUPS_IN_CORP = @"get_all_groups_in_corp";


NSString* const WT_GET_MEMBERS_IN_DEPARTMENT = @"get_all_buddys_in_group";

NSString* const WT_SEND_ENMERGENCY_MESSAGE = @"send_emergency_msg";

NSString* const WT_GET_SCHOOL_MEMBERS = @"get_school_members";

#pragma mark 
NSString *const WT_MESSAGE  =                       @"message";
NSString *const WT_SAVE_PATH  =                     @"savepathformedia";

NSString* const WT_FILE_PATH_LOCAL =                @"filepath";
NSString* const WT_UNREAD_MESSAGES_COUNT =          @"unreadmessagecount";
NSString* const WT_PUSH_TOKEN =                     @"pushtoken";

NSString* const WT_ACCESS_CODE_USER_NAME =          @"username";
NSString* const WT_ACCESS_CODE_COUNTRY_CODE =       @"countrycode";
NSString* const WT_ACCESS_CODE_CARRIER =            @"carriername";
NSString* const WT_ACCESS_CODE =                    @"accesscode";

NSString* const WT_REGISTER_MAIL = @"mail";
NSString* const WT_REGISTER_USERID = @"wowtalk_id";
NSString* const WT_REGISTER_PASSWORD = @"password";
NSString* const WT_LOGIN_USER = @"user";
NSString* const WT_LOGIN_PASSWORD = @"plain_password";

NSString* const WT_PROFILE_SEX = @"sex";
NSString* const WT_PROFILE_NICKNAME = @"nickname";
NSString* const WT_PROFILE_STATUS = @"status";
NSString* const WT_PROFILE_BIRTHDAY = @"birthday";
NSString* const WT_PROFILE_AREA = @"area";

NSString* const WT_LATITUDE = @"latitude";
NSString* const WT_LONGITUDE = @"longitude";
NSString* const WT_CONTENT = @"content";
NSString* const WT_PRIVACY = @"privacy";
NSString* const WT_ALLOW_REVIEW = @"allow_review";
NSString* const WT_MOMENTID = @"moment_id";
NSString* const WT_CONTENT_TYPE = @"content_type";
NSString* const WT_CONTENT_PATH = @"content_path";
NSString* const WT_COMMENT_TYPE = @"comment_type";
NSString* const WT_COMMENT = @"comment";
NSString* const WT_REVIEW_ID = @"review_id";
NSString* const WT_WITH_REVIEW = @"with_review";
NSString* const WT_OWNER_ID = @"owner_id";
NSString* const WT_REVIEWER_ID = @"reviewer_id";

NSString* const WT_PHONENUMBER_LIST = @"numberlist";


NSString* const WT_PRIVACY_ADD_BUDDY_AUTOMATICALLY = @"addbuddyautomatically";
NSString* const WT_PRIVACY_PEOPLE_CAN_ADD_ME = @"peoplecanaddme";
NSString* const WT_PRIVACY_UNKNOWN_PEOPLE_CAN_CALL_ME = @"unknownpeoplecancallme";
NSString* const WT_PRIVACY_UNKNOWN_PEOPLE_CAN_MESSAGE_ME = @"unknownpeoplecanmessageme";
NSString* const WT_PRIVACY_SHOW_MSG_DETAIL_IN_PUSH = @"showmessagedetailinpush";


NSString* const WT_BUDDY_ID = @"buddy_id";

NSString* const WT_FILE_PATH_IN_SERVER = @"filepathinserver";

NSString* const WT_IS_TEMPORARY_GROUP = @"istemporarygroup";
NSString* const WT_GROUP_NAME = @"groupname";   
NSString* const WT_GROUP_ID = @"group_id";
NSString* const WT_SHORT_GROUP_ID = @"short_group_id";
NSString* const WT_GROUP_MEMBER_LIST = @"memberlist";

NSString* const WT_EVENT_ID = @"event_id";
NSString* const WT_WOWTALK_ID = @"wowtalk_id";
NSString* const WT_NEW_PASSWORD = @"new_plain_password";

NSString* const WT_EMAIL = @"email";
NSString* const WT_PHONE_NUMBER = @"phone_number";
NSString* const WT_PASSWORD = @"password";

NSString* const WT_GET_ACCESSCODE_TYPE = @"accesstype";

NSString* const WT_OFFICIAL_UID = @"official_uid";

NSString* const WT_LAST_LONGITUDE = @"last_longitude";
NSString* const WT_LAST_LATITUDE = @"last_latitude";


#pragma mark -
#pragma mark Reserved Keys In userinfo contained in the posted notif.
NSInteger const WT_ERROR_AUTH_ERROR = 2;
NSString* const WT_ERROR =  @"error";
NSString* const WT_PASSED_IN_NOTIFDATA = @"passedinnotifdata";

NSString* const WT_DID_SEND_THE_MESSAGE = @"didsendthemessage";
NSString* const WT_DID_UPLOAD_THE_THUMBNAIL = @"diduploadthethumbnail";
NSString* const WT_DID_UPLOAD_THE_ORIGINAL_FILE = @"diduploadtheoriginalfile";
NSString* const WT_IS_SENDING_GROUP_MESSAGE = @"issendinggroupmessage";
NSString* const WT_DID_DOWNLOAD_THE_THUMBNAIL = @"diddownloadthethumbnail";
NSString* const WT_DID_DOWNLOAD_THE_ORIGINAL_FILE = @"diddownloadttheoriginalfile";
NSString* const WT_DID_DOWNLOAD_THE_MSG_RECORD_FILE = @"diddownloadthemsgrecordfile";
NSString* const WT_BUDDY = @"buddy";
NSString* const WT_SEARCH_RESULT = @"searchresult";
NSString* const WT_PENDING_REQUEST = @"pendingrequest";

NSString* const WT_GET_CHAT_HISTORY = @"getchathistory";
NSString* const WT_GET_CHAT_HISTORY_COUNT = @"getchathistorycount";
NSString* const WT_GET_OFFLINE_MESSAGE = @"getofflinemessage";

NSString* const WT_GET_LATEST_CONTACT_LIST = @"getlatestcontactlist";


NSString* const WT_NEED_RELOAD_TIMELINE_MOMENT_TABLE  =     @"need_reload_timeline_moment_table";
NSString* const TIMELINE_VIEW_NEW_REVIEWS=@"time_view_new_reviews";
NSString* const TIMELINE_COVER_IMAGE_CHANGED=@"timeline_cover_image_changed";
NSString* const SETTING_ATTACH_USER_STATE_CHANGE=@"setting_attach_user_state_change";

NSString* const TIMELINE_MOMENT_STATUS_CHANGED=@"timeline_moment_status_changed";
NSString* const BIZ_MEMBER_DELETED=@"biz_member_deleted";
NSString* const BIZ_MEMBER_UPDATED=@"biz_member_updated";

NSString* const MOMENT_ACTION_NEW_MOMENT=@"moment_action_new_moment";
NSString* const MOMENT_ACTION_REFRESH_MOMENT=@"moment_action_refresh_moment";
NSString* const MOMENT_ACTION_DELETE_MOMENT=@"moment_action_delete_moment";

NSString* const BIZ_MEMBER_INFO_DID_UPDATE=@"biz_member_info_did_update";

;
NSString* const WT_GET_SINGLE_MOMENT = @"get_single_moment";

NSString* const WT_BIND_INVITATION_CODE = @"bind_with_invitation_code";
NSString* const WT_LOGIN_WITH_INVITATION_CODE = @"login_with_invitation_code";
NSString* const WT_GET_SCHOOL_STRUCTURE = @"get_school_structure";



// MyClassNetWork
#pragma mark - MyClassNetWork
NSString* const WT_GET_SCHOOL_LESSON_ROOM = @"get_room";

NSString* const WT_USE_SCHOOL_LESSON_ROOM = @"use_room";

NSString* const WT_GET_SCHOOL_LESSON_CAMERA = @"get_camera";

NSString* const WT_GET_SCHOOL_LESSON_CAMERA_BYLESSONID = @"get_camera_by_lesson";

NSString* const WT_SET_SCHOOL_LESSON_CAMERA_STATUS = @"set_camera_status";

NSString* const WT_GET_SCHOOL_LESSON_DETAIL = @"get_lesson_detail";

NSString* const WT_RELEASE_SCHOOL_LESSON_ROOM = @"release_room";

NSString* const WT_DEL_SCHOOL_LESSON = @"del_lesson";

NSString* const WT_ADD_SCHOOL_LESSON = @"add_lesson";

NSString* const WT_MODIFY_SCHOOL_LESSON = @"modify_lesson";


#pragma mark - Setting
NSString* const WT_LATEST_VERSION = @"check_for_updates";

NSString* const WT_PUT_USER_SETTING = @"put_user_settings";

NSString* const WT_GET_USER_SETTING = @"get_user_settings";


#pragma mark - Login
// 发送手机验证码
NSString* const WT_SEND_SMS = @"sms_sendSMS";
// 验证手机验证码
NSString* const WT_CHECK_SMSCODE = @"sms_checkCode";
// 发送邮箱验证码
NSString* const WT_RSTRIEVE_PASSWORD_VIA_EMAIL = @"retrieve_password_via_email";
// 验证邮箱验证码
NSString* const WT_RESET_PASSWORD_VIA_EMAIL = @"reset_password_via_email";
// 绑定手机号码
NSString* const WT_USER_BIND_PHONE = @"user_bind_phone";
// 手机修改密码接口
NSString* const WT_RESET_PASSWORD_BY_MOBILE = @"reset_password_by_mobile";
// 检查手机号码
NSString* const WT_CHECK_MOBILE_EXIST= @"check_mobile_exist";
@end
